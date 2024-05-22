# Errors  :id=kengine-utils-errors

[Kengine.Utils.Errors](Kengine.Utils.Errors) <code>object</code>
<!-- tabs:start -->


##### **Description**

A struct containing Kengine errors utilitiy functions


<!-- tabs:end -->

## Types  :id=kengine-utils-errors-types

[Kengine.Utils.Errors.Types](Kengine.Utils.Errors?id=kengine.utils.errors.types) <code>Struct</code>
<!-- tabs:start -->


##### **Description**

Preset error types. These errors are extendable through Kengine extensions.


<!-- tabs:end -->

### unknown  :id=kengine-utils-errors-types-unknown

[Kengine.Utils.Errors.Types.unknown](Kengine.Utils.Errors?id=kengine.utils.errors.types.unknown) <code>String</code>
<!-- tabs:start -->


##### **Description**

Unknown error occured.


<!-- tabs:end -->

### array__access_with_name  :id=kengine-utils-errors-types-array__access_with_name

[Kengine.Utils.Errors.Types.array__access_with_name](Kengine.Utils.Errors?id=kengine.utils.errors.types.array__access_with_name) <code>String</code>
<!-- tabs:start -->


##### **Description**

Cannot access array by name.


<!-- tabs:end -->

### array__cannot_be_private  :id=kengine-utils-errors-types-array__cannot_be_private

[Kengine.Utils.Errors.Types.array__cannot_be_private](Kengine.Utils.Errors?id=kengine.utils.errors.types.array__cannot_be_private) <code>String</code>
<!-- tabs:start -->


##### **Description**

Arrays cannot become private.


<!-- tabs:end -->

### array__cannot_be_readonly  :id=kengine-utils-errors-types-array__cannot_be_readonly

[Kengine.Utils.Errors.Types.array__cannot_be_readonly](Kengine.Utils.Errors?id=kengine.utils.errors.types.array__cannot_be_readonly) <code>String</code>
<!-- tabs:start -->


##### **Description**

Arrays cannot become readonly.


<!-- tabs:end -->

### error__does_not_exist  :id=kengine-utils-errors-types-error__does_not_exist

[Kengine.Utils.Errors.Types.error__does_not_exist](Kengine.Utils.Errors?id=kengine.utils.errors.types.error__does_not_exist) <code>String</code>
<!-- tabs:start -->


##### **Description**

Error is not defined.


<!-- tabs:end -->

### asset__asset_type__does_not_exist  :id=kengine-utils-errors-types-asset__asset_type__does_not_exist

[Kengine.Utils.Errors.Types.asset__asset_type__does_not_exist](Kengine.Utils.Errors?id=kengine.utils.errors.types.asset__asset_type__does_not_exist) <code>String</code>
<!-- tabs:start -->


##### **Description**

Cannot create asset (non-existent AssetType).


<!-- tabs:end -->

### asset__asset_type__cannot_replace  :id=kengine-utils-errors-types-asset__asset_type__cannot_replace

[Kengine.Utils.Errors.Types.asset__asset_type__cannot_replace](Kengine.Utils.Errors?id=kengine.utils.errors.types.asset__asset_type__cannot_replace) <code>String</code>
<!-- tabs:start -->


##### **Description**

Cannot replace Asset (AssetType is not replaceable).


<!-- tabs:end -->

### asset__cannot_replace  :id=kengine-utils-errors-types-asset__cannot_replace

[Kengine.Utils.Errors.Types.asset__cannot_replace](Kengine.Utils.Errors?id=kengine.utils.errors.types.asset__cannot_replace) <code>String</code>
<!-- tabs:start -->


##### **Description**

Cannot replace Asset.


<!-- tabs:end -->

### asset__invalid  :id=kengine-utils-errors-types-asset__invalid

[Kengine.Utils.Errors.Types.asset__invalid](Kengine.Utils.Errors?id=kengine.utils.errors.types.asset__invalid) <code>String</code>
<!-- tabs:start -->


##### **Description**

