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

	static Cmps = new __KengineCmpUtils();

	static Extensions = new __KengineExtensionUtils();

	static Strings = new __KengineStringUtils();

	static Errors = new __KengineErrorUtils();

	static Arrays = new __KengineArrayUtils();

	static Structs = new __KengineStructUtils();

	static Ascii = new __KengineAsciiUtils();

	static Input = new __KengineInputUtils();

	static Easing = new __KengineEasingUtils();

	static Data = new __KengineDataUtils();

	static Events = new __KengineEventUtils();

	static Hashkeys = new __KengineHashkeyUtils();

	static Coroutines = new __KengineCoroutineUtils();

	static Instance = new __KengineInstanceUtils();

	static Parser = new __KengineParserUtils();

	static Benchmark = new __KengineBenchmarkUtils();

	static Assets = new __KengineAssetUtils();
	
	static Tiles = new __KengineTileUtils();

	static Rooms = new __KengineRoomUtils();

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
			__KengineBenchmarkUtils.Mark(string("Complete in {0}ms", __KengineBenchmarkUtils.CalcTimerDiff(0)/1000), 0, false);
		}
		Kengine.status = "READY";
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
		__KengineBenchmarkUtils.Mark("Extensions: Starting...", 3);
		__KengineExtensionUtils.__FindAndStartAll();
		__KengineBenchmarkUtils.Mark("Extensions: Complete", 3);
		__StartFinish();
	}

	static __Start = function() {
		__KengineEventUtils.Fire("start__before");

		if (KENGINE_ASSET_TYPES_AUTO_INDEX_AT_START) {
			__KengineAssetUtils.__AutoIndex();
		}
	}
}
//__KengineUtils();
