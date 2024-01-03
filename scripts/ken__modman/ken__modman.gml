function ken_mods_read_file(filepath, show_err=true) {
	// TODO: Consider online files.
	var jsonc;
	var fpath = filepath;
	var choices = [
		GAME_EXE_DIRECTORY,
		program_directory,
		working_directory,
		game_save_id,
	];
	var i = array_length(choices);
	while (--i >= 0) {
		fpath = choices[i] + filepath;
		if file_exists(fpath) {
			filepath = fpath;
			break;
		}
	}
	if file_exists(filepath) {
		var _f = file_text_open_read(filepath);
		var t = ""
		while !(file_text_eof(_f)) {
			t = t + file_text_read_string(_f) + "\n"
			file_text_readln(_f);
		}
		file_text_close(_f);
		return t;

		/*
		try {
			jsonc = json_parse(t);
		} catch (e) {
			Kengine.console.echo_error("Kengine: Mods: Error: JSON parse error in \""+ filepath + "\"");
			Kengine.console.echo_ext("Kengine: Mods: Warning: mod was not loaded due to error.", c_yellow, true, true);
			return {};
		}
		return jsonc;*/

	} else {
		if show_err {
			Kengine.console.echo_error("Kengine: Mods: Error: File \"" + filepath + "\" does not exist.");
		}
		return undefined;
	}
}

function ken_mods_parse_mod_file(_mod, filepath) {
	// Parse twice the mod file strings to resolve @ symbols. And return a struct.
	// Struct contains assetconfs, and general confs.
	var result;
	var modtext = ken_mods_read_file(filepath, true);
	if modtext == undefined {
		Kengine.console.echo_ext(string("Kengine: Mods: Warning: mod file \"{0}\" was not loaded due to error.", _mod), c_yellow, true, true);
		return undefined;
	}
	try {
		result = SnapFromYAML(modtext);
	} catch (e) {
		Kengine.console.echo_error("Kengine: Mods: Error: Could not parse mod \"" + _mod + "\" config.yml file");
		Kengine.console.echo_ext(string("Kengine: Mods: Warning: mod file \"{0}\" was not loaded due to error.", _mod), c_yellow, true, true);
		return undefined;
	}
	var imports = [];
	var imports_found_per_file = [];
	while true {
		try {
			values_map(result, method({imports, imports_found_per_file}, function(val) {
				var dir = "@import ";
				if string_starts_with(val, dir) {
					var val2 = ken_mods_read_file(string_copy(val, string_length(dir)+1, string_length(val) - string_length(dir)), false);
					if val2 == undefined {
						throw {type: "FAIL_PARSE_FILE"};
					}
					if array_contains(imports, val) {
						throw {type: "FAIL_PARSE_IMPORT"};
					}
					imports[array_length(imports)] = val;
					imports_found_per_file[array_length(imports_found_per_file)] = val;
					val = SnapFromYAML(val2);
				}
				return val;
			}));
		} catch (e) {
			if e.type == "FAIL_PARSE_FILE" {
				Kengine.console.echo_error("Kengine: Mods: Error: File \"" + filepath + "\" does not exist.");
			} else if e.type == "FAIL_PARSE_IMPORT" {
				Kengine.console.echo_error("Kengine: Mods: Error: File \"" + filepath + "\" has recursive imports.");
			}
			Kengine.console.echo_ext(string("Kengine: Mods: Warning: mod file \"{0}\" was not loaded due to error.", _mod), c_yellow, true, true);
			return undefined;
		}
		if array_length(imports_found_per_file) == 0 {
			break;
		} else {
			imports_found_per_file = [];
			continue;
		}
	}
	return result;
}

function ken_mods_default_game_find_mods() {

	return ken_mods_default_dir_find_mods();

	// Write your mod loading code here.
	// A sample way to load your mods is written below.

	// Example:
	//var mod_1 = new Kengine.Mod({name: "my-first-mod", enabled: false});
	//var mod_2 = new Kengine.Mod({name: "my-second-mod", enabled: false})
	//var mod_3 = new Kengine.Mod({name: "my-third-mod", enabled: false, dependencies: [
	//		mod_1, "my-second-mod",
	//]});

	//mods_found = [
	//		mod_1,
	//		mod_2,
	//		mod_3,
	//];
}

/**
 * @function ken_mods_default_dir_find_mods
 * @description Find directory mods. Return Mod objects.
 * @return {Array<Kengine.mods.Mod>}
 *
 */
