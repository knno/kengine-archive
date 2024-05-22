# Utils  :id=kengine-utils

Kengine.Utils <code>object</code>
<!-- tabs:start -->


##### **Description**

Kengine Utils library.


<!-- tabs:end -->

## Arrays  :id=kengine-utils-arrays

[Kengine.Utils.Arrays](Kengine.Utils.Arrays) <code>object</code>
<!-- tabs:start -->


##### **Description**

A struct containing Kengine arrays utilitiy functions


<!-- tabs:end -->

### DeleteValue  :id=kengine-utils-arrays-deletevalue

`Kengine.Utils.Arrays.DeleteValue(array, value, _all)` ⇒ <code>Real</code>
<!-- tabs:start -->


##### **Description**

Deletes value from an array.


**Returns**: <code>Real</code> - Count of deleted indices.  

| Param | Type | Description |
| --- | --- | --- |
| array | <code>Array.&lt;Any&gt;</code> |  |
| value | <code>Any</code> |  |
| _all | <code>Bool</code> | <p>Whether to delete all occurences</p> |

<!-- tabs:end -->

### MinMax  :id=kengine-utils-arrays-minmax

`Kengine.Utils.Arrays.MinMax(arr)` ⇒ <code>Array.&lt;Any&gt;</code>
<!-- tabs:start -->


##### **Description**

Returns the minimum and maximum numbers in an array


**Returns**: <code>Array.&lt;Any&gt;</code> - An array containing the minimum and maximum numbers  

| Param | Type | Description |
| --- | --- | --- |
| arr | <code>Array</code> | <p>The input array</p> |

<!-- tabs:end -->

### Concat  :id=kengine-utils-arrays-concat

`Kengine.Utils.Arrays.Concat(arrays)` ⇒ <code>Array.&lt;Any&gt;</code>
<!-- tabs:start -->


##### **Description**

Returns arrays' values as a single array.



| Param | Type |
| --- | --- |
| arrays | <code>Array.&lt;Array.&lt;Any&gt;&gt;</code> | 

<!-- tabs:end -->

## Ascii  :id=kengine-utils-ascii

[Kengine.Utils.Ascii](Kengine.Utils.Ascii) <code>object</code>
<!-- tabs:start -->


##### **Description**

A struct containing Kengine ascii utilitiy functions


<!-- tabs:end -->

## Assets  :id=kengine-utils-assets

[Kengine.Utils.Assets](Kengine.Utils.Assets) <code>object</code>
<!-- tabs:start -->


##### **Description**

A struct containing Kengine asset utilitiy functions


<!-- tabs:end -->

## Benchmark  :id=kengine-utils-benchmark

[Kengine.Utils.Benchmark](Kengine.Utils.Benchmark) <code>object</code>
<!-- tabs:start -->


##### **Description**

A struct containing Kengine benchmark utilitiy functions


<!-- tabs:end -->

## Cmps  :id=kengine-utils-cmps

[Kengine.Utils.Cmps](Kengine.Utils.Cmps) <code>object</code>
<!-- tabs:start -->


##### **Description**

A struct containing Kengine comparing functions.


<!-- tabs:end -->

## Coroutine  :id=kengine-utils-coroutine

[Kengine.Utils.Coroutine](Kengine.Utils.Coroutine) <code>object</code>
<!-- tabs:start -->


##### **Description**

A struct containing Kengine coroutine utilitiy functions


<!-- tabs:end -->

## Data  :id=kengine-utils-data

[Kengine.Utils.Data](Kengine.Utils.Data) <code>object</code>
<!-- tabs:start -->


##### **Description**

A struct containing Kengine data utilitiy functions


<!-- tabs:end -->

### ValuesMap  :id=kengine-utils-data-valuesmap

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

### ToBoolean  :id=kengine-utils-data-toboolean

`Kengine.Utils.Data.ToBoolean(value)` ⇒ <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Convert a value to a boolean. such as &quot;ON&quot;, 1, 0, or &quot;false&quot;


**Returns**: <code>Bool</code> - Boolean equivalent of the value.  

