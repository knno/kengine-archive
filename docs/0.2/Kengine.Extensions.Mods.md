# Mods  :id=kengine-extensions-mods

[Kengine.Extensions.Mods](Kengine.Extensions.Mods) <code>object</code>
<!-- tabs:start -->


##### **Description**

Kengine's Mods extension


<!-- tabs:end -->

## GetAssetTypeSynonymsArray  :id=kengine-extensions-mods-getassettypesynonymsarray

`Kengine.Extensions.Mods.GetAssetTypeSynonymsArray(asset_type)` ⇒ <code>Array.&lt;String&gt;</code>
<!-- tabs:start -->


##### **Description**

Returns the synonyms array for an asset type. First one is the canonical.



| Param | Type | Description |
| --- | --- | --- |
| asset_type | <code>String</code> \| <code>Kengine.AssetType</code> | <p>The asset type you want to get synonyms for.</p> |

<!-- tabs:end -->

## ParseModFileSync  :id=kengine-extensions-mods-parsemodfilesync

`Kengine.Extensions.Mods.ParseModFileSync(modname, source)` ⇒ <code>Struct</code> \| <code>Undefined</code> \| <code>Any</code>
<!-- tabs:start -->


##### **Description**

Parses a mod definition file (source) while also handling imports.


**Returns**: <code>Struct</code> \| <code>Undefined</code> \| <code>Any</code> - The definition data.  

| Param | Type | Description |
| --- | --- | --- |
| modname | <code>String</code> | <p>The mod name.</p> |
| source | <code>String</code> | <p>The source to parse.</p> |

<!-- tabs:end -->

## DefaultGameFindMods  :id=kengine-extensions-mods-defaultgamefindmods

`Kengine.Extensions.Mods.DefaultGameFindMods()` ⇒ <code>Array.&lt;Array.&lt;Kengine.Extensions.Mods.Mod&gt;&gt;</code>
<!-- tabs:start -->


##### **Description**

The default mods finder function. It returns an array of arrays that contain mods found.
<code>{this}</code> is the Mod Manager.


<!-- tabs:end -->

## FindLocalMods  :id=kengine-extensions-mods-findlocalmods

`Kengine.Extensions.Mods.FindLocalMods(base)` ⇒ [<code>Array.&lt;Mod&gt;</code>](Kengine.Extensions.Mods?id=kengine.extensions.mods.mod)
<!-- tabs:start -->


##### **Description**

Finds directory mods and return Mod objects in an array.



| Param | Type | Description |
| --- | --- | --- |
| base | <code>String</code> | <p>The base location of the finding, could be working_directory, program_directory, game_save_id, a custom path...</p> |

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

[Kengine.Extensions.Mods.AssetConf.conf](Kengine.Extensions.Mods?id=kengine.extensions.mods.assetconf.conf) <code>Kengine.Struct</code>
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


<!-- tabs:end -->

### source_mod  :id=kengine-extensions-mods-assetconf-source_mod

[Kengine.Extensions.Mods.AssetConf.source_mod](Kengine.Extensions.Mods?id=kengine.extensions.mods.assetconf.source_mod) [<code>Mod</code>](Kengine.Extensions.Mods?id=kengine.extensions.mods.mod) \| <code>Undefined</code>
<!-- tabs:start -->


##### **Description**

The mod emitting this assetconf.


<!-- tabs:end -->

### asset  :id=kengine-extensions-mods-assetconf-asset

[Kengine.Extensions.Mods.AssetConf.asset](Kengine.Extensions.Mods?id=kengine.extensions.mods.assetconf.asset) <code>Kengine.Asset</code>
<!-- tabs:start -->


##### **Description**

The asset created by this asset conf. It can be the same as <code>self.target</code> if it's totally new.


<!-- tabs:end -->

### Apply  :id=kengine-extensions-mods-assetconf-apply

`Kengine.Extensions.Mods.AssetConf.Apply()`
<!-- tabs:start -->


##### **Description**

Applies this asset conf, creating a new asset.


<!-- tabs:end -->

### Unapply  :id=kengine-extensions-mods-assetconf-unapply

`Kengine.Extensions.Mods.AssetConf.Unapply()`
<!-- tabs:start -->


##### **Description**

Unapplies this asset conf, destroying or removing the asset created.


<!-- tabs:end -->

## Mod  :id=kengine-extensions-mods-mod

`Kengine.Extensions.Mods.Mod(name, [asset_confs], [_dependencies], [source], [enabled])`
<!-- tabs:start -->


##### **Description**

