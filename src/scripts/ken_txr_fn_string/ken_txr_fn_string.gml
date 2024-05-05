function ken_txr_fn_string() {
	if argument_count == 1 {
		return string(argument[0]);
	} else if argument_count == 2 {
		return string(argument[0], argument[1]);
	}
}