| Param | Type | Description |
| --- | --- | --- |
| value | <code>Any</code> | <p>The value to be converted.</p> |

<!-- tabs:end -->

### IniReadBool  :id=kengine-utils-data-inireadbool

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

### IsBoolable  :id=kengine-utils-data-isboolable

`Kengine.Utils.Data.IsBoolable(value)` ⇒ <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Return whether a value can be a boolean. such as &quot;ON&quot;, 1, or &quot;true&quot;.


**Returns**: <code>Bool</code> - Whether it accepts ToBool or not.  

| Param | Type | Description |
| --- | --- | --- |
| value | <code>Any</code> | <p>The value to be checked as boolean.</p> |

<!-- tabs:end -->

### GetFontCharRange  :id=kengine-utils-data-getfontcharrange

`Kengine.Utils.Data.GetFontCharRange(strs)` ⇒ <code>Array.&lt;Real&gt;</code>
<!-- tabs:start -->


##### **Description**

Return array of min, max for the characters in the provided string. Useful for creating fonts.


**Returns**: <code>Array.&lt;Real&gt;</code> - [min, max]  

| Param | Type | Description |
| --- | --- | --- |
| strs | <code>String</code> | <p>A string that contains characters to be used for the range.</p> |

<!-- tabs:end -->

## Easing  :id=kengine-utils-easing

[Kengine.Utils.Easing](Kengine.Utils.Easing) <code>object</code>
<!-- tabs:start -->


##### **Description**

A struct containing Kengine easing utilitiy functions


<!-- tabs:end -->

### EaseIn  :id=kengine-utils-easing-easein

`Kengine.Utils.Easing.EaseIn(value, start, change, duration)` ⇒ <code>Real</code>
<!-- tabs:start -->


##### **Description**

Takes a value and applies ease-in transition on, starting from <code>_start</code> and ending after <code>_duration</code> with added <code>_change</code>.


**Returns**: <code>Real</code> - Converted real value to ease-in  
**See**

- Kengine.Utils.Easing.ease_out
- Kengine.Utils.Easing.ease_inout


| Param | Type | Description |
| --- | --- | --- |
| value | <code>Real</code> | <p>The value to be applied.</p> |
| start | <code>Real</code> | <p>The start value.</p> |
| change | <code>Real</code> | <p>The end or change of the value.</p> |
| duration | <code>Real</code> | <p>The duration in steps.</p> |


##### **Example**

```gml
// Step event_x2 = Kengine.Utils.Easing.EaseIn(_x1, 0, 2, 60); // _x2 is from 0 to 2 in 60 steps eased-in.
```
<!-- tabs:end -->

### EaseInOut  :id=kengine-utils-easing-easeinout

`Kengine.Utils.Easing.EaseInOut(value, start, change, duration)` ⇒ <code>Real</code>
<!-- tabs:start -->


##### **Description**

Takes a value and applies ease-in-out transition on, starting from <code>_start</code> and ending after <code>_duration</code> with added <code>_change</code>.


**Returns**: <code>Real</code> - Converted real value to ease-in-out  
**See**

- Kengine.Utils.Easing.ease_in
- Kengine.Utils.Easing.ease_out


| Param | Type | Description |
| --- | --- | --- |
| value | <code>Real</code> | <p>The value to be applied.</p> |
| start | <code>Real</code> | <p>The start value.</p> |
| change | <code>Real</code> | <p>The end or change of the value.</p> |
| duration | <code>Real</code> | <p>The duration in steps.</p> |


##### **Example**

```gml
// Step event_x2 = Kengine.Utils.Easing.EaseInOut(_x1, 0, 2, 60); // _x2 is from 0 to 2 in 60 steps eased-in-out.
```
<!-- tabs:end -->

### EaseOut  :id=kengine-utils-easing-easeout

`Kengine.Utils.Easing.EaseOut(value, start, change, duration)` ⇒ <code>Real</code>
<!-- tabs:start -->


##### **Description**

Takes a value and applies ease-out transition on, starting from <code>_start</code> and ending after <code>_duration</code> with added <code>_change</code>.


