/// @description Delete? + DO EV
__kengine_do_ev(__KengineHashkeyUtils.__all.room_end);

if variable_struct_exists(wrapper, "persistent") {
	if not wrapper.persistent {
		wrapper.destroy();
	}
}