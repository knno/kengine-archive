<!-- a name="Kengine.Utils"></a -->

# Utils  :id=kengine-utils

Kengine.Utils <code>object</code>
Kengine Utils library.


<!-- a name="Kengine.Utils.Arrays"></a -->

## Arrays  :id=kengine-utils-arrays

[Kengine.Utils.Arrays](Kengine.Utils.Arrays) <code>object</code>
A struct containing Kengine arrays utilitiy functions


<!-- a name="Kengine.Utils.Arrays.DeleteValue"></a -->

### DeleteValue  :id=kengine-utils-arrays-deletevalue

`Kengine.Utils.Arrays.DeleteValue(array, value, _all)` ⇒ <code>Real</code>
<!-- tabs:start -->


##### **Description**

Delete value from an array.


**Returns**: <code>Real</code> - Count of deleted indices.  

| Param | Type |
| --- | --- |
| array | <code>Array.&lt;Any&gt;</code> | 
| value | <code>Any</code> | 
| _all | <code>Bool</code> | 

<!-- tabs:end -->

<!-- a name="Kengine.Utils.Arrays.MinMax"></a -->

### MinMax  :id=kengine-utils-arrays-minmax

`Kengine.Utils.Arrays.MinMax(arr)` ⇒ <code>Array.&lt;Any&gt;</code>
<!-- tabs:start -->


##### **Description**

Return the minimum and maximum numbers in an array


**Returns**: <code>Array.&lt;Any&gt;</code> - An array containing the minimum and maximum numbers  

| Param | Type | Description |
| --- | --- | --- |
| arr | <code>Array</code> | <p>The input array</p> |

<!-- tabs:end -->

<!-- a name="Kengine.Utils.Arrays.Concat"></a -->

### Concat  :id=kengine-utils-arrays-concat

`Kengine.Utils.Arrays.Concat(arrays)` ⇒ <code>Array.&lt;Any&gt;</code>
<!-- tabs:start -->


##### **Description**

Return arrays' values as a single array.



| Param | Type |
| --- | --- |
| arrays | <code>Array.&lt;Array.&lt;Any&gt;&gt;</code> | 

<!-- tabs:end -->

<!-- a name="Kengine.Utils.Ascii"></a -->

## Ascii  :id=kengine-utils-ascii

[Kengine.Utils.Ascii](Kengine.Utils.Ascii) <code>object</code>
A struct containing Kengine ascii utilitiy functions


<!-- a name="Kengine.Utils.Benchmark"></a -->

## Benchmark  :id=kengine-utils-benchmark

[Kengine.Utils.Benchmark](Kengine.Utils.Benchmark) <code>object</code>
A struct containing Kengine benchmark utilitiy functions


<!-- a name="Kengine.Utils.Cmps"></a -->

## Cmps  :id=kengine-utils-cmps

[Kengine.Utils.Cmps](Kengine.Utils.Cmps) <code>object</code>
A struct containing Kengine comparing functions.


<!-- a name="Kengine.Utils.Coroutine"></a -->

## Coroutine  :id=kengine-utils-coroutine

[Kengine.Utils.Coroutine](Kengine.Utils.Coroutine) <code>object</code>
A struct containing Kengine coroutine utilitiy functions


<!-- a name="Kengine.Utils.Data"></a -->

## Data  :id=kengine-utils-data

[Kengine.Utils.Data](Kengine.Utils.Data) <code>object</code>
A struct containing Kengine data utilitiy functions


<!-- a name="Kengine.Utils.Data.ValuesMap"></a -->

### ValuesMap  :id=kengine-utils-data-valuesmap

`Kengine.Utils.Data.ValuesMap(struct_or_array, func, [par])`
<!-- tabs:start -->


##### **Description**

Visit a struct's or array's values (that are not structs or arrays) and do a function with the values.
The returned value from the func is the new value. It accepts argument <code>val</code>.</p>
<p>Note - Disabling copy on write behavior for arrays is required.



