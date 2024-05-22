# Assets

A custom asset (KAsset) or a GMAsset (YYAsset) has the following properties:

- `__is_yyp` Which is a boolean whether it is a YYAsset or a KAsset
- `index` Which is the index of the asset in the asset type pool.
- `type` Which is a reference to the *AssetType*
- `id` Which is the real ID of the asset. Such as the real created sprite by creating this custom asset.
- `uid` Which is a unique ID within Kengine, at runtime.

### Asset Indexing

Asset indexing is used to make a pool of all the assets (both internal GM assets **and** custom ones you defined and added).

Each *AssetType* has a pool for it self (e.g. `Kengine.asset_types.sprite.assets`, which is a Kengine Collection.)

Each *Asset*, whenever constructed manually is indexed automatically regardless of auto indexing at start. This means auto indexing at start is very much recommended. It is provided as a delayed function (coroutine) which can be run immediately or over multiple frames with chunks.
It is simply configurable in the `KengineConfig` script.

An **indexed asset** mean that the asset's `index` is unique at runtime, within its type's pool.


### Asset Replacement

When replacing assets, a "replaced" tag is set on the *Asset* and on the real asset if it represents one.
Both assets will exist at the same time. But using `Kengine.Utils.GetAsset` will return the required asset or its replacing assets if any until there's no replacing assets. This can be represented with a graph such as  `A -> B -> C -> D`

When adding assets (from mods) an "added" tag is set.

When a system or fixed asset tag is found, it means the asset cannot be replaced.

## AssetTypes

Assets belong to an AssetType (singular form: sprite, rm, script, path, custom_script...).

### Definition

The schema defined in the `KengineAssetTypes` script is a struct with each attribute represents an *AssetType* to be created (which is done at the very beginning in runtime.) and its value will be the options to define this asset type with:

Let's take a look at a simple "script" asset type schema definition:

```gml
script: {
	name: "script", // The name to call this asset type.
    asset_kind: asset_script, // This should be provided if representing a YYAsset. Required for indexing.
    indexing_options: {
        exclude_prefixes: ["ken__", "anon_", "anon@", "__Kengine"], // Prefixes to exclude when indexing assets.
        rename_rules: [], // Rename rules (omitted from actual source.)
    },

    // Var struct is for attributes to set to the asset type.
    var_struct: {
        is_addable: false, // Whether this script asset is addable in mod manager.
        is_replaceable: false, // Whether this script asset is replaceable in mod manager.

        index_asset_filter: function(asset) { // A filter function for when indexing script assets.
            return true;
        },

        // Assets var struct is for attributes to set to the assets when created of their type.
        assets_var_struct: {
            Run: function() { // {this}
                return script_execute(this.id);
            },
        },
    },
},

```

Pretty much self-explanatory. `var_struct` and `assets_var_struct` are optional.


## AssetConf

An AssetConf is basically the formula to apply to get an asset out of it. AssetConfs are the objects in the type array defined in the mod external text file (yaml).

### Mapping

You can use the `asset_conf_mapping` attribute in the `var_struct` attribute of the schemas, in order to manipulate confs and assets in a function

Let's assume you want to reference a custom sprite (which is a custom asset) to your tileset asset. 

```gml
asset_conf_mapping: function(assetconf) {
    var asset = assetconf.asset;
    var conf = assetconf.conf;
    var spr = Kengine.Utils.GetAsset("sprite", conf.sprite).id;
    asset.original_sprite = spr;
}
```

> Note: custom asset loading order is defined with `KENGINE_ASSET_TYPES_ORDER`


You can also use multiple `KengineMapper`s for simplicity, make sure you decide well on this.

```gml
asset_conf_mapping: [
    new KengineMapper("sprite", function(value, assetconf) {
        var v = Kengine.Utils.GetAsset("sprite", value);
        if is_undefined(v) {
            throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__asset_conf__no_resolve, string("AssetConf \"{0}\" property {1}=\"{2}\" not found.", assetconf, "sprite", value), true);
        }
        return v;
    }),
]
// Can now access asset.sprite
// and asset.__opts.original_attributes.sprite
```

## Conclusion {docsify-ignore}

Congrats! An explanation of Assets, Asset indexing, Asset Types, Asset Confs, was provided above and also a schema example has been demonstrated.

You can see the source code for more detailed explanations.
