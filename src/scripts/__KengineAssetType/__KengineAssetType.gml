
/**
 * @function AssetType
 * @typicalname Kengine.AssetType
 * @memberof Kengine
 * @description An asset type is a group of assets, such as rooms or custom levels. It can be a custom type (`KAsset`) or default type (`YYAsset`).
 * @param {String} name The name of the asset type (in singular form).
 * @param {Constant.AssetType|String} [asset_kind=KENGINE_CUSTOM_ASSET_KIND] A default asset kind if it's a YYAsset (asset_room, asset_object, etc.) or {@link KENGINE_CUSTOM_ASSET_KIND} if it's custom.
 * @param {Struct|Undefined} [indexing_options=undefined] A struct containing key-value configuration for indexing of this asset type. {@link Kengine.AssetType.IndexingOptions}
 * @param {Struct|Undefined} [var_struct] A struct of attributes to add to this asset type. If there is a function value, it is copied as a method with self as this asset type.
 * 
 */
function __KengineAssetType(name, asset_kind=KENGINE_CUSTOM_ASSET_KIND, indexing_options=undefined, var_struct=undefined) : __KengineStruct() constructor {
	var this = self;

	__indexing_coroutine = undefined;

	/**
	* @typedef {Struct} IndexingOptions
	* @memberof Kengine.AssetType
	* @description AssetType indexing options struct.
	* @property {Array<Real>} [index_range=[0,999999]]] An array of min, max for the indexing range.
	* @property {Array<Struct>} [rename_rules] An array of renaming rules when indexing assets.
	* @property {Array<String>} [exclude_prefixes=["__",]]] An array of prefixing strings that should be excluding when indexing at start.
	* @property {Array<String|Array<String>>} [unique_attrs=["id","name","real_name",]]] A list of attribute names that are unique by nature. So when indexing happens, it is only added once, otherwise replaced. Attributes such as `id` and `real_name` must be unique when adding assets. You can also use array of attrs inside to make them unique together.
	*/
	self.indexing_options = indexing_options ?? {};

	__KengineStructUtils.SetDefault(self.indexing_options, "unique_attrs", ["id", "name", "real_name"]);

	/**
	 * @name name
	 * @type {String}
	 * @memberof Kengine.AssetType
	 * @description The name property of the AssetType. Can be provided in creation options. Required.
	 * 
	 */
	self.name = name;

	/**
	 * @name is_addable
	 * @type {Bool}
	 * @memberof Kengine.AssetType
	 * @description Whether assets can be added to this asset type in general. Can be provided in creation options.
	 * @defaultvalue true
	 *
	 */
	self.is_addable = __KengineStructUtils.SetDefault(self.indexing_options, "is_addable", true);

	/**
	 * @name is_replaceable
	 * @type {Bool}
	 * @memberof Kengine.AssetType
	 * @description Whether assets can be added to this asset type in general. Can be provided in creation options.
	 * @defaultvalue true
	 *
	 */
	self.is_replaceable = __KengineStructUtils.SetDefault(self.indexing_options, "is_replaceable", true);

	/**
	 * @name asset_kind
	 * @type {String|Constant.AssetType|Any}
	 * @memberof Kengine.AssetType
	 * @description The `asset_kind` property of the AssetType. Can be provided in creation options. Defaults to `{@link KENGINE_CUSTOM_ASSET_KIND}`.
	 * @defaultvalue KENGINE_CUSTOM_ASSET_KIND
	 * 
	 */
	self.asset_kind = asset_kind;

	/**
	 * @name rename_rules
	 * @type {Undefined|Array<Struct>}
	 * @memberof Kengine.AssetType
	 * @description A set of rules to rename assets.
	 * 
	 * Each rule (struct) contains `{kind, search, replace_by}`
	 *
	 * `kind`: Search kind as a string, one of `"prefix", "suffix", "any", "one"`. Where any means anywhere in the name.
	 *
	 * `search`: A string to search in the original asset name.
	 *
	 * `replace_by`: A string to replace the match in the asset name.
	 *
	 * The asset will have a new attribute called `__original_name`.
	 */
	self.rename_rules = __KengineStructUtils.SetDefault(self.indexing_options, "rename_rules", undefined);

	/**
	 * @function GetAssetReplacement
	 * @memberof Kengine.AssetType
	 * @description Returns an [Asset]{@link Kengine.Asset} by id or name. This function looks up the replacement chain of found asset, and iterates until it finds the final replacement of the asset and returns it.
	 * @param {String|Real} id_or_name The real ID or name of the asset.
	 * @param {Real} [replacement_depth=0] If the asset is marked as replaced, take the replacement.. and repeat that for replacement_depth` times. Use `0` to get last in the chain. Use `-1` to get the first in chain. Use `false` to not lookup replacements.
	 * @param {String} [return_type="asset"] What to return. "asset" (the asset itself), "id" (the asset id), or "index" (the index of the asset in the {@link Kengine.Collection}). Defaults to "asset"
	 * @return {Any} The wanted return type. Could be asset, its id or its index in the collection. `undefined` if not found.
	 * @example
	 * my_asset1 = my_asset_type.GetAssetReplacement("spr_character01", 0, "index"); // Return the correct index of the asset in the asset collection.
	 *
	 * // Assuming `Mods` changed spr_character02 sprite:
	 * my_asset2 = my_asset_type.GetAssetReplacement("spr_character02", 0, "index"); // Return the correct index of the asset (the newest one, if more than one, and with the latest YYAsset real ID) in the asset collection.
	 *
	 */
	self.GetAssetReplacement = function(id_or_name, replacement_depth=0, return_type="asset") {
		var _types, _a_by_types, _asset_aind;
		_a_by_types = __KengineStructUtils.Get(Kengine.asset_types, self.name).assets.GetAll();
		_asset_aind = array_find_index(_a_by_types, method({id_or_name}, __KengineCmpUtils.cmp_id_or_name));

		if _asset_aind == -1 return undefined;

		var _a = _a_by_types[_asset_aind];

		if not is_bool(replacement_depth) and replacement_depth != undefined {
			// look-up chain, get latest replacement.
			var _a_chain = _a.GetReplacement(-1);
			_a = _a_chain[max(0, min(array_length(_a_chain)-1, replacement_depth == 0 ? 100000 : replacement_depth))];	
		}

		if return_type == "asset" {
			return _a;
		} else if return_type == "id" {
			return _a.id;
		} else if return_type == "uid" {
			return _a.uid;
		} else if return_type == "index" {
			return _a.index;
		}

	};

	/**
	 * @name index_asset_filter
	 * @type {Function}
	 * @memberof Kengine.AssetType
	 * @description A function that returns `true` if the provided asset should be indexed, `false` otherwise.
	 * @param {Kengine.Asset} asset The asset to check before indexing.
	 * @param {Kengine.AssetType} The main AssetType.
	 * 
	 */
	self.index_asset_filter = __KengineStructUtils.SetDefault(self.indexing_options, "index_asset_filter", undefined);

	/**
	 * @function IndexAssets
	 * @memberof Kengine.AssetType
	 * @param {Struct} [indexing_options=undefined]
	 * @description The asset indexing functions (IndexAssets, IndexAsset) prepare and adds all the assets of this type, or only prepares and adds the provided {@link Kengine.Asset} to the {@link Kengine.Collection}, returning whether operation was successful.
	 * @return {Bool} Whether successful indexing occured or not.
	 * 
	 */
	self.IndexAssets = function(indexing_options=undefined) {
		static chunk_size = KENGINE_ASSET_TYPES_AUTO_INDEX_ASYNC ? KENGINE_ASSET_TYPES_INDEX_CHUNK_SIZE : 0
		static __index_assets_halt = {halt: true}
		static __indices_are_assets = false

		static __ChunkIndexAssets = function(indices_are_assets, index_range, asset_list, indexing_options) {

			static __SingleAssetFindName = function(type, asset) {
				var _name = undefined;
				if type.__exists(asset) {
					_name = type.__get_name(asset);
				}
				if _name == "<undefined>" or _name == "<unknown>" or _name == "undefined" or _name == undefined or _name == pointer_null {
					// If it is a script or object, skip it.
					if type.asset_kind == asset_script or type.asset_kind == asset_object {
						return false;
					}
					return undefined;
				}
				return _name;
			}

			static __SingleAssetCheckExclude = function(name, exclude_prefixes) {
				var _skip = false;
				for (var _j=0; _j<array_length(exclude_prefixes); _j++) {
					if name == exclude_prefixes[_j] {
						_skip = true;
						break;
					}							
					if string_starts_with(name, exclude_prefixes[_j]) {
						_skip = true;
						break;
					}
				}
				return _skip;
			}

			static __SingleAssetCreate = function(type, name, asset_id) {
				var _ass = new __KengineAsset(type, name, true, asset_id, undefined, false);
				return _ass;
			}

			var _ass;
			var _indexed_assets = [];
			for (var _i=index_range[0]; _i<index_range[1]; _i++) {
				_ass = indices_are_assets ? _i : asset_list[_i];
				// Find the name
				var _name = __SingleAssetFindName(type, _ass)
				if _name == undefined {
					throw {halt: true};
				}
				if _name == false {
					continue;
				}
				// Exclude prefixes
				if (__SingleAssetCheckExclude(_name, indexing_options.exclude_prefixes)) {
					continue;
				}
				_ass = __SingleAssetCreate(type, _name, _ass);
				// Index
				type.IndexAsset(_ass);
				array_push(_indexed_assets, _ass);
			}
			return _indexed_assets;
		}

		var __ChunkIndexAssetsCallback = function() {
			var concat = __KengineArrayUtils.Concat
			var _indexed_assets = concat(coroutine.results);
			__KengineEventUtils.Fire("asset_type__index_assets__after", {asset_type: self, indexed_assets: _indexed_assets});
			coroutine.Destroy();
		}

		var _this = self;

		indexing_options = indexing_options ?? self.indexing_options;

		__KengineEventUtils.Fire("asset_type__index_assets__before", {asset_type: _this,});

		var _indexed_assets = [];
		var _index_range = __KengineStructUtils.SetDefault(indexing_options, "index_range", [0,999999]);
		var _exclude_prefixes = [];
		_exclude_prefixes = __KengineStructUtils.SetDefault(indexing_options, "exclude_prefixes", _exclude_prefixes);

		var _name, _ass, _real_name, _tags;
		var _count = 0;
		var _id;
		var _j = 0;
		var _skip = false;

		if self.__get_name != undefined and self.__exists != undefined {

			__indices_are_assets = false;
			var _assets = [];

			// If it's a custom asset (KAsset) then asset IDs are from 0 to 9999+ or per index ranges.
			// Or if it's a real asset (YYAsset) then just use the real IDs.
			if is_string(self.asset_kind) {
				__indices_are_assets = true;
			} else {
				/// feather disable GM1044
				_assets = asset_get_ids(self.asset_kind);
				_index_range[0] = 0;
				_index_range[1] = array_length(_assets);
			}

			// Chunking
			var _chunk_count = 1;
			var _chunks;
			var _range;
			if chunk_size == 0 {
				_range = array_create(2);
				_range[0] = _index_range[0];
				_range[1] = _index_range[1];
				_chunks = array_create(1, _range);
			} else {
				_chunk_count = ceil((_index_range[1] - _index_range[0]) / chunk_size);
				_chunks = array_create(_chunk_count);
				_range = array_create(2);
				for (var _i=0; _i<_chunk_count; _i++) {
					_range[0] = _index_range[0] + _i * chunk_size;
					_range[1] = min(_index_range[1], _range[0] + chunk_size);
					_chunks[_i] = variable_clone(_range);
				}
			}

			// Set up functions for coroutine
			var _func;
			var _funcs = [];
			var _chunk_assets;
			for (var _i=0; _i<_chunk_count; _i++) {
				_chunk_assets = [];
				// array_copy(_chunk_assets, 0, _assets, _chunks[_i][0], _chunks[_i][1] - _chunks[_i][0] + 1);
				_func = array_create(2); // function, params
				_func[0] = method({type: _this}, __ChunkIndexAssets);
				_func[1] = array_create(4);
				_func[1][0] = __indices_are_assets // indices_are_assets
				_func[1][1] = _chunks[_i] // index_range
				_func[1][2] = _assets // asset_list
				_func[1][3] = indexing_options // indexing_options
				array_push(_funcs, variable_clone(_func));
			}

			// If indexing halts, this means we reached a dead-end. Thus, callback is required both on halt and on successful finish.
			var _coroutine = new __KengineCoroutine("assettype.autoindex."+string(self.name), _funcs, __ChunkIndexAssetsCallback, __ChunkIndexAssetsCallback);

			self.__indexing_coroutine = _coroutine;
			if (KENGINE_ASSET_TYPES_AUTO_INDEX_ASYNC) {
				_coroutine.Start();
				return _coroutine;
			} else {
				_coroutine.Immediate();
				return _coroutine;
			}
		}

		return false;
	};

	/**
	 * @function IndexAsset
	 * @memberof Kengine.AssetType
	 * @description The asset indexing functions (IndexAssets, IndexAsset) prepare and adds all the assets of this type, or only prepares and adds the provided {@link Kengine.Asset} to the {@link Kengine.Collection}, returning whether operation was successful.
	 * The function surpasses `indexing_options.exclude_prefixes`.
	 * @param {Kengine.Asset} asset The asset to index.
	 * @return {Array<Any>} A two-value array containing whether the asset was added or not, and the index of the asset or -1.
	 * 
	 */
	self.IndexAsset = function(asset) {
		var _unique_attrs = self.indexing_options.unique_attrs;
		var _result = [];
		if asset != undefined {
			__KengineEventUtils.Fire("asset__index__before", {asset, _result});
			if asset.__is_indexed {
				if array_length(_result) == 0 {
					_result = [false, asset.index];
				}
				return _result;
			}
			var _tags;
			if __KengineStructUtils.Get(asset, "tags") == undefined {
				if asset.__is_yyp {
					/// feather disable GM1044
					_tags = asset_get_tags(asset.id, self.asset_kind);
					_tags[array_length(_tags)] = "YYAsset";
				} else {
					_tags = [KENGINE_CUSTOM_ASSET_KIND];
				}
				asset.tags = new __KengineCollection(_tags);
				asset.tags.__all = array_unique(asset.tags.__all);
			}
			var _ind, _accepted;
			var _cmp
			if is_array(_unique_attrs) {
				_cmp = method({unique_attrs: _unique_attrs}, __KengineCmpUtils.cmp_unique_attrs);
				_ind = self.assets.GetInd(asset, _cmp);

				if _ind != -1 {
					_result = [false, _ind];
					return _result;
				}
				_accepted = true;
				if (self.index_asset_filter != undefined) {
					_accepted = self.index_asset_filter(asset, self);
				}
				if (_accepted) {
					_ind = self.assets.AddOnce(asset, _cmp);
					asset.index = _ind;
				}
			} else {
				_accepted = true;
				if (self.index_asset_filter != undefined) {
					_accepted = self.index_asset_filter(asset, self);
				}
				if (_accepted) {
					_ind = self.assets.AddOnce(asset, __KengineCmpUtils.cmp_unique_id_name);
					asset.index = _ind;
				}
			}

			if asset.real_name == "" {
				asset.real_name = self.__get_name(asset.id);
			}

			if self.rename_rules != undefined {
				var _rule;
				for (var i=0; i<array_length(self.rename_rules); i++) {
					_rule = self.rename_rules[i];
					switch (_rule.kind) {
						case "prefix":
							if string_starts_with(asset.name, _rule.search) {
								asset.__original_name = asset.name;
								asset.name = string_replace(asset.name, _rule.search, _rule.replace_by);
							}
							break;
						case "suffix":
							if string_ends_with(asset.name, _rule.search) {
								asset.__original_name = asset.name;
								var l0 = string_length(asset.name);
								var l1 = string_length(_rule.search);
								asset.name = string_delete(asset.name, l0-l1, l1) + _rule.replace_by;
							}
							break;
						case "one":
							asset.__original_name = asset.name;
							asset.name = string_replace(asset.name, _rule.search, _rule.replace_by);
							break;
						case "any":
						case "anywhere":
							asset.__original_name = asset.name;
							asset.name = string_replace_all(asset.name, _rule.search, _rule.replace_by);
							break;
					}
				}

				if asset.name != asset.__original_name {
					asset.__is_renamed = true;
					if __KengineStructUtils.Exists(_rule, "when_successful") {
						method({this: asset, rename_rule: _rule}, _rule.when_successful)();
					}
				}
			}

			if asset.uid == undefined {
				asset.uid = Kengine.new_uid();
			}
			if not _accepted {
				_result = [false, -1];
			} else {
				_result = [true, _ind];
			}
		}

		__KengineEventUtils.Fire("asset__index__after", {asset, _result});
		return _result;
	};

	switch (self.asset_kind) {
		case asset_font:
			self.__get_name = method(self, font_get_name);
			self.__add = method(self, font_add);
			self.__delete = method(self, font_delete);
			self.__exists = method(self, font_exists);
			break;
		case asset_object:
			self.__get_name = method(self, object_get_name);
			self.__add = undefined;
			self.__delete = undefined;
			self.__exists = method(self, object_exists);
			break;
		case asset_path:
			self.__get_name = method(self, path_get_name);
			self.__add = method(self, path_add);
			self.__delete = method(self, path_delete);
			self.__exists = method(self, path_exists);
			break;
		case asset_room:
			self.__get_name = method(self, room_get_name);
			self.__add = method(self, room_add);
			self.__delete = undefined;
			self.__exists = method(self, room_exists);
			break;
		case asset_script:
			self.__get_name = method(self, script_get_name);
			self.__add = undefined;
			self.__delete = undefined;
			self.__exists = method(self, script_exists);
			break;
		case asset_sound:
			self.__get_name = method(self, audio_get_name);
			self.__add = undefined;
			self.__delete = undefined;
			self.__exists = method(self, audio_exists);
			break;
		case asset_sprite:
			self.__get_name = method(self, sprite_get_name);
			self.__add = method(self, sprite_add);
			self.__delete = method(self, sprite_delete);
			self.__exists = method(self, sprite_exists);
			break;
		case asset_timeline:
			self.__get_name = method(self, timeline_get_name);
			self.__add = method(self, timeline_add);
			self.__delete = method(self, timeline_delete);
			self.__exists = method(self, timeline_exists);
			break;
		case asset_unknown:
			self.__get_name = undefined;
			self.__add = undefined;
			self.__delete = undefined;
			self.__exists = undefined;
			break;
		default:

			/**
			 * @function __get_name
			 * @memberof Kengine.AssetType
			 * @description A function that returns the {@link Kengine.Asset} name by its real ID.
			 * @private
			 * @param {Real} _id The real ID of the {@link Kengine.Asset}.
			 * @return {String|Undefined} The name of the asset.
			 *
			 */
			self.__get_name = function (_id) { 
				var ass = self.GetAssetReplacement(_id, false);
				if ass != undefined {
					return ass.name;
				}
				return undefined;
			};
			/**
			 * @function __exists
			 * @memberof Kengine.AssetType
			 * @description A function that returns whether {@link Kengine.Asset} with the real ID exists. Use this function instead of `sprite_exists` ...etc.
			 * @private
			 * @param {Real} id The real ID of the {@link Kengine.Asset}.
			 * @return {Bool} Whether the asset exists or not.
			 *
			 */
			self.__exists = function (_id) {
				var ass = self.GetAssetReplacement(_id, false, "id");
				if ass != undefined { return true;}
				return false;
			};
			
			// TODO: __add and __delete functions.

			break;
	}

	/**
	 * @name assets
	 * @type {Kengine.Collection}
	 * @memberof Kengine.AssetType
	 * @description The AssetType's collection.
	 * 
	 * @example
	 * Kengine.asset_types[my_type.name].assets == my_type.assets // Return true
	 *
	 */
	self.assets = new __KengineCollection();

	self.toString = function() {return string("<AssetType: {0}>", self.name);}

	if var_struct != undefined {
		var vss = struct_get_names(var_struct);
		var val;
		for (var i=0; i<array_length(vss); i++) {
			val = var_struct[$ vss[i]];
			if is_method(val) {
				this = self;
				self[$ vss[i]] = method({this}, val);
			} else {
				self[$ vss[i]] = val;
			}
		}
	}

	Kengine.asset_types[$ self.name] = self;

	__KengineEventUtils.Fire("asset_type__init__after", {asset_type: this,});
};
