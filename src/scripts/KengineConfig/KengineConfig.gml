#region Constants

/**
 * @namespace Kengine~Constants
 *
 */

enum KENGINE_COROUTINES_STATUS {
	IDLE,
	RUNNING,
	PAUSED,
	DONE,
	FAIL
}

enum KENGINE_STATUS_TYPE {
	MAIN = 1,
	COROUTINES = 2,
	EXTENSIONS = 4
}

enum KENGINE_PANELS_SCROLLBAR_TYPE {
	HORIZONTAL,
	VERTICAL,
}


/**
 * @constant KENGINE_CUSTOM_ASSET_KIND
 * @memberof Kengine~Constants
 * @description Asset kind if it is not a YYAsset.
 * @type {String}
 * @readonly
 * @defaultvalue "KAsset"
 * 
 */
#macro KENGINE_CUSTOM_ASSET_KIND "KAsset"

/**
 * @constant KENGINE_ASSET_TAG_FIXED
 * @memberof Kengine~Constants
 * @description Fixed asset tag. Any {@link Kengine.Asset} with this tag is never replaced by mods.
 * @type {String}
 * @readonly
 * @defaultvalue "Fixed"
 * 
 */
#macro KENGINE_ASSET_TAG_FIXED "Fixed"

/**
 * @constant KENGINE_ASSET_TAG_REPLACED
 * @memberof Kengine~Constants
 * @description A replaced asset tag. Any {@link Kengine.Asset} with this tag means that is has been replaced by mods.
 * @type {String}
 * @readonly
 * @defaultvalue "Replaced"
 * 
 */
#macro KENGINE_ASSET_TAG_REPLACED "Replaced"

/**
 * @constant KENGINE_ASSET_TAG_ADDED
 * @memberof Kengine~Constants
 * @description An added asset tag. Any {@link Kengine.Asset} with this tag means that is has been added by a mod.
 * @type {String}
 * @readonly
 * @defaultvalue "Added"
 * 
 */
#macro KENGINE_ASSET_TAG_ADDED "Added"

/**
 * @constant KENGINE_MAIN_OBJECT_RESOURCE 
 * @memberof Kengine~Constants
 * @description The main object asset that is obj_kengine.
 * @type {Asset.GMObject}
 * @readonly
 * @defaultvalue obj_kengine
 * 
 */
#macro KENGINE_MAIN_OBJECT_RESOURCE obj_kengine

/**
 * @constant KENGINE_CUSTOM_SCRIPT_ASSETTYPE_NAME
 * @memberof Kengine~Constants
 * @description What the custom scripts language is called.
 * @type {String}
 * @readonly
 * @defaultvalue "kscript"
 * 
 */
#macro KENGINE_CUSTOM_SCRIPT_ASSETTYPE_NAME "kscript"

/**
 * @constant KENGINE_CUSTOM_SCRIPT_EXTENSION
 * @memberof Kengine~Constants
 * @description The custom scripts file extension.
 * @type {String}
 * @readonly
 * @defaultvalue ".scr"
 * 
 */
#macro KENGINE_CUSTOM_SCRIPT_EXTENSION ".scr"

/**
 * @constant KENGINE_TEST_FUNCTION_PREFIX
 * @memberof Kengine~Constants
 * @description The prefix for "test" functions to be detected.
 * @type {String}
 * @readonly
 * @defaultvalue "ken_test_"
 * 
 */
#macro KENGINE_TEST_FUNCTION_PREFIX "ken_test_"

#endregion Constants

#region Configs

/**
 * @constant KENGINE_MODS_FIND_MODS_FUNCTION
 * @memberof Kengine~Constants
 * @description A reference to a function that returns mods that are found at game start.
 * @type {Function|String}
 * @readonly
 * @defaultvalue "DefaultGameFindMods"
 * 
 */
#macro KENGINE_MODS_FIND_MODS_FUNCTION "DefaultGameFindMods"

