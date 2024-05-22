
/**
 * @function Mod
 * @memberof Kengine.Extensions.Mods
 * @param {String} name The name of the Mod.
 * @param {Array<Kengine.Extensions.Mods.AssetConf>} [asset_confs=[]]] AssetConfs that the Mod comprises.
 * @param {Array<Kengine.Extensions.Mods.Mod>|Array<String>} [_dependencies=[]]] Mod dependencies of other Mods or their names.
 * @param {String} [source=undefined] Mod source path.
 * @param {Bool} [enabled=false] Whether the mod is enabled or not.
 * @description A `Kengine.Extensions.Mods.Mod` is a group of {@link Kengine.Extensions.Mods.AssetConf} instances that will be enabled in order to apply them as `Kengine.Asset` instances.
 * Newely added `Kengine.Asset`s can either be simply just added or replace pre-existing Assets. When enabling a `Mod`, this happens. When disabling the `Mod`, all its `Kengine.Asset`s are removed and replaced ones are restored to their previous state.
 *
 */
function __KengineModsMod(name, asset_confs=undefined, _dependencies=undefined, source=undefined, enabled=false) constructor {
    var this = self;

	/**
	 * @name name
	 * @type {String}
	 * @memberof Kengine.Extensions.Mods.Mod
	 * @description The `name` provided when creating the `Mod`.
	 * 
	 */
	self.name = name

    /**
	 * @name options
	 * @type {Any}
	 * @memberof Kengine.Extensions.Mods.Mod
	 * @description The `description` property of the `Mod`.
	 * @defaultvalue undefined
	 * 
	 */
	self.description = undefined

	/**
	 * @name dependencies
	 * @type {Array<Kengine.Extensions.Mods.Mod>}
	 * @memberof Kengine.Extensions.Mods.Mod
	 * @description Mod dependencies.
	 * @defaultvalue []
	 * 
	 */
	self.dependencies = _dependencies ?? []

	/**
	 * @name asset_confs
	 * @type {Struct}
	 * @memberof Kengine.Extensions.Mods.Mod
	 * @description The `asset_confs` property of the Mod. Set by the mod manager when it finds mods.
	 * @defaultvalue {}
	 *
	 */
	self.asset_confs = asset_confs ?? {}

	/**
	 * @name enabled
	 * @type {Bool}
	 * @memberof Kengine.Extensions.Mods.Mod
	 * @description Whether Mod is enabled or not.
	 * @defaultvalue false
	 * 
	 */
	self.enabled = enabled ?? false

    /**
     * @name source
     * @type {String|Undefined|Kengine.Extensions.Mods.ModSource}
     * @memberof Kengine.Extensions.Mods.Mod
     * @descripton The source of this mod.
     * @defaultvalue "<unknown>"
     * 
     */
    self.source = source ?? "<unknown>"

	Kengine.Utils.Events.Fire("mods__mod__init__before", {_mod: this});

	/**
	 * @function GetAssetConfs
	 * @memberof Kengine.Extensions.Mods.Mod
	 * @description Returns the mod's asset confs.
	 * @return {Array<Kengine.Extensions.Mods.AssetConf>}
	 *
	 */
	GetAssetConfs = function() {
		var _asset_confs = [];
		var _asset_confs_names = __KengineMods.__GetAcceptableAssetConfsTypesNames(struct_get_names(self.asset_confs));
		array_sort(_asset_confs_names, function(a, b) {
			var _sort_ref_array = KENGINE_ASSET_TYPES_ORDER;
			return array_get_index(_sort_ref_array, a) - array_get_index(_sort_ref_array, b);
		})
		for (var _i=0; _i<array_length(_asset_confs_names); _i++) {
			for (var _j=0; _j<array_length(self.asset_confs[$ _asset_confs_names[_i]]); _j++) {
				array_push(_asset_confs, self.asset_confs[$ _asset_confs_names[_i]][_j])
			}
		}
		return _asset_confs;
	}

	/**
	 * @function Enable
	 * @memberof Kengine.Extensions.Mods.Mod
	 * @description Enables the mod. Applying its `asset_confs`.
	 *
	 */
	Enable = function() {
		var this = self;
		Kengine.Utils.Events.Fire("mods__mod__enable__before", {_mod: this});
		var _asset_confs = self.GetAssetConfs();
		for (var _i=0; _i<array_length(_asset_confs); _i++) {
			_asset_confs[_i].Apply(self);
		}
		self.enabled = true;
		Kengine.Utils.Events.Fire("mods__mod__enable__after", {_mod: this});
	}

	/**
	 * @function Disable
	 * @memberof Kengine.Extensions.Mods.Mod
	 * @description Disables the mod. Unapplying its `asset_confs`.
	 * 
	 */
	Disable = function() {
		var this = self;
		Kengine.Utils.Events.Fire("mods__mod__disable__before", {_mod: this});
		var _asset_confs = self.GetAssetConfs();
		for (var _i=0; _i<array_length(_asset_confs); _i++) {
			_asset_confs[_i].Unapply(self);
		}
		self.enabled = false;
		Kengine.Utils.Events.Fire("mods__mod__disable__after", {_mod: this});
	}

	/**
	 * @function ResolveDependencies
	 * @memberof Kengine.Extensions.Mods.Mod
	 * @description Resolves dependencies. If there are `string` values as dependencies, it is converted to a `Mod` (if found) or it's kept.
	 *
	 */
	ResolveDependencies = function() {
		for (var _i=0; _i<array_length(self.dependencies); _i++) {
			if is_string(self.dependencies[_i]) {
				var _mod = __KengineMods.mod_manager.mods.GetInd(self.dependencies[_i], Kengine.Utils.Cmps.cmp_val1_val2_name);
				if _mod != -1 {
					self.dependencies[_i] = __KengineMods.mod_manager.mods.Get(_mod);
				}
			}
		}
	}

	/**
	 * @function Update
	 * @memberof Kengine.Extensions.Mods.Mod
	 * @description Resolves or update mod's assetconfs from the mod's source.
	 *
	 */
	Update = function() {
        if self.enabled return

        var this = self;

		var _data = Kengine.Extensions.Mods.ParseModFileSync(self.name, self.source); // TODO: Async option

		if _data == undefined {
			return false;
		}

		var _name = Kengine.Utils.Structs.Get(_data, "name"); if _name != undefined {self.display_name = _name;}
		var _desc = Kengine.Utils.Structs.Get(_data, "description"); if _desc != undefined {self.description = _desc;}
		var _auth = Kengine.Utils.Structs.Get(_data, "author"); if _auth != undefined {self.author = _auth;}
		var _vers = Kengine.Utils.Structs.Get(_data, "version"); if _vers != undefined {self.version = _vers;}
		var _deps = Kengine.Utils.Structs.Get(_data, "dependencies"); if _deps != undefined {
			self.dependencies = _deps;
			self.ResolveDependencies();
		}
        var _asset_confs = Kengine.Utils.Structs.Get(_data, "assets");
        if _asset_confs != undefined {
            self.UpdateAssetConfs(_asset_confs);
        }
        Kengine.Utils.Events.Fire("mods__mod__update__after", {_mod: this});
        return true;
	}

	/**
	 * @function UpdateAssetConfs
	 * @memberof Kengine.Extensions.Mods.Mod
	 * @description Resolves or update mod's current assetconfs with updated and/or newly created assetconfs.
	 * This would add and update existing asset confs of the mod.
	 * @param {Array<Kengine.Extensions.Mods.AssetConf>|Struct} asset_confs
	 * 
	 */
	UpdateAssetConfs = function(asset_confs) {
		var _asset_confs_struct = __KengineMods.__NormalizeAssetConfs(asset_confs);
		var _prev_asset_confs_array = self.GetAssetConfs();
        var _a;
		var _ms;
		var _typ;
		var _conf, _opts;
		var _create = true;
		var _asset_confs_names = __KengineMods.__GetAcceptableAssetConfsTypesNames(struct_get_names(_asset_confs_struct));

        // Iterate over new asset conf types.
		for (var _i=0; _i<array_length(_asset_confs_names); _i++) {
			_a = Kengine.Utils.Structs.Get(_asset_confs_struct, _asset_confs_names[_i]);

            // Iterate over asset confs of the current type.
            for (var _j=0; _j<array_length(_a); _j++) {
				_create = true;

                // Iterate over previous asset confs.
                for (var _k=0; _k<array_length(_prev_asset_confs_array); _k++) {

                    // Get the type main name (not synonyms) and update it.
                    _typ = Kengine.Utils.Structs.Get(_a[_j], "type");
					_typ = _typ ?? _asset_confs_names[_i];
					_typ = __KengineMods.GetAssetTypeSynonymsArray(_typ)[0];
					// _typ = Kengine.Utils.Structs.Get(Kengine.asset_types, _typ);
                    _a[_j].type = _typ;

                    // If type and name are the same (from previous and new asset confs)
                    if _a[_j].name == _prev_asset_confs_array[_k].conf.name and _a[_j].type == _prev_asset_confs_array[_k].conf.type {

                        // Handle applied assets.
                        if _prev_asset_confs_array[_k].is_applied {
                            throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__asset_conf__cannot_update, string("Mod \"{0}\" AssetConf \"{1}\" cannot be updated since it's applied currently.", self, _prev_asset_confs_array[_k].conf.name));
                        }

                        // Replace original asset confs (objects) conf with new info (confs).
						_ms = struct_get_names(_a[_j]);
						for (var m=0; m<array_length(_ms); m++) {
							Kengine.Utils.Structs.Set(_prev_asset_confs_array[_k].conf, _ms[m], Kengine.Utils.Structs.Get(_a[_j], _ms[m]));
						}
						_create = _k;
						break;
					}
				}

                // Otherwise no break means no matching update.
				if _create != true {
					_conf = _prev_asset_confs_array[_create];
				} else {
                    // It's a new assetconf for this mod.
					try {
                        // Set canonical type name.
						_typ = Kengine.Utils.Structs.Get(_a[_j], "type");
						_typ = _typ ?? _asset_confs_names[_i];
						_typ = __KengineMods.GetAssetTypeSynonymsArray(_typ)[0];
						// _typ = Kengine.Utils.Structs.Get(Kengine.asset_types, _typ);
						_a[_j].type = _typ;

						if Kengine.Utils.Structs.Exists(Kengine.asset_types, _typ) {
							_conf = new __KengineModsAssetConf(_a[_j]);
							_a[_j] = _conf;
						} else {
							throw "ASSET_CONF__INVALID_TYPE";
						}
					} catch (e) {
						throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__asset_conf__invalid, string("Mod \"{0}\" AssetConfs of \"{1}\" are invalid.", self, _asset_confs_names[_i]));
					}
				}
			}
		}
	
		self.asset_confs = _asset_confs_struct;
	}

	toString = function() {
		return string("<Mod {0}>", self.name);
	}

	Kengine.Utils.Events.Fire("mods__mod__init__after", {_mod: this});
	Kengine.Extensions.Mods.mod_manager.mods.AddOnce(self);
}
