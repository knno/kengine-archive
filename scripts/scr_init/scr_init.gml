function get_game_exe_directory() {
	// Feather disable GM1024
	if debug_mode == true {
		return "D:/Projects/Kengine";
	}
	return program_directory;
}

#macro GAME_EXE_DIRECTORY get_game_exe_directory()
