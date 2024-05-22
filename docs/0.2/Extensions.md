# Extensions

Kengine also finds specific extension scripts that you can have added to the project.
Most of these are internal and required to run smoothly.

> This section is a work-in-progress and most likely to change in the future.

&nbsp;

## Mods

This extension adds the ability to get external mods into your game.

A `Kengine.Extensions.Mods.Mod` is basically a set of configurations to apply (or unapply) in your game. Mod `source` allows it to update from that source folder.

A `Mod` struct contains a set of `Kengine.Extensions.Mods.AssetConf` structs. Each one of these is a single Asset replacement definition.

Mods contain a main entry file, which specifies AssetConfs. If you're using the default mod parsing provided, then this entry file can import other relative files that contain more definitions. The default format is YAML. All these files and dependent files are included in a single archive file, which in turn is extracted and managed either in-game or outside the game (Assuming there's no sandboxing) once extracted.

#### Downloading

Since Mods are mainly an archive, This archive is what is used to download the mod. You will have to:
- Download the mod archive
- Find the new mods using the appropriate function (Such as `Kengine.Extensions.Mods.mod_manager.ReloadMods()`)

#### Updating

When updating a mod, it is recommended to "clear" mod contents if it's extracted and redownload the newer version of that mod and extract it again.

### AssetConfs

The `Kengine.Extensions.Mods.AssetConf` constructor defines the type and information of the asset to be added, and to replace if it exists. So in-game we would have two assets where one is the replacing asset and the other is kept in-memory, as a replaced asset.


## Panels

This extension adds a very basic GUI system called "Panels". It is required for the `Console` to work. 

> To add console commands, add `ken_script_` for IDE scripts to be run in the console with `scr_`.
> Or you can use the prefix `ken_scr_` to call directly with the prefix. (See rename_rules of scripts.)


## Tests

A small system for doing tests inside your project. It adds a `Test` constructor, a `Fixture` and a `Test Manager`.

Any script that starts with `ken_test_` is **called twice** in order to find its fixtures and to run the actual test.
A `Fixture` is simply an object with `setup` and `cleanup` functions that are required for the test. Mulitple tests can have the same fixtures (identified by the fixture name.)

> To add tests, add `ken_test_` prefixed functions.