**Returns**: <code>Real</code> - Converted real value to ease-out  
**See**

- Kengine.Utils.Easing.ease_in
- Kengine.Utils.Easing.ease_inout


| Param | Type | Description |
| --- | --- | --- |
| value | <code>Real</code> | <p>The value to be applied.</p> |
| start | <code>Real</code> | <p>The start value.</p> |
| change | <code>Real</code> | <p>The end or change of the value.</p> |
| duration | <code>Real</code> | <p>The duration in steps.</p> |


##### **Example**

```gml
// Step event_x2 = Kengine.Utils.Easing.EaseOut(_x1, 0, 2, 60); // _x2 is from 0 to 2 in 60 steps eased-out.
```
<!-- tabs:end -->

## Errors  :id=kengine-utils-errors

[Kengine.Utils.Errors](Kengine.Utils.Errors) <code>object</code>
<!-- tabs:start -->


##### **Description**

A struct containing Kengine errors utilitiy functions


<!-- tabs:end -->

### Types  :id=kengine-utils-errors-types

[Kengine.Utils.Errors.Types](Kengine.Utils.Errors?id=kengine.utils.errors.types) <code>Struct</code>
<!-- tabs:start -->


##### **Description**

Preset error types. These errors are extendable through Kengine extensions.


<!-- tabs:end -->

### Create  :id=kengine-utils-errors-create

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

### Define  :id=kengine-utils-errors-define

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

## Events  :id=kengine-utils-events

[Kengine.Utils.Events](Kengine.Utils.Events) <code>object</code>
<!-- tabs:start -->


##### **Description**

A struct containing Kengine events utilitiy functions


<!-- tabs:end -->

### Define  :id=kengine-utils-events-define

`Kengine.Utils.Events.Define(event, [listeners])`
<!-- tabs:start -->


##### **Description**

Defines an event.



| Param | Type | Description |
| --- | --- | --- |
| event | <code>String</code> | <p>The event name.</p> |
| [listeners] | <code>Array.&lt;function()&gt;</code> | <p>The event listener functions</p> |

<!-- tabs:end -->

### AddListener  :id=kengine-utils-events-addlistener

`Kengine.Utils.Events.AddListener(event, listener)` ⇒ <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Adds an event listener (function) or more to the events.


**Returns**: <code>Bool</code> - Whether added successfuly (if the event is defined) or not.  

| Param | Type | Description |
| --- | --- | --- |
| event | <code>String</code> | <p>The event name.</p> |
| listener | <code>function</code> \| <code>Array.&lt;function()&gt;</code> | <p>The event listener function(s)</p> |

<!-- tabs:end -->

### RemoveListener  :id=kengine-utils-events-removelistener

`Kengine.Utils.Events.RemoveListener(event, listener, [_all])` ⇒ <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Removes an event listener (function) or more from the events.


**Returns**: <code>Bool</code> - Whether removed successfuly (if the event is defined) or not.  

| Param | Type | Default | Description |
| --- | --- | --- | --- |
| event | <code>String</code> |  | <p>The event name.</p> |
| listener | <code>function</code> \| <code>Array.&lt;function()&gt;</code> |  | <p>The event listener function(s)</p> |
| [_all] | <code>Bool</code> | <code>true</code> | <p>Whether to remove all occurences of the function. Defaults to <code>true</code>.</p> |

<!-- tabs:end -->

### Fire  :id=kengine-utils-events-fire

`Kengine.Utils.Events.Fire(event, args)` ⇒ <code>Bool</code> \| <code>Undefined</code>
<!-- tabs:start -->


##### **Description**

Fires an event with arguments.


**Returns**: <code>Bool</code> \| <code>Undefined</code> - Whether the event is registered.  

| Param | Type | Description |
| --- | --- | --- |
| event | <code>String</code> | <p>The event name.</p> |
| args | <code>Any</code> | <p>The event arguments</p> |

<!-- tabs:end -->

## Extensions  :id=kengine-utils-extensions

