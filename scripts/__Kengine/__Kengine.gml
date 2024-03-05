/**
 * @namespace Kengine
 * @description The Kengine namespace.
 * 
 */
function Kengine() : __KengineStruct() constructor {

	static Utils = static_get(__KengineUtils);


	static status = "NOT_STARTED";

	static GetStatuses = function(type) {

		var statuses = [];
		
		if (type & KENGINE_STATUS_TYPE.MAIN) {
			statuses[array_length(statuses)] = ["Kengine", Kengine.status]
		}
		if (type & KENGINE_STATUS_TYPE.COROUTINES) {
			for (var _i=0; _i<array_length(Kengine.coroutines); _i++) {
				statuses[array_length(statuses)] = [Kengine.coroutines[_i].name, Kengine.coroutines[_i].status]
			}
		}
		if (type & KENGINE_STATUS_TYPE.EXTENSIONS) {
			var _exts = struct_get_names(Kengine.Extensions);
			var _ext
			for (var _i=0; _i<array_length(_exts); _i++) {
				if string_starts_with(_exts[_i], "_") continue;
				_ext = Kengine.Extensions[$ _exts[_i]];
				if !is_struct(_ext) continue;
				if __KengineStructUtils.Exists(_ext, "status") {
					statuses[array_length(statuses)] = [_exts[_i], _ext.status]
				}
			}
		}

		return statuses;
	}

	/**
	 * @constant initialized
	 * @memberof Kengine
	 * @description Whether Kengine has been initiated or not.
	 * @type {Bool}
	 * @readonly
	 * 
	 */
	static initialized = false

	if initialized {
		return obj_kengine.__kengine;
	}

	/**
	 * @name instances
	 * @type {Kengine.Collection}
	 * @memberof Kengine
	 * @description This collection contains all created {@link Kengine.Instance}.
	 */
	static instances = new __KengineCollection()

	static __Extensions = function() : __KengineStruct() constructor {
		static Add = function(ext) {
			self[$ ext.name] = ext;
		}
	}

	/**
	 * @name Extensions
	 * @type {Struct}
	 * @memberof Kengine
	 * @description A key value struct of name to Kengine extension.
	 */
	static Extensions = (new __Extensions());


	/**
	 * @name coroutines
	 * @type {Array<Kengine.Coroutine>}
	 * @memberof Kengine
	 * @description An array of {@link Kengine.Coroutine} currently processing.
	 */
	static coroutines = []
	static __coroutines_last_tick = 0

	/**
	 * @name current_room_asset
	 * @type {Kengine.Asset|Undefined}
	 * @memberof Kengine
	 * @description The Room-type {@link Kengine.Asset} currently active as room.
	 */
	static current_room_asset = undefined

	static asset_type_options = KengineAssetTypes();

	/**
	 * @member asset_types
	 * @type {Struct}
	 * @memberof Kengine
	 * @description The asset types struct of Kengine.
	 *
	 */
	static asset_types = {}

	static AssetType = __KengineAssetType
	static Asset = __KengineAsset
	static Instance = __KengineInstance
	static Collection = __KengineCollection

	static __console_backlog = [];
	static __StartFakeConsole = function() {
		var _console;
		_console = {
			echo_error: function(msg) {
				Kengine.__console_backlog[array_length(Kengine.__console_backlog)] = {
					msg,
					kind: "echo_error"
				}
			},
			echo_ext: function(msg, color=undefined, notify=undefined, write=undefined) {
				Kengine.__console_backlog[array_length(Kengine.__console_backlog)] = {
					msg,
					color,
					kind: "echo_ext",
					notify,
					write
				}
			},
			echo: function(msg=undefined) {
				Kengine.__console_backlog[array_length(Kengine.__console_backlog)] = {
					msg,
					kind: "echo"
				}			
			},
			debug: function(msg=undefined) {
				Kengine.__console_backlog[array_length(Kengine.__console_backlog)] = {
					msg,
					kind: "debug"
				}
			},
			verbose: function(msg=undefined, verbosity=undefined) {
				Kengine.__console_backlog[array_length(Kengine.__console_backlog)] = {
					msg,
					kind: "verbose",
					verbosity
				};
			}
		}
		_console.Echo = _console.echo;
		_console.EchoError = _console.echo_error;
		_console.EchoExt = _console.echo_ext;
		_console.Debug = _console.debug;
		_console.Verbose = _console.verbose;
		return _console;
	}

	// We create a fake console that add to a backlog because it is a Kengine extension (panels)
	static console = __StartFakeConsole()

	/**
	* @member __uids
	* @type {Real}
	* @memberof Kengine
	* @description The current UID reached for the Kengine's UID generator.
	* 
	*/
	static __uids = 0
	static new_uid = function() {return __uids++}

	/**
	 * @member main_object
	 * @type {Asset.GMObject}
	 * @memberof Kengine
	 * @description The main Kengine singleton object. Referenced by `Kengine.main_object`.
	 *
	 */
	static main_object = KENGINE_MAIN_OBJECT_RESOURCE

	/**
	 * @function Initialize
	 * @description Initializes Kengine. This should be called when rooms are ready to also be able to create a singleton object.
	 * Once obj_kengine is placed in the room, this function is called.
	 * @return Whether initialization was successful or not.
	 *
	 */
	static Initialize = function() {
		if Kengine.initialized return false;
		Kengine.asset_types = (new __KengineStruct())
		Kengine.initialized = true;

		__KengineBenchmarkUtils.Init();

		Kengine.main_object = self;

		__KengineUtils.__Start();

		return true;
	}
}
Kengine();
// variable_global_set("Kengine", static_get(Kengine));
