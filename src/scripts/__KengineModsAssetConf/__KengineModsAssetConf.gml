
/**
 * @function AssetConf
 * @memberof Kengine.Extensions.Mods
 * @param {Struct} conf The conf of the asset to initiate the `Kengine.Extensions.Mods.AssetConf` with. Must at least have `{name, type}`
 * @description An AssetConf is a configuration object for an asset to be applied or unapplied. AssetConfs are created when creating or updating the mod using `mod.update` function.
 * 
 */
function __KengineModsAssetConf(conf) constructor {

    /**
	 * @name conf
	 * @type {Kengine.Struct}
	 * @memberof Kengine.Extensions.Mods.AssetConf
	 * @description The internal confs of this AssetConf.
	 * 
	 * Note - underscore confs are stripped out.
	 *
	 */
    self.conf = new __KengineStruct(undefined, {
		original_attributes: {},
	});

	var ns = struct_get_names(conf);
	// Remove only the first depth of confs "_" names.
	for (var i=0; i<array_length(ns); i++) {
		if string_starts_with(ns[i], "_") continue;
		self.conf[$ ns[i]] = conf[$ ns[i]];
	}

	var this = self;
    Kengine.Utils.Events.Fire("mods__asset_conf__init__before", {asset_conf: this});

	if !struct_exists(self.conf, "name") {
		throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__asset_conf__no_name);
	}
	if !struct_exists(self.conf, "type") {
		throw Kengine.Utils.Errors.create(Kengine.Utils.Errors.Types.mods__asset_conf__no_type, string("AssetConf \"{0}\" does not have a type.", self.conf.name));
	}

	/**
	 * @name is_applied
	 * @type {Bool}
	 * @memberof Kengine.Extensions.Mods.AssetConf
	 * @description Whether the assetconf is applied by a specific mod. Defaults to `false`.
	 *
	 */
	self.is_applied = false;

	/**
	 * @name target
	 * @type {Kengine.Asset}
	 * @memberof Kengine.Extensions.Mods.AssetConf
	 * @description The target asset of this asset conf. It can be the same as `self.asset` if it's totally new, or the replacement asset target.
	 *
	 */
	self.target = undefined;


    /**
     * @name source_mod
     * @type {Kengine.Extensions.Mods.Mod|Undefined}
     * @memberof Kengine.Extensions.Mods.AssetConf
     * @description The mod emitting this assetconf.
     *
     */
    self.source_mod = undefined;

	/**
	 * @name asset
	 * @type {Kengine.Asset}
	 * @memberof Kengine.Extensions.Mods.AssetConf
	 * @description The asset created by this asset conf. It can be the same as `self.target` if it's totally new.
	 *
	 */
    self.asset = undefined;

	/**
	 * @function Apply
	 * @memberof Kengine.Extensions.Mods.AssetConf
	 * @description Applies this asset conf, creating a new asset.
	 *
	 */
	self.Apply = function(source_mod) {
		if self.is_applied return;

        var this = self;
		self.source_mod = source_mod;
		Kengine.console.verbose("Kengine: Mods: Applying AssetConf: " + string(self), 3);

		var _assettype;
		if is_string(self.conf.type)
	        _assettype = Kengine.asset_types[$ self.conf.type];
		else
			_assettype = self.conf.type;

		if not Kengine.Utils.Structs.Exists(self.conf, "replaces") {
			if not _assettype.is_addable {
				throw Kengine.Utils.Errors.Create("asset__asset_type__cannot_add", string("Cannot add Asset of AssetType \"{0}\".", _assettype.name));
			}
		}

		Kengine.Utils.Events.Fire("mods__asset_conf__apply__before", {asset_conf: this});
		if !struct_exists(Kengine.asset_types, this.conf.type) {
			throw Kengine.Utils.Errors.Create("assettype__does_not_exist", string("AssetType \"{0}\" for AssetConf \"{1}\" does not exist.", self.conf.type, self.conf.name));
		}

		self.asset = new __KengineAsset(_assettype, self.conf.name);

		if Kengine.Utils.Structs.Exists(_assettype, "asset_conf_mapping") {
			if is_callable(_assettype.asset_conf_mapping) {
				_assettype.asset_conf_mapping(self);
			} else {
				var mappers = _assettype.asset_conf_mapping;
				for (var _j=0; _j<array_length(mappers); _j ++){ 
					mappers[_j].Resolve(self);
				}
			}
		}

		var _vs = struct_get_names(self.conf);
		for (var i=0; i<array_length(_vs); i++) {
			if _vs[i] == "type" continue; // Do not overwrite type
			if string_starts_with(_vs[i], "_") continue; // Optional: Do not write values with underscore.
			if !struct_exists(self.asset, _vs[i]) {
				self.asset[$ _vs[i]] = self.conf[$ _vs[i]];
			}
		}

		if struct_exists(self.conf, "replaces") {
			self.target = Kengine.Utils.GetAsset(_assettype, self.conf.replaces);
			self.target.ReplaceWith(self.asset);
		} else {
			self.target = self.asset;
			if self.target.tags == undefined self.target.tags = new __KengineCollection();
			self.target.tags.AddOnce(KENGINE_ASSET_TAG_ADDED);
		}

		self.is_applied = true;
		Kengine.Utils.Events.Fire("mods__asset_conf__apply__after", {asset_conf: this});
	}

	/**
	 * @function Unapply
	 * @memberof Kengine.Extensions.Mods.AssetConf
	 * @description Unapplies this asset conf, destroying or removing the asset created.
	 *
	 */
	self.Unapply = function(source_mod) {
		var this = self;
		var _is_added;
		if not self.is_applied return;
		Kengine.Utils.Events.Fire("mods__asset_conf__unapply__before", {asset_conf: this});
		if self.target == self.asset {
			_is_added = true;
			self.target.tags.Remove(KENGINE_ASSET_TAG_ADDED);
		} else {
			_is_added = false;
			self.target.replaced_by = undefined;
			self.target.tags.Remove(KENGINE_ASSET_TAG_REPLACED);
		}
		if Kengine.Utils.Structs.Exists(self.asset, "Remove") {
			self.asset.Remove();
		} else if Kengine.Utils.Structs.Exists(self.asset, "Destroy") {
            self.asset.Destroy();
        }
		delete self.asset;
		self.asset = undefined;

		self.is_applied = false;
		Kengine.Utils.Events.Fire("mods__asset_conf__unapply__after", {asset_conf: this});
	}

	self.toString = function() {
		return string("<AssetConf \"{0}\">", self.conf.name);
	}

	Kengine.Utils.Events.Fire("mods__asset_conf__init__after", {asset_conf: this});
}