[Kengine.Utils.Extensions](Kengine.Utils.Extensions) <code>object</code>
<!-- tabs:start -->


##### **Description**

A struct containing Kengine extensions utilitiy functions


<!-- tabs:end -->

## Hashkeys  :id=kengine-utils-hashkeys

[Kengine.Utils.Hashkeys](Kengine.Utils.Hashkeys) <code>object</code>
<!-- tabs:start -->


##### **Description**

A struct containing Kengine hashkeys utilitiy functions


<!-- tabs:end -->

### Add  :id=kengine-utils-hashkeys-add

`Kengine.Utils.Hashkeys.Add(name)` ⇒ <code>Struct</code>
<!-- tabs:start -->


##### **Description**

Adds a hash to _hashkeys.


**Returns**: <code>Struct</code> - The key struct which contains name and hash attrs.  

| Param | Type | Description |
| --- | --- | --- |
| name | <code>String</code> | <p>The name.</p> |

<!-- tabs:end -->

### Hash  :id=kengine-utils-hashkeys-hash

`Kengine.Utils.Hashkeys.Hash(name)` ⇒ <code>Any</code>
<!-- tabs:start -->


##### **Description**

Converts hashkey or string or hash to just hash.


**Returns**: <code>Any</code> - The hash to use.  

| Param | Type | Description |
| --- | --- | --- |
| name | <code>Struct</code> \| <code>String</code> \| <code>Real</code> | <p>The name as a string, real or hash key.</p> |

<!-- tabs:end -->

## Input  :id=kengine-utils-input

[Kengine.Utils.Input](Kengine.Utils.Input) <code>object</code>
<!-- tabs:start -->


##### **Description**

A struct containing Kengine input utilitiy functions


<!-- tabs:end -->

### keyboard_check_released  :id=kengine-utils-input-keyboard_check_released

`Kengine.Utils.Input.keyboard_check_released(key)` ⇒ <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Returns whether key is released.



| Param | Type |
| --- | --- |
| key | <code>Struct</code> \| <code>Real</code> | 

<!-- tabs:end -->

### keyboard_check  :id=kengine-utils-input-keyboard_check

`Kengine.Utils.Input.keyboard_check(key)` ⇒ <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Returns whether key is being held down.



| Param | Type |
| --- | --- |
| key | <code>Struct</code> \| <code>Real</code> | 

<!-- tabs:end -->

### keyboard_check_pressed  :id=kengine-utils-input-keyboard_check_pressed

`Kengine.Utils.Input.keyboard_check_pressed(key)` ⇒ <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Returns whether key is pressed.



| Param | Type |
| --- | --- |
| key | <code>Struct</code> \| <code>Real</code> | 

<!-- tabs:end -->

### keyboard_clear  :id=kengine-utils-input-keyboard_clear

`Kengine.Utils.Input.keyboard_clear(key)` ⇒ <code>Bool</code> \| <code>Undefined</code>
<!-- tabs:start -->


##### **Description**

Clears keyboard key state.



| Param | Type |
| --- | --- |
| key | <code>Struct</code> \| <code>Real</code> | 

<!-- tabs:end -->

## Instance  :id=kengine-utils-instance

[Kengine.Utils.Instance](Kengine.Utils.Instance) <code>object</code>
<!-- tabs:start -->


##### **Description**

Kengine Instance Utils.


<!-- tabs:end -->

### Exists  :id=kengine-utils-instance-exists

`Kengine.Utils.Instance.Exists(value)` ⇒ <code>Bool</code>
<!-- tabs:start -->



| Param | Type |
| --- | --- |
| value | <code>Kengine.Instance</code> \| <code>Kengine.Asset</code> \| <code>Id.Instance</code> \| <code>Asset.GMObject</code> | 

<!-- tabs:end -->

### IsAncestor  :id=kengine-utils-instance-isancestor

`Kengine.Utils.Instance.IsAncestor(obj, parent)` ⇒ <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Checks whether object-type Asset is ancestor of another object-type Asset.