function ken_mods_default_dir_find_mods() {
	var choices = [
		GAME_EXE_DIRECTORY,
		program_directory,
		working_directory,
		game_save_id,
	];

	var _files = [];
	var _dirs = [];
	var mods_found = [];
	var file_name, dir_name;

	for (var i=0; i<array_length(choices); i++) {
		file_name = file_find_first(choices[i] + "/mods/" + "*.zip", fa_archive);
		while (file_name != "")
			{
			Kengine.console.debug("Found ZIP archive: \"" + choices[i] + "/mods/" + file_name + "\"");
			array_push(_files, choices[i] + "/mods/" + file_name);
			file_name = file_find_next();
			}
		file_find_close();

		dir_name = file_find_first(choices[i] + "/mods/*", fa_directory);
		while (dir_name != "")
			{
			if not directory_exists(choices[i] + "/mods/" + dir_name) {
				dir_name = file_find_next();
				continue;
			}
			Kengine.console.debug("Found mod: \"" + choices[i] + "/mods/" + dir_name + "\"");
			array_push(_dirs, choices[i] + "/mods/" + dir_name);
			dir_name = file_find_next();
			}
		file_find_close();

		file_name = file_find_first(choices[i] + "/" + "*.zip", fa_archive);
		while (file_name != "")
			{
			Kengine.console.debug("Found ZIP archive: \"" + "/" + file_name + "\"");
			array_push(_files, choices[i] + "/" + file_name);
			file_name = file_find_next();
			}
		file_find_close();
	}

	var _mod;
	var mod_name;
	var extracted = false;
	var tgt;

	// Iterate ZIP files.
	for (var i=0; i<array_length(_files); i++) {
		mod_name = string_copy(filename_name(_files[i]), 1, string_length(filename_name(_files[i])) - 4);
		for (var j=0; j<array_length(mods_found); j++) {
			if mods_found[j].name == mod_name or mods_found[j].original_name == mod_name {
				throw Kengine.utils.errors.create(Kengine.utils.errors.types.mods__mod__duplicate, string("Duplicate Mod \"{0}\" found.", mod_name));
			}
		}
		if not directory_exists(temp_directory + "archives/" + mod_name) directory_create(temp_directory + "archives/" + mod_name);
		tgt = temp_directory + "archives/" + mod_name;
		extracted = zip_unzip(_files[i], tgt);
		if extracted {
			_mod = new Kengine.mods.Mod({
				name: mod_name,
				source: tgt + "/config.yml",
				enabled: false,
				is_extracted: true,
			});
			array_push(mods_found, _mod);
			_mod.original_name = mod_name;
			_mod.update();
		}
	}

	// Iterate directories.
	for (var i=0; i<array_length(_dirs); i++) {
		mod_name = filename_name(_dirs[i]);
		for (var j=0; j<array_length(mods_found); j++) {
			if mods_found[j].name == mod_name or mods_found[j].original_name == mod_name {
				throw Kengine.utils.errors.create(Kengine.utils.errors.types.mods__mod__duplicate, string("Duplicate Mod \"{0}\" found.", mod_name));
			}
		}
		_mod = new Kengine.mods.Mod({
			name: mod_name,
			source: _dirs[i] + "/config.yml",
			enabled: false,
			is_extracted: true,
		});
		array_push(mods_found, _mod);
		_mod.original_name = mod_name;
		_mod.update();
	}

	return mods_found;
}


/**
 * @namespace mods
 * @memberof Kengine
 * @description Kengine's Mods extension
 *
 */
Kengine.mods = {};

/**
 * @typedef {Struct} ModOptions
 * @memberof Kengine.mods.Mod
 * @description Mod options struct.
 * @property {String} name The name of the Mod.
 * @property {Array<Kengine.mods.AssetConf>} [asset_confs=[]]] AssetConfs that the Mod comprises.
 * @property {Bool} [enabled=false] Whether the mod is enabled or not.
 * @property {Array<Kengine.mods.Mod>} [dependencies=[]]] Mod dependencies of other Mods.
 *
 */

/**
 * @function Mod
 * @constructor
 * @new_name Kengine.mods.Mod
 * @memberof Kengine.mods
 * @description A mod is a group of {@link Kengine.mods.AssetConf} to be added as Assets, or replace other Assets.
 * When enabling a mod, this happens. And when disabling it, all new assets are deleted and replaced ones are restored.
 * This class is swappable through {@link Kengine.conf.exts.mods.mod_class}. You can also extend this class from its original definition: `Kengine.mods.DefaultMod`.
 *
 * @param {Kengine.mods.Mod.ModOptions} options A struct containing key-value configuration of the mod.
 *
 */
