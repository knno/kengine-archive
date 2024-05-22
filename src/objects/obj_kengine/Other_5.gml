if Kengine.status == "READY" {
	if Kengine.current_room_asset != undefined { 
		if Kengine.current_room_asset.is_active == false {
			Kengine.current_room_asset.Deactivate();
		}
	}
}