| Param | Type | Description |
| --- | --- | --- |
| obj | <code>Kengine.Asset</code> | <p>The object</p> |
| parent | <code>Kengine.Asset</code> | <p>The parent</p> |

<!-- tabs:end -->

### CreateLayer  :id=kengine-utils-instance-createlayer

`Kengine.Utils.Instance.CreateLayer(x, y, [layer], [asset], [var_struct])` ⇒ <code>Kengine.Instance</code>
<!-- tabs:start -->


##### **Description**

Creates an <code>Instance</code> and adds it to the [instances](Kengine?id=kengine.instances) collection, creating a real instance in the room.


**Returns**: <code>Kengine.Instance</code> - The <code>Instance</code>.  

| Param | Type | Description |
| --- | --- | --- |
| x | <code>Real</code> | <p>The X position of the instance.</p> |
| y | <code>Real</code> | <p>The Y position of the instance.</p> |
| [layer] | <code>String</code> | <p>The layer to create the instance at.</p> |
| [asset] | <code>Kengine.Asset</code> \| <code>Asset.GMObject</code> \| <code>String</code> \| <code>Real</code> | <p>The [Kengine.Asset](Kengine?id=kengine.asset) or object index to use. Defaults to <code>[KENGINE_WRAPPED_OBJECT](KENGINE_WRAPPED_OBJECT)</code>.</p> |
| [var_struct] | <code>Struct</code> | <p>An initial struct of variables to set for the real instance.</p> |

<!-- tabs:end -->

### CreateDepth  :id=kengine-utils-instance-createdepth

`Kengine.Utils.Instance.CreateDepth(x, y, [depth], [asset], [var_struct])` ⇒ <code>Kengine.Instance</code>
<!-- tabs:start -->


##### **Description**

Creates an <code>Instance</code> and adds it to the [instances](Kengine?id=kengine.instances) collection, creating a real instance in the room.


**Returns**: <code>Kengine.Instance</code> - The <code>Instance</code>.  

| Param | Type | Default | Description |
| --- | --- | --- | --- |
| x | <code>Real</code> |  | <p>The X position of the instance.</p> |
| y | <code>Real</code> |  | <p>The Y position of the instance.</p> |
| [depth] | <code>Real</code> | <code>0</code> | <p>The depth to create the instance at.</p> |
| [asset] | <code>Kengine.Asset</code> \| <code>Asset.GMObject</code> \| <code>String</code> \| <code>Real</code> |  | <p>The [Kengine.Asset](Kengine?id=kengine.asset) or object index to use. Defaults to <code>[KENGINE_WRAPPED_OBJECT](KENGINE_WRAPPED_OBJECT)</code>.</p> |
| [var_struct] | <code>Struct</code> |  | <p>An initial struct of variables to set for the real instance.</p> |

<!-- tabs:end -->

### With  :id=kengine-utils-instance-with

`Kengine.Utils.Instance.With(expr_or_cmp, func)`
<!-- tabs:start -->


##### **Description**

A replacement for with statement. Calls the func with all instances in the expr_or_cmp. You can provide a function to filter instances from the collection.



| Param | Type | Description |
| --- | --- | --- |
| expr_or_cmp | <code>Any</code> | <p>The instances wanted. Or a filter function that returns true if you want the instance to get func called on. This can be any of the following:</p> <ul> <li>Function</li> <li>Id.Instance</li> <li>Kengine.Instance</li> <li>Kengine.Collection</li> <li>Array&lt;Kengine.Instance&gt;</li> <li>Kengine.Asset</li> </ul> |
| func | <code>function</code> | <p>The function to call. Takes an argument 'inst' which is the Kengine's Instance.</p> |

<!-- tabs:end -->

## Parser  :id=kengine-utils-parser

[Kengine.Utils.Parser](Kengine.Utils.Parser) <code>object</code>
<!-- tabs:start -->


##### **Description**

A struct containing Kengine parser utilitiy functions


<!-- tabs:end -->

### InterpretAsset  :id=kengine-utils-parser-interpretasset

