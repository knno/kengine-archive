function ken_txr_default_function(){
	var scr = argument[0];
	var _scrs = Kengine.asset_types.script.assets;
	var scr_ind = _scrs.GetInd(scr, function(val1, val2) {
		if ((val1 == val2.name) or (val1 == val2.real_name)) {
			return not __KengineStructUtils.IsPrivate(val2, __KengineParser.__default_private);
		}
		return false;
	});

	if scr_ind > 0 {
		var scr_asset = _scrs.get(scr_ind);
		if scr_asset != undefined {
			var v;
			var _run = __KengineStructUtils.Get(scr_asset, "execute") ?? scr_asset.id;
			switch (argument_count) {
				case  1: return _run();
				case  2: return _run(argument[1]);
				case  3: return _run(argument[1], argument[2]);
				case  4: return _run(argument[1], argument[2], argument[3]);
				case  5: return _run(argument[1], argument[2], argument[3], argument[4]);
				case  6: return _run(argument[1], argument[2], argument[3], argument[4], argument[5]);
				case  7: return _run(argument[1], argument[2], argument[3], argument[4], argument[5], argument[6]);
				case  8: return _run(argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7]);
				case  9: return _run(argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8]);
				case 10: return _run(argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9]);
				case 11: return _run(argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10]);
				case 12: return _run(argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11]);
				case 13: return _run(argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11], argument[12]);
				case 14: return _run(argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11], argument[12], argument[13]);
				case 15: return _run(argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11], argument[12], argument[13], argument[14]);
				case 16: return _run(argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9], argument[10], argument[11], argument[12], argument[13], argument[14], argument[15]);
			}
		}
	}
}
