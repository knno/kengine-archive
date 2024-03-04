if room == rm_init {
	Kengine.current_room_asset = undefined;
} else {
	Kengine.current_room_asset = __KengineUtils.GetAsset("rm", room_get_name(room));
	if Kengine.current_room_asset != undefined {
		Kengine.current_room_asset.activate();
	}
}
__kengine_log("Room event");