| Param | Type | Description |
| --- | --- | --- |
| struct_or_array | <code>Struct</code> \| <code>Array.&lt;Any&gt;</code> |  |
| func | <code>function</code> |  |
| [par] | <code>Struct</code> \| <code>Array.&lt;Any&gt;</code> | <p>A parameter for recursive calls.</p> |

<!-- tabs:end -->

<!-- a name="Kengine.Utils.Data.ToBoolean"></a -->

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

<!-- a name="Kengine.Utils.Data.IniReadBool"></a -->

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

<!-- a name="Kengine.Utils.Data.IsBoolable"></a -->

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

<!-- a name="Kengine.Utils.Data.GetFontCharRange"></a -->

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

<!-- a name="Kengine.Utils.Easing"></a -->

## Easing  :id=kengine-utils-easing

[Kengine.Utils.Easing](Kengine.Utils.Easing) <code>object</code>
A struct containing Kengine easing utilitiy functions


<!-- a name="Kengine.Utils.Easing.ease_in"></a -->

### ease_in  :id=kengine-utils-easing-ease_in

`Kengine.Utils.Easing.ease_in(value, start, change, duration)` ⇒ <code>Real</code>
<!-- tabs:start -->


##### **Description**

Take a value and apply ease-in transition on, starting from <code>_start</code> and ending after <code>_duration</code> with added <code>_change</code>.


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
// Step event
_x2 = ease_in(_x1, 0, 2, 60); // _x2 is from 0 to 2 in 60 steps eased-in.
```
<!-- tabs:end -->

<!-- a name="Kengine.Utils.Easing.ease_inout"></a -->

### ease_inout  :id=kengine-utils-easing-ease_inout

`Kengine.Utils.Easing.ease_inout(value, start, change, duration)` ⇒ <code>Real</code>
<!-- tabs:start -->


##### **Description**

Take a value and apply ease-in-out transition on, starting from <code>_start</code> and ending after <code>_duration</code> with added <code>_change</code>.


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
// Step event
_x2 = ease_inout(_x1, 0, 2, 60); // _x2 is from 0 to 2 in 60 steps eased-in-out.
```
<!-- tabs:end -->

<!-- a name="Kengine.Utils.Easing.ease_out"></a -->

### ease_out  :id=kengine-utils-easing-ease_out

`Kengine.Utils.Easing.ease_out(value, start, change, duration)` ⇒ <code>Real</code>
<!-- tabs:start -->


##### **Description**

