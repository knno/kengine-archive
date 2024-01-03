function ken_customize(kengine){
	Kengine.conf.console_enabled = true;
	Kengine.conf.asset_types.sound.do_index = false;
	Kengine.conf.debug = true;
	Kengine.conf.verbosity = 1;
	Kengine.conf.testing = true;
	Kengine.conf.benchmark = true;
	Kengine.utils.events.define("awesome", []);
	Kengine.utils.events.add_listener(
		"awesome", [
		function(alaa, ev) {Kengine.console.echo(alaa);},
	]);
}
