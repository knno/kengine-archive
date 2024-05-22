# Data  :id=kengine-utils-data

[Kengine.Utils.Data](Kengine.Utils.Data) <code>object</code>
<!-- tabs:start -->


##### **Description**

A struct containing Kengine data utilitiy functions


<!-- tabs:end -->

## ValuesMap  :id=kengine-utils-data-valuesmap

`Kengine.Utils.Data.ValuesMap(struct_or_array, func, [_par])`
<!-- tabs:start -->


##### **Description**

Visit a struct's or array's values (that are not structs or arrays) and do a function with the values.
The returned value from the func is the new value. It accepts argument <code>val</code>.</p>
<p>Note - Disabling copy on write behavior for arrays is required.



| Param | Type | Description |
| --- | --- | --- |
| struct_or_array | <code>Struct</code> \| <code>Array.&lt;Any&gt;</code> |  |
| func | <code>function</code> |  |
| [_par] | <code>Struct</code> \| <code>Array.&lt;Any&gt;</code> | <p>A parameter for recursive calls.</p> |

<!-- tabs:end -->

## ToBoolean  :id=kengine-utils-data-toboolean

`Kengine.Utils.Data.ToBoolean(value)` ⇒ <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Convert a value to a boolean. such as &quot;ON&quot;, 1, 0, or &quot;false&quot;


**Returns**: <code>Bool</code> - Boolean equivalent of the value.  

| Param | Type | Description |
| --- | --- | --- |
| value | <code>Any</code> | <p>The value to be converted.</p> |

<!-- tabs:end -->

## IniReadBool  :id=kengine-utils-data-inireadbool

`Kengine.Utils.Data.IniReadBool(section, key, default_val)` ⇒ <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Read a key from opened INI and converts it to a boolean value.



| Param | Type |
| --- | --- |
| section | <code>String</code> | 
| key | <code>String</code> | 
| default_val | <code>Bool</code> | 

<!-- tabs:end -->

## IsBoolable  :id=kengine-utils-data-isboolable

`Kengine.Utils.Data.IsBoolable(value)` ⇒ <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Return whether a value can be a boolean. such as &quot;ON&quot;, 1, or &quot;true&quot;.


**Returns**: <code>Bool</code> - Whether it accepts ToBool or not.  

| Param | Type | Description |
| --- | --- | --- |
| value | <code>Any</code> | <p>The value to be checked as boolean.</p> |

<!-- tabs:end -->

## GetFontCharRange  :id=kengine-utils-data-getfontcharrange

`Kengine.Utils.Data.GetFontCharRange(strs)` ⇒ <code>Array.&lt;Real&gt;</code>
<!-- tabs:start -->


##### **Description**

Return array of min, max for the characters in the provided string. Useful for creating fonts.


**Returns**: <code>Array.&lt;Real&gt;</code> - [min, max]  

| Param | Type | Description |
| --- | --- | --- |
| strs | <code>String</code> | <p>A string that contains characters to be used for the range.</p> |

<!-- tabs:end -->