Asset is invalid.


<!-- tabs:end -->

### asset__asset_type__cannot_add  :id=kengine-utils-errors-types-asset__asset_type__cannot_add

[Kengine.Utils.Errors.Types.asset__asset_type__cannot_add](Kengine.Utils.Errors?id=kengine.utils.errors.types.asset__asset_type__cannot_add) <code>String</code>
<!-- tabs:start -->


##### **Description**

Cannot add Asset (AssetType is not addable).


<!-- tabs:end -->

### asset_type__asset_type__exists  :id=kengine-utils-errors-types-asset_type__asset_type__exists

[Kengine.Utils.Errors.Types.asset_type__asset_type__exists](Kengine.Utils.Errors?id=kengine.utils.errors.types.asset_type__asset_type__exists) <code>String</code>
<!-- tabs:start -->


##### **Description**

AssetType already defined.


<!-- tabs:end -->

### asset_type__does_not_exist  :id=kengine-utils-errors-types-asset_type__does_not_exist

[Kengine.Utils.Errors.Types.asset_type__does_not_exist](Kengine.Utils.Errors?id=kengine.utils.errors.types.asset_type__does_not_exist) <code>String</code>
<!-- tabs:start -->


##### **Description**

AssetType does not exist.


<!-- tabs:end -->

### instance__asset__does_not_exist  :id=kengine-utils-errors-types-instance__asset__does_not_exist

[Kengine.Utils.Errors.Types.instance__asset__does_not_exist](Kengine.Utils.Errors?id=kengine.utils.errors.types.instance__asset__does_not_exist) <code>String</code>
<!-- tabs:start -->


##### **Description**

Cannot create instance from asset (non-existent Asset).


<!-- tabs:end -->

### script_exec__script__does_not_exist  :id=kengine-utils-errors-types-script_exec__script__does_not_exist

[Kengine.Utils.Errors.Types.script_exec__script__does_not_exist](Kengine.Utils.Errors?id=kengine.utils.errors.types.script_exec__script__does_not_exist) <code>String</code>
<!-- tabs:start -->


##### **Description**

Cannot execute script (non-existent script).


<!-- tabs:end -->

### mods__mod__duplicate  :id=kengine-utils-errors-types-mods__mod__duplicate

[Kengine.Utils.Errors.Types.mods__mod__duplicate](Kengine.Utils.Errors?id=kengine.utils.errors.types.mods__mod__duplicate) <code>String</code>
<!-- tabs:start -->


##### **Description**

Duplicate Mod found.


<!-- tabs:end -->

### mods__mod__does_not_exist  :id=kengine-utils-errors-types-mods__mod__does_not_exist

[Kengine.Utils.Errors.Types.mods__mod__does_not_exist](Kengine.Utils.Errors?id=kengine.utils.errors.types.mods__mod__does_not_exist) <code>String</code>
<!-- tabs:start -->


##### **Description**

Mod does not exist.


<!-- tabs:end -->

### mods__asset_conf__no_type  :id=kengine-utils-errors-types-mods__asset_conf__no_type

[Kengine.Utils.Errors.Types.mods__asset_conf__no_type](Kengine.Utils.Errors?id=kengine.utils.errors.types.mods__asset_conf__no_type) <code>String</code>
<!-- tabs:start -->


##### **Description**

AssetConf does not have a type.


<!-- tabs:end -->

### mods__asset_conf__invalid  :id=kengine-utils-errors-types-mods__asset_conf__invalid

[Kengine.Utils.Errors.Types.mods__asset_conf__invalid](Kengine.Utils.Errors?id=kengine.utils.errors.types.mods__asset_conf__invalid) <code>String</code>
<!-- tabs:start -->


##### **Description**

AssetConfs are invalid.


<!-- tabs:end -->

### mods__asset_conf__cannot_update  :id=kengine-utils-errors-types-mods__asset_conf__cannot_update