/**
 * @constant KENGINE_EVENTS_ENABLED
 * @memberof Kengine~Constants
 * @description Whether Kengine events are enabled.
 * @type {Bool}
 * @readonly
 * @defaultvalue true
 * 
 */
#macro KENGINE_EVENTS_ENABLED (true)

/**
 * @constant KENGINE_ASSET_TYPES_AUTO_INDEX_AT_START
 * @memberof Kengine~Constants
 * @description Whether index assets at start of Kengine.
 * @type {Bool}
 * @readonly
 * @defaultvalue true
 * 
 */
#macro KENGINE_ASSET_TYPES_AUTO_INDEX_AT_START (true)

/**
 * @constant KENGINE_ASSET_TYPES_AUTO_INDEX_ASYNC
 * @memberof Kengine~Constants
 * @description Whether Auto indexing should be asynchronous at game start.
 * @type {Bool}
 * @readonly
 * @defaultvalue true
 * 
 */
#macro KENGINE_ASSET_TYPES_AUTO_INDEX_ASYNC (true)

/**
 * @constant KENGINE_ASSET_TYPES_INDEX_CHUNK_SIZE
 * @memberof Kengine~Constants
 * @description Auto indexing chunk size for async. Recommended average is 5-25.
 * @type {Real}
 * @readonly
 * @defaultvalue 5
 * 
 */
#macro KENGINE_ASSET_TYPES_INDEX_CHUNK_SIZE (5)

/**
 * @member KENGINE_CONSOLE_ENABLED
 * @type {Bool}
 * @memberof Kengine~Constants
 * @description Whether console is enabled for Kengine. It is set to `true` in Debug configuration.
 * @defaultvalue false
 * 
 */
#macro KENGINE_CONSOLE_ENABLED (true)

/**
 * @member KENGINE_CONSOLE_ALLOW_PRIVATE
 * @type {Bool}
 * @memberof Kengine~Constants
 * @description Whether console can access structs and methods marked as private.
 * @defaultvalue false
 * 
 */
#macro KENGINE_CONSOLE_ALLOW_PRIVATE (false)

/**
 * @member KENGINE_PARSER_FIELD_RULES
 * @type {Array<Any>}
 * @memberof Kengine~Constants
 * @description Set some member/field rules for the parser. They are used in the same order. All rules will execute, no breaks.
 * Do not use empty strings.
 * Use an empty array to not use any rules.
 * Use ? to make sure the struct or instance is not private. (recommended)
 * Use !? to make sure the struct or instance is (not) not private. (not recommended)
 * Use any other string as the prefix of a member name which CAN be accessed of any struct or instance.
 * Use ! with any other string as the prefix of a member name which CANNOT be accessed of any struct or instance.
 * @defaultvalue ["?", "!__", ]
 * 
 */
#macro KENGINE_PARSER_FIELD_RULES (os_get_config() == "Debug" ? ["?", "!__"] : ["?", "!_"])

/**
 * @member KENGINE_PARSER_DEFAULT_PRIVATE
 * @type {Bool}
 * @memberof Kengine~Constants
 * @description Whether parser treats everything as private by default.
 * @defaultvalue false
 * 
 */
#macro KENGINE_PARSER_DEFAULT_PRIVATE (false)

/**
 * @member KENGINE_PARSER_STATICS
 * @type {Bool}
 * @memberof Kengine~Constants
 * @description An array of two-elements arrays where the first is the key and the second is the value to be evaluated
 * upon using that key as an indentifier in parsing.
 * @defaultvalue ["Kengine", "obj_kengine.__kengine"]
 * 
 */
#macro KENGINE_PARSER_STATICS [\
	["Kengine", "obj_kengine.__kengine"], \
]

