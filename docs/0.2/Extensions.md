# Extensions

Kengine also finds specific extension scripts that you can have added to the project.
Most of these are internal and required to run smoothly.

&nbsp;

## Mods

This extension adds the ability to get external mods into your game.

A `Kengine.Extensions.Mods.Mod` is basically a set of configurations to apply (or unapply) in your game. Mod repositories exist to facilitate getting mods updated from their sources.
`Kengine.Extensions.Mods.ModRepo`s represent a website, or a folder, that contains `Mod`s to be downloaded or grabbed to your game.
If a `Mod` source is a **remote location**, then there's a *download process*.
A Mod contains a set of `Kengine.Extensions.Mods.AssetConf`s objects. Each one of these is a single Asset replacement definition.

Mods also contain a main entry file, which specifies AssetConfs either in the same file or by reference to other files.
These files are all included in a single archive file, which in turn is extracted and managed either in-game or outside the game by manipulating respective directories.

### Downloading

Since Mods are mainly an archive, This archive is what is used to download the mod.

### Updating

When updating a mod, it is recommended to "clear" mod contents if it's extracted and redownload the newer version of that mod and extract it again.
This is managed automatically by Kengine.

### AssetConf

The `Kengine.Extensions.Mods.AssetConf` constructor defines the type and information of the asset to be added, and to replace if it exists. So in-game we would have two assets where one is the replacing asset and the other is kept in-memory, as a replaced asset.

## Panels

This extension adds a very basic GUI system called "Panels". It is required for the `Console` to work.

## Tests

A small system for doing tests inside your project. It adds a `Test` constructor, a `Fixture` and a `Test Manager`.

Any script that starts with `ken_test_` is **called twice** in order to find its fixtures and to run the actual test.
A `Fixture` is simply an object with `setup` and `cleanup` functions that are required for the test. Mulitple tests can have the same fixtures (identified by the fixture name.)

