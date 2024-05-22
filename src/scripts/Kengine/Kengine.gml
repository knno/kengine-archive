/**
 * @namespace Kengine
 * @description The Kengine namespace.
 * 
 */
function Kengine() : __KengineStruct() constructor {

	/**
	 * @constant __initialized
	 * @memberof Kengine
	 * @description Whether Kengine has been initiated or not.
	 * @type {Bool}
	 * @readonly
	 * @private
	 * 
	 */
	static __initialized = false

	if __initialized {
		return;
	}

	static Struct = __KengineStruct;

	static Utils = new __KengineUtils();

	static status = "NOT_STARTED";

	static is_testing = function() {
		var _is_testing = KENGINE_IS_TESTING;
		if _is_testing == true {return true;}
		var _param_count = parameter_count();
		if _param_count > 0
		{
			for (var i = 0; i < _param_count; i += 1)
		    {
				var _param = parameter_string(i + 1);
				var _wanted = "--run-tests";

				if string_count(_wanted, _param) != 0 {
					return true;
				}
		    }
		}
		return false;
	}
	is_testing = is_testing();

	static verbosity = function() {
		var v = KENGINE_VERBOSITY;
		if (v) > 0 {
			return v;
		}
		var _verbosity = environment_get_variable("KENGINE_VERBOSITY");
		switch (string_lower(_verbosity)) {
			case "1": case "v": case "true": return 1;
			case "2": case "vv": return 2;
			case "3": case "vvv": return 3;
			case "4": case "vvvv": return 4;
		}
		return 0;
	}
	verbosity = verbosity();

	/**
	 * @function GetStatusArray
	 * @memberof Kengine
	 * @description Returns the current status of Kengine
	 * @param {String} type The `KENGINE_STATUS_TYPE` such as (MAIN, COROUTINES, EXTENSIONS)
	 * @return {Array<Any>} pairs of (name, status)
	 * 
	 * @example
	 * var statuses = Kengine.GetStatusArray(KENGINE_STATUS_TYPE.MAIN);
	 * var i = array_find_index(statuses, function(ele) { return ele[0] == "Kengine"; });
	 * if i > -1 {
	 *   var kengine_status = statuses[i][1];
	 *   if kengine_status == "NOT_STARTED" ...
	 *   if kengine_status == "STARTING" ...
	 *   if kengine_status == "READY" ...
	 * }
	 * 
	 */
	static GetStatusArray = function(type) {
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
					statuses[array_length(statuses)] = [_exts[_i], _ext.status];
				} else {
					statuses[array_length(statuses)] = [_exts[_i], "NOT_STARTED"];
				}
			}
		}
		return statuses;
	}

	/**
	 * @name instances
	 * @type {Kengine.Collection}
	 * @memberof Kengine
	 * @description This collection contains all created {@link Kengine.Instance}.
	 * 
	 */
	static instances = new __KengineCollection()

	// feather ignore GM1045
	static __Extensions = function() : __KengineStruct() constructor {
		/**
		 * @function Add
		 * @memberof Kengine.Extensions
		 * @description Adds a struct to Kengine extensions.
		 *
		 * > if your extension returns a struct, then it is added automatically and no need to call this method.
		 *
		 * @param {Struct} ext The extension struct to add.
		 * @return {Struct}
		 * 
		 */
		static Add = method(self, function(ext) {
			self[$ ext.name] = ext;
		})
		/**
		 * @function Get
		 * @memberof Kengine.Extensions
		 * @description Returns a Kengine extension by name.
		 * @param {String} name
		 * @return {Struct}
		 * 
		 */
		static Get = method(self, function(name) {
			return __KengineStructUtils.Get(self, name);
		})
		/**
		 * @function Exists
		 * @memberof Kengine.Extensions
		 * @param {String} name
		 * @description Returns whether a Kengine extension exists by name.
		 * @return {Bool}
		 * 
		 */
		static Exists = method(self, function(name) {
			return self.Get(name) != undefined;
		})
		/**
		 * @function GetAllNames
		 * @memberof Kengine.Extensions
		 * @description Gets all Extensions' names.
		 * @return {Array}
		 * 
		 */
		static GetAllNames = method(self, function() {
			return array_filter(struct_get_names(self), method(self, function(element) {
				return is_struct(self[$ element]);
			}));
		})
		/**
		 * @function GetAll
		 * @memberof Kengine.Extensions
		 * @description Gets all Extensions.
		 * @return {Array}
		 * 
		 */
		static GetAll = method(self, function() {
			return array_map(self.GetAllNames(), method(self, function(element, index) {
				return self[$ element];
			}));
		})
	}

	/**
	 * @name Extensions
	 * @type {Struct}
	 * @memberof Kengine
	 * @description A struct of `name` as key and `extension` as value.
	 * 
	 */
	static Extensions = new __Extensions();

	/**
	 * @name coroutines
	 * @type {Array<Kengine.Coroutine>}
	 * @memberof Kengine
	 * @description An array of {@link Kengine.Coroutine} that are currently processing.
	 * 
	 */
	static coroutines = []
	static __coroutines_last_tick = 0

	/**
	 * @name current_room_asset
	 * @type {Kengine.Asset|Undefined}
	 * @memberof Kengine
	 * @description The Room-type {@link Kengine.Asset} currently active as `room`.
	 * 
	 */
	static current_room_asset = undefined

	/**
	 * @member asset_type_options
	 * @type {Undefined|Struct}
	 * @memberof Kengine
	 * @description The asset type options for Kengine.
	 *
	 */
	static asset_type_options = undefined

	/**
	 * @member asset_types
	 * @type {Struct}
	 * @memberof Kengine
	 * @description The asset types struct of Kengine.
	 * 
	 * @example
	 * Kengine.asset_types.sprites
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

	/**
	* @function new_uid
	* @memberof Kengine
	* @description Returns a new UID. This is mostly used for assets.
	* 
	*/
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
		if __initialized return false;
		status = "STARTING"
		asset_types = new __KengineStruct()
		__initialized = true;

		__KengineBenchmarkUtils.Init();

		main_object = self;

		variable_global_set("Kengine", self);

		__KengineUtils.__Start();

		return true;
	}
}
