/**
 * @namespace Utils
 * @memberof Kengine
 * @description Kengine Utils library.
 * 
 */
function __KengineUtils() constructor {

	/**
	 * @function GetAsset
	 * @memberof Kengine.Utils
	 * @description Retrieve an {@link Kengine.Asset} from an AssetType (if loaded).
	 * @param {Kengine.AssetType|String} asset_type The type of the asset to retrieve.
	 * @param {Real|String} id_or_name The real ID or name of the asset.
	 * @return {Kengine.Asset|Undefined} An asset, or `undefined`.
	 *
	 */
	static GetAsset = function(asset_type, id_or_name) {
		if is_string(asset_type) {
			asset_type = __KengineStructUtils.Get(Kengine.asset_types, asset_type);
		}
		if asset_type == undefined {
			return undefined;
		}
		var asset = asset_type.GetAssetReplacement(id_or_name, 0);
		return asset;
	}

	/**
	 * @function Execute
	 * @memberof Kengine.Utils
	 * @description A replacement for execute_script. Executes the script or method or a script-type asset.
	 * @param {Function|Kengine.Asset} scr The script to execute.
	 * @param {Array<Any>} [args] arguments to use in an array.
	 * @return {Any} The return of the script.
	 * 
	 */
	static Execute = function(scr, args) {
		args = args ?? [];
		if is_instanceof(scr, __KengineAsset) {
			if struct_exists(scr, "Execute") {
				scr = scr.Execute ?? scr.id;
			} else if struct_exists(scr, "Run") { // custom scripts
				return scr.Run(undefined, undefined, args);
			} else {
				scr = scr.id;
			}
		}
		if script_exists(scr) {
			return script_execute_ext(scr, args);		
		} else if typeof(scr) == "method" {
			return script_execute_ext(scr, args);
		}
		throw __KengineErrorUtils.Create(__KengineErrorUtils.Types.script_exec__script__does_not_exist, string("Cannot execute script with non-existent Asset \"{0}\".", scr));
	}

	static Cmps = static_get(__KengineCmpUtils);

	static Extensions = static_get(__KengineExtensionUtils)

	static Strings = static_get(__KengineStringUtils)

	static Errors = static_get(__KengineErrorUtils)

	static Arrays = static_get(__KengineArrayUtils)

	static Structs = static_get(__KengineStructUtils)

	static Ascii = static_get(__KengineAsciiUtils)

	static Input = static_get(__KengineInputUtils)

	static Easing = static_get(__KengineEasingUtils)

	static Data = static_get(__KengineDataUtils)

	static Events = static_get(__KengineEventUtils)

	static Hashkeys = static_get(__KengineHashkeyUtils)

	static Coroutines = static_get(__KengineCoroutineUtils)

	static Instance = static_get(__KengineInstanceUtils)	

	static Parser = static_get(__KengineParserUtils)

	static Benchmark = static_get(__KengineBenchmarkUtils)

	/**
	 * @function __CreateBaseObjectAsset
	 * @memberof Kengine.Utils
	 * @private
	 * @description A function to create the base object asset (It is excluded from indexing because we want to index it ourself.)
	 * 
	 * This function is called after auto indexing.
	 * 
	 * @see {@link Kengine.Utils.Assets.__AsyncAutoIndexCallback}
	 */
	static __CreateBaseObjectAsset = function() {
		var _object_asset_type = __KengineStructUtils.Get(Kengine.asset_types, "object");
		if (_object_asset_type != undefined) {
			// Define default object asset.
			Kengine.__default_object_asset = new Kengine.Asset(_object_asset_type, "obj_default_object", true, KENGINE_WRAPPED_OBJECT);
			Kengine.__default_object_asset.real_name = object_get_name(KENGINE_WRAPPED_OBJECT);
			/// Feather ignore GM1008
			Kengine.__default_object_asset.id = KENGINE_WRAPPED_OBJECT; // Resource
			Kengine.__default_object_asset.parent = undefined;
			Kengine.__default_object_asset.event_scripts = {};	
		}
	}

	static __StartFinish = function() {
		__KengineEventUtils.Fire("start__after");

		if (KENGINE_BENCHMARK) {
			__KengineBenchmarkUtils.Mark(string("Complete in {0}", __KengineBenchmarkUtils.CalcTimerDiff(1)), 0, false);
		}
	}

	/**
	 * @function __StartExtensions
	 * @memberof Kengine.Utils
	 * @private
	 * @description A function to start Kengine extensions.
	 * 
	 * This function is called after auto indexing.
	 * 
	 * @see {@link Kengine.Utils.Assets.__AsyncAutoIndexCallback}
	 */
	static __StartExtensions = function() {
		__KengineBenchmarkUtils.Mark("Extensions: Starting...", 1);
		__KengineExtensionUtils.__FindAndStartAll();
		__KengineBenchmarkUtils.Mark("Extensions: Complete", 1);
		__StartFinish();
	}

	static __Start = function() {
		__KengineEventUtils.Fire("start__before");

		if (KENGINE_ASSET_TYPES_AUTO_INDEX_AT_START) {
			__KengineAssetUtils.AutoIndex();
		}
	}
}
__KengineUtils();
