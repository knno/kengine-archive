/**
 * @namespace Mods
 * @memberof Kengine.Extensions
 * @description Kengine's Mods extension
 *
 */
function __KengineMods(_mod_manager) : __KengineStruct() constructor {

	static name = "Mods";

	static mod_manager = _mod_manager
	mod_manager.extension = self;

	static ModManager = __KengineModsModManager	
	static Mod = __KengineModsMod
	static AssetConf = __KengineModsAssetConf
	static ModSource = __KengineModsMod

    /**
     * @function GetAssetTypeSynonymsArray
     * @memberof Kengine.Extensions.Mods
     * @param {String|Kengine.AssetType} asset_type The asset type you want to get synonyms for.
     * @description Returns the synonyms array for an asset type. First one is the canonical.
     * @return {Array<String>}
     * 
     */
	static GetAssetTypeSynonymsArray = function(asset_type) {
        if is_instanceof(asset_type, Kengine.AssetType) {
            asset_type = asset_type.name;
        }
		/// feather ignore GM1045
        switch(asset_type) {
            case "room":
            case "rm":
                return ["rm", "room"]
            default: return [asset_type, asset_type];
        }
    }

    /**
     * @function ParseModFileSync
     * @memberof Kengine.Extensions.Mods
     * @param {String} modname The mod name.
	 * @param {String} source The source to parse.
     * @description Parses a mod definition file (source) while also handling imports. 
     * @return {Struct|Undefined|Any} The definition data.
     *
     */
    static ParseModFileSync = function(modname, source) {
        // Parse twice the mod file strings to resolve @ symbols. And return a struct.
        // Struct contains assetconfs, and general confs.
        var result = undefined;
		var filepath = source;
        var basepath = filename_dir(filepath);
        var modtext = ReadFileSync(filepath, basepath, "text", true);
        if modtext == undefined {
            Kengine.console.echo_ext(string("Kengine: Mods: Warning: mod file \"{0}\" was not loaded due to error.", modname), c_yellow, true, true);
            return undefined;
        }
        try {
            result = SnapFromYAML(modtext);
        } catch (e) {
            Kengine.console.echo_error("Kengine: Mods: Error: Could not parse mod \"" + modname + "\" " + filename_name(filepath) + " file");
            Kengine.console.echo_ext(string("Kengine: Mods: Warning: mod file \"{0}\" was not loaded due to error.", modname), c_yellow, true, true);
            return undefined;
        }
        var _imports = [];
        var _imports_found_per_file = [];
        while (true) {
            try {
                Kengine.Utils.Data.ValuesMap(result, method({imports: _imports, imports_found_per_file: _imports_found_per_file, basepath}, function(val) {
                    var dir = "@import ";
                    if string_starts_with(val, dir) {
                        var val2 = __KengineModsUtils.ReadFileSync(string_copy(val, string_length(dir)+1, string_length(val) - string_length(dir)), basepath, "text", false);
                        if val2 == undefined { throw ({type: "FAIL_PARSE_FILE"}) }
                        if array_contains(imports, val) {
                            throw ({type: "FAIL_PARSE_IMPORT"})
                        }
                        imports[array_length(imports)] = val;
                        imports_found_per_file[array_length(imports_found_per_file)] = val;
                        val = SnapFromYAML(val2);
                    }
                    return val
                }))
            } catch (e) {
                if e.type == "FAIL_PARSE_FILE" {
                    Kengine.console.echo_error("Kengine: Mods: Error: File \"" + filepath + "\" does not exist.");
                } else if e.type == "FAIL_PARSE_IMPORT" {
                    Kengine.console.echo_error("Kengine: Mods: Error: File \"" + filepath + "\" has recursive imports.");
                }
                Kengine.console.echo_ext(string("Kengine: Mods: Warning: mod file \"{0}\" was not loaded due to error.", modname), c_yellow, true, true);
                return undefined;
            }
            if array_length(_imports_found_per_file) == 0 {
                break;
            } else {
                _imports_found_per_file = [];
                continue;
            }
        }
        return result;
    }

    /**
     * @function ReadFileSync
     * @memberof Kengine.Extensions.Mods.Utils
     * @description Reads the contents of a file. file path can be absolute path. If basepath is not provided, it can be relative to game directories.
     * @param {String} filepath Path to file.
     * @param {Undefined|String|Array<String>|Kengine.Extensions.Mods.ModSource} [base=undefined] The base source for reading the file. Defaults to program, working and gamesave directories in order.
     * @param {String} [mode="text"] Reading mode.
     * @param {Bool} [show_err=true] Whether to write a console error.
     * @return {String|Undefined} file contents as string. Undefined if there's an error.
     *
     * @example
     * var text = Kengine.Extensions.Mods.Utils.ReadFileSync("abs/path/to/my/file.txt");
     * var text = Kengine.Extensions.Mods.Utils.ReadFileSync("relative-path/file.txt", undefined);
     * var text = Kengine.Extensions.Mods.Utils.ReadFileSync("relative-path/file.txt", "abs/path/to/dir/", "text", false);
     * 
     */
    static ReadFileSync = function(filepath, base, mode="text", show_err=true) {
        var _bases;
        if is_undefined(base) {
			if !file_exists(filepath) {
		        if show_err {
	                Kengine.console.echo_error("Kengine: Mods: Error: Cannot search file \"" + filepath + "\" without a base dir.");
			    }
				return undefined;
			}
			_bases = [];
        } else if is_instanceof(base, __KengineModsMod) {
            _bases = [base.source];
        } else if is_array(base) {
            _bases = base;
            for (var i=0; i<array_length(i); i++) {
                if string_ends_with(_bases[i], "/") or string_ends_with(_bases[i], "\\") {
                    _bases[i] = string_copy(_bases[i], 1, string_length(_bases[i])-1);
                }
                if directory_exists(_bases[i]) {
                    if file_exists(_bases[i] + "/" + filepath) {
                        _bases[i] = _bases[i] + "/" + filepath;
                    }
                }
            }
        } else if is_string(base) {
            _bases = [base];
        }

        var _jsonc;
        var _fpath = filepath;
        
        var i = array_length(_bases);

        while (--i >= 0) {
            _fpath = _bases[i] + filepath;
            if file_exists(_fpath) {
                filepath = _fpath;
                break;
            }
        }
        if file_exists(filepath) {
            switch (mode) {
                case "text":
                    return __kengine_load_txt_file(filepath)
            }

        } else {
            if show_err {
                Kengine.console.echo_error("Kengine: Mods: Error: File \"" + filepath + "\" does not exist.");
            }
            return undefined;
        }
    }

    /**
     * @function __NormalizeAssetConfs
     * @private
     * @memberof Kengine.Extensions.Mods
     * @param {Array<Kengine.Extensions.Mods.AssetConf>|Struct} asset_confs
     * @description Normalizes `asset_confs` array or struct to a good assetconf struct with proper names.
     * @return {Struct}
     * 
     */
    static __NormalizeAssetConfs = function(asset_confs) {
        // Convert it to a struct.
        var _asset_confs = {};
        var a;
        if is_array(asset_confs) {
            for (var i=0; i<array_length(asset_confs); i++) {
                a = Kengine.Utils.Structs.SetDefault(_asset_confs, asset_confs[i].type, []);
                array_push(a, asset_confs[i]);
            }
        } else {
            _asset_confs = asset_confs;
        }
        // _asset_confs is asset_confs but as struct.

        var names = struct_get_names(_asset_confs);
        var _ns;

        // Iterate over available types.
        for (var i=0; i<array_length(names); i++) {

            // Get all other names, current name included
            _ns = GetAssetTypeSynonymsArray(names[i]);

            if names[i] != _ns[0] {
                
                // Change the struct member name to the first name of that type.
                _asset_confs[$ _ns[0]] = _asset_confs[$ names[i]];
                struct_remove(_asset_confs, names[i])
            }
        }
        return _asset_confs;
    }

    /**
     * @function __GetAcceptableAssetConfsTypesNames
     * @memberof Kengine.Extensions.Mods
     * @private
     * @param {Array<String>} asset_confs_types_names
     * @description Returns the names of types that asset confs can be in, and will be read from mod files.
     * This is to filter out asset types that are totally not replaceable and not addable.
     * @return {Array<String>}
     *
     */
    static __GetAcceptableAssetConfsTypesNames = function(asset_confs_types_names) {
		/// feather ignore GM1045
        var _a = [];
        var _b;
        var _c;
        var _names_list;
        for (var i=0; i<array_length(asset_confs_types_names); i++) {
            _c = 0;
            _b = undefined;
            _names_list = GetAssetTypeSynonymsArray(asset_confs_types_names[i]);
            while (_b == undefined) {
                _b = Kengine.Utils.Structs.Get(Kengine.asset_types, _names_list[_c]);
                _c ++;
                if _c >= array_length(_names_list) break;
            }
            if _b != undefined {
                asset_confs_types_names[i] = _b.name;
				if struct_exists(_b, "is_addable") and struct_exists(_b, "is_replaceable") {
	                if _b.is_addable or _b.is_replaceable {
		                array_push(_a, _b.name);
			        }
				}
            }
        }
        return array_unique(_a);
    }

    /**
     * @function DefaultGameFindMods
     * @memberof Kengine.Extensions.Mods
     * @description The default mods finder function. It returns an array of arrays that contain mods found.
	 * `{this}` is the Mod Manager.
     * @return {Array<Array<Kengine.Extensions.Mods.Mod>>}
     * 
     */
    static DefaultGameFindMods = function() {
        var _array = [
            this.extension.FindLocalMods(program_directory),
            this.extension.FindLocalMods(game_save_id),
        ]

		// Check for KENGINE_MODS_DIR environment variable.
		// Comment out this code if you want to disable the environment variable.
			var _mods_dir_final;
			var _mods_dir = environment_get_variable("KENGINE_MODS_DIR");
			if _mods_dir != "" {
				if not directory_exists(_mods_dir) {
					_mods_dir_final = program_directory + "/" + _mods_dir; // Test program + relpath
					if not directory_exists(_mods_dir_final) {
						_mods_dir_final = working_directory + "/" + _mods_dir; // Test working + relpath
					}
				} else {
					_mods_dir_final = _mods_dir;
				}
				if directory_exists(_mods_dir_final) {
					// Remove the /mods/ part from the ENV to canonicalize.
					if string_ends_with(_mods_dir_final, "/mods/")
					or string_ends_with(_mods_dir_final, "/mods\\")
					or string_ends_with(_mods_dir_final, "\\mods/")
					or string_ends_with(_mods_dir_final, "\\mods\\") {
						_mods_dir_final = string_copy(_mods_dir_final, 1, string_length(_mods_dir_final) - 6);
					}
					_array[array_length(_array)] = this.extension.FindLocalMods(_mods_dir_final)
				}
			}

        return _array;

        // Other examples:

        // var mod_1 = new Mod({name: "my-first-mod", enabled: false});
        // var mod_2 = new Mod({name: "my-second-mod", enabled: false})
        // var mod_3 = new Mod({name: "my-third-mod", enabled: false, dependencies: [
        //  		mod_1, "my-second-mod",
        // ]});
        // mods_found1 = [
        //  		mod_1,
        //  		mod_2,
        //  		mod_3,
        // ];
        // return [
		//  	mods_found1
		// ];
    }

    /**
     * @function FindLocalMods
     * @memberof Kengine.Extensions.Mods
     * @param {String} base The base location of the finding, could be working_directory, program_directory, game_save_id, a custom path...
     * @description Finds directory mods and return Mod objects in an array.
     * @return {Array<Kengine.Extensions.Mods.Mod>}
     *
     */
    static FindLocalMods = function(base) {
        var _files = [];
        var _dirs = [];
        var _mods_found = [];
        var _file_name, _dir_name;

        // Priority based

        // First and least priority, find the ZIP files in mods sub-directory.
        if string_ends_with(base, "/") or string_ends_with(base, "\\") {
            base = string_copy(base, 1, string_length(base)-1);
        }
        _file_name = file_find_first(base + "/mods/" + "*.mod.zip", fa_archive);
        while (_file_name != "")
            {
            Kengine.console.debug("Kengine: Mods: Found ZIP archive: \"" + base + "/mods/" + _file_name + "\"");
            array_push(_files, base + "/mods/" + _file_name);
            _file_name = file_find_next();
            }
        file_find_close();

        // Secondly, find the ZIP files in base directory.
        _file_name = file_find_first(base + "/" + "*.mod.zip", fa_archive);
        while (_file_name != "")
            {
            Kengine.console.debug("Kengine: Mods: Found ZIP archive: \"" + "/" + _file_name + "\"");
            array_push(_files, base + "/" + _file_name);
            _file_name = file_find_next();
            }
        file_find_close();

        // Finally, find the directories that are considered mods.
        _dir_name = file_find_first(base + "/mods/*", fa_directory);
        while (_dir_name != "")
            {
            if not directory_exists(base + "/mods/" + _dir_name) {
                _dir_name = file_find_next();
                continue;
            }
            Kengine.console.debug("Kengine: Mods: Found mod: \"" + base + "/mods/" + _dir_name + "\"");
            array_push(_dirs, base + "/mods/" + _dir_name);
            _dir_name = file_find_next();
            }
        file_find_close();

        // Iterate over ZIP files and extract them.
        var _mod;
        var mod_name;
        var extracted = false;
        var tgt;
        for (var i=0; i<array_length(_files); i++) {
            // mod name is the name of ZIP without extension.
            mod_name = string_copy(filename_name(_files[i]), 1, string_length(filename_name(_files[i])) - 4);

            // Handle clashing names.
            for (var j=0; j<array_length(_mods_found); j++) {
                if _mods_found[j].name == mod_name or _mods_found[j].original_name == mod_name {
                    throw Kengine.utils.errors.create(Kengine.utils.errors.types.mods__mod__duplicate, string("Duplicate Mod name \"{0}\" found.", mod_name));
                }
            }

            // Unzip the mod files to temp_directory.
            if not directory_exists(temp_directory + "archives/" + mod_name) directory_create(temp_directory + "archives/" + mod_name);
            tgt = temp_directory + "archives/" + mod_name;
            extracted = zip_unzip(_files[i], tgt);
            if extracted {
                _mod = new Kengine.Extensions.Mods.Mod(mod_name, undefined, undefined, tgt + "/config.yml", false);
                array_push(_mods_found, _mod);
                _mod.original_name = mod_name;
                _mod.Update();
            }
        }

        // Iterate directories.
        for (var i=0; i<array_length(_dirs); i++) {
            mod_name = filename_name(_dirs[i]);
            for (var j=0; j<array_length(_mods_found); j++) {
                if _mods_found[j].name == mod_name or _mods_found[j].original_name == mod_name {
                    throw Kengine.utils.errors.create(Kengine.utils.errors.types.mods__mod__duplicate, string("Duplicate Mod \"{0}\" found.", mod_name));
                }
            }
            _mod = new Kengine.Extensions.Mods.Mod(mod_name, undefined, undefined, _dirs[i] + "/config.yml", false);
            array_push(_mods_found, _mod);
            _mod.original_name = mod_name;
            _mod.Update();
        }

        return _mods_found;
    }

}


