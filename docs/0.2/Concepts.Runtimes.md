# Runtimes

> This section is a work-in-progress.

## Parser Runtime

The parsing in Kengine is based on YellowAfterLife's Tiny Expression Runtime. It is a little bit modified to handle *identifiers* with Kengine.

Your main entry point to executing scripts is to use `Kengine.Utils.Execute`.

You can also check other functions such as `Kengine.Utils.Parser.InterpretAsset`

Custom scripts use `this` as a reference to the calling object (self), this is when custom object events are ran.
Calls to scripts (using `asset.Run`, or the events) automatically provide the `this` argument.

> `Kengine.Utils.Execute` has an optional `this` argument.

The recommended approach is to use Run and provide the first argument which is the self (this) that you want.
The second approach (Using Kengine.Utils.Execute) is to provide the `this` argument as the self you want for your script to run.

This way you can access this (and self) which should be the same value.

> In event scripts of your objects, self and this are the instance, and you can use `wrapper` directly for the Kengine object instance.

> To add usable language functions, add `ken_txr_fn_` and `ken_txr_const_` prefixed scripts.


## Instance Runtime

The instances (should be created with `Kengine.Utils.Instance.CreateLayer` or `CreateDepth`) are managed with wrapper structs.
Each wrapper has an `instance` variable for the real instance, and the `wrapper` variable in the latter.

This is required to mimic GameMaker instances and events and their scripts.

## Room Runtime

- room: You can access it with `Kengine.current_room_asset`
- `asset.Goto` is available to switch to a room.

## Tiles Runtime

Tilemaps are basically just special instances created at a specific depth, that draw a vbuffer.
