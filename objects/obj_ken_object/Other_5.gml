/// @description Delete? + DO EV
__kengine_do_ev(Kengine.utils.hashkeys._all.other_, ev_room_end);

if variable_struct_exists(wrapper, "persistent") {
	if not wrapper.persistent {
		wrapper.destroy();
	}
}