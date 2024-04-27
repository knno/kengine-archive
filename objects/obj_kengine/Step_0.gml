if not Kengine.initialized exit;

#region Kengine.debug
instances = Kengine.instances;
#endregion Kengine.debug

#region Kengine.ascii
__KengineAsciiUtils.__Step()
#endregion Kengine.ascii

#region Kengine.extensions
var _m;
var _exts = Kengine.Extensions.GetAll();
var _ext;
for (var _i=0; _i<array_length(_exts); _i++) {
	_ext = _exts[_i];
	_m = __KengineStructUtils.Get(_ext, "Step")
	if not is_method(_m) _m = __KengineStructUtils.Get(_ext, "_Step")
	if not is_method(_m) _m = __KengineStructUtils.Get(_ext, "__Step")
	if is_method(_m) {
		_m(_ext);
	}
}
#endregion Kengine.extensions

#region Kengine.coroutines
if Kengine.coroutines != undefined {
	var _expectedFrameTime = game_get_speed(gamespeed_microseconds)/1000;
	if (current_time - Kengine.__coroutines_last_tick > 0.9*_expectedFrameTime)
	{
		Kengine.__coroutines_last_tick = current_time;
		for (var i=0; i<array_length(Kengine.coroutines); i++) {
			if Kengine.coroutines[i] == undefined continue;
			Kengine.coroutines[i].__Step();
			if Kengine.coroutines[i].__marked_as_delete {
				array_delete(Kengine.coroutines, i,1);
				continue;
			}
		}
	}
}

#endregion Kengine.coroutines

#region Kengine.room

if (Kengine.current_room_asset == undefined) {
	Kengine.current_room_asset = __KengineUtils.GetAsset("rm", room_get_name(room));
	if (Kengine.current_room_asset != undefined) {
		Kengine.current_room_asset.Activate();
	}
}

#endregion Kengine.room
