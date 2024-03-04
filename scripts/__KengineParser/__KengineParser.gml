function __KengineParser() : __KengineStruct() constructor {
	static __default_private = KENGINE_PARSER_DEFAULT_PRIVATE
	
	static __SetupTxr = function() {
		// Get scripts that start with ken_txr_fn and add them to TXR functions.
		show_debug_message(Kengine);
		var txrs = Kengine.asset_types[$ "script"].assets.Filter(function(val) { return string_starts_with(val.name, "ken_txr_fn_");});
		for (var i=0; i<array_length(txrs); i++;) {
			__KengineParserUtils.__Interpreter.System._function_add(string_replace(txrs[i].name, "ken_txr_fn_", ""), txrs[i].id, -1);
		}
		// Get scripts that start with ken_txr_constant_ and add them to TXR constants.
		txrs = Kengine.asset_types[$ "script"].assets.Filter(function(val) { return string_starts_with(val.name, "ken_txr_constant_");});
		for (var i=0; i<array_length(txrs); i++;) {
			__KengineParserUtils.__Interpreter.System._constant_add(string_replace(txrs[i].name, "ken_txr_constant_", ""), txrs[i].id, -1);
		}
	}

}
__KengineParser();