A <code>Kengine.Extensions.Mods.Mod</code> is a group of [AssetConf](Kengine.Extensions.Mods?id=kengine.extensions.mods.assetconf) instances that will be enabled in order to apply them as <code>Kengine.Asset</code> instances.
Newely added <code>Kengine.Asset</code>s can either be simply just added or replace pre-existing Assets. When enabling a <code>Mod</code>, this happens. When disabling the <code>Mod</code>, all its <code>Kengine.Asset</code>s are removed and replaced ones are restored to their previous state.



| Param | Type | Default | Description |
| --- | --- | --- | --- |
| name | <code>String</code> |  | <p>The name of the Mod.</p> |
| [asset_confs] | [<code>Array.&lt;AssetConf&gt;</code>](Kengine.Extensions.Mods?id=kengine.extensions.mods.assetconf) | <code>[]</code> | <p>AssetConfs that the Mod comprises.</p> |
| [_dependencies] | [<code>Array.&lt;Mod&gt;</code>](Kengine.Extensions.Mods?id=kengine.extensions.mods.mod) \| <code>Array.&lt;String&gt;</code> | <code>[]</code> | <p>Mod dependencies of other Mods or their names.</p> |
| [source] | <code>String</code> |  | <p>Mod source path.</p> |
| [enabled] | <code>Bool</code> | <code>false</code> | <p>Whether the mod is enabled or not.</p> |

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

### GetAssetConfs  :id=kengine-extensions-mods-mod-getassetconfs

`Kengine.Extensions.Mods.Mod.GetAssetConfs()` ⇒ [<code>Array.&lt;AssetConf&gt;</code>](Kengine.Extensions.Mods?id=kengine.extensions.mods.assetconf)
<!-- tabs:start -->


##### **Description**

Returns the mod's asset confs.


<!-- tabs:end -->

### Enable  :id=kengine-extensions-mods-mod-enable

`Kengine.Extensions.Mods.Mod.Enable()`
<!-- tabs:start -->


##### **Description**

Enables the mod. Applying its <code>asset_confs</code>.


<!-- tabs:end -->

### Disable  :id=kengine-extensions-mods-mod-disable

`Kengine.Extensions.Mods.Mod.Disable()`
<!-- tabs:start -->


##### **Description**

Disables the mod. Unapplying its <code>asset_confs</code>.


<!-- tabs:end -->

### ResolveDependencies  :id=kengine-extensions-mods-mod-resolvedependencies

`Kengine.Extensions.Mods.Mod.ResolveDependencies()`
<!-- tabs:start -->


##### **Description**

Resolves dependencies. If there are <code>string</code> values as dependencies, it is converted to a <code>Mod</code> (if found) or it's kept.


<!-- tabs:end -->

### Update  :id=kengine-extensions-mods-mod-update

`Kengine.Extensions.Mods.Mod.Update()`
<!-- tabs:start -->


##### **Description**

Resolves or update mod's assetconfs from the mod's source.


<!-- tabs:end -->

### UpdateAssetConfs  :id=kengine-extensions-mods-mod-updateassetconfs

`Kengine.Extensions.Mods.Mod.UpdateAssetConfs(asset_confs)`
<!-- tabs:start -->


##### **Description**

Resolves or update mod's current assetconfs with updated and/or newly created assetconfs.
This would add and update existing asset confs of the mod.



| Param | Type |
| --- | --- |
| asset_confs | [<code>Array.&lt;AssetConf&gt;</code>](Kengine.Extensions.Mods?id=kengine.extensions.mods.assetconf) \| <code>Struct</code> | 

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

Collection of <code>Mod</code> objects that are found by [FindMods](Kengine.Extensions.Mods?id=kengine.extensions.mods.modmanager.findmods). Defaults to empty Collection.


<!-- tabs:end -->

### FindMods  :id=kengine-extensions-mods-modmanager-findmods

`Kengine.Extensions.Mods.ModManager.FindMods()` ⇒ <code>Collection</code> \| [<code>Array.&lt;Mod&gt;</code>](Kengine.Extensions.Mods?id=kengine.extensions.mods.mod)
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
| [discover] | <code>Bool</code> | <code>true</code> | <p>Whether to discover new mods or not.</p> |

<!-- tabs:end -->

### EnableMod  :id=kengine-extensions-mods-modmanager-enablemod

`Kengine.Extensions.Mods.ModManager.EnableMod(_mod, [force])` ⇒ <code>Struct</code>
<!-- tabs:start -->


##### **Description**

Enables a Mod. If forced, enable its dependencies.</p>
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

Disables a Mod. If forced, disable its dependants and dependencies.</p>
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

