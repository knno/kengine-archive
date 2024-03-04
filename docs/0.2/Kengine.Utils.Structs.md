<!-- a name="Kengine.Utils.Structs"></a -->

# Structs  :id=kengine-utils-structs

[Kengine.Utils.Structs](Kengine.Utils.Structs) <code>object</code>
A struct containing Kengine structs utilitiy functions


<!-- a name="Kengine.Utils.Structs.Exists"></a -->

## Exists  :id=kengine-utils-structs-exists

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

## Get  :id=kengine-utils-structs-get

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

## SetDefault  :id=kengine-utils-structs-setdefault

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

## Set  :id=kengine-utils-structs-set

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

## Merge  :id=kengine-utils-structs-merge

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

## DotSet  :id=kengine-utils-structs-dotset

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

## DotGet  :id=kengine-utils-structs-dotget

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

## IsPublic  :id=kengine-utils-structs-ispublic

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

## IsPrivate  :id=kengine-utils-structs-isprivate

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

## SetPrivate  :id=kengine-utils-structs-setprivate

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

## IsReadonly  :id=kengine-utils-structs-isreadonly

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

