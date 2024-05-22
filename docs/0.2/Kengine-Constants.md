# Constants  :id=kengine-constants

[Kengine~Constants](Kengine-Constants) <code>object</code>
<!-- tabs:start -->


<!-- tabs:end -->

## KENGINE_CONSOLE_ENABLED  :id=kengine-constants-kengine_console_enabled

[Kengine~Constants.KENGINE_CONSOLE_ENABLED](Kengine-Constants.KENGINE_CONSOLE_ENABLED) <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Whether console is enabled for Kengine. It is set to <code>true</code> in Debug configuration.


**Default**: <code>false</code>  
<!-- tabs:end -->

## KENGINE_CONSOLE_ALLOW_PRIVATE  :id=kengine-constants-kengine_console_allow_private

[Kengine~Constants.KENGINE_CONSOLE_ALLOW_PRIVATE](Kengine-Constants.KENGINE_CONSOLE_ALLOW_PRIVATE) <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Whether console can access structs and methods marked as private.


**Default**: <code>false</code>  
<!-- tabs:end -->

## KENGINE_PARSER_FIELD_RULES  :id=kengine-constants-kengine_parser_field_rules

[Kengine~Constants.KENGINE_PARSER_FIELD_RULES](Kengine-Constants.KENGINE_PARSER_FIELD_RULES) <code>Array.&lt;Any&gt;</code>
<!-- tabs:start -->


##### **Description**

Set some member/field rules for the parser. They are used in the same order. All rules will execute, no breaks.
Do not use empty strings.
Use an empty array to not use any rules.
Use ? to make sure the struct or instance is not private. (recommended)
Use !? to make sure the struct or instance is (not) not private. (not recommended)
Use any other string as the prefix of a member name which CAN be accessed of any struct or instance.
Use ! with any other string as the prefix of a member name which CANNOT be accessed of any struct or instance.


**Default**: <code>[&quot;?&quot;, &quot;!__&quot;, ]</code>  
<!-- tabs:end -->

## KENGINE_PARSER_DEFAULT_PRIVATE  :id=kengine-constants-kengine_parser_default_private

[Kengine~Constants.KENGINE_PARSER_DEFAULT_PRIVATE](Kengine-Constants.KENGINE_PARSER_DEFAULT_PRIVATE) <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Whether parser treats everything as private by default.


**Default**: <code>false</code>  
<!-- tabs:end -->

## KENGINE_PARSER_STATICS  :id=kengine-constants-kengine_parser_statics

[Kengine~Constants.KENGINE_PARSER_STATICS](Kengine-Constants.KENGINE_PARSER_STATICS) <code>Bool</code>
<!-- tabs:start -->


##### **Description**

An array of two-elements arrays where the first is the key and the second is the value to be evaluated
upon using that key as an indentifier in parsing.


**Default**: <code>[&quot;Kengine&quot;, &quot;obj_kengine.__kengine&quot;]</code>  
<!-- tabs:end -->

## KENGINE_CONSOLE_LOG_FILE  :id=kengine-constants-kengine_console_log_file

[Kengine~Constants.KENGINE_CONSOLE_LOG_FILE](Kengine-Constants.KENGINE_CONSOLE_LOG_FILE) <code>Bool</code> \| <code>String</code>
<!-- tabs:start -->


##### **Description**

console log file for Kengine. It is set to <code>&quot;kengine.debug.log&quot;</code> in Debug configuration.


<!-- tabs:end -->

## KENGINE_DEBUG  :id=kengine-constants-kengine_debug

[Kengine~Constants.KENGINE_DEBUG](Kengine-Constants.KENGINE_DEBUG) <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Whether debug mode is on for Kengine. It is set to <code>true</code> in Debug configuration.


**Default**: <code>false</code>  
<!-- tabs:end -->

## KENGINE_VERBOSITY  :id=kengine-constants-kengine_verbosity

[Kengine~Constants.KENGINE_VERBOSITY](Kengine-Constants.KENGINE_VERBOSITY) <code>Real</code>
<!-- tabs:start -->


##### **Description**

Verbosity level. This logs more info. 0,1,2...


**Default**: <code>0</code>  
<!-- tabs:end -->

## KENGINE_BENCHMARK  :id=kengine-constants-kengine_benchmark

[Kengine~Constants.KENGINE_BENCHMARK](Kengine-Constants.KENGINE_BENCHMARK) <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Whether benchmarking mode is on for Kengine. This logs debug information for timing. It is set to true in Benchmark configuration


**Default**: <code>false</code>  
<!-- tabs:end -->

## KENGINE_IS_TESTING  :id=kengine-constants-kengine_is_testing

[Kengine~Constants.KENGINE_IS_TESTING](Kengine-Constants.KENGINE_IS_TESTING) <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Whether testing mode is on for Kengine. This logs debug information for timing. It is set to true in Benchmark configuration


