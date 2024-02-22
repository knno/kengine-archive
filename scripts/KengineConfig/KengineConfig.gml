/// feather disable all


#region Constants

/**
 * @constant KENGINE_CUSTOM_ASSET_KIND
 * @memberof Kengine~constants
 * @description Asset kind if it is not a YYAsset.
 * @type {String}
 * @readonly
 * @defaultvalue "KAsset"
 * 
 */
#macro KENGINE_CUSTOM_ASSET_KIND "KAsset"

/**
 * @constant KENGINE_ASSET_TAG_FIXED
 * @memberof Kengine~constants
 * @description Fixed asset tag. Any {@link Kengine.Asset} with this tag is never replaced by mods.
 * @type {String}
 * @readonly
 * @defaultvalue "Fixed"
 * 
 */
#macro KENGINE_ASSET_TAG_FIXED "Fixed"

/**
 * @constant KENGINE_ASSET_TAG_REPLACED
 * @memberof Kengine~constants
 * @description A replaced asset tag. Any {@link Kengine.Asset} with this tag means that is has been replaced by mods.
 * @type {String}
 * @readonly
 * @defaultvalue "Replaced"
 * 
 */
#macro KENGINE_ASSET_TAG_REPLACED "Replaced"

/**
 * @constant KENGINE_ASSET_TAG_ADDED
 * @memberof Kengine~constants
 * @description An added asset tag. Any {@link Kengine.Asset} with this tag means that is has been added by a mod.
 * @type {String}
 * @readonly
 * @defaultvalue "Added"
 * 
 */
#macro KENGINE_ASSET_TAG_ADDED "Added"

/**
 * @constant KENGINE_MAIN_OBJECT_RESOURCE 
 * @memberof Kengine~constants
 * @description The main object asset that is obj_kengine.
 * @type {Asset.GMObject}
 * @readonly
 * @defaultvalue obj_kengine
 * 
 */
#macro KENGINE_MAIN_OBJECT_RESOURCE obj_kengine

/**
 * @constant KENGINE_CUSTOM_SCRIPT_ASSETTYPE_NAME
 * @memberof Kengine~constants
 * @description What the custom scripts language is called.
 * @type {String}
 * @readonly
 * @defaultvalue "kscript"
 * 
 */
#macro KENGINE_CUSTOM_SCRIPT_ASSETTYPE_NAME "kscript"

/**
 * @constant KENGINE_CUSTOM_SCRIPT_EXTENSION
 * @memberof Kengine~constants
 * @description The custom scripts file extension.
 * @type {String}
 * @readonly
 * @defaultvalue ".scr"
 * 
 */
#macro KENGINE_CUSTOM_SCRIPT_EXTENSION ".scr"

/**
 * @constant KENGINE_TEST_FUNCTION_PREFIX
 * @memberof Kengine~constants
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
 * @member KENGINE_CONSOLE_ENABLED
 * @type {Bool}
 * @memberof Kengine~constants
 * @description Whether console is enabled for Kengine. It is set to `true` in Debug configuration.
 * @defaultvalue false
 * 
 */
#macro KENGINE_CONSOLE_ENABLED true

/**
 * @member KENGINE_CONSOLE_ALLOW_PRIVATE
 * @type {Bool}
 * @memberof Kengine~constants
 * @description Whether console can access structs and methods marked as private.
 * @defaultvalue false
 * 
 */
#macro KENGINE_CONSOLE_ALLOW_PRIVATE false

/**
 * @member KENGINE_PARSER_FIELD_RULES
 * @type {String|Undefined}
 * @memberof Kengine~constants
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
 * @member KENGINE_CONSOLE_LOG_FILE
 * @type {Bool}
 * @memberof Kengine~constants
 * @description console log file for Kengine. It is set to `"kengine.debug.log"` in Debug configuration.
 * @defaultvalue false
 * 
 */
#macro KENGINE_CONSOLE_LOG_FILE ((GM_build_type == "run") ? string("kengine." + string_lower((os_get_config()) + ".log")) : false)

/**
 * @member KENGINE_DEBUG
 * @type {Bool}
 * @memberof Kengine~constants
 * @description Whether debug mode is on for Kengine. It is set to `true` in Debug configuration.
 * @defaultvalue false
 * 
 */
#macro KENGINE_DEBUG (GM_build_type == "run" and (os_get_config() == "Debug"))

/**
 * @member KENGINE_VERBOSITY
 * @type {Real}
 * @memberof Kengine~constants
 * @description Verbosity level. This logs more info. 0,1,2. It is set to `2` in Debug configuration.
 * @defaultvalue 0
 * 
 */
#macro KENGINE_VERBOSITY ((os_get_config() == "Debug" || os_get_config() == "Benchmark" || os_get_config() == "Test") ? 2 : 0)

/**
 * @member KENGINE_BENCHMARK
 * @type {Bool}
 * @memberof Kengine~constants
 * @description Whether benchmarking mode is on for kengine. This logs debug information for timing. It is set to true in Benchmark configuration
 * @defaultvalue false
 * 
 */
#macro KENGINE_BENCHMARK (os_get_config() == "Benchmark")

/**
 * @member KENGINE_IS_TESTING
 * @type {Bool}
 * @memberof Kengine~constants
 * @description Whether benchmarking mode is on for kengine. This logs debug information for timing. It is set to true in Benchmark configuration
 * @defaultvalue false
 * 
 */
#macro KENGINE_IS_TESTING (os_get_config() == "Test")

/**
 * @member KENGINE_DEFAULT_INSTANCES_LAYER_NAME
 * @type {String}
 * @memberof Kengine~constants
 * @description Default layer that wrapped instances of {@link KENGINE_WRAPPED_OBJECT} are created on, when layer is not provided.
 * @defaultvalue "Instances"
 * 
 */
#macro KENGINE_DEFAULT_INSTANCES_LAYER_NAME "Instances"

/**
 * @member KENGINE_WRAPPED_OBJECT
 * @type {Asset.GMObject}
 * @memberof Kengine~constants
 * @description Default object. When a custom object asset is created, it is based on using this object.
 * @defaultvalue `obj_ken_object`
 * 
 */
#macro KENGINE_WRAPPED_OBJECT obj_ken_object


#macro KENGINE_ASSET_TYPES_ORDER [\
	"sprite", "tileset", "sound", KENGINE_CUSTOM_SCRIPT_ASSETTYPE_NAME, "object", "rm",\ //... etc. "tilemap", TODO: Update this array.
]

#endregion Configs