Kengine.mods.DefaultMod = function(options) constructor {
	var this = self;

	if not struct_exists(options, "name") {
		throw Kengine.utils.errors.create(Kengine.utils.errors.types.mods__mod__no_name);
    }
	if not struct_exists(options, "description") {
		options.description = "";
    }

	/**
	 * @name options
	 * @type {Kengine.mods.Mod.ModOptions}
	 * @memberof Kengine.mods.Mod
	 * @private
	 * @description The initial `options` provided when creating the `Mod`.
	 * 
	 */
	self.options = options;

	Kengine.utils.events.fire("mods__mod__init__before", {_mod: this,});

	/**
	 * @name name
	 * @type {String}
	 * @memberof Kengine.mods.Mod
	 * @description The name property of the Mod. Can be provided in creation options. Required.
	 * 
	 */
	self.name = self.options.name;
	/**
	 * @name description
	 * @type {String}
	 * @memberof Kengine.mods.Mod
	 * @description The description property of the Mod. Can be provided in creation options.
	 * @defaultvalue ""
	 * 
	 */
	self.description = self.options.description;

	/**
	 * @name source
	 * @type {String}
	 * @memberof Kengine.mods.Mod
	 * @description The source property of the Mod.
	 * @defaultvalue "<unknown source>"
	 *
	 */
	self.source = Kengine.utils.structs.get(self.options, "source") ?? "<unknown source>";
	
	self.url = Kengine.utils.structs.set_default(self.options, "url", undefined);

	self.is_downloaded = Kengine.utils.structs.set_default(self.options, "is_downloaded", false);
	self.download_url = Kengine.utils.structs.set_default(self.options, "download_url", undefined);
	self.is_extracted = Kengine.utils.structs.set_default(self.options, "is_extracted", false);

	/**
	 * @name asset_confs
	 * @type {Struct}
	 * @memberof Kengine.mods.Mod
	 * @description The `asset_confs` property of the Mod. Set by the mod manager when it finds mods.
	 * @defaultvalue {}
	 *
	 */
	self.asset_confs = Kengine.utils.structs.set_default(self.options, "asset_confs", {});

	/**
	 * @name enabled
	 * @type {Bool}
	 * @memberof Kengine.mods.Mod
	 * @description Whether Mod is enabled or not.
	 * @defaultvalue false
	 * 
	 */
	self.enabled = Kengine.utils.structs.set_default(self.options, "enabled", false);

	/**
	 * @name dependencies
	 * @type {Array<Kengine.mods.Mod>}
	 * @memberof Kengine.mods.Mod
	 * @description Mod dependencies.
	 * @defaultvalue []
	 * 
	 */
	self.dependencies = Kengine.utils.structs.set_default(self.options, "dependencies", []);

	self.get_all_asset_confs = function() {
		var _asset_confs = [];
		var _asset_confs_names = struct_get_names(self.asset_confs);
		for (var i=0; i<array_length(_asset_confs_names); i++) {
			for (var j=0; j<array_length(self.asset_confs[$ _asset_confs_names[i]]); j++) {
				array_push(_asset_confs, self.asset_confs[$ _asset_confs_names[i]][j])
			}
		}
		return _asset_confs;
	}

	/**
	 * @function enable
	 * @memberof Kengine.mods.Mod
	 * @description Enables the mod. Applying all its `asset_confs`.
	 *
	 */
	self.enable = function() {
		var this = self;
		Kengine.utils.events.fire("mods__mod__enable__before", {_mod: this,});
		var _asset_confs = self.get_all_asset_confs();
		for (var i=0; i<array_length(_asset_confs); i++) {
			_asset_confs[i].apply(self);
		}
		self.enabled = true;
		Kengine.utils.events.fire("mods__mod__enable__after", {_mod: this,});
	}

	/**
	 * @function disable
	 * @memberof Kengine.mods.Mod
	 * @description Disables the mod. Unapplying all its `asset_confs`.
	 * 
	 */
	self.disable = function() {
		var this = self;
		Kengine.utils.events.fire("mods__mod__disable__before", {_mod: this,});
		var _asset_confs = self.get_all_asset_confs();
		for (var i=0; i<array_length(_asset_confs); i++) {
			_asset_confs[i].unapply(self);
		}
		self.enabled = false;
		Kengine.utils.events.fire("mods__mod__disable__after", {_mod: this,});
	}

	/**
	 * @function resolve_dependencies
	 * @memberof Kengine.mods.Mod
	 * @description Resolve dependencies if any is a `string`, it is converted for a `Mod` if found, otherwise it's kept as `string`.
	 *
	 */
	self.resolve_dependencies = function() {
		for (var i=0; i<array_length(self.dependencies); i++) {
			if is_string(self.dependencies[i]) {
				var __mod = Kengine.mods.mod_manager.mods.get_ind(self.dependencies[i], Kengine.utils.cmps.cmp_val1_val2_name);
				if __mod != -1 {
					self.dependencies[i] = Kengine.mods.mod_manager.mods.get(__mod);
				}
			}
		}
	}

	/**
	 * @function update
	 * @memberof Kengine.mods.Mod
	 * @description Resolve or update mod's assetconfs from its source.
	 *
	 */
	self.update = function() {
		var payload = ken_mods_parse_mod_file(self.name, self.source);
		if payload == undefined {
			return false;
		}
		var _name = Kengine.utils.structs.get(payload, "name"); if _name != undefined {self.name = _name;}
		var _desc = Kengine.utils.structs.get(payload, "description"); if _desc != undefined {self.description = _desc;}
		var _auth = Kengine.utils.structs.get(payload, "author"); if _auth != undefined {self.author = _auth;}
		var _url = Kengine.utils.structs.get(payload, "url"); if _url != undefined {self.url = _url;}
		try {
			var _asset_confs = Kengine.utils.structs.get(payload, "assets"); if _asset_confs != undefined {self._update_asset_confs(_asset_confs);}
		} catch (e) {
			Kengine.console.echo_error("Kengine: Mods: Error: " + e.longMessage);
		}
	}

	self._update_asset_confs = function(asset_confs) {
		var _orig_asset_confs = self.get_all_asset_confs();
		var _asset_confs = {};
		var a;
		if is_array(asset_confs) {
			for (var i=0; i<array_length(asset_confs); i++) {
				a = Kengine.utils.structs.set_default(_asset_confs, asset_confs[i].type, []);
				array_push(a, asset_confs[i]);
			}
		} else {
			_asset_confs = asset_confs;
		}
		
		// _asset_confs is asset_confs but as struct.

		var ms;
		var typ;
		var conf, opts;
		var c = true;
		var asset_confs_names = struct_get_names(_asset_confs);
		for (var i=0; i<array_length(asset_confs_names); i++) {
			a = Kengine.utils.structs.get(_asset_confs, asset_confs_names[i]);
			for (var j=0; j<array_length(a); j++) {
				c = true;
				for (var k=0; k<array_length(_orig_asset_confs); k++) {
					typ = Kengine.utils.structs.get(a[j], "type");
					typ = typ ?? asset_confs_names[i];
					a[j].type = typ;
					if a[j].name == _orig_asset_confs[k].conf.name and a[j].type == _orig_asset_confs[k].conf.type {
						// Replace original asset confs (objects) conf with new info (confs).
						ms = struct_get_names(a[j]);
						for (var m=0; m<array_length(ms); m++) {
							Kengine.utils.structs.set_default(_orig_asset_confs[k].conf, ms[m], Kengine.utils.structs.get(a[j], ms[m]));
						}
						c = k;
						break;
					}
				}
				if c != true {
					conf = _orig_asset_confs[c];
				} else {
					try {
						typ = Kengine.utils.structs.get(a[j], "type");
						typ = typ ?? asset_confs_names[i];
						a[j].type = typ;
						if Kengine.utils.structs.exists(Kengine.asset_types, typ) {
							conf = new Kengine.mods.AssetConf(a[j]);
							a[j] = conf;
						} else {
							throw "ASSET_CONF__INVALID_TYPE";
						}
					} catch (e) {
						throw Kengine.utils.errors.create(Kengine.utils.errors.types.mods__asset_conf__corrupt, string("Mod \"{0}\" AssetConfs of \"{1}\" are invalid.", self, asset_confs_names[i]));
					}
				}
			}
		}
	
		self.asset_confs = _asset_confs;
		// Events.
	}

	self.toString = function() {
		return string("<Mod {0}>", self.name);
	}

	Kengine.utils.events.fire("mods__mod__init__after", {_mod: this,});
	Kengine.mods.mod_manager.mods.add_once(self);
}

/**
 * @typedef {Struct} ModManagerOptions
 * @memberof Kengine.mods.ModManager
 * @description ModManager options struct.
 * @property {Function} [find_mods_func=undefined] A function to run for finding mods. This function should return an array or {@link Kengine.Collection} of {@link Kengine.mods.Mod} objects.
 * @property {Array<Kengine.mods.Mod>} [mods=[]]] Initial mods that are found. Defaults to the output of `find_mods` function.
 *
 */

