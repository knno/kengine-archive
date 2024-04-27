# Mods  :id=kengine-extensions-mods

[Kengine.Extensions.Mods](Kengine.Extensions.Mods) <code>object</code>
<!-- tabs:start -->


##### **Description**

Kengine's Mods extension


<!-- tabs:end -->

## AssetConf  :id=kengine-extensions-mods-assetconf

`Kengine.Extensions.Mods.AssetConf(conf)`
<!-- tabs:start -->


##### **Description**

An AssetConf is a configuration object for an asset to be applied or unapplied. AssetConfs are created when creating or updating the mod using <code>mod.update</code> function.



| Param | Type | Description |
| --- | --- | --- |
| conf | <code>Struct</code> | <p>The conf of the asset to initiate the <code>Kengine.Extensions.Mods.AssetConf</code> with. Must at least have <code>{name, type}</code></p> |

<!-- tabs:end -->

### conf  :id=kengine-extensions-mods-assetconf-conf

[Kengine.Extensions.Mods.AssetConf.conf](Kengine.Extensions.Mods?id=kengine.extensions.mods.assetconf.conf) <code>Struct</code>
<!-- tabs:start -->


##### **Description**

The internal confs of this AssetConf.</p>
<p>Note - underscore confs are stripped out.


<!-- tabs:end -->

### is_applied  :id=kengine-extensions-mods-assetconf-is_applied

[Kengine.Extensions.Mods.AssetConf.is_applied](Kengine.Extensions.Mods?id=kengine.extensions.mods.assetconf.is_applied) <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Whether the assetconf is applied by a specific mod. Defaults to <code>false</code>.


<!-- tabs:end -->

### target  :id=kengine-extensions-mods-assetconf-target

[Kengine.Extensions.Mods.AssetConf.target](Kengine.Extensions.Mods?id=kengine.extensions.mods.assetconf.target) <code>Kengine.Asset</code>
<!-- tabs:start -->


##### **Description**

The target asset of this asset conf. It can be the same as <code>self.asset</code> if it's totally new, or the replacement asset target.


**See**: [Kengine.Asset.__replaces](Kengine?id=kengine.asset.__replaces)  
<!-- tabs:end -->

### source_mod  :id=kengine-extensions-mods-assetconf-source_mod

[Kengine.Extensions.Mods.AssetConf.source_mod](Kengine.Extensions.Mods?id=kengine.extensions.mods.assetconf.source_mod) [<code>Mod</code>](Kengine.Extensions.Mods?id=kengine.extensions.mods.mod) \| <code>Undefined</code>
<!-- tabs:start -->


##### **Description**

The mod emitting this assetconf.


<!-- tabs:end -->

### Apply  :id=kengine-extensions-mods-assetconf-apply

`Kengine.Extensions.Mods.AssetConf.Apply()`
<!-- tabs:start -->


##### **Description**

.


<!-- tabs:end -->

### Unapply  :id=kengine-extensions-mods-assetconf-unapply

`Kengine.Extensions.Mods.AssetConf.Unapply()`
<!-- tabs:start -->


##### **Description**

.


<!-- tabs:end -->

## Mod  :id=kengine-extensions-mods-mod

`Kengine.Extensions.Mods.Mod(name, [asset_confs], [dependencies], [source], [enabled])`
<!-- tabs:start -->


##### **Description**

A <code>Kengine.Extensions.Mods.Mod</code> is a group of [AssetConf](Kengine.Extensions.Mods?id=kengine.extensions.mods.assetconf) instances that will be enabled in order to apply them as <code>Kengine.Asset</code> instances.
Newely added <code>Kengine.Asset</code>s can either be simply just added or replace pre-existing Assets. When enabling a <code>Mod</code>, this happens. When disabling the <code>Mod</code>, all its <code>Kengine.Asset</code>s are removed and replaced ones are restored to their previous state.



| Param | Type | Default | Description |
| --- | --- | --- | --- |
| name | <code>String</code> |  | <p>The name of the Mod.</p> |
| [asset_confs] | [<code>Array.&lt;AssetConf&gt;</code>](Kengine.Extensions.Mods?id=kengine.extensions.mods.assetconf) | <code>[]</code> | <p>AssetConfs that the Mod comprises.</p> |
| [dependencies] | [<code>Array.&lt;Mod&gt;</code>](Kengine.Extensions.Mods?id=kengine.extensions.mods.mod) \| <code>Array.&lt;String&gt;</code> | <code>[]</code> | <p>Mod dependencies of other Mods or their names.</p> |
| [source] | <code>Kengine.Extensions.Mods.ModSource</code> |  | <p>Mod source.</p> |
| [enabled] | <code>Bool</code> | <code>false</code> | <p>Whether the mod is enabled or not.</p> |