**Default**: <code>Kengine.is_testing</code>  
<!-- tabs:end -->

## KENGINE_DEFAULT_INSTANCES_LAYER  :id=kengine-constants-kengine_default_instances_layer

[Kengine~Constants.KENGINE_DEFAULT_INSTANCES_LAYER](Kengine-Constants.KENGINE_DEFAULT_INSTANCES_LAYER) <code>String</code>
<!-- tabs:start -->


##### **Description**

Default layer that wrapped instances of [KENGINE_WRAPPED_OBJECT](KENGINE_WRAPPED_OBJECT) are created on, when layer is not provided. You can use undefined to create using depth by default.


**Default**: <code>undefined</code>  
<!-- tabs:end -->

## KENGINE_WRAPPED_OBJECT  :id=kengine-constants-kengine_wrapped_object

[Kengine~Constants.KENGINE_WRAPPED_OBJECT](Kengine-Constants.KENGINE_WRAPPED_OBJECT) <code>Asset.GMObject</code>
<!-- tabs:start -->


##### **Description**

Default object. When a custom object asset is created, it is based on using this object.


**Default**: <code>&#x60;obj_ken_object&#x60;</code>  
<!-- tabs:end -->

## KENGINE_ASSET_TYPES_ORDER  :id=kengine-constants-kengine_asset_types_order

[Kengine~Constants.KENGINE_ASSET_TYPES_ORDER](Kengine-Constants.KENGINE_ASSET_TYPES_ORDER) <code>Array</code>
<!-- tabs:start -->


##### **Description**

Order for asset evaluations. Do not modify unless you know what you are doing.
Put the dependants last and put the dependencies that do not depend on others first.


**Default**: <code>[&quot;sprite&quot;, &quot;tileset&quot;, &quot;sound&quot;, KENGINE_CUSTOM_SCRIPT_ASSETTYPE_NAME, &quot;object&quot;, &quot;rm&quot;,]</code>  
<!-- tabs:end -->

## KENGINE_EXTENSIONS_ORDER  :id=kengine-constants-kengine_extensions_order

[Kengine~Constants.KENGINE_EXTENSIONS_ORDER](Kengine-Constants.KENGINE_EXTENSIONS_ORDER) <code>Array</code>
<!-- tabs:start -->


##### **Description**

Order for extensions loading. Do not modify unless you know what you are doing.
Put the dependants last and put the dependencies that do not depend on others first.


**Default**: <code>[&quot;parser&quot;, &quot;mods&quot;, &quot;panels&quot;, &quot;tests&quot;,]</code>  
<!-- tabs:end -->

## KENGINE_CUSTOM_ASSET_KIND  :id=kengine-constants-kengine_custom_asset_kind

[Kengine~Constants.KENGINE_CUSTOM_ASSET_KIND](Kengine-Constants.KENGINE_CUSTOM_ASSET_KIND) <code>String</code>
<!-- tabs:start -->


##### **Description**

Asset kind if it is not a YYAsset.


**Default**: <code>&quot;KAsset&quot;</code>  
**Read only**: true  
<!-- tabs:end -->

## KENGINE_ASSET_TAG_FIXED  :id=kengine-constants-kengine_asset_tag_fixed

[Kengine~Constants.KENGINE_ASSET_TAG_FIXED](Kengine-Constants.KENGINE_ASSET_TAG_FIXED) <code>String</code>
<!-- tabs:start -->


##### **Description**

Fixed asset tag. Any [Kengine.Asset](Kengine?id=kengine.asset) with this tag is never replaced by mods.


**Default**: <code>&quot;Fixed&quot;</code>  
**Read only**: true  
<!-- tabs:end -->

## KENGINE_ASSET_TAG_REPLACED  :id=kengine-constants-kengine_asset_tag_replaced

[Kengine~Constants.KENGINE_ASSET_TAG_REPLACED](Kengine-Constants.KENGINE_ASSET_TAG_REPLACED) <code>String</code>
<!-- tabs:start -->


##### **Description**

A replaced asset tag. Any [Kengine.Asset](Kengine?id=kengine.asset) with this tag means that is has been replaced by mods.


**Default**: <code>&quot;Replaced&quot;</code>  
**Read only**: true  
<!-- tabs:end -->

## KENGINE_ASSET_TAG_ADDED  :id=kengine-constants-kengine_asset_tag_added

[Kengine~Constants.KENGINE_ASSET_TAG_ADDED](Kengine-Constants.KENGINE_ASSET_TAG_ADDED) <code>String</code>
<!-- tabs:start -->


##### **Description**

An added asset tag. Any [Kengine.Asset](Kengine?id=kengine.asset) with this tag means that is has been added by a mod.