/**
 * @function ModManager
 * @constructor
 * @new_name Kengine.mods.ModManager
 * @memberof Kengine.mods
 * @description A mod manager is a singleton object that manages {@link Kengine.mods.Mod} objects.
 * This class is swappable through {@link Kengine.conf.exts.mods.mod_manager_class}. You can also extend this class from its original definition: `Kengine.mods.DefaultModManager`.
 * @param {Kengine.mods.ModManager.ModManagerOptions} options A struct containing key-value configuration of the mod manager.
 * 
 */
Kengine.mods.DefaultModManager = function(options) constructor {
	var this = self;
	/**
	 * @name options
	 * @type {Kengine.mods.ModManager.ModManagerOptions}
	 * @memberof Kengine.mods.ModManager
	 * @private
	 * @description The initial `options` provided when creating the `ModManager`.
	 *
	 */
	self.options = options ?? {};

	self.toString = function() {
		return string("<ModManager (Kengine.mods.mod_manager)>");
	}

	Kengine.utils.events.fire("mods__mod_manager__init__before", {mod_manager: this,});

	/**
	 * @name mods
	 * @type {Kengine.Collection}
	 * @memberof Kengine.mods.ModManager
	 * @description Collection of `Mod` objects that are found by {@link Kengine.mods.ModManager.find_mods}. Defaults to empty Collection.
	 *
	 */
	self.mods = [];

	/**
	 * @function find_mods
	 * @memberof Kengine.mods.ModManager
	 * @description A function to search for mods. It uses `find_mods_func` set with `options` previously.
	 * @return {Collection|Array<Kengine.mods.Mod>}
	 * 
	 */
	self.find_mods_func = Kengine.utils.structs.set_default(self.options, "find_mods_func", ken_mods_default_game_find_mods);
	self.find_mods = function() {
		var this = self;
		var mods = [];
		Kengine.utils.events.fire("mods__mod_manager__find_mods__before", {mod_manager: this, mods});
		if self.find_mods_func != undefined {
			self.find_mods_func = method({this}, self.find_mods_func);
			if array_length(mods) == 0 {
				try {
					mods = Kengine.utils.structs.set_default(self.options, "mods", self.find_mods_func());
				} catch (e) {
					Kengine.console.echo_error("Kengine: Mods: Error: " + e.longMessage);
					return false;
				}
			}
		} else {
			var __is_empty = false;
			if is_instanceof(mods, Kengine.Collection) {
				if mods.length() == 0 {
					__is_empty = true;
				}
			} else {
				if array_length(mods) == 0 {
					__is_empty = true;
				}
			}
			if __is_empty {
				Kengine.console.echo_ext(string("Kengine: Mods: Warning: No mods are found since there is no \"find_mods\" function option for {0}", self.toString()), c_yellow, true, true);
			}
		}
		if not is_instanceof(mods, Kengine.Collection) {
			mods = new Kengine.Collection(mods);
		}
		Kengine.utils.events.fire("mods__mod_manager__find_mods__after", {mod_manager: this, mods: mods});
		
		for (var m=0;m<array_length(mods); m++) {
			self.mods.add_once(mods[m]);
		}
	}

	/**
	 * @function reload_mods
	 * @param {Bool} [discover=false] Whether to discover new mods or not.
	 * @memberof Kengine.mods.ModManager
	 * @description A function to reload mods.
	 * 
	 */
	self.reload_mods = function(discover=false) {
		if discover {
			self.find_mods();
		}
		
		// var mods = self.mods.get_all();
		// for (var m=0;m<array_length(mods); m++) {
		//  	mods[m].update();
		// }
	}

	/**
	 * @function enable
	 * @memberof Kengine.mods.ModManager
	 * @param {String|Kengine.mods.Mod} _mod The mod to enable.
	 * @param {Real} [force=0] Whether to enable the mod forcefully by enabling its dependencies.
	 * @description Enable a Mod. If forced, enable its dependencies.
	 * 
	 * Returns a struct containing `{success, dependencies_to_enable, dependencies_not_found, dependencies_enabled}`.
	 * 
	 * `success`: Whether enabling was successful.
	 * 
	 * `dependencies_to_enable`: Dependencies that still need to be enabled manually. If `force` is `true`, This should be an empty array.
	 * 
	 * `dependencies_not_found`: Dependencies that are needed but not found as initiated Mods.
	 *
	 * `dependencies_enabled`: Dependencies that are enabled as a result of calling this function.
	 *
	 * @return {Struct}
	 *
	 */
	self.enable = function(_mod, force=0) {
		if is_string(_mod) {
			var mod_ind = self.mods.get_ind(_mod, Kengine.utils.cmps.cmp_val1_val2_name);
			if mod_ind == -1 {
				throw Kengine.utils.errors.create(Kengine.utils.errors.types.mods__mod__does_not_exist, string("Mod \"{0}\" does not exist.", _mod));
			}
			_mod = self.mods.get(mod_ind);
		}
		
		_mod.resolve_dependencies();
		var _dependencies = _mod.dependencies;
		var _dependencies_to_enable = [];
		var _dependencies_not_found = [];
		var _dependencies_enabled = [];
		var _dependencies_met = 0;
		var r;

		// Find dependencies structure, add them to the relevant arrays. Enable them if force.
		for (var i=0; i<array_length(_dependencies); i++) {
			if is_string(_dependencies[i]) {
				_dependencies_not_found[array_length(_dependencies_not_found)] = _dependencies[i];
			} else if not _dependencies[i].enabled {
				if (force >= 1) {
					r = self.enable(_dependencies[i], true);
					if r.success {
						_dependencies_enabled[array_length(_dependencies_enabled)] = _dependencies[i];
						_dependencies_met ++;
					}
				} else {
					_dependencies_to_enable[array_length(_dependencies_to_enable)] = _dependencies[i];
				}
			}
		}

		if _dependencies_met == array_length(_dependencies) {
			_mod.enable();
			return {
				success: true,
				dependencies_to_enable: _dependencies_to_enable,
				dependencies_not_found: _dependencies_not_found,
				dependencies_enabled: _dependencies_enabled,
			};
		} else {
			return {
				success: false,
				dependencies_to_enable: _dependencies_to_enable,
				dependencies_not_found: _dependencies_not_found,
				dependencies_enabled: _dependencies_enabled,
			};
		}
	}

	/**
	 * @function disable
	 * @memberof Kengine.mods.ModManager
	 * @param {String|Kengine.mods.Mod} _mod The mod to disable.
	 * @param {Real} [force=0] Whether to disable the mod forcefully by disabling its dependants and dependencies.
	 * @description Disable a Mod. If forced, disable its dependants and dependencies.
	 *
	 * Returns a struct containing `{success, mods_disabled, dependants_to_disable, dependencies_to_disable}`.
	 *
	 * `success`: Whether disabling was successful.
	 *
	 * `mods_disabled`: All mods that have been disabled as a result of calling this function.
	 *
	 * `dependants_to_disable`: An array of `Mod` objects, which are dependants on the mod, if there are any that need to be disabled. If `force` is `1`, They are disabled and this is an empty array.
	 *
	 * `dependencies_to_disable`: An array of `Mod` objects, which are the dependencies of the mod, if there are any that are preferrably to be disabled (they are unused now). If `force` is `2`, They are disabled and this is an empty array.
	 *
	 * @return {Struct}
	 *
	 */
	self.disable = function(_mod, force=0) {
		var mods;
		if is_string(_mod) {
			var mod_ind = self.mods.get_ind(_mod, Kengine.utils.cmps.cmp_val1_val2_name);
			if mod_ind == -1 {
				throw Kengine.utils.errors.create(Kengine.utils.errors.types.mods__mod__does_not_exist, string("Mod \"{0}\" does not exist.", _mod));
			}
			_mod = self.mods.get(mod_ind);
		}

		_mod.resolve_dependencies();
		var _dependencies = _mod.dependencies;
		var _dependencies_to_disable = [];
		var _dependants_to_disable = [];
		var _mods_disabled = [];

		// Find dependencies structure, add them to the relevant arrays. Disable them if force.
		var do_disable;
		mods = self.mods.get_all();
		for (var i=0; i<array_length(_dependencies); i++) {
			if is_string(_dependencies[i]) {
				_dependencies_to_disable[array_length(_dependencies_to_disable)] = _dependencies[i];
			} else if _dependencies[i].enabled {
				if (force >= 2) {
					do_disable = true;
					if do_disable {
						// if there are no other dependants that are active, disable them (without disabling further dependants).
						self.disable(_dependencies[i], 1);
						_mods_disabled[array_length(_mods_disabled)] = _dependencies[i];
					}
				} else {
					_dependencies_to_disable[array_length(_dependencies_to_disable)] = _dependencies[i];
				}
			}
		}

		// Find dependants and disable them if force.
		mods = self.mods.filter(method({_mod}, function(val) {
			return array_contains(val.dependencies, _mod);
		}));
		var is_disabled = false;
		for (var i=0; i<array_length(mods); i++) {
			if (force >= 1) {
				is_disabled = self.disable(mods[i], force).success;
				if is_disabled {
					_mods_disabled[array_length(_mods_disabled)] = mods[i];
				}
			} else {
				_dependants_to_disable[array_length(_dependants_to_disable)] = mods[i]
			}
		}

		if array_length(_dependencies_to_disable) == 0 {
			_mod.disable();
			return {
				success: true,
				mods_disabled: _mods_disabled,
				dependants_to_disable: _dependants_to_disable,
				dependencies_to_disable: _dependencies_to_disable,
			};
		} else {
			return {
				success: false,
				mods_disabled: [],
				dependants_to_disable: _dependants_to_disable,
				dependencies_to_disable: _dependencies_to_disable,
			};
		}
	}

	self.mods = is_array(self.mods) ? new Kengine.Collection(self.mods) : self.mods;

	Kengine.utils.events.fire("mods__mod_manager__init__after", {mod_manager: this,});
}

