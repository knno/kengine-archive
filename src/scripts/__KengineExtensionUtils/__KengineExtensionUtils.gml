/**
 * @namespace Extensions
 * @memberof Kengine.Utils
 * @description A struct containing Kengine extensions utilitiy functions
 *
 */
function __KengineExtensionUtils() : __KengineStruct() constructor {

    static __extensions_order = KENGINE_EXTENSIONS_ORDER

    /**
     * @function __FindAndStartAll
     * @private
     * @memberof Kengine.Utils.Extensions
     * @description Finds and starts all the extensions found.
     * 
     */
	static __FindAndStartAll = function() {
		var _exts = __KengineExtensionUtils.__Find(); // {my_ext: <Asset >, ...}
		__KengineEventUtils.Fire("extensions__before", {extension_assets: _exts,});
		var _exts_names = struct_get_names(_exts);
		if __extensions_order != undefined {
			array_sort(_exts_names, method({names: __extensions_order}, function(elm1, elm2) {
				var e1 = array_get_index(names, elm1);
				var e2 = array_get_index(names, elm2);
				return e1 >= e2;
			}));
		}
        var _ext_asset = undefined;
        var _ext_name = undefined;
        var h;
		for (var i=0; i<array_length(_exts_names); i++) {
			_ext_name = _exts_names[i];
			h = variable_get_hash(_ext_name);
			_ext_asset = struct_get_from_hash(_exts, h);        
    		__KengineBenchmarkUtils.CalcTimerDiff(4); // Clear
    		__KengineBenchmarkUtils.Mark("Extensions: Starting " + _ext_name, 4);
			__KengineEventUtils.Fire("extension__start__before", {extension_name: _ext_name, extension_asset: _ext_asset});
			__KengineExtensionUtils.__Start(_ext_name, _ext_asset);
			__KengineEventUtils.Fire("extension__start__after", {extension_name: _ext_name, extension_asset: _ext_asset});
    		__KengineBenchmarkUtils.Mark("Extensions: " + _ext_name + " started", 4);
		}
		__KengineEventUtils.Fire("extensions__after", {extensions: _exts,});
	}

    /**
     * @function __Find
     * @private
     * @memberof Kengine.Utils.Extensions
     * @description Finds extensions to start. The name of script assets (functions) that starts with `ken_init_ext_` are matched.
     * @return {Array<Kengine.Asset>} Assets of function scripts that are extensions.
     *
     */
    static __Find = function() {
        var _exts = {};
        var _ext_name;
        var _founds = Kengine.asset_types.script.assets.Filter(function (val) {
            return string_starts_with(val.name, "ken_init_ext_");
        });
        for (var i=0; i<array_length(_founds); i++) {
            _ext_name = string_replace(_founds[i].name, "ken_init_ext_", "");
            _exts[$ _ext_name] = _founds[i];
        }
        return _exts;
    }

    /**
     * @function __Start
     * @private
     * @memberof Kengine.Utils.Extensions
     * @description Starts extension.
     * @param {String} ext_name name of the extension.
     * @param {Kengine.Asset} ext_asset asset of the extension.
     *
     */
    static __Start = function(ext_name, ext_asset) {
        Kengine.console.debug("Kengine: Starting extension: " + ext_name);
		var _ext = ext_asset.id();
		if is_struct(_ext) {
	        Kengine.Extensions.Add(_ext);
			_ext.status = "READY";
		}
    }

}