**Default**: <code>&quot;Added&quot;</code>  
**Read only**: true  
<!-- tabs:end -->

## KENGINE_MAIN_OBJECT_RESOURCE  :id=kengine-constants-kengine_main_object_resource

[Kengine~Constants.KENGINE_MAIN_OBJECT_RESOURCE](Kengine-Constants.KENGINE_MAIN_OBJECT_RESOURCE) <code>Asset.GMObject</code>
<!-- tabs:start -->


##### **Description**

The main object asset that is obj_kengine.


**Default**: <code>obj_kengine</code>  
**Read only**: true  
<!-- tabs:end -->

## KENGINE_CUSTOM_SCRIPT_ASSETTYPE_NAME  :id=kengine-constants-kengine_custom_script_assettype_name

[Kengine~Constants.KENGINE_CUSTOM_SCRIPT_ASSETTYPE_NAME](Kengine-Constants.KENGINE_CUSTOM_SCRIPT_ASSETTYPE_NAME) <code>String</code>
<!-- tabs:start -->


##### **Description**

What the custom scripts language is called.


**Default**: <code>&quot;kscript&quot;</code>  
**Read only**: true  
<!-- tabs:end -->

## KENGINE_CUSTOM_SCRIPT_EXTENSION  :id=kengine-constants-kengine_custom_script_extension

[Kengine~Constants.KENGINE_CUSTOM_SCRIPT_EXTENSION](Kengine-Constants.KENGINE_CUSTOM_SCRIPT_EXTENSION) <code>String</code>
<!-- tabs:start -->


##### **Description**

The custom scripts file extension.


**Default**: <code>&quot;.scr&quot;</code>  
**Read only**: true  
<!-- tabs:end -->

## KENGINE_TEST_FUNCTION_PREFIX  :id=kengine-constants-kengine_test_function_prefix

[Kengine~Constants.KENGINE_TEST_FUNCTION_PREFIX](Kengine-Constants.KENGINE_TEST_FUNCTION_PREFIX) <code>String</code>
<!-- tabs:start -->


##### **Description**

The prefix for &quot;test&quot; functions to be detected.


**Default**: <code>&quot;ken_test_&quot;</code>  
**Read only**: true  
<!-- tabs:end -->

## KENGINE_MODS_FIND_MODS_FUNCTION  :id=kengine-constants-kengine_mods_find_mods_function

[Kengine~Constants.KENGINE_MODS_FIND_MODS_FUNCTION](Kengine-Constants.KENGINE_MODS_FIND_MODS_FUNCTION) <code>function</code> \| <code>String</code>
<!-- tabs:start -->


##### **Description**

A reference to a function that returns mods that are found at game start.


**Default**: <code>&quot;DefaultGameFindMods&quot;</code>  
**Read only**: true  
<!-- tabs:end -->

## KENGINE_EVENTS_ENABLED  :id=kengine-constants-kengine_events_enabled

[Kengine~Constants.KENGINE_EVENTS_ENABLED](Kengine-Constants.KENGINE_EVENTS_ENABLED) <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Whether Kengine events are enabled.


**Default**: <code>true</code>  
**Read only**: true  
<!-- tabs:end -->

## KENGINE_ASSET_TYPES_AUTO_INDEX_AT_START  :id=kengine-constants-kengine_asset_types_auto_index_at_start

[Kengine~Constants.KENGINE_ASSET_TYPES_AUTO_INDEX_AT_START](Kengine-Constants.KENGINE_ASSET_TYPES_AUTO_INDEX_AT_START) <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Whether index assets at start of Kengine.


**Default**: <code>true</code>  
**Read only**: true  
<!-- tabs:end -->

## KENGINE_ASSET_TYPES_AUTO_INDEX_ASYNC  :id=kengine-constants-kengine_asset_types_auto_index_async

[Kengine~Constants.KENGINE_ASSET_TYPES_AUTO_INDEX_ASYNC](Kengine-Constants.KENGINE_ASSET_TYPES_AUTO_INDEX_ASYNC) <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Whether Auto indexing should be asynchronous at game start.


**Default**: <code>true</code>  
**Read only**: true  
<!-- tabs:end -->

## KENGINE_ASSET_TYPES_INDEX_CHUNK_SIZE  :id=kengine-constants-kengine_asset_types_index_chunk_size

[Kengine~Constants.KENGINE_ASSET_TYPES_INDEX_CHUNK_SIZE](Kengine-Constants.KENGINE_ASSET_TYPES_INDEX_CHUNK_SIZE) <code>Real</code>
<!-- tabs:start -->


##### **Description**

Auto indexing chunk size for async. Recommended average is 5-25.


**Default**: <code>5</code>  
**Read only**: true  
<!-- tabs:end -->