Take a value and apply ease-out transition on, starting from <code>_start</code> and ending after <code>_duration</code> with added <code>_change</code>.


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
// Step event
_x2 = ease_out(_x1, 0, 2, 60); // _x2 is from 0 to 2 in 60 steps eased-out.
```
<!-- tabs:end -->

<!-- a name="Kengine.Utils.Errors"></a -->

## Errors  :id=kengine-utils-errors

[Kengine.Utils.Errors](Kengine.Utils.Errors) <code>object</code>
A struct containing Kengine errors utilitiy functions


<!-- a name="Kengine.Utils.Errors.Types"></a -->

### Types  :id=kengine-utils-errors-types

[Kengine.Utils.Errors.Types](Kengine.Utils.Errors?id=kengine.utils.errors.types) <code>Struct</code>
<!-- tabs:start -->


##### **Description**

Preset error types. These errors are extendable through Kengine extensions.


<!-- tabs:end -->

<!-- a name="Kengine.Utils.Errors.Create"></a -->

### Create  :id=kengine-utils-errors-create

`Kengine.Utils.Errors.Create([error_type], [longMessage], [useLong])` ⇒ <code>Struct</code>
<!-- tabs:start -->


##### **Description**

Create an error struct that is thrown.



| Param | Type | Default | Description |
| --- | --- | --- | --- |
| [error_type] | <code>String</code> | <code>&quot;unknown&quot;</code> | <p>Error type as a string, or as a reference to an attribute of <code>Kengine.Utils.Errors.Types</code>.</p> |
| [longMessage] | <code>String</code> | <code>&quot;&quot;</code> |  |
| [useLong] | <code>Bool</code> | <code>false</code> |  |

<!-- tabs:end -->

<!-- a name="Kengine.Utils.Events"></a -->

## Events  :id=kengine-utils-events

[Kengine.Utils.Events](Kengine.Utils.Events) <code>object</code>
A struct containing Kengine events utilitiy functions


<!-- a name="Kengine.Utils.Events.__all"></a -->

### __all  :id=kengine-utils-events-__all

[Kengine.Utils.Events.__all](Kengine.Utils.Events?id=kengine.utils.events.__all) <code>Struct</code>
<!-- tabs:start -->


##### **Description**

A struct that contains Kengine events as keys and an array of functions (listeners) to call on event fire.


<!-- tabs:end -->

<!-- a name="Kengine.Utils.Events.Define"></a -->

### Define  :id=kengine-utils-events-define

`Kengine.Utils.Events.Define(event, [listeners])`
<!-- tabs:start -->


##### **Description**

Define an event.



| Param | Type | Description |
| --- | --- | --- |
| event | <code>String</code> | <p>The event name.</p> |
| [listeners] | <code>Array.&lt;function()&gt;</code> | <p>The event listener functions</p> |

<!-- tabs:end -->

<!-- a name="Kengine.Utils.Events.AddListener"></a -->

### AddListener  :id=kengine-utils-events-addlistener

`Kengine.Utils.Events.AddListener(event, listener)` ⇒ <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Add an event listener (function) or more to the events.


**Returns**: <code>Bool</code> - Whether added successfuly (if the event is defined) or not.  

| Param | Type | Description |
| --- | --- | --- |
| event | <code>String</code> | <p>The event name.</p> |
| listener | <code>function</code> \| <code>Array.&lt;function()&gt;</code> | <p>The event listener function(s)</p> |

<!-- tabs:end -->

<!-- a name="Kengine.Utils.Events.RemoveListener"></a -->

### RemoveListener  :id=kengine-utils-events-removelistener

`Kengine.Utils.Events.RemoveListener(event, listener, [_all])` ⇒ <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Remove an event listener (function) or more from the events.


**Returns**: <code>Bool</code> - Whether removed successfuly (if the event is defined) or not.  

| Param | Type | Default | Description |
| --- | --- | --- | --- |
| event | <code>String</code> |  | <p>The event name.</p> |
| listener | <code>function</code> \| <code>Array.&lt;function()&gt;</code> |  | <p>The event listener function(s)</p> |
| [_all] | <code>Bool</code> | <code>true</code> | <p>Whether to remove all occurences of the function. Defaults to <code>true</code>.</p> |

<!-- tabs:end -->

<!-- a name="Kengine.Utils.Events.Fire"></a -->

### Fire  :id=kengine-utils-events-fire

`Kengine.Utils.Events.Fire(event, args)` ⇒ <code>Bool</code> \| <code>Undefined</code>
<!-- tabs:start -->


##### **Description**

Fire an event with arguments.


**Returns**: <code>Bool</code> \| <code>Undefined</code> - Whether the event is registered.  

| Param | Type | Description |
| --- | --- | --- |
| event | <code>String</code> | <p>The event name.</p> |
| args | <code>Any</code> | <p>The event arguments</p> |

<!-- tabs:end -->

<!-- a name="Kengine.Utils.Extensions"></a -->

## Extensions  :id=kengine-utils-extensions

[Kengine.Utils.Extensions](Kengine.Utils.Extensions) <code>object</code>
A struct containing Kengine extensions utilitiy functions


<!-- a name="Kengine.Utils.Hashkeys"></a -->

## Hashkeys  :id=kengine-utils-hashkeys

[Kengine.Utils.Hashkeys](Kengine.Utils.Hashkeys) <code>object</code>
A struct containing Kengine hashkeys utilitiy functions


<!-- a name="Kengine.Utils.Hashkeys.__all"></a -->

### __all  :id=kengine-utils-hashkeys-__all

[Kengine.Utils.Hashkeys.__all](Kengine.Utils.Hashkeys?id=kengine.utils.hashkeys.__all) <code>Struct</code>
<!-- tabs:start -->


##### **Description**

A struct that contains name and hash structs for structs.


<!-- tabs:end -->

<!-- a name="Kengine.Utils.Hashkeys.add"></a -->

### add  :id=kengine-utils-hashkeys-add

`Kengine.Utils.Hashkeys.add(name)` ⇒ <code>Struct</code>
<!-- tabs:start -->


##### **Description**

Add a hash to _hashkeys.


**Returns**: <code>Struct</code> - The key struct which contains name and hash attrs.  

| Param | Type | Description |
| --- | --- | --- |
| name | <code>String</code> | <p>The name.</p> |

<!-- tabs:end -->

<!-- a name="Kengine.Utils.Hashkeys.hash"></a -->

### hash  :id=kengine-utils-hashkeys-hash

`Kengine.Utils.Hashkeys.hash(name)` ⇒ <code>Any</code>
<!-- tabs:start -->


##### **Description**

Convert hashkey or string or hash to just hash.


**Returns**: <code>Any</code> - The hash to use.  

| Param | Type | Description |
| --- | --- | --- |
| name | <code>Struct</code> \| <code>String</code> \| <code>Real</code> | <p>The name as a string, real or hash key.</p> |

<!-- tabs:end -->

<!-- a name="Kengine.Utils.Input"></a -->

## Input  :id=kengine-utils-input

[Kengine.Utils.Input](Kengine.Utils.Input) <code>object</code>
A struct containing Kengine input utilitiy functions


<!-- a name="Kengine.Utils.Input.ken_keyboard_check_released"></a -->

### ken_keyboard_check_released  :id=kengine-utils-input-ken_keyboard_check_released

`Kengine.Utils.Input.ken_keyboard_check_released(key)` ⇒ <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Return whether key is released.



| Param | Type |
| --- | --- |
| key | <code>Struct</code> \| <code>Real</code> | 

<!-- tabs:end -->

<!-- a name="Kengine.Utils.Input.keyboard_check"></a -->

### keyboard_check  :id=kengine-utils-input-keyboard_check

`Kengine.Utils.Input.keyboard_check(key)` ⇒ <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Return whether key is being held down.



| Param | Type |
| --- | --- |
| key | <code>Struct</code> \| <code>Real</code> | 

<!-- tabs:end -->

<!-- a name="Kengine.Utils.Input.keyboard_check_pressed"></a -->

### keyboard_check_pressed  :id=kengine-utils-input-keyboard_check_pressed

`Kengine.Utils.Input.keyboard_check_pressed(key)` ⇒ <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Return whether key is pressed.



| Param | Type |
| --- | --- |
| key | <code>Struct</code> \| <code>Real</code> | 

<!-- tabs:end -->

<!-- a name="Kengine.Utils.Input.keyboard_clear"></a -->

### keyboard_clear  :id=kengine-utils-input-keyboard_clear

`Kengine.Utils.Input.keyboard_clear(key)` ⇒ <code>Bool</code> \| <code>Undefined</code>
<!-- tabs:start -->


##### **Description**

Clear keyboard key state.



| Param | Type |
| --- | --- |
| key | <code>Struct</code> \| <code>Real</code> | 

<!-- tabs:end -->

<!-- a name="Kengine.Utils.Instance"></a -->

## Instance  :id=kengine-utils-instance

[Kengine.Utils.Instance](Kengine.Utils.Instance) <code>object</code>
Kengine Instance Utils.


<!-- a name="Kengine.Utils.Instance.Exists"></a -->

### Exists  :id=kengine-utils-instance-exists

`Kengine.Utils.Instance.Exists(value)` ⇒ <code>Bool</code>
<!-- tabs:start -->



| Param | Type |
| --- | --- |
| value | <code>Kengine.Instance</code> \| <code>Kengine.Asset</code> \| <code>Id.Instance</code> \| <code>Asset.GMObject</code> | 

<!-- tabs:end -->

<!-- a name="Kengine.Utils.Instance.IsAncestor"></a -->

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

<!-- a name="Kengine.Utils.Instance.CreateLayer"></a -->

### CreateLayer  :id=kengine-utils-instance-createlayer

`Kengine.Utils.Instance.CreateLayer(x, y, [layer], [asset], [var_struct])` ⇒ <code>Kengine.Instance</code>
<!-- tabs:start -->


##### **Description**

Create a Kengine <code>Instance</code> and adds it to the [instances](Kengine?id=kengine.instances) collection, creating a real instance in the room.


**Returns**: <code>Kengine.Instance</code> - The <code>Instance</code>.  

| Param | Type | Description |
| --- | --- | --- |
| x | <code>Real</code> | <p>The X position of the instance.</p> |
| y | <code>Real</code> | <p>The Y position of the instance.</p> |
| [layer] | <code>String</code> | <p>The layer to create the instance at.</p> |
| [asset] | <code>Kengine.Asset</code> \| <code>Asset.GMObject</code> \| <code>String</code> \| <code>Real</code> | <p>The [Kengine.Asset](Kengine?id=kengine.asset) or object index to use. Defaults to <code>[KENGINE_WRAPPED_OBJECT](KENGINE_WRAPPED_OBJECT)</code>.</p> |
| [var_struct] | <code>Struct</code> | <p>An initial struct of variables to set for the real instance.</p> |

<!-- tabs:end -->

<!-- a name="Kengine.Utils.Instance.CreateDepth"></a -->

### CreateDepth  :id=kengine-utils-instance-createdepth

`Kengine.Utils.Instance.CreateDepth(x, y, [depth], [asset], [var_struct])` ⇒ <code>Kengine.Instance</code>
<!-- tabs:start -->


##### **Description**

Create a Kengine <code>Instance</code> and adds it to the [instances](Kengine?id=kengine.instances) collection, creating a real instance in the room.


**Returns**: <code>Kengine.Instance</code> - The <code>Instance</code>.  

| Param | Type | Default | Description |
| --- | --- | --- | --- |
| x | <code>Real</code> |  | <p>The X position of the instance.</p> |
| y | <code>Real</code> |  | <p>The Y position of the instance.</p> |
| [depth] | <code>Real</code> | <code>0</code> | <p>The depth to create the instance at.</p> |
| [asset] | <code>Kengine.Asset</code> \| <code>Asset.GMObject</code> \| <code>String</code> \| <code>Real</code> |  | <p>The [Kengine.Asset](Kengine?id=kengine.asset) or object index to use. Defaults to <code>[KENGINE_WRAPPED_OBJECT](KENGINE_WRAPPED_OBJECT)</code>.</p> |
| [var_struct] | <code>Struct</code> |  | <p>An initial struct of variables to set for the real instance.</p> |

<!-- tabs:end -->

<!-- a name="Kengine.Utils.Instance.With"></a -->

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

<!-- a name="Kengine.Utils.Parser"></a -->

## Parser  :id=kengine-utils-parser

[Kengine.Utils.Parser](Kengine.Utils.Parser) <code>object</code>
A struct containing Kengine parser utilitiy functions


<!-- a name="Kengine.Utils.Strings"></a -->

## Strings  :id=kengine-utils-strings

[Kengine.Utils.Strings](Kengine.Utils.Strings) <code>object</code>
A struct containing Kengine strings utilitiy functions


<!-- a name="Kengine.Utils.Strings.PosDirection"></a -->

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

<!-- a name="Kengine.Utils.Structs"></a -->

## Structs  :id=kengine-utils-structs

[Kengine.Utils.Structs](Kengine.Utils.Structs) <code>object</code>
A struct containing Kengine structs utilitiy functions


<!-- a name="Kengine.Utils.Structs.Exists"></a -->

### Exists  :id=kengine-utils-structs-exists

`Kengine.Utils.Structs.Exists(_struct, name)` ⇒ <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Check whether a struct member exists.


**Returns**: <code>Bool</code> - Whether the struct member exists.  

| Param | Type | Description |
| --- | --- | --- |
| _struct | <code>Struct</code> | <p>The struct.</p> |
| name | <code>String</code> \| <code>Struct</code> | <p>The name or hash key.</p> |

<!-- tabs:end -->

<!-- a name="Kengine.Utils.Structs.Get"></a -->

### Get  :id=kengine-utils-structs-get

`Kengine.Utils.Structs.Get(_struct, name)` ⇒ <code>Any</code>
<!-- tabs:start -->


##### **Description**

Get a struct member.


**Returns**: <code>Any</code> - The value.  

| Param | Type | Description |
| --- | --- | --- |
| _struct | <code>Struct</code> \| <code>Id.Instance</code> \| <code>Constant.All</code> \| <code>Any</code> | <p>The struct to get from.</p> |
| name | <code>String</code> \| <code>Real</code> \| <code>Struct</code> | <p>The hash key to use. If it's a struct, uses &quot;hash&quot; attr.</p> |

<!-- tabs:end -->

<!-- a name="Kengine.Utils.Structs.SetDefault"></a -->

### SetDefault  :id=kengine-utils-structs-setdefault

`Kengine.Utils.Structs.SetDefault(_struct, name, value)` ⇒ <code>Any</code>
<!-- tabs:start -->


##### **Description**

Set a struct member with a default value if it's undefined, otherwise it keeps the value.


**Returns**: <code>Any</code> - The new value. Or the default value.  

| Param | Type | Description |
| --- | --- | --- |
| _struct | <code>Struct</code> | <p>The struct.</p> |
| name | <code>String</code> \| <code>Struct</code> | <p>The name or hash key.</p> |
| value | <code>Any</code> | <p>The value.</p> |

<!-- tabs:end -->

<!-- a name="Kengine.Utils.Structs.Set"></a -->

### Set  :id=kengine-utils-structs-set

`Kengine.Utils.Structs.Set(_struct, name)`
<!-- tabs:start -->


##### **Description**

Set a struct member.



| Param | Type | Description |
| --- | --- | --- |
| _struct | <code>Struct</code> | <p>The struct.</p> |
| name | <code>String</code> \| <code>Struct</code> | <p>The name or hash key.</p> |

<!-- tabs:end -->

<!-- a name="Kengine.Utils.Structs.Merge"></a -->

### Merge  :id=kengine-utils-structs-merge

`Kengine.Utils.Structs.Merge(struct1, struct2, merge_arrays)` ⇒ <code>Struct</code>
<!-- tabs:start -->


##### **Description**

Merge struct2 to struct1 recursively.


**Returns**: <code>Struct</code> - The first struct after being merged.  

| Param | Type | Description |
| --- | --- | --- |
| struct1 | <code>Struct</code> | <p>The main struct.</p> |
| struct2 | <code>Struct</code> | <p>The secondary struct.</p> |
| merge_arrays | <code>Bool</code> | <p>Whether to merge arrays.</p> |

<!-- tabs:end -->

<!-- a name="Kengine.Utils.Structs.DotSet"></a -->

### DotSet  :id=kengine-utils-structs-dotset

`Kengine.Utils.Structs.DotSet(_struct, key, val)`
<!-- tabs:start -->


##### **Description**

Set a struct member using dot notation.



| Param | Type | Description |
| --- | --- | --- |
| _struct | <code>Struct</code> | <p>The struct.</p> |
| key | <code>String</code> | <p>The dot notation of key.</p> |
| val | <code>String</code> | <p>The value.</p> |

<!-- tabs:end -->

<!-- a name="Kengine.Utils.Structs.DotGet"></a -->

### DotGet  :id=kengine-utils-structs-dotget

`Kengine.Utils.Structs.DotGet(_struct, key, [default_val])`
<!-- tabs:start -->


##### **Description**

Get a struct member using dot notation.



| Param | Type | Description |
| --- | --- | --- |
| _struct | <code>Struct</code> | <p>The struct.</p> |
| key | <code>String</code> | <p>The dot notation of key.</p> |
| [default_val] | <code>Any</code> | <p>The default value to return.</p> |

<!-- tabs:end -->

<!-- a name="Kengine.Utils.Structs.IsPublic"></a -->

### IsPublic  :id=kengine-utils-structs-ispublic

`Kengine.Utils.Structs.IsPublic(_object, [member_name], [default_val])` ⇒ <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Return whether <code>object</code> or its member is public or not. By reading the struct's <code>__opts.public</code>.



| Param | Type | Description |
| --- | --- | --- |
| _object | <code>Any</code> |  |
| [member_name] | <code>String</code> | <p>The member if you want to get its access publicity.</p> |
| [default_val] | <code>Any</code> |  |

<!-- tabs:end -->

<!-- a name="Kengine.Utils.Structs.IsPrivate"></a -->

### IsPrivate  :id=kengine-utils-structs-isprivate

`Kengine.Utils.Structs.IsPrivate(_object, [member_name], [default_val])` ⇒ <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Return whether <code>object</code> or its member is private or not. (<code>.__opts.private</code>)


**Returns**: <code>Bool</code> - Whether it is private or not.  

| Param | Type | Description |
| --- | --- | --- |
| _object | <code>Any</code> |  |
| [member_name] | <code>String</code> \| <code>Undefined</code> | <p>The member if you want to get its access privacy.</p> |
| [default_val] | <code>Bool</code> |  |

<!-- tabs:end -->

<!-- a name="Kengine.Utils.Structs.SetPrivate"></a -->

### SetPrivate  :id=kengine-utils-structs-setprivate

`Kengine.Utils.Structs.SetPrivate(_object, [member_name], [private])`
<!-- tabs:start -->


##### **Description**

Set <code>object</code> or its member is private or not. (<code>.__opts.private</code>)



| Param | Type | Default | Description |
| --- | --- | --- | --- |
| _object | <code>Any</code> |  |  |
| [member_name] | <code>String</code> \| <code>Undefined</code> |  | <p>The member if you want to set its access privacy.</p> |
| [private] | <code>Bool</code> | <code>true</code> | <p>Whether it is private or not.</p> |

<!-- tabs:end -->

<!-- a name="Kengine.Utils.Structs.IsReadonly"></a -->

### IsReadonly  :id=kengine-utils-structs-isreadonly

`Kengine.Utils.Structs.IsReadonly(_object, [member_name], [default_val])` ⇒ <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Return whether <code>object</code> or its member is readonly or not. (<code>.__opts.readonly</code>)


**Returns**: <code>Bool</code> - Whether it is private or not.  

| Param | Type | Default | Description |
| --- | --- | --- | --- |
| _object | <code>Any</code> |  |  |
| [member_name] | <code>String</code> \| <code>Undefined</code> |  | <p>The member if you want to get its access readonliness.</p> |
| [default_val] | <code>Bool</code> | <code>false</code> |  |

<!-- tabs:end -->

<!-- a name="Kengine.Utils.GetAsset"></a -->

## GetAsset  :id=kengine-utils-getasset

`Kengine.Utils.GetAsset(asset_type, id_or_name)` ⇒ <code>Kengine.Asset</code> \| <code>Undefined</code>
<!-- tabs:start -->


##### **Description**

Retrieve an [Kengine.Asset](Kengine?id=kengine.asset) from an AssetType (if loaded).


**Returns**: <code>Kengine.Asset</code> \| <code>Undefined</code> - An asset, or <code>undefined</code>.  

| Param | Type | Description |
| --- | --- | --- |
| asset_type | <code>Kengine.AssetType</code> \| <code>String</code> | <p>The type of the asset to retrieve.</p> |
| id_or_name | <code>Real</code> \| <code>String</code> | <p>The real ID or name of the asset.</p> |

<!-- tabs:end -->

<!-- a name="Kengine.Utils.Execute"></a -->

## Execute  :id=kengine-utils-execute

`Kengine.Utils.Execute(scr, [args])` ⇒ <code>Any</code>
<!-- tabs:start -->


##### **Description**

A replacement for execute_script. Executes the script or method or a script-type asset.


**Returns**: <code>Any</code> - The return of the script.  

| Param | Type | Description |
| --- | --- | --- |
| scr | <code>function</code> \| <code>Kengine.Asset</code> | <p>The script to execute.</p> |
| [args] | <code>Array.&lt;Any&gt;</code> | <p>arguments to use in an array.</p> |

<!-- tabs:end -->
