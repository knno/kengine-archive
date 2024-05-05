/**
 * @function Asset
 * @memberof Kengine
 * @description An asset that represents sprites, objects, rooms, and can be any other customly defined assets.
 * @param {String|Kengine.AssetType} type The AssetType or its name that this Asset belongs to.
 * @param {String} name The name of this Asset. This name should be the same as the name of the `YYAsset` if it represents one.
 * @param {Bool} [is_yyp=false] Whether this asset is a representation of a real YYAsset. Defaults to `false`.
 * @param {Real|Asset} [real_id=undefined] The real ID of this Asset. This id should be the same as the index of the `YYAsset` if it represents one. Otherwise it is automatically assigned.
 * @param {String} [real_name=undefined] The real name of this Asset. This name should be the same as the name of the `YYAsset` if it represents one. Otherwise you can assign any name.
 * @param {Bool} [auto_index=true] Whether to index the asset or not. Defaults to `true`.
 * @example
 * // This example creates a new room asset, that is indexed automatically, and adds "MyTag" to its tags.
 *
 * my_asset = new Kengine.Asset(my_asset_type, "rm_init", rm_init);
 * my_asset.tags.AddOnce("MyTag");
 *
 */
function __KengineAsset(type, name, is_yyp=false, real_id=undefined, real_name=undefined, auto_index=true) : __KengineStruct() constructor {

	var this = self;

	real_id = real_id ?? -1;
	real_name = real_name ?? "";

	/**
	 * @name __replaced_by
	 * @type {Kengine.Asset}
	 * @memberof Kengine.Asset
	 * @private
	 * @description `__replaced_by` references an Asset that replaces this Asset, if it is done by `Mods`.
	 *
	 */
	self.__replaced_by = undefined;

	/**
	 * @name __replaces
	 * @type {Kengine.Asset}
	 * @memberof Kengine.Asset
	 * @private
	 * @description `__replaces` references an the Asset that this Asset replaces, if it is done by `Mods`.
	 *
	 */
	self.__replaces = undefined;

	/**
	 * @name __is_indexed
	 * @type {Bool}
	 * @memberof Kengine.Asset
	 * @private
	 * @description Whether the asset has been indexed or not.
	 * It should be automatically indexed upon its creation.
	 *
	 */
	self.__is_indexed = false;
	/**
	 * @name index
	 * @type {Real}
	 * @memberof Kengine.Asset
	 * @description The index of the asset in the asset type collection.
	 *
	 */
	self.index = undefined;
	self.uid = undefined;

	if typeof(type) == "string" {
		if not __KengineStructUtils.Exists(Kengine.asset_types, type) {
			throw __KengineErrorUtils.create(__KengineErrorUtils.Types.asset__asset_type__does_not_exist, string("Cannot create asset \"{0}\". AssetType with the name \"{1}\" does not exist.", name, type));
		}
		type = __KengineStructUtils.Get(Kengine.asset_types, type);
	}

	__KengineEventUtils.Fire("asset__init__before", {asset: this,});

	/**
	 * @name type
	 * @type {Kengine.AssetType}
	 * @memberof Kengine.Asset
	 * @description The type of the asset.
	 *
	 */
	self.type = type;

	/**
	 * @name name
	 * @type {String}
	 * @memberof Kengine.Asset
	 * @description The name of the asset.
	 *
	 */
	self.name = name;

	/**
	 * @name id
	 * @type {Real}
	 * @memberof Kengine.Asset
	 * @description The real ID of the asset.
	 *
	 */
	self.id = real_id;

	/**
	 * @name index
	 * @type {Real|Undefined}
	 * @memberof Kengine.Asset
	 * @description The index of the asset.
	 *
	 */
	self.index = undefined;

	/**
	 * @name __original_name
	 * @type {String}
	 * @memberof Kengine.Asset
	 * @description The same as `name` of the asset object, This is not necessarily the real name.
	 *
	 */
	self.__original_name = self.name;

	/**
	 * @name __is_renamed
	 * @type {Bool}
	 * @memberof Kengine.Asset
	 * @description Whether this asset has been renamed. The original name is at {@link Kengine.Asset.__original_name} attribute.
	 *
	 */
	self.__is_renamed = false;

	/**
	 * @function GetReplacement
	 * @memberof Kengine.Asset
	 * @param {Real} [replaced_by_max=-1]
	 * @param {Real} [replaces_max=-2]
	 * @return {Array<Kengine.Asset>}
	 */
	self.GetReplacement = function(replaced_by_max=-1, replaces_max=-2) {
		var _la = [], _ra = [];
		var _a = self;
		var _l = replaces_max;
		var _r = replaced_by_max;
		var _lac;
		var _rac;

		while (_l != -2) {
			_lac = array_length(_la);
			_la[_lac] = _a;
			if _la[_lac].__replaces != undefined {
				_lac++;
				_la[_lac] = _a.__replaces;
				_a = _la[_lac];
				if _l == -1 {
					for (var i=0; i<_lac; i++) {
						if _a == _la[i] {
							Kengine.console.echo_error(string("Circular replacement detected within replacement chain of Asset \"{0}\".", _a.name));
							_l = -2; break;
						}
					}
					continue;
				}
				_l -= 1;
				if _l == 0 {_l = -2; break;}
			} else {
				_l = -2; break;
			}
		}
		while (_r != -2) {
			_rac = array_length(_ra);
			_ra[_rac] = _a;
			if _ra[_rac].__replaced_by != undefined {
				_rac++;
				_ra[_rac] = _a.__replaced_by;
				_a = _ra[_rac];
				if _r == -1 {
					for (var i=0; i<_rac; i++) {
						if _a == _ra[i] {
							Kengine.console.echo_error(string("Circular replacement detected within replacement chain of Asset \"{0}\".", _a.name));
							_r = -2; break;
						}
					}
					continue;
				}
				_r -= 1;
				if _r == 0 {_r = -2; break;}
			} else {
				_r = -2; break;
			}
		}
		
		array_pop(_la)
		return array_unique(array_concat(array_reverse(_la), _ra));
	}

	/**
	 * @name is_yyp
	 * @type {Bool}
	 * @memberof Kengine.Asset
	 * @description Whether this asset's `id` is the real ID of a `YYAsset`.
	 *
	 */
	self.__is_yyp = is_yyp;

	/**
	 * @name real_name
	 * @type {String}
	 * @memberof Kengine.Asset
	 * @description The real name of the asset (For YYAssets compatibility).
	 *
	 */
	self.real_name = real_name;

	if (auto_index) {
		var indexer_result = self.type.IndexAsset(self);
		if indexer_result != undefined {
			self.__is_indexed = indexer_result[0];
			self.index = indexer_result[1];
		}
	}

	if self.id == -1 {
		self.id = self.type.GetAssetReplacement(self.name, false, "id");
	} else {
		if self.__is_yyp == false {
			if self.real_name == "" {
				self.real_name = self.name;
			}
		}
	}
	self.real_name = (self.real_name != "") ? self.real_name : self.name;

	self.toString = function() {
		return string("<Asset {0} ({1}) (id/uid: {2}/{3})>", self.name, self.type.name, self.id, self.uid);
	}

	/**c
	 * @function ReplaceBy
	 * @memberof Kengine.Asset
	 * @description Replaces this asset by the provided argument. It will have {@link KENGINE_ASSET_TAG_REPLACED} in its tags and also a `__replaced_by` variable. The replacing asset will have a `__replaces` variable.
	 * @param {Kengine.Asset} replacer_asset
	 *
	 */
	ReplaceBy = function(replacer_asset) {
		if self.type.is_replaceable {
			if self.tags == undefined self.tags = new __KengineCollection();
			if self.tags.GetInd(KENGINE_ASSET_TAG_FIXED) != -1 {
				throw __KengineErrorUtils.create(__KengineErrorUtils.Types.asset__cannot_replace, string("Cannot replace Asset \"{0}\".", self.name));
			}
			self.tags.AddOnce(KENGINE_ASSET_TAG_REPLACED);
			self.__replaced_by = replacer_asset;
			replacer_asset.__replaces = self;
		} else {
			throw __KengineErrorUtils.create(__KengineErrorUtils.Types.asset__asset_type__cannot_replace, string("Cannot replace Assets of AssetType \"{0}\".", self.type.name));
		}
	}

	// Add var_struct variables for Asset.
	if struct_exists(self.type, "assets_var_struct") {
		var vss = struct_get_names(self.type.assets_var_struct);
		var val;
		for (var i=0; i<array_length(vss); i++) {
			val = self.type.assets_var_struct[$ vss[i]];
			if is_method(val) {
				this = self;
				self[$ vss[i]] = method({this}, val);
			} else {
				self[$ vss[i]] = val;
			}
		}
	}

	/**
	 * @name tags
	 * @type {Kengine.Collection|Undefined}
	 * @memberof Kengine.Asset
	 * @description A Kengine.Collection of the tags associated with the asset.
	 * 
	 */
	self.tags = undefined

	__KengineEventUtils.Fire("asset__init__after", {asset: this,});
}