<!-- tabs:end -->

### source_path  :id=kengine-extensions-mods-mod-source_path

[Kengine.Extensions.Mods.Mod.source_path](Kengine.Extensions.Mods?id=kengine.extensions.mods.mod.source_path) <code>String</code>
<!-- tabs:start -->


##### **Description**

The source_path property of the Mod.


**Default**: <code>&quot;&lt;unknown source_path&gt;&quot;</code>  
<!-- tabs:end -->

### name  :id=kengine-extensions-mods-mod-name

[Kengine.Extensions.Mods.Mod.name](Kengine.Extensions.Mods?id=kengine.extensions.mods.mod.name) <code>String</code>
<!-- tabs:start -->


##### **Description**

The <code>name</code> provided when creating the <code>Mod</code>.


<!-- tabs:end -->

### options  :id=kengine-extensions-mods-mod-options

[Kengine.Extensions.Mods.Mod.options](Kengine.Extensions.Mods?id=kengine.extensions.mods.mod.options) <code>Any</code>
<!-- tabs:start -->


##### **Description**

The <code>description</code> property of the <code>Mod</code>.


**Default**: <code>undefined</code>  
<!-- tabs:end -->

### dependencies  :id=kengine-extensions-mods-mod-dependencies

[Kengine.Extensions.Mods.Mod.dependencies](Kengine.Extensions.Mods?id=kengine.extensions.mods.mod.dependencies) [<code>Array.&lt;Mod&gt;</code>](Kengine.Extensions.Mods?id=kengine.extensions.mods.mod)
<!-- tabs:start -->


##### **Description**

Mod dependencies.


**Default**: <code>[]</code>  
<!-- tabs:end -->

### asset_confs  :id=kengine-extensions-mods-mod-asset_confs

[Kengine.Extensions.Mods.Mod.asset_confs](Kengine.Extensions.Mods?id=kengine.extensions.mods.mod.asset_confs) <code>Struct</code>
<!-- tabs:start -->


##### **Description**

The <code>asset_confs</code> property of the Mod. Set by the mod manager when it finds mods.


**Default**: <code>{}</code>  
<!-- tabs:end -->

### enabled  :id=kengine-extensions-mods-mod-enabled

[Kengine.Extensions.Mods.Mod.enabled](Kengine.Extensions.Mods?id=kengine.extensions.mods.mod.enabled) <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Whether Mod is enabled or not.


**Default**: <code>false</code>  
<!-- tabs:end -->

### source  :id=kengine-extensions-mods-mod-source

[Kengine.Extensions.Mods.Mod.source](Kengine.Extensions.Mods?id=kengine.extensions.mods.mod.source) <code>String</code> \| <code>Undefined</code> \| <code>Kengine.Extensions.Mods.ModSource</code>
<!-- tabs:start -->


**Default**: <code>&quot;&lt;unknown&gt;&quot;</code>  
**Descripton**: The source of this mod.  
<!-- tabs:end -->

### GetAllAssetConfs  :id=kengine-extensions-mods-mod-getallassetconfs

`Kengine.Extensions.Mods.Mod.GetAllAssetConfs()` ⇒ [<code>Array.&lt;AssetConf&gt;</code>](Kengine.Extensions.Mods?id=kengine.extensions.mods.assetconf)
<!-- tabs:start -->


##### **Description**

Return all the mod's asset confs.


<!-- tabs:end -->

### Enable  :id=kengine-extensions-mods-mod-enable

`Kengine.Extensions.Mods.Mod.Enable()`
<!-- tabs:start -->


##### **Description**

Enable the mod. Applying its <code>asset_confs</code>.


<!-- tabs:end -->

### Disable  :id=kengine-extensions-mods-mod-disable

`Kengine.Extensions.Mods.Mod.Disable()`
<!-- tabs:start -->


##### **Description**

Disable the mod. Unapplying its <code>asset_confs</code>.


<!-- tabs:end -->

### ResolveDependencies  :id=kengine-extensions-mods-mod-resolvedependencies

`Kengine.Extensions.Mods.Mod.ResolveDependencies()`
<!-- tabs:start -->


##### **Description**

Resolve dependencies. If there are <code>string</code> values as dependencies, it is converted to a <code>Mod</code> (if found) or it's kept.


<!-- tabs:end -->

### Update  :id=kengine-extensions-mods-mod-update

`Kengine.Extensions.Mods.Mod.Update()`
<!-- tabs:start -->


##### **Description**

Resolve or update mod's assetconfs from the mod's source.