[Kengine.Utils.Errors.Types.mods__asset_conf__cannot_update](Kengine.Utils.Errors?id=kengine.utils.errors.types.mods__asset_conf__cannot_update) <code>String</code>
<!-- tabs:start -->


##### **Description**

AssetConf cannot be updated since it's applied currently.


<!-- tabs:end -->

### mods__asset_conf__no_name  :id=kengine-utils-errors-types-mods__asset_conf__no_name

[Kengine.Utils.Errors.Types.mods__asset_conf__no_name](Kengine.Utils.Errors?id=kengine.utils.errors.types.mods__asset_conf__no_name) <code>String</code>
<!-- tabs:start -->


##### **Description**

AssetConf does not have a name.


<!-- tabs:end -->

### mods__asset_conf__no_resolve  :id=kengine-utils-errors-types-mods__asset_conf__no_resolve

[Kengine.Utils.Errors.Types.mods__asset_conf__no_resolve](Kengine.Utils.Errors?id=kengine.utils.errors.types.mods__asset_conf__no_resolve) <code>String</code>
<!-- tabs:start -->


##### **Description**

AssetConf property not found.


<!-- tabs:end -->

### mods__asset_conf__does_not_exist  :id=kengine-utils-errors-types-mods__asset_conf__does_not_exist

[Kengine.Utils.Errors.Types.mods__asset_conf__does_not_exist](Kengine.Utils.Errors?id=kengine.utils.errors.types.mods__asset_conf__does_not_exist) <code>String</code>
<!-- tabs:start -->


##### **Description**

AssetConf does not exist.


<!-- tabs:end -->

### tests__test__func_invalid_return  :id=kengine-utils-errors-types-tests__test__func_invalid_return

[Kengine.Utils.Errors.Types.tests__test__func_invalid_return](Kengine.Utils.Errors?id=kengine.utils.errors.types.tests__test__func_invalid_return) <code>String</code>
<!-- tabs:start -->


##### **Description**

Test function did not return a struct.


<!-- tabs:end -->

### tests__fixture__does_not_exist  :id=kengine-utils-errors-types-tests__fixture__does_not_exist

[Kengine.Utils.Errors.Types.tests__fixture__does_not_exist](Kengine.Utils.Errors?id=kengine.utils.errors.types.tests__fixture__does_not_exist) <code>String</code>
<!-- tabs:start -->


##### **Description**

Test fixture does not exist.


<!-- tabs:end -->

### tests__assertion__is_not  :id=kengine-utils-errors-types-tests__assertion__is_not

[Kengine.Utils.Errors.Types.tests__assertion__is_not](Kengine.Utils.Errors?id=kengine.utils.errors.types.tests__assertion__is_not) <code>String</code>
<!-- tabs:start -->


##### **Description**

Assertion failure.


<!-- tabs:end -->

## Create  :id=kengine-utils-errors-create

`Kengine.Utils.Errors.Create([error_type], [longMessage], [useLong])` ⇒ <code>Struct</code>
<!-- tabs:start -->


##### **Description**

Creates an error struct that is thrown.



| Param | Type | Default | Description |
| --- | --- | --- | --- |
| [error_type] | <code>String</code> | <code>&quot;unknown&quot;</code> | <p>Error type as a string, or as a reference to an attribute of <code>Kengine.Utils.Errors.Types</code>.</p> |
| [longMessage] | <code>String</code> | <code>&quot;&quot;</code> |  |
| [useLong] | <code>Bool</code> | <code>false</code> |  |

<!-- tabs:end -->

## Define  :id=kengine-utils-errors-define

`Kengine.Utils.Errors.Define(key, _message)`
<!-- tabs:start -->


##### **Description**

Adds an error type.



| Param | Type | Description |
| --- | --- | --- |
| key | <code>String</code> | <p>The key to the error handle.</p> |
| _message | <code>String</code> | <p>The message to display.</p> |


##### **Example**

```gml
Kengine.Utils.Errors.Define("myext__myclass__does_not_exist", "instance of MyClass does not exist.");
```
<!-- tabs:end -->

