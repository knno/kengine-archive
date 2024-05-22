if rm_asset != undefined {
	if rm_asset != Kengine.current_room_asset {
		instance_destroy();
		exit;
	}
}

if tilemap != undefined tilemap.__Step();