<!-- tabs:end -->

## ModManager  :id=kengine-extensions-mods-modmanager

`Kengine.Extensions.Mods.ModManager()`
<!-- tabs:start -->


##### **Description**

A mod manager is a singleton object that manages [Mod](Kengine.Extensions.Mods?id=kengine.extensions.mods.mod) objects.


<!-- tabs:end -->

### mods  :id=kengine-extensions-mods-modmanager-mods

[Kengine.Extensions.Mods.ModManager.mods](Kengine.Extensions.Mods?id=kengine.extensions.mods.modmanager.mods) <code>Kengine.Collection</code>
<!-- tabs:start -->


##### **Description**

Collection of <code>Mod</code> objects that are found by [Kengine.Extensions.Mods.ModManager.FindMods](Kengine.Extensions.Mods?id=kengine.extensions.mods.modmanager.findmods). Defaults to empty Collection.


<!-- tabs:end -->

### find_mods  :id=kengine-extensions-mods-modmanager-find_mods

`Kengine.Extensions.Mods.ModManager.find_mods()` ⇒ <code>Collection</code> \| [<code>Array.&lt;Mod&gt;</code>](Kengine.Extensions.Mods?id=kengine.extensions.mods.mod)
<!-- tabs:start -->


##### **Description**

A function to search for mods. It uses <code>find_mods_func</code>.


<!-- tabs:end -->

### ReloadMods  :id=kengine-extensions-mods-modmanager-reloadmods

`Kengine.Extensions.Mods.ModManager.ReloadMods([discover])`
<!-- tabs:start -->


##### **Description**

A function to reload mods.



| Param | Type | Default | Description |
| --- | --- | --- | --- |
| [discover] | <code>Bool</code> | <code>false</code> | <p>Whether to discover new mods or not.</p> |

<!-- tabs:end -->

### EnableMod  :id=kengine-extensions-mods-modmanager-enablemod

`Kengine.Extensions.Mods.ModManager.EnableMod(_mod, [force])` ⇒ <code>Struct</code>
<!-- tabs:start -->


##### **Description**

Enable a Mod. If forced, enable its dependencies.</p>
<p>Returns a struct containing <code>{success, dependencies_to_enable, dependencies_not_found, dependencies_enabled}</code>.</p>
<p><code>success</code>: Whether enabling was successful.</p>
<p><code>dependencies_to_enable</code>: Dependencies that still need to be enabled manually. If <code>force</code> is <code>true</code>, This should be an empty array.</p>
<p><code>dependencies_not_found</code>: Dependencies that are needed but not found as initiated Mods.</p>
<p><code>dependencies_enabled</code>: Dependencies that are enabled as a result of calling this function.



| Param | Type | Default | Description |
| --- | --- | --- | --- |
| _mod | <code>String</code> \| [<code>Mod</code>](Kengine.Extensions.Mods?id=kengine.extensions.mods.mod) |  | <p>The mod to enable.</p> |
| [force] | <code>Real</code> | <code>0</code> | <p>Whether to enable the mod forcefully by enabling its dependencies.</p> |

<!-- tabs:end -->

### DisableMod  :id=kengine-extensions-mods-modmanager-disablemod

`Kengine.Extensions.Mods.ModManager.DisableMod(_mod, [_force])` ⇒ <code>Struct</code>
<!-- tabs:start -->


##### **Description**

Disable a Mod. If forced, disable its dependants and dependencies.</p>
<p>Returns a struct containing <code>{success, mods_disabled, dependants_to_disable, dependencies_to_disable}</code>.</p>
<p><code>success</code>: Whether disabling was successful.</p>
<p><code>mods_disabled</code>: All mods that have been disabled as a result of calling this function.</p>
<p><code>dependants_to_disable</code>: An array of <code>Mod</code> objects, which are dependants on the mod, if there are any that need to be disabled. If <code>force</code> is <code>1</code>, They are disabled and this is an empty array.</p>
<p><code>dependencies_to_disable</code>: An array of <code>Mod</code> objects, which are the dependencies of the mod, if there are any that are preferrably to be disabled (they are unused now). If <code>force</code> is <code>2</code>, They are disabled and this is an empty array.



| Param | Type | Default | Description |
| --- | --- | --- | --- |
| _mod | <code>String</code> \| [<code>Mod</code>](Kengine.Extensions.Mods?id=kengine.extensions.mods.mod) |  | <p>The mod to disable.</p> |
| [_force] | <code>Real</code> | <code>0</code> | <p>Whether to disable the mod forcefully by disabling its dependants and dependencies.</p> |

<!-- tabs:end -->

