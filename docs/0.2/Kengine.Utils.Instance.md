# Instance  :id=kengine-utils-instance

[Kengine.Utils.Instance](Kengine.Utils.Instance) <code>object</code>
<!-- tabs:start -->


##### **Description**

Kengine Instance Utils.


<!-- tabs:end -->

## Exists  :id=kengine-utils-instance-exists

`Kengine.Utils.Instance.Exists(value)` ⇒ <code>Bool</code>
<!-- tabs:start -->



| Param | Type |
| --- | --- |
| value | <code>Kengine.Instance</code> \| <code>Kengine.Asset</code> \| <code>Id.Instance</code> \| <code>Asset.GMObject</code> | 

<!-- tabs:end -->

## IsAncestor  :id=kengine-utils-instance-isancestor

`Kengine.Utils.Instance.IsAncestor(obj, parent)` ⇒ <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Checks whether object-type Asset is ancestor of another object-type Asset.



| Param | Type | Description |
| --- | --- | --- |
| obj | <code>Kengine.Asset</code> | <p>The object</p> |
| parent | <code>Kengine.Asset</code> | <p>The parent</p> |

<!-- tabs:end -->

## CreateLayer  :id=kengine-utils-instance-createlayer

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

## CreateDepth  :id=kengine-utils-instance-createdepth

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

## With  :id=kengine-utils-instance-with

`Kengine.Utils.Instance.With(expr_or_cmp, func)`
<!-- tabs:start -->


##### **Description**

A replacement for with statement. Calls the func with all instances in the expr_or_cmp. You can provide a function to filter instances from the collection.



| Param | Type | Description |
| --- | --- | --- |
| expr_or_cmp | <code>Any</code> | <p>The instances wanted. Or a filter function that returns true if you want the instance to get func called on. This can be any of the following:</p> <ul> <li>Function</li> <li>Id.Instance</li> <li>Kengine.Instance</li> <li>Kengine.Collection</li> <li>Array&lt;Kengine.Instance&gt;</li> <li>Kengine.Asset</li> </ul> |
| func | <code>function</code> | <p>The function to call. Takes an argument 'inst' which is the Kengine's Instance.</p> |

<!-- tabs:end -->