function ken_init_ext_mods() {

    #region Error types
	/**
	 * @member {String} mods__mod__duplicate
	 * @memberof Kengine.Utils.Errors.Types
	 * @description Duplicate Mod found.
	 */
	Kengine.Utils.Errors.Define("mods__mod__duplicate", "Duplicate Mod found.")

	/**
	 * @member {String} mods__mod__does_not_exist
	 * @memberof Kengine.Utils.Errors.Types
	 * @description Mod does not exist.
	 */
	Kengine.Utils.Errors.Define("mods__mod__does_not_exist", "Mod does not exist.")

	/**
	 * @member {String} mods__asset_conf__no_type
	 * @memberof Kengine.Utils.Errors.Types
	 * @description AssetConf does not have a type.
	 */
	Kengine.Utils.Errors.Define("mods__asset_conf__no_type", "AssetConf does not have a type.")
	
	/**
	 * @member {String} mods__asset_conf__invalid
	 * @memberof Kengine.Utils.Errors.Types
	 * @description AssetConfs are invalid.
	 */
	Kengine.Utils.Errors.Define("mods__asset_conf__invalid", "AssetConfs are invalid.")
	
	/**
	 * @member {String} mods__asset_conf__cannot_update
	 * @memberof Kengine.Utils.Errors.Types
	 * @description AssetConf cannot be updated since it's applied currently.
	 */
	Kengine.Utils.Errors.Define("mods__asset_conf__cannot_update", "AssetConf cannot be updated since it's applied currently.")

	/**
	 * @member {String} mods__asset_conf__no_name
	 * @memberof Kengine.Utils.Errors.Types
	 * @description AssetConf does not have a name.
	 */
	Kengine.Utils.Errors.Define("mods__asset_conf__no_name", "AssetConf does not have a name.")

	/**
	 * @member {String} mods__asset_conf__no_resolve
	 * @memberof Kengine.Utils.Errors.Types
	 * @description AssetConf property not found.
	 */
	Kengine.Utils.Errors.Define("mods__asset_conf__no_resolve", "AssetConf property not found.")

	/**
	 * @member {String} mods__asset_conf__does_not_exist
	 * @memberof Kengine.Utils.Errors.Types
	 * @description AssetConf does not exist.
	 */
	Kengine.Utils.Errors.Define("mods__asset_conf__does_not_exist", "AssetConf does not exist.")
    #endregion
    #region Events
	/**
	 * @event mods__mod_manager__init__before
	 * @type {Array<Function>}
	 * @description An event that fires before initializing a Kengine Mod.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {_mod}`.
	 *
	 * `event`: The event.
	 *
	 * `_mod`: The {@link Kengine.Extensions.Mods.Mod} being constructed.
	 *
	 */
	Kengine.Utils.Events.Define("mods__mod__init__before");

	/**
	 * @event mods__mod_manager__init__after
	 * @type {Array<Function>}
	 * @description An event that fires after initializing a Kengine Mod.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {_mod}`.
	 *
	 * `event`: The event.
	 *
	 * `_mod`: The {@link Kengine.Extensions.Mods.Mod} being constructed.
	 *
	 */
	Kengine.Utils.Events.Define("mods__mod__init__after");

	/**
	 * @event mods__mod_manager__init__before
	 * @type {Array<Function>}
	 * @description An event that fires after updating a Kengine Mod.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {_mod}`.
	 *
	 * `event`: The event.
	 *
	 * `_mod`: The {@link Kengine.Extensions.Mods.Mod} being updated.
	 *
	 */
	Kengine.Utils.Events.Define("mods__mod__update__after");

	/**
	 * @event mods__mod_manager__init__before
	 * @type {Array<Function>}
	 * @description An event that fires before initializing a Kengine Mod.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {_mod}`.
	 *
	 * `event`: The event.
	 *
	 * `_mod`: The {@link Kengine.Extensions.Mods.Mod} being constructed.
	 *
	 */
	Kengine.Utils.Events.Define("mods__mod__init__before");

	/**
	 * @event mods__mod__enable__before
	 * @type {Array<Function>}
	 * @description An event that fires before enabling a Kengine Mod.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {_mod}`.
	 *
	 * `event`: The event.
	 *
	 * `_mod`: The {@link Kengine.Extensions.Mods.Mod} being enabled.
	 *
	 */
	Kengine.Utils.Events.Define("mods__mod__enable__before");

	/**
	 * @event mods__mod__enable__after
	 * @type {Array<Function>}
	 * @description An event that fires after enabling a Kengine Mod.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {_mod}`.
	 *
	 * `event`: The event.
	 *
	 * `_mod`: The {@link Kengine.Extensions.Mods.Mod} being enabled.
	 *
	 */
	Kengine.Utils.Events.Define("mods__mod__enable__after");

	/**
	 * @event mods__mod__disable__before
	 * @type {Array<Function>}
	 * @description An event that fires before disabling a Kengine Mod.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {_mod}`.
	 *
	 * `event`: The event.
	 *
	 * `_mod`: The {@link Kengine.Extensions.Mods.Mod} being disabled.
	 *
	 */
	Kengine.Utils.Events.Define("mods__mod__disable__before");

	/**
	 * @event mods__mod__disable__after
	 * @type {Array<Function>}
	 * @description An event that fires after disabling a Kengine Mod.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {_mod}`.
	 *
	 * `event`: The event.
	 *
	 * `_mod`: The {@link Kengine.Extensions.Mods.Mod} being disabled.
	 *
	 */
	Kengine.Utils.Events.Define("mods__mod__disable__after");

	/**
	 * @event mods__mod_manager__init__before
	 * @type {Array<Function>}
	 * @description An event that fires before initializing a Kengine's mods mod_manager.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {mod_manager}`.
	 *
	 * `event`: The event.
	 *
	 * `mod_manager`: The {@link Kengine.Extensions.Mods.ModManager} being constructed.
	 *
	 */
	Kengine.Utils.Events.Define("mods__mod_manager__init__before");

	/**
	 * @event mods__mod_manager__init__after
	 * @type {Array<Function>}
	 * @description An event that fires after initializing a Kengine's mods mod_manager.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {mod_manager}`.
	 *
	 * `event`: The event.
	 *
	 * `mod_manager`: The {@link Kengine.Extensions.Mods.ModManager} being constructed.
	 *
	 */
	Kengine.Utils.Events.Define("mods__mod_manager__init__after");

	/**
	 * @event mods__asset_conf__init__before
	 * @type {Array<Function>}
	 * @description An event that fires before initializing a Kengine's mods AssetConf.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {asset_conf}`.
	 *
	 * `event`: The event.
	 *
	 * `asset_conf`: The {@link Kengine.Extensions.Mods.AssetConf} being constructed.
	 *
	 */
	Kengine.Utils.Events.Define("mods__asset_conf__init__before");

	/**
	 * @event mods__asset_conf__init__after
	 * @type {Array<Function>}
	 * @description An event that fires after initializing a Kengine's mods AssetConf.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {asset_conf}`.
	 *
	 * `event`: The event.
	 *
	 * `asset_conf`: The {@link Kengine.Extensions.Mods.AssetConf} being constructed.
	 *
	 */
	Kengine.Utils.Events.Define("mods__asset_conf__init__after");

	/**
	 * @event mods__asset_conf__apply__before
	 * @type {Array<Function>}
	 * @description An event that fires before applying a Kengine's mods AssetConf.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {asset_conf}`.
	 *
	 * `event`: The event.
	 *
	 * `asset_conf`: The {@link Kengine.Extensions.Mods.AssetConf} being applied.
	 *
	 */
	Kengine.Utils.Events.Define("mods__asset_conf__apply__before");

	/**
	 * @event mods__asset_conf__apply__after
	 * @type {Array<Function>}
	 * @description An event that fires after applying a Kengine's mods AssetConf.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {asset_conf}`.
	 *
	 * `event`: The event.
	 *
	 * `asset_conf`: The {@link Kengine.Extensions.Mods.AssetConf} being applied.
	 *
	 */
	Kengine.Utils.Events.Define("mods__asset_conf__apply__after");

	/**
	 * @event mods__asset_conf__unapply__before
	 * @type {Array<Function>}
	 * @description An event that fires before unapplying a Kengine's mods AssetConf.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {asset_conf}`.
	 *
	 * `event`: The event.
	 *
	 * `asset_conf`: The {@link Kengine.Extensions.Mods.AssetConf} being unapplied.
	 *
	 */
	Kengine.Utils.Events.Define("mods__asset_conf__unapply__before");

	/**
	 * @event mods__asset_conf__unapply__after
	 * @type {Array<Function>}
	 * @description An event that fires after unapplying a Kengine's mods AssetConf.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {asset_conf}`.
	 *
	 * `event`: The event.
	 *
	 * `asset_conf`: The {@link Kengine.Extensions.Mods.AssetConf} being unapplied.
	 *
	 */
	Kengine.Utils.Events.Define("mods__asset_conf__unapply__after");

	/**
	 * @event mods__mod_manager__find_mods__before
	 * @type {Array<Function>}
	 * @description An event that fires before finding Kengine mods.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {mod_manager, mods}`.
	 *
	 * `event`: The event.
	 *
	 * `mod_manager`: The {@link Kengine.Extensions.Mods.ModManager}.
	 * 
	 * `mods`: An array of Mods that are to be found.
	 *
	 */
	Kengine.Utils.Events.Define("mods__mod_manager__find_mods__before");

	/**
	 * @event mods__mod_manager__find_mods__after
	 * @type {Array<Function>}
	 * @description An event that fires after finding Kengine mods.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {mod_manager, mods}`.
	 *
	 * `event`: The event.
	 *
	 * `mod_manager`: The {@link Kengine.Extensions.Mods.ModManager}.
	 * 
	 * `mods`: An array of Mods that are found.
	 *
	 */
	Kengine.Utils.Events.Define("mods__mod_manager__find_mods__after");
    #endregion

	var _mod_manager = new __KengineModsModManager();
    var _mods = new __KengineMods(_mod_manager);
    _mods.default_game_find_mods = __KengineMods.DefaultGameFindMods;

    Kengine.Extensions.Add(_mods);

    _mods.mod_manager.ReloadMods();

    return _mods;
}