`Kengine.Utils.Parser.InterpretAsset(asset, this, [dict], [args])` ⇒ <code>Any</code>
<!-- tabs:start -->


##### **Description**

Interprets a script asset.



| Param | Type | Description |
| --- | --- | --- |
| asset | <code>String</code> \| <code>Kengine.Asset</code> | <p>Asset or name of the asset.</p> |
| this | <code>Any</code> | <p><code>this</code> arg in the asset runtime script.</p> |
| [dict] | <code>Struct</code> | <p>An extra context in the asset runtime script.</p> |
| [args] | <code>Array.&lt;Any&gt;</code> | <p><code>arguments</code> in the asset runtime script.</p> |

<!-- tabs:end -->

## Strings  :id=kengine-utils-strings

[Kengine.Utils.Strings](Kengine.Utils.Strings) <code>object</code>
<!-- tabs:start -->


##### **Description**

A struct containing Kengine strings utilitiy functions


<!-- tabs:end -->

### PosDirection  :id=kengine-utils-strings-posdirection

`Kengine.Utils.Strings.PosDirection(text, sep, [dir], [pos])` ⇒ <code>Real</code>
<!-- tabs:start -->


##### **Description**

Find position of the next string that is after sep, starting from pos, in direction dir.


**Returns**: <code>Real</code> - The position of the first occurence of a word.  

| Param | Type | Default | Description |
| --- | --- | --- | --- |
| text | <code>String</code> |  | <p>The main text.</p> |
| sep | <code>String</code> |  | <p>The separation of text words.</p> |
| [dir] | <code>Real</code> | <code>1</code> | <p>The direction to look.</p> |
| [pos] | <code>Real</code> | <code>0</code> | <p>The position to start.</p> |

<!-- tabs:end -->

## Structs  :id=kengine-utils-structs

[Kengine.Utils.Structs](Kengine.Utils.Structs) <code>object</code>
<!-- tabs:start -->


##### **Description**

A struct containing Kengine structs utilitiy functions


<!-- tabs:end -->

### Exists  :id=kengine-utils-structs-exists

`Kengine.Utils.Structs.Exists(_struct, name)` ⇒ <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Checks whether a struct member exists.


**Returns**: <code>Bool</code> - Whether the struct member exists.  

| Param | Type | Description |
| --- | --- | --- |
| _struct | <code>Struct</code> | <p>The struct.</p> |
| name | <code>String</code> \| <code>Struct</code> | <p>The name or hash key.</p> |

<!-- tabs:end -->

### Get  :id=kengine-utils-structs-get

`Kengine.Utils.Structs.Get(_struct, name)` ⇒ <code>Any</code>
<!-- tabs:start -->


##### **Description**

Gets a struct member.


**Returns**: <code>Any</code> - The value.  

| Param | Type | Description |
| --- | --- | --- |
| _struct | <code>Struct</code> \| <code>Id.Instance</code> \| <code>Constant.All</code> \| <code>Any</code> | <p>The struct to get from.</p> |
| name | <code>String</code> \| <code>Real</code> \| <code>Struct</code> | <p>The hash key to use. If it's a struct, uses its &quot;hash&quot; member value.</p> |

<!-- tabs:end -->

### SetDefault  :id=kengine-utils-structs-setdefault

`Kengine.Utils.Structs.SetDefault(_struct, name, value)` ⇒ <code>Any</code>
<!-- tabs:start -->


##### **Description**

Sets a struct member with a default value if it's undefined, otherwise it keeps the value.


**Returns**: <code>Any</code> - The new value. Or the default value.  

| Param | Type | Description |
| --- | --- | --- |
| _struct | <code>Struct</code> | <p>The struct.</p> |
| name | <code>String</code> \| <code>Struct</code> | <p>The name or hash key.</p> |
| value | <code>Any</code> | <p>The value.</p> |

<!-- tabs:end -->

### Set  :id=kengine-utils-structs-set

`Kengine.Utils.Structs.Set(_struct, name, value)` ⇒ <code>Any</code>
<!-- tabs:start -->


##### **Description**

Sets a struct member.