/**
 * @member KENGINE_CONSOLE_LOG_FILE
 * @type {Bool|String}
 * @memberof Kengine~Constants
 * @description console log file for Kengine. It is set to `"kengine.debug.log"` in Debug configuration.
 * 
 */
#macro KENGINE_CONSOLE_LOG_ENABLED (GM_build_type == "run")
#macro KENGINE_CONSOLE_LOG_FILE (KENGINE_CONSOLE_LOG_ENABLED ? string("kengine." + string_lower((os_get_config()) + ".log")) : "")

/**
 * @member KENGINE_DEBUG
 * @type {Bool}
 * @memberof Kengine~Constants
 * @description Whether debug mode is on for Kengine. It is set to `true` in Debug configuration.
 * @defaultvalue false
 * 
 */
#macro KENGINE_DEBUG (GM_build_type == "run" and (os_get_config() == "Debug" || os_get_config() == "Benchmark"))

/**
 * @member KENGINE_VERBOSITY
 * @type {Real}
 * @memberof Kengine~Constants
 * @description Verbosity level. This logs more info. 0,1,2...
 * @defaultvalue 0
 * 
 */
#macro KENGINE_VERBOSITY ((os_get_config() == "Debug" || os_get_config() == "Benchmark" || os_get_config() == "Test") ? 3 : 0)

/**
 * @member KENGINE_BENCHMARK
 * @type {Bool}
 * @memberof Kengine~Constants
 * @description Whether benchmarking mode is on for Kengine. This logs debug information for timing. It is set to true in Benchmark configuration
 * @defaultvalue false
 * 
 */
#macro KENGINE_BENCHMARK (os_get_config() == "Benchmark")

/**
 * @member KENGINE_IS_TESTING
 * @type {Bool}
 * @memberof Kengine~Constants
 * @description Whether testing mode is on for Kengine. This logs debug information for timing. It is set to true in Benchmark configuration
 * @defaultvalue Kengine.is_testing
 * 
 */
#macro KENGINE_IS_TESTING (os_get_config() == "Test")

/**
 * @member KENGINE_DEFAULT_INSTANCES_LAYER
 * @type {String}
 * @memberof Kengine~Constants
 * @description Default layer that wrapped instances of {@link KENGINE_WRAPPED_OBJECT} are created on, when layer is not provided. You can use undefined to create using depth by default.
 * @defaultvalue undefined
 * 
 */
#macro KENGINE_DEFAULT_INSTANCES_LAYER undefined

/**
 * @member KENGINE_WRAPPED_OBJECT
 * @type {Asset.GMObject}
 * @memberof Kengine~Constants
 * @description Default object. When a custom object asset is created, it is based on using this object.
 * @defaultvalue `obj_ken_object`
 * 
 */
#macro KENGINE_WRAPPED_OBJECT obj_ken_object

/**
 * @member KENGINE_ASSET_TYPES_ORDER
 * @type {Array}
 * @memberof Kengine~Constants
 * @description Order for asset evaluations. Do not modify unless you know what you are doing.
 * Put the dependants last and put the dependencies that do not depend on others first.
 * @defaultvalue ["sprite", "tileset", "sound", KENGINE_CUSTOM_SCRIPT_ASSETTYPE_NAME, "object", "rm",]
 * 
 */
#macro KENGINE_ASSET_TYPES_ORDER ([\
	"path", "sprite", "tileset", "sound", KENGINE_CUSTOM_SCRIPT_ASSETTYPE_NAME, "object", "rm",\
])

/**
 * @member KENGINE_EXTENSIONS_ORDER
 * @type {Array}
 * @memberof Kengine~Constants
 * @description Order for extensions loading. Do not modify unless you know what you are doing.
 * Put the dependants last and put the dependencies that do not depend on others first.
 * @defaultvalue ["parser", "mods", "panels", "tests",]
 * 
 */
#macro KENGINE_EXTENSIONS_ORDER ([\
	"parser", "mods", "panels", "tests",\
])

#endregion Configs
