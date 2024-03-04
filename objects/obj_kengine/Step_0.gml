/// @description General Step functions

__kengine_log("Step event begin");

if not Kengine.initialized exit;

__kengine_log("Step event continueing");

#region Kengine.debug

#endregion Kengine.debug

#region Kengine.ascii
__KengineAsciiUtils.__Step()
__kengine_log("Step event : 1");
#endregion Kengine.ascii

#region Kengine.extensions
var _m;
var _exts = struct_get_names(Kengine.Extensions);
var _ext;
__kengine_log(string(_exts));
for (var _i=0; _i<array_length(_exts); _i++) {
	if _exts[_i] == "toString" continue
	if _exts[_i] == "__opts" continue
	_ext = __KengineStructUtils.Get(Kengine.Extensions, _exts[_i]);
	_m = __KengineStructUtils.Get(_ext, "Step")
	if not is_method(_m) _m = __KengineStructUtils.Get(_ext, "_Step")
	if not is_method(_m) _m = __KengineStructUtils.Get(_ext, "__Step")
	if is_method(_m) {
		_m(_ext);
	}
}
#endregion Kengine.extensions

#region Kengine.coroutines
__kengine_log("Step event : 3");
if Kengine.coroutines != undefined {
	var _expectedFrameTime = game_get_speed(gamespeed_microseconds)/1000;
	if (current_time - Kengine.__coroutines_last_tick > 0.9*_expectedFrameTime)
	{
	__kengine_log("Step event : 3.1");
		Kengine.__coroutines_last_tick = current_time;
		for (var i=0; i<array_length(Kengine.coroutines); i++) {
			if Kengine.coroutines[i] == undefined continue;
			__kengine_log("Step event : 3.1.1");
			Kengine.coroutines[i].__Step();
		}
	}
}

#endregion Kengine.coroutines

#region Kengine.room

if room != rm_init {
	if (Kengine.current_room_asset == undefined) {
		Kengine.current_room_asset = __KengineUtils.GetAsset("rm", room_get_name(room));
		if (Kengine.current_room_asset != undefined) {
			Kengine.current_room_asset.activate();
		}
	}
} else {
	
}

#endregion Kengine.room
__kengine_log("Step event ended");