| Param | Type | Description |
| --- | --- | --- |
| _struct | <code>Struct</code> | <p>The struct.</p> |
| name | <code>String</code> \| <code>Struct</code> | <p>The name or hash key.</p> |
| value | <code>Any</code> | <p>The value</p> |

<!-- tabs:end -->

### Merge  :id=kengine-utils-structs-merge

`Kengine.Utils.Structs.Merge(struct1, struct2, merge_arrays)` ⇒ <code>Struct</code>
<!-- tabs:start -->


##### **Description**

Merges struct2 to struct1 recursively.


**Returns**: <code>Struct</code> - The first struct after being merged.  

| Param | Type | Description |
| --- | --- | --- |
| struct1 | <code>Struct</code> | <p>The main struct.</p> |
| struct2 | <code>Struct</code> | <p>The secondary struct.</p> |
| merge_arrays | <code>Bool</code> | <p>Whether to merge arrays.</p> |

<!-- tabs:end -->

### FilterOutPrefixed  :id=kengine-utils-structs-filteroutprefixed

`Kengine.Utils.Structs.FilterOutPrefixed(struct, prefix)` ⇒ <code>Struct</code>
<!-- tabs:start -->


##### **Description**

Filters out struct members that begin with a prefix



| Param | Type | Description |
| --- | --- | --- |
| struct | <code>Struct</code> | <p>The struct.</p> |
| prefix | <code>String</code> | <p>The prefix.</p> |

<!-- tabs:end -->

### DotSet  :id=kengine-utils-structs-dotset

`Kengine.Utils.Structs.DotSet(_struct, key, val)` ⇒ <code>Any</code>
<!-- tabs:start -->


##### **Description**

Sets a struct member using dot notation.



| Param | Type | Description |
| --- | --- | --- |
| _struct | <code>Struct</code> | <p>The struct.</p> |
| key | <code>String</code> | <p>The dot notation of key.</p> |
| val | <code>Any</code> | <p>The value.</p> |

<!-- tabs:end -->

### DotGet  :id=kengine-utils-structs-dotget

`Kengine.Utils.Structs.DotGet(_struct, key, [default_val])` ⇒ <code>Any</code>
<!-- tabs:start -->


##### **Description**

Gets a struct member using dot notation.



| Param | Type | Description |
| --- | --- | --- |
| _struct | <code>Struct</code> | <p>The struct.</p> |
| key | <code>String</code> | <p>The dot notation of key.</p> |
| [default_val] | <code>Any</code> | <p>The default value to return.</p> |

<!-- tabs:end -->

### IsPublic  :id=kengine-utils-structs-ispublic

`Kengine.Utils.Structs.IsPublic(_object, [member_name], [default_val])` ⇒ <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Returns whether <code>object</code> or its member is public or not. By reading the struct's <code>__opts.public</code>.



| Param | Type | Description |
| --- | --- | --- |
| _object | <code>Any</code> |  |
| [member_name] | <code>String</code> | <p>The member if you want to get its access publicity.</p> |
| [default_val] | <code>Any</code> |  |

<!-- tabs:end -->

### IsPrivate  :id=kengine-utils-structs-isprivate

`Kengine.Utils.Structs.IsPrivate(_object, [member_name], [default_val])` ⇒ <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Returns whether <code>object</code> or its member is private or not. (<code>.__opts.private</code>)


**Returns**: <code>Bool</code> - Whether it is private or not.  

| Param | Type | Description |
| --- | --- | --- |
| _object | <code>Any</code> |  |
| [member_name] | <code>String</code> \| <code>Undefined</code> | <p>The member if you want to get its access privacy.</p> |
| [default_val] | <code>Bool</code> |  |

<!-- tabs:end -->

### SetPrivate  :id=kengine-utils-structs-setprivate

`Kengine.Utils.Structs.SetPrivate(_object, [member_name], [private])`
<!-- tabs:start -->


##### **Description**

Sets <code>object</code> or its member is private or not. (<code>.__opts.private</code>)



