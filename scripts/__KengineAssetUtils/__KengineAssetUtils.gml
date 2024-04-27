function __KengineAssetUtils() : __KengineStruct() constructor {

	static __AutoIndex = function() {

		__KengineBenchmarkUtils.Mark("AssetTypes: Indexing AssetTypes...", 1);

		// Create AssetTypes.
		var asset_type_options = KengineAssetTypes()
		var _option_names = struct_get_names(asset_type_options);
		var _option_name;
		var _funcs = [];
		var _fn;

		static __AsyncAutoIndexTypeFromOptionName = function(option_name) {
			var _option = asset_type_options[$ option_name]
			var _assettype = __KengineAssetUtils.__CreateAssetType(_option);
			if _assettype == false {
				_assettype = Kengine.Utils.Structs.Get(Kengine.asset_types, option_name);
			}
			if struct_exists(_option, "auto_index") {
				if _option.auto_index {
					Kengine.Utils.Assets.__IndexType(_assettype, _option.indexing_options);
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
				__KengineParserUtils.interpreter.System._function_add(string_replace(txrs[i].name, "ken_txr_fn_", ""), txrs[i].id, -1);
			}
			// Get scripts that start with ken_txr_constant_ and add them to TXR constants.
			txrs = Kengine.asset_types[$ "script"].assets.Filter(function(val) { return string_starts_with(val.name, "ken_txr_constant_");});
			for (var i=0; i<array_length(txrs); i++) {
				__KengineParserUtils.interpreter.System._constant_add(string_replace(txrs[i].name, "ken_txr_constant_", ""), txrs[i].id);
			}
			__KengineUtils.__CreateBaseObjectAsset();
			__KengineUtils.__StartExtensions();
			coroutine.Destroy();
			return true;
		}


		for (var i=0; i<array_length(_option_names); i++) {
			_option_name = _option_names[i];
			_fn = method({asset_type_options}, __AsyncAutoIndexTypeFromOptionName);
			array_push(_funcs, [_fn, [_option_name]])
		}

		var _coroutine = new __KengineCoroutine("assettype.autoindex", _funcs, __AsyncAutoIndexCallback);

		if (KENGINE_ASSET_TYPES_AUTO_INDEX_ASYNC) {
			_coroutine.Start();
			return _coroutine;
		} else {
			_coroutine.Immediate();
		}
		return true;
	}

	static __CreateAssetType = function(asset_type_option) {
		if array_contains(struct_get_names(Kengine.asset_types), asset_type_option.name) return false;

		asset_type_option.indexing_options = asset_type_option[$ "indexing_options"] ?? {}; // __KengineStructUtils.SetDefault(asset_type_option, "indexing_options", undefined);
		asset_type_option.var_struct = asset_type_option[$ "var_struct"] ?? {}; // __KengineStructUtils.SetDefault(asset_type_option, "var_struct", undefined);

		return new __KengineAssetType(asset_type_option.name, asset_type_option.asset_kind, asset_type_option.indexing_options, asset_type_option.var_struct);
	}

	static __IndexType = function(assettype, indexing_options) {
			__KengineBenchmarkUtils.Mark(string("AssetType: {0}: Indexing...", assettype.name), 2, false);
			assettype.IndexAssets(indexing_options);
			__KengineBenchmarkUtils.Mark(string("AssetType: {0}: Complete", assettype.name), 2, true);
	}
}
