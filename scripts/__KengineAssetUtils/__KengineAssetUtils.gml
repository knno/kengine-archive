function __KengineAssetUtils() : __KengineStruct() constructor {

	static AutoIndex = function() {

		__KengineBenchmarkUtils.Mark("AssetTypes: Indexing AssetTypes...", 1);

		// Create AssetTypes.
		var _option_names = struct_get_names(Kengine.asset_type_options);
		__kengine_log(_option_names);
		var _option_name;
		var _funcs = [];
		var _fn;
		
		var __AsyncAutoIndexTypeFromOptionName = function() {
			/// var_struct {option_name}
			var _option = __KengineStructUtils.Get(Kengine.asset_type_options, option_name);
			var _assettype = __KengineAssetUtils.CreateAssetType(_option);
			if _assettype == false {
				_assettype = __KengineStructUtils.Get(Kengine.asset_types, option_name);
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
		var __AsyncAutoIndexCallback = function() {
			coroutine.Destroy();
			__KengineBenchmarkUtils.Mark(string("AssetTypes: Complete in {0}", __KengineBenchmarkUtils.CalcTimerDiff(2)), 1, false);

			// When scripts are loaded we can set up the parser.
			__KengineParser.__SetupTxr();
			__KengineUtils.__CreateBaseObjectAsset();
			__KengineUtils.__StartExtensions();
		}


		for (var i=0; i<array_length(_option_names); i++) {
			_option_name = _option_names[i];
			_fn = method({option_name: _option_name}, __AsyncAutoIndexTypeFromOptionName);
			__kengine_log(_option_name);
			__kengine_log(_fn);
			array_push(_funcs, _fn)
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

		__kengine_log("CreateAssetType 1");
		__KengineStructUtils.SetDefault(asset_type_option, "indexing_options", undefined);
		__KengineStructUtils.SetDefault(asset_type_option, "var_struct", undefined);
		__kengine_log("CreateAssetType 1.5");

		var _assettype = new __KengineAssetType(asset_type_option.name, asset_type_option.asset_kind, asset_type_option.indexing_options, asset_type_option.var_struct);
		__kengine_log("CreateAssetType 2");
		return _assettype;
	}

	static IndexType = function(assettype, indexing_options) {
			__KengineBenchmarkUtils.Mark(string("AssetType: {0}: Indexing...", assettype.name), 2, false);
			assettype.IndexAssets(indexing_options);
			__KengineBenchmarkUtils.Mark(string("AssetType: {0}: Complete", assettype.name), 2, true);
	}
}
__KengineAssetUtils();
