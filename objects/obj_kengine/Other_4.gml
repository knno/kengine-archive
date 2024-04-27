if Kengine.status == "READY" {
	Kengine.current_room_asset = __KengineUtils.GetAsset("rm", room_get_name(room));
	if Kengine.current_room_asset != undefined {
		Kengine.current_room_asset.Activate();
	}
}