/**
 * @typedef {Struct} AssetConfOptions
 * @memberof Kengine.mods.AssetConf
 * @description AssetConfOptions options struct.
 * 
 */

/**
 * @function AssetConf
 * @constructor
 * @new_name Kengine.mods.AssetConf
 * @memberof Kengine.mods
 * @param {Kengine.mods.AssetConf.AssetConfOptions} options The options to initiate the `AssetConf` with.
 * @description An AssetConf is a configuration object for an asset to be applied or unapplied. AssetConfs are created when creating or updating the mod using `mod.update` function.
 * This class is swappable through {@link Kengine.conf.exts.mods.asset_conf_class}. You can also extend this class from its original definition: `Kengine.mods.DefaultAssetConf`.
 * 
 */
Kengine.mods.DefaultAssetConf = function(options) constructor {
	var this = self;
	self.options = options;
	Kengine.utils.events.fire("mods__asset_conf__init__before", {asset_conf: this,});

	var ns = struct_get_names(self.options);
	
	/**
	 * @name conf
	 * @type {Struct}
	 * @memberof Kengine.mods.AssetConf
	 * @description The internal confs of this AssetConf. Note: underscore confs are stripped out.
	 *
	 */
	self.conf = {};

	// Remove only the first depth of confs "_" names.
	for (var i=0; i<array_length(ns); i++) {
		if string_starts_with(ns[i], "_") continue;
		self.conf[$ ns[i]] = self.options[$ ns[i]];
	}

	if !struct_exists(self.conf, "name") {
		throw Kengine.utils.errors.create(Kengine.utils.errors.types.mods__asset_conf__no_name);
	}
	if !struct_exists(self.conf, "type") {
		throw Kengine.utils.errors.create(Kengine.utils.errors.types.mods__asset_conf__no_type, string("AssetConf \"{0}\" does not have a type.", self.conf.name));
	}

	/**
	 * @name is_applied
	 * @type {Bool}
	 * @memberof Kengine.mods.AssetConf
	 * @description Whether the assetconf is applied by a specific mod. Defaults to `false`.
	 *
	 */
	self.is_applied = false;

	/**
	 * @name target
	 * @type {Kengine.Asset}
	 * @memberof Kengine.mods.AssetConf
	 * @description The target asset of this asset conf. It can be the same as `self.asset` if it's totally new, or the replacement asset target.
	 * @see {Kengine.Asset.replaces}
	 *
	 */
	self.target = undefined;

	/**
	 * @function apply
	 * @memberof Kengine.mods.AssetConf
	 * @description .
	 *
	 */
	self.apply = function(source_mod) {
		var this = self;
		if self.is_applied return;
		var assettype = Kengine.asset_types[$ self.conf.type];
		if not Kengine.utils.structs.exists(self.conf, "replaces") {
			if not assettype.is_addable {
				throw Kengine.utils.errors.create(Kengine.utils.errors.types.asset__asset_type__cannot_add, string("Cannot add Asset of AssetType \"{0}\".", assettype.name));
			}
		}

		Kengine.utils.events.fire("mods__asset_conf__apply__before", {asset_conf: this,});
		if !struct_exists(Kengine.asset_types, self.conf.type) {
			throw Kengine.utils.errors.create(Kengine.utils.errors.types.assettype__does_not_exist, string("AssetType \"{0}\" for AssetConf \"{1}\" does exist.", self.conf.type, self.conf.name));
		}

		self.asset = new Kengine.Asset(assettype, self.conf.name);

		// switch (self.conf.type) {
			// Here we can manipulate per type of asset.
		// }

		if Kengine.utils.structs.exists(self.conf, "vars") {
			var vs = struct_get_names(self.conf.vars);
			for (var i=0; i<array_length(vs); i++) {
				if vs[i] == "instance_var_struct" {
					if struct_exists(self.conf.vars[$ vs[i]], "sprite_index") {
						if is_string(self.conf.vars[$ vs[i]][$ "sprite_index"]) {
							self.conf.vars[$ vs[i]][$ "sprite_index"] = Kengine.utils.get_asset("sprite", self.conf.vars[$ vs[i]][$ "sprite_index"]).id;
						}
					}
				} else if vs[i] == "event_scripts" {
					var evs = struct_get_names(self.conf.vars.event_scripts);
					for (var j=0; j<array_length(evs); j++) {
						var filepath = filename_dir(source_mod.source);
						var f = filepath + "/" + self.conf.vars.event_scripts[$ evs[j]]
						if not string_ends_with(f, ".vsl") {
							continue;
						}
						var _ev_vsl_text = ken_mods_read_file(f, true);
						if _ev_vsl_text != undefined {
							var _ev_vsl = new Kengine.Asset(Kengine.asset_types.vsl, source_mod.name + "__" + self.conf.name + "__ev_" + evs[j], false);
							_ev_vsl.src = _ev_vsl_text;
							_ev_vsl.compile();
							self.conf.vars.event_scripts[$ evs[j]] = _ev_vsl;
						}
					}
				}
				self.asset[$ vs[i]] = self.conf.vars[$ vs[i]];
			}
		}

		if struct_exists(self.conf, "replaces") {
			self.target = Kengine.utils.get_asset(assettype, self.conf.replaces);
			self.target.replace_by(self.asset);
		} else {
			self.target = self.asset;
			self.target.tags.add_once(Kengine.constants.ASSET_TAG_ADDED);
		}

		self.is_applied = true;
		Kengine.utils.events.fire("mods__asset_conf__apply__after", {asset_conf: this,});
	}

	/**
	 * @function unapply
	 * @memberof Kengine.mods.AssetConf
	 * @description .
	 *
	 */
	self.unapply = function(source_mod) {
		var this = self;
		if not self.is_applied return;
		Kengine.utils.events.fire("mods__asset_conf__unapply__before", {asset_conf: this,});
		if self.target == self.asset {
			self.target.tags.remove(Kengine.constants.ASSET_TAG_ADDED);
		} else {
			self.target.replaced_by = undefined;
			self.target.tags.remove(Kengine.constants.ASSET_TAG_REPLACED);
		}
		if struct_exists(self.asset, "remove") {
			self.asset.remove();
		}
		self.asset = undefined;

		self.is_applied = false;
		Kengine.utils.events.fire("mods__asset_conf__unapply__after", {asset_conf: this,});
	}

	self.toString = function() {
		return string("<AssetConf \"{0}\">", self.conf.name);
	}

	Kengine.utils.events.fire("mods__asset_conf__init__after", {asset_conf: this,});
}

