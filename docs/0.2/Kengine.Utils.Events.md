# Events  :id=kengine-utils-events

[Kengine.Utils.Events](Kengine.Utils.Events) <code>object</code>
<!-- tabs:start -->


##### **Description**

A struct containing Kengine events utilitiy functions


<!-- tabs:end -->

## Define  :id=kengine-utils-events-define

`Kengine.Utils.Events.Define(event, [listeners])`
<!-- tabs:start -->


##### **Description**

Defines an event.



| Param | Type | Description |
| --- | --- | --- |
| event | <code>String</code> | <p>The event name.</p> |
| [listeners] | <code>Array.&lt;function()&gt;</code> | <p>The event listener functions</p> |

<!-- tabs:end -->

## AddListener  :id=kengine-utils-events-addlistener

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

## RemoveListener  :id=kengine-utils-events-removelistener

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

## Fire  :id=kengine-utils-events-fire

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