| Param | Type | Default | Description |
| --- | --- | --- | --- |
| _object | <code>Any</code> |  |  |
| [member_name] | <code>String</code> \| <code>Undefined</code> |  | <p>The member if you want to set its access privacy.</p> |
| [private] | <code>Bool</code> | <code>true</code> | <p>Whether it is private or not.</p> |

<!-- tabs:end -->

### IsReadonly  :id=kengine-utils-structs-isreadonly

`Kengine.Utils.Structs.IsReadonly(_object, [member_name], [default_val])` ⇒ <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Returns whether <code>object</code> or its member is readonly or not. (<code>.__opts.readonly</code>)


**Returns**: <code>Bool</code> - Whether it is private or not.  

| Param | Type | Default | Description |
| --- | --- | --- | --- |
| _object | <code>Any</code> |  |  |
| [member_name] | <code>String</code> \| <code>Undefined</code> |  | <p>The member if you want to get its access readonliness.</p> |
| [default_val] | <code>Bool</code> | <code>false</code> |  |

<!-- tabs:end -->

## Tiles  :id=kengine-utils-tiles

[Kengine.Utils.Tiles](Kengine.Utils.Tiles) <code>object</code>
<!-- tabs:start -->


##### **Description**

A struct containing Kengine tiles, tilesets and tilemaps utilitiy functions


<!-- tabs:end -->

### vertex_format  :id=kengine-utils-tiles-vertex_format

[Kengine.Utils.Tiles.vertex_format](Kengine.Utils.Tiles?id=kengine.utils.tiles.vertex_format) <code>Id.VertexFormat</code>
<!-- tabs:start -->


##### **Description**

The vertex format for Kengine tileset system.


<!-- tabs:end -->

### GetMaskValue  :id=kengine-utils-tiles-getmaskvalue

`Kengine.Utils.Tiles.GetMaskValue(tileset_asset)`
<!-- tabs:start -->


##### **Description**

Returns the mask value for a tileset asset.



| Param | Type |
| --- | --- |
| tileset_asset | <code>Kengine.Tilemap</code> \| <code>Kengine.Asset</code> | 

<!-- tabs:end -->

### SetupTilemapSolidMask  :id=kengine-utils-tiles-setuptilemapsolidmask

`Kengine.Utils.Tiles.SetupTilemapSolidMask(tilemap)` ⇒ <code>Real</code>
<!-- tabs:start -->


##### **Description**

Sets up a bit value and return the offset in the mask for a tilemap.



| Param | Type | Description |
| --- | --- | --- |
| tilemap | <code>Kengine.Tilemap</code> | <p>The tilemap</p> |

<!-- tabs:end -->

## GetAsset  :id=kengine-utils-getasset

`Kengine.Utils.GetAsset(asset_type, id_or_name)` ⇒ <code>Kengine.Asset</code> \| <code>Undefined</code>
<!-- tabs:start -->


##### **Description**

Retrieves a [Kengine.Asset](Kengine?id=kengine.asset) from <code>asset_type</code> (if loaded).


**Returns**: <code>Kengine.Asset</code> \| <code>Undefined</code> - An asset, or <code>undefined</code>.  

| Param | Type | Description |
| --- | --- | --- |
| asset_type | <code>Kengine.AssetType</code> \| <code>String</code> | <p>The type of the asset to retrieve.</p> |
| id_or_name | <code>Real</code> \| <code>String</code> | <p>The real ID or name of the asset.</p> |

<!-- tabs:end -->

## Execute  :id=kengine-utils-execute

`Kengine.Utils.Execute(script_or_method, [args])` ⇒ <code>Any</code>
<!-- tabs:start -->


##### **Description**

A replacement for <code>execute_script</code>. Executes the script or method or a script-type asset.


**Returns**: <code>Any</code> - The return of the script.  

| Param | Type | Description |
| --- | --- | --- |
| script_or_method | <code>function</code> \| <code>Kengine.Asset</code> | <p>The script or method to execute.</p> |
| [args] | <code>Array.&lt;Any&gt;</code> | <p>arguments to use in an array.</p> |

<!-- tabs:end -->