/// @description Define DO EV and DO EV
/// @function do_ev
/// @param {Struct} ev 
/// @param {Real} ev_arg
function do_ev(ev, ev_arg) {
	var scr = "";
	if not variable_instance_exists(self, "wrapper") exit;
	Kengine.utils.structs.set_default(wrapper.asset, "event_scripts", {});
	scr = Kengine.utils.structs.get(wrapper.asset.event_scripts, ev);
	if scr != undefined {
		if is_instanceof(scr, Kengine.Asset) {
			return Kengine.utils.parser.interpret_asset(scr, wrapper, {wrapper, event: ev.name, event_arg: ev_arg, vsl_object: wrapper,});
		} else if is_method(scr) {
			return method({wrapper, event: ev.name, event_arg: ev_arg, vsl_object: wrapper}, scr)();
		} else if is_string(scr) {
			switch scr {
				case "draw_self": draw_self(); return;
			}
		}
	}
}


function ken_init_ext_mods() {

	/**
	 * @member {String} mods__mod__no_name
	 * @memberof Kengine.utils.errors.types
	 * @description Mod does not have a name.
	 */
	Kengine.utils.errors.types.mods__mod__no_name = "Mod does not have a name.";

	/**
	 * @member {String} mods__mod__duplicate
	 * @memberof Kengine.utils.errors.types
	 * @description Duplicate Mod found.
	 */
	Kengine.utils.errors.types.mods__mod__duplicate = "Duplicate Mod found.";

	/**
	 * @member {String} mods__mod__does_not_exist
	 * @memberof Kengine.utils.errors.types
	 * @description Mod does not exist.
	 */
	Kengine.utils.errors.types.mods__mod__does_not_exist = "Mod does not exist.";

	/**
	 * @member {String} mods__asset_conf__no_type
	 * @memberof Kengine.utils.errors.types
	 * @description AssetConf does not have a type.
	 */
	Kengine.utils.errors.types.mods__asset_conf__no_type = "AssetConf does not have a type.";
	
	/**
	 * @member {String} mods__asset_conf__corrupt
	 * @memberof Kengine.utils.errors.types
	 * @description AssetConfs are invalid.
	 */
	Kengine.utils.errors.types.mods__asset_conf__corrupt = "AssetConfs are invalid.";

	/**
	 * @member {String} mods__asset_conf__no_name
	 * @memberof Kengine.utils.errors.types
	 * @description AssetConf does not have a name.
	 */
	Kengine.utils.errors.types.mods__asset_conf__no_name = "AssetConf does not have a name.";

	/**
	 * @member {String} mods__asset_conf__does_not_exist
	 * @memberof Kengine.utils.errors.types
	 * @description AssetConf does not exist.
	 */
	Kengine.utils.errors.types.mods__asset_conf__does_not_exist = "AssetConf does not exist.";

	/**
	 * @event mods__mod_manager__init__before
	 * @type {Array<Function>}
	 * @description An event that fires before initializing a Kengine Mod.
	 * If you have replaced the class, you need to reimplement this event.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {_mod}`.
	 *
	 * `event`: The event.
	 *
	 * `_mod`: The {@link Kengine.mods.Mod} being constructed.
	 *
	 */
	Kengine.utils.events.define("mods__mod__init__before");

	/**
	 * @event mods__mod_manager__init__after
	 * @type {Array<Function>}
	 * @description An event that fires after initializing a Kengine Mod.
	 * If you have replaced the class, you need to reimplement this event.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {_mod}`.
	 *
	 * `event`: The event.
	 *
	 * `_mod`: The {@link Kengine.mods.Mod} being constructed.
	 *
	 */
	Kengine.utils.events.define("mods__mod__init__after");

	/**
	 * @event mods__mod__enable__before
	 * @type {Array<Function>}
	 * @description An event that fires before enabling a Kengine Mod.
	 * If you have replaced the class, you need to reimplement this event.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {_mod}`.
	 *
	 * `event`: The event.
	 *
	 * `_mod`: The {@link Kengine.mods.Mod} being enabled.
	 *
	 */
	Kengine.utils.events.define("mods__mod__enable__before");

	/**
	 * @event mods__mod__enable__after
	 * @type {Array<Function>}
	 * @description An event that fires after enabling a Kengine Mod.
	 * If you have replaced the class, you need to reimplement this event.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {_mod}`.
	 *
	 * `event`: The event.
	 *
	 * `_mod`: The {@link Kengine.mods.Mod} being enabled.
	 *
	 */
	Kengine.utils.events.define("mods__mod__enable__after");

	/**
	 * @event mods__mod__disable__before
	 * @type {Array<Function>}
	 * @description An event that fires before disabling a Kengine Mod.
	 * If you have replaced the class, you need to reimplement this event.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {_mod}`.
	 *
	 * `event`: The event.
	 *
	 * `_mod`: The {@link Kengine.mods.Mod} being disabled.
	 *
	 */
	Kengine.utils.events.define("mods__mod__disable__before");

	/**
	 * @event mods__mod__disable__after
	 * @type {Array<Function>}
	 * @description An event that fires after disabling a Kengine Mod.
	 * If you have replaced the class, you need to reimplement this event.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {_mod}`.
	 *
	 * `event`: The event.
	 *
	 * `_mod`: The {@link Kengine.mods.Mod} being disabled.
	 *
	 */
	Kengine.utils.events.define("mods__mod__disable__after");

	/**
	 * @event mods__mod_manager__init__before
	 * @type {Array<Function>}
	 * @description An event that fires before initializing a Kengine's mods mod_manager.
	 * If you have replaced the class, you need to reimplement this event.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {mod_manager}`.
	 *
	 * `event`: The event.
	 *
	 * `mod_manager`: The {@link Kengine.mods.ModManager} being constructed.
	 *
	 */
	Kengine.utils.events.define("mods__mod_manager__init__before");

	/**
	 * @event mods__mod_manager__init__after
	 * @type {Array<Function>}
	 * @description An event that fires after initializing a Kengine's mods mod_manager.
	 * If you have replaced the class, you need to reimplement this event.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {mod_manager}`.
	 *
	 * `event`: The event.
	 *
	 * `mod_manager`: The {@link Kengine.mods.ModManager} being constructed.
	 *
	 */
	Kengine.utils.events.define("mods__mod_manager__init__after");

	/**
	 * @event mods__asset_conf__init__before
	 * @type {Array<Function>}
	 * @description An event that fires before initializing a Kengine's mods AssetConf.
	 * If you have replaced the class, you need to reimplement this event.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {asset_conf}`.
	 *
	 * `event`: The event.
	 *
	 * `asset_conf`: The {@link Kengine.mods.AssetConf} being constructed.
	 *
	 */
	Kengine.utils.events.define("mods__asset_conf__init__before");

	/**
	 * @event mods__asset_conf__init__after
	 * @type {Array<Function>}
	 * @description An event that fires after initializing a Kengine's mods AssetConf.
	 * If you have replaced the class, you need to reimplement this event.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {asset_conf}`.
	 *
	 * `event`: The event.
	 *
	 * `asset_conf`: The {@link Kengine.mods.AssetConf} being constructed.
	 *
	 */
	Kengine.utils.events.define("mods__asset_conf__init__after");

	/**
	 * @event mods__asset_conf__apply__before
	 * @type {Array<Function>}
	 * @description An event that fires before applying a Kengine's mods AssetConf.
	 * If you have replaced the class, you need to reimplement this event.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {asset_conf}`.
	 *
	 * `event`: The event.
	 *
	 * `asset_conf`: The {@link Kengine.mods.AssetConf} being applied.
	 *
	 */
	Kengine.utils.events.define("mods__asset_conf__apply__before");

	/**
	 * @event mods__asset_conf__apply__after
	 * @type {Array<Function>}
	 * @description An event that fires after applying a Kengine's mods AssetConf.
	 * If you have replaced the class, you need to reimplement this event.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {asset_conf}`.
	 *
	 * `event`: The event.
	 *
	 * `asset_conf`: The {@link Kengine.mods.AssetConf} being applied.
	 *
	 */
	Kengine.utils.events.define("mods__asset_conf__apply__after");

	/**
	 * @event mods__asset_conf__unapply__before
	 * @type {Array<Function>}
	 * @description An event that fires before unapplying a Kengine's mods AssetConf.
	 * If you have replaced the class, you need to reimplement this event.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {asset_conf}`.
	 *
	 * `event`: The event.
	 *
	 * `asset_conf`: The {@link Kengine.mods.AssetConf} being unapplied.
	 *
	 */
	Kengine.utils.events.define("mods__asset_conf__unapply__before");

	/**
	 * @event mods__asset_conf__unapply__after
	 * @type {Array<Function>}
	 * @description An event that fires after unapplying a Kengine's mods AssetConf.
	 * If you have replaced the class, you need to reimplement this event.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {asset_conf}`.
	 *
	 * `event`: The event.
	 *
	 * `asset_conf`: The {@link Kengine.mods.AssetConf} being unapplied.
	 *
	 */
	Kengine.utils.events.define("mods__asset_conf__unapply__after");

	/**
	 * @event mods__mod_manager__find_mods__before
	 * @type {Array<Function>}
	 * @description An event that fires before finding Kengine mods.
	 * If you have replaced the class, you need to reimplement this event.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {mod_manager, mods}`.
	 *
	 * `event`: The event.
	 *
	 * `mod_manager`: The {@link Kengine.mods.ModManager}.
	 * 
	 * `mods`: An array of Mods that are to be found.
	 *
	 */
	Kengine.utils.events.define("mods__mod_manager__find_mods__before");

	/**
	 * @event mods__mod_manager__find_mods__after
	 * @type {Array<Function>}
	 * @description An event that fires after finding Kengine mods.
	 * If you have replaced the class, you need to reimplement this event.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {mod_manager, mods}`.
	 *
	 * `event`: The event.
	 *
	 * `mod_manager`: The {@link Kengine.mods.ModManager}.
	 * 
	 * `mods`: An array of Mods that are found.
	 *
	 */
	Kengine.utils.events.define("mods__mod_manager__find_mods__after");

	Kengine.mods.Mod = Kengine.utils.structs.set_default(Kengine.conf.exts.mods, "mod_class", Kengine.mods.DefaultMod);
	Kengine.mods.ModManager = Kengine.utils.structs.set_default(Kengine.conf.exts.mods, "mod_manager_class", Kengine.mods.DefaultModManager);
	Kengine.mods.AssetConf = Kengine.utils.structs.set_default(Kengine.conf.exts.mods, "asset_conf_class", Kengine.mods.DefaultAssetConf);

	Kengine.mods.mod_manager = new Kengine.mods.ModManager();
	Kengine.mods.mod_manager.reload_mods(true);

}

