# Easing  :id=kengine-utils-easing

[Kengine.Utils.Easing](Kengine.Utils.Easing) <code>object</code>
<!-- tabs:start -->


##### **Description**

A struct containing Kengine easing utilitiy functions


<!-- tabs:end -->

## EaseIn  :id=kengine-utils-easing-easein

`Kengine.Utils.Easing.EaseIn(value, start, change, duration)` ⇒ <code>Real</code>
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
// Step event_x2 = ease_in(_x1, 0, 2, 60); // _x2 is from 0 to 2 in 60 steps eased-in.
```
<!-- tabs:end -->

## EaseInOut  :id=kengine-utils-easing-easeinout

`Kengine.Utils.Easing.EaseInOut(value, start, change, duration)` ⇒ <code>Real</code>
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
// Step event_x2 = ease_inout(_x1, 0, 2, 60); // _x2 is from 0 to 2 in 60 steps eased-in-out.
```
<!-- tabs:end -->

## EaseOut  :id=kengine-utils-easing-easeout

`Kengine.Utils.Easing.EaseOut(value, start, change, duration)` ⇒ <code>Real</code>
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
// Step event_x2 = ease_out(_x1, 0, 2, 60); // _x2 is from 0 to 2 in 60 steps eased-out.
```
<!-- tabs:end -->

