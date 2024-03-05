function __KengineAssetUtils() : __KengineStruct() constructor {

	static AutoIndex = function() {

		__KengineBenchmarkUtils.Mark("AssetTypes: Indexing AssetTypes...", 1);

		// Create AssetTypes.
		var _option_names = struct_get_names(Kengine.asset_type_options);
		var _option_name;
		var _funcs = [];
		var _fn;

		static __AsyncAutoIndexTypeFromOptionName = function(option_name) {
			/// var_struct {option_name}
			var _option = __KengineStructUtils.Get(Kengine.asset_type_options, option_name);
			var _assettype = __KengineAssetUtils.CreateAssetType(_option);
			if _assettype == false {
				var _k = Kengine();
				_assettype = __KengineStructUtils.Get(_k.asset_types, option_name);
			}
			if struct_exists(_option, "auto_index") {
				if _option.auto_index {
					__KengineAssetUtils.IndexType(_assettype, _option.indexing_options);
				}
			}
		}

		/**
		 * @function __AsyncAutoIndexCallback
		 * @memberof Kengine.Utils.Assets
		 * @private
		 */
		static __AsyncAutoIndexCallback = function() {
			// When scripts are loaded we can set up the parser.
			// Get scripts that start with ken_txr_fn and add them to TXR functions.
			var txrs = Kengine.asset_types[$ "script"].assets.Filter(function(val) { return string_starts_with(val.name, "ken_txr_fn_");});
			for (var i=0; i<array_length(txrs); i++) {
				__KengineParserUtils.__Interpreter.System._function_add(string_replace(txrs[i].name, "ken_txr_fn_", ""), txrs[i].id, -1);
			}
			// Get scripts that start with ken_txr_constant_ and add them to TXR constants.
			txrs = Kengine.asset_types[$ "script"].assets.Filter(function(val) { return string_starts_with(val.name, "ken_txr_constant_");});
			for (var i=0; i<array_length(txrs); i++) {
				__KengineParserUtils.__Interpreter.System._constant_add(string_replace(txrs[i].name, "ken_txr_constant_", ""), txrs[i].id, -1);
			}
			__KengineUtils.__CreateBaseObjectAsset();
			__KengineUtils.__StartExtensions();
			coroutine.Destroy();
			return 55;
		}


		for (var i=0; i<array_length(_option_names); i++) {
			_option_name = _option_names[i];
			_fn = method({option_name: _option_name}, __AsyncAutoIndexTypeFromOptionName);
			array_push(_funcs, [_fn, [_option_name]])
		}

		var _coroutine = new __KengineCoroutine("assettypes-autoindex",_funcs, __AsyncAutoIndexCallback);

		if (KENGINE_ASSET_TYPES_AUTO_INDEX_ASYNC) {
			_coroutine.Start();
		} else {
			_coroutine.Immediate();
		}
		return _coroutine;
	}

	static CreateAssetType = function(asset_type_option) {
		if array_contains(struct_get_names(Kengine.asset_types), asset_type_option.name) return false;

		asset_type_option.indexing_options = asset_type_option[$ "indexing_options"] ?? {}; // __KengineStructUtils.SetDefault(asset_type_option, "indexing_options", undefined);
		asset_type_option.var_struct = asset_type_option[$ "var_struct"] ?? {}; // __KengineStructUtils.SetDefault(asset_type_option, "var_struct", undefined);

		return new __KengineAssetType(asset_type_option.name, asset_type_option.asset_kind, asset_type_option.indexing_options, asset_type_option.var_struct);
	}

	static IndexType = function(assettype, indexing_options) {
			__KengineBenchmarkUtils.Mark(string("AssetType: {0}: Indexing...", assettype.name), 2, false);
			assettype.IndexAssets(indexing_options);
			__KengineBenchmarkUtils.Mark(string("AssetType: {0}: Complete", assettype.name), 2, true);
	}
}
__KengineAssetUtils();