function ken_test_mods_enabling_disabling() {
	if not test.is_testing {
		var fixtures = [
			new Kengine.tests.Fixture("fixture-add-mods", function() {
				Kengine.tests.test_manager.testing_mods = [];
				Kengine.tests.test_manager.testing_mods[array_length(Kengine.tests.test_manager.testing_mods)] = new Kengine.mods.Mod({name: "Kawazaki-01"});
				Kengine.tests.test_manager.testing_mods[array_length(Kengine.tests.test_manager.testing_mods)] = new Kengine.mods.Mod({name: "Kawazaki-02"});
				Kengine.tests.test_manager.testing_mods[array_length(Kengine.tests.test_manager.testing_mods)] = new Kengine.mods.Mod({name: "Kawazaki-03", dependencies: ["Kawazaki-01"]});
				// Creating mods makes it a found mod automatically.
				
			}, function() {
				var i = 3;
				while --i > 0 {
					Kengine.mods.mod_manager.disable(Kengine.tests.test_manager.testing_mods[i], 2);
				}
			}),
		];
		return {fixtures}
	}
	var mods = Kengine.tests.test_manager.testing_mods;
	test.assertEqual(mods[0].enabled, false);
	test.assertEqual(mods[1].enabled, false);
	test.assertEqual(mods[2].enabled, false);
	Kengine.mods.mod_manager.enable("Kawazaki-01");
	test.assertEqual(mods[0].enabled, true);
	test.assertEqual(mods[1].enabled, false);
	test.assertEqual(mods[2].enabled, false);
	Kengine.mods.mod_manager.disable("Kawazaki-01");
	test.assertEqual(mods[0].enabled, false);
	test.assertEqual(mods[1].enabled, false);
	test.assertEqual(mods[2].enabled, false);
	Kengine.mods.mod_manager.enable("Kawazaki-03", 2);
	test.assertEqual(mods[0].enabled, true);
	test.assertEqual(mods[1].enabled, false);
	test.assertEqual(mods[2].enabled, true);
	Kengine.mods.mod_manager.disable("Kawazaki-01", 2);
	test.assertEqual(mods[0].enabled, false);
	test.assertEqual(mods[1].enabled, false);
	test.assertEqual(mods[2].enabled, false);
	Kengine.mods.mod_manager.enable("Kawazaki-03", 1);
	Kengine.mods.mod_manager.disable("Kawazaki-01", 2); // Disables dependants (03)
	test.assertEqual(mods[0].enabled, false);
	test.assertEqual(mods[1].enabled, false);
	test.assertEqual(mods[2].enabled, false);
	test.done();
}