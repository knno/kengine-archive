function ken_txr_fn_array_get(){
	try {
		return argument[0][argument[1]];
	} catch (e) {
		Kengine.console.echo_error(e.message);
	}
}
