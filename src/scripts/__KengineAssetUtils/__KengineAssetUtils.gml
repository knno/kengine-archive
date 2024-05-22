/**
 * @namespace Assets
 * @memberof Kengine.Utils
 * @description A struct containing Kengine asset utilitiy functions
 *
 */
function __KengineAssetUtils() : __KengineStruct() constructor {

	/**
	 * @function __AutoIndex
	 * @private
	 * @memberof Kengine.Utils.Assets
	 * @description Starts Auto Indexing assets. Called by Utils' __Start method.
	 * 
	 */
	static __AutoIndex = function() {

		__KengineBenchmarkUtils.Mark("AssetTypes: Indexing AssetTypes...", 1);

		// Create AssetTypes.
		var asset_type_options = KengineAssetTypes()
		var _option_names = struct_get_names(asset_type_options);
		var _option_name;
		var _funcs = [];
		var _fn;

		/**
		 * @function __AsyncAutoIndexTypeFromOptionName
		 * @private
		 * @memberof Kengine.Utils.Assets.__AutoIndex
		 * @description A utility method that indexes a specific asset type
		 * 
		 */
		static __AsyncAutoIndexTypeFromOptionName = function(option_name) { // {asset_type_options}
			var _option = asset_type_options[$ option_name]
			var _assettype = __KengineAssetUtils.__CreateAssetType(_option);
			if _assettype == false {
				_assettype = Kengine.Utils.Structs.Get(Kengine.asset_types, option_name);
			}
			Kengine.Utils.Assets.__IndexType(_assettype, _option.indexing_options);
		}

		/**
		 * @function __AsyncAutoIndexCallback
		 * @private
		 * @memberof Kengine.Utils.Assets.__AutoIndex
		 * @description A callback for when the all `assettype.autoindex.*` named coroutines finish.
		 * 
		 */
		static __AsyncAutoIndexCallback = function() {
			// When scripts are loaded we can set up the parser.
			// Get scripts that start with ken_txr_fn and add them to TXR functions.
			var txrs = Kengine.asset_types[$ "script"].assets.Filter(function(val) { return string_starts_with(val.name, "ken_txr_fn_");});
			for (var i=0; i<array_length(txrs); i++) {
				__KengineParserUtils.interpreter.System._function_add(string_replace(txrs[i].name, "ken_txr_fn_", ""), txrs[i].id, -1);
			}
			// Get scripts that start with ken_txr_constant_ and add them to TXR constants.
			txrs = Kengine.asset_types[$ "script"].assets.Filter(function(val) { return string_starts_with(val.name, "ken_txr_const_");});
			for (var i=0; i<array_length(txrs); i++) {
				__KengineParserUtils.interpreter.System._constant_add(string_replace(txrs[i].name, "ken_txr_const_", ""), txrs[i].id);
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
			return _coroutine;
		}
	}

	/**
	 * @function __CreateAssetType
	 * @private
	 * @memberof Kengine.Utils.Assets
	 * @description A function that takes an asset type option and creates an asset type from it. Called by `Kengine.Utils.Assets.__AutoIndex.__AsyncAutoIndexTypeFromOptionName`.
	 * @see {@link Kengine.Utils.Assets.__AutoIndex.__AsyncAutoIndexTypeFromOptionName}
	 * 
	 */
	static __CreateAssetType = function(asset_type_option) {
		if array_contains(struct_get_names(Kengine.asset_types), asset_type_option.name) return false;

		asset_type_option.indexing_options = asset_type_option[$ "indexing_options"] ?? {};
		asset_type_option.var_struct = asset_type_option[$ "var_struct"] ?? {};

		return new __KengineAssetType(asset_type_option.name, asset_type_option.asset_kind, asset_type_option.indexing_options, asset_type_option.var_struct);
	}

	/**
	 * @function __IndexType
	 * @private
	 * @memberof Kengine.Utils.Assets
	 * @description Indexes an asset type. with custom indexing options. Called by `Kengine.Utils.Assets.__AutoIndex.__AsyncAutoIndexTypeFromOptionName`.
	 * @see {@link Kengine.Utils.Assets.__AutoIndex.__AsyncAutoIndexTypeFromOptionName}
	 * 
	 */
	static __IndexType = function(assettype, indexing_options) {
			__KengineBenchmarkUtils.Mark(string("AssetType: {0}: Indexing...", assettype.name), 2, false);
			assettype.IndexAssets(indexing_options);
			__KengineBenchmarkUtils.Mark(string("AssetType: {0}: Complete", assettype.name), 2, true);
	}
}
