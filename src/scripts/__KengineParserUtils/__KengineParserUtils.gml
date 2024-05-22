/**
 * @namespace Parser
 * @memberof Kengine.Utils
 * @description A struct containing Kengine parser utilitiy functions
 *
 */
function __KengineParserUtils() : __KengineStruct() constructor {

	static interpreter = new __TXR();

	/** 
	 * @function __dot2ident
	 * @memberof Kengine.Utils.Parser
	 * @private
	 * @param {String} dot
	 * @return {String}
	 * 
	 */
	static __dot2ident = function(dot) {
		return string_replace_all(dot, ".", "___");
	}

	/** 
	 * @function __ident2dot
	 * @memberof Kengine.Utils.Parser
	 * @private
	 * @param {String} ident 
	 * @return {String}
	 * 
	 */
	static __ident2dot = function(ident) {
		return string_replace_all(ident, "___", ".");
	}

	static __InterpretValue = function(value, context=undefined) {
		var _pre;
		if string_count("=", value) > 0 { _pre=""; } else { _pre="return "; }
		return __InterpretTxr(_pre + string(value) + (string_ends_with(string_trim(value), ";") ? "" : ";"), context);
	}

	/**
	 * @function __InterpretObject
	 * @memberof Kengine.Utils.Parser
	 * @private
	 * @description Tries to interpret an object: Find what kind of object it is. Maybe a YYasset (KAsset scripts excluded.)
	 * @param {Any} object
	 * @param {Bool} [show_err=true] Whether to show an error on failure.
	 * @return {Any}
	 */
	static __InterpretObject = function(object, show_err=true) {
		var _arg0 = object;
		var _a = asset_get_index(_arg0);
		if _a == -1 {
			_arg0 = string_lower(_arg0);
			_a = asset_get_index(_arg0);
			if _a == -1 {
				// Possibley an indexed script asset that is public...
				_a = Kengine.asset_types.script.assets.GetInd(_arg0, __KengineCmpUtils.cmp_val1_val2_name)
				if _a != -1 {
					_a = Kengine.asset_types.script.assets.Get(_a);
					if __KengineStructUtils.IsPrivate(_a) {
						_a = -1;
					} else {
						return _a.id;
					}
				}
			}
		}
		var _e = show_err ?? false;

		if _a != -1 {
			if asset_get_type(_arg0) == asset_object {
				if object_exists(_a) {
					var _o = instance_find(_a, instance_number(_a)-1);
					if instance_exists(_o) {
						return _o;
					} else {
						return _a;
					}
				} else {
					if _e Kengine.console.echo_error("Object named \"" + string(object)+ "\" does not exist.");
				}
				
			} else if asset_get_type(_arg0) == asset_script {
				_a = Kengine.asset_types.script.assets.GetInd(_arg0, __KengineCmpUtils.cmp_val1_val2_name)
				if _a != -1 {
					_a = Kengine.asset_types.script.assets.Get(_a);
					if __KengineStructUtils.IsPrivate(_a) {
						_a = -1;
					} else {
						return _a.id;
					}
				}
			} else {
				if _e Kengine.console.echo_error("Name \"" + string(object) + "\" is not an object.");
			}
		} else {
			if string_digits(_arg0) == _arg0 {
				var _f = undefined;
				var _search = _arg0;
				if asset_get_type(_arg0) == asset_object {
					return asset_get_index(_arg0);
				}

				if instance_exists(real(_search)) {_f = real(_search);};
				if _f != undefined {
					return _f;
				} else {
					if _e Kengine.console.echo_error("Object id " + string(object) + " does not exist.");
				}
			}
		}
		return undefined;
	}

	/**
	 * @function __InterpretDotValue
	 * @memberof Kengine.Utils.Parser
	 * @description Interprets a dot notation value (dotvalue)
	 * @private
	 * @param {Any} dotvalue
	 * @return {Any} Undefined if not found. 
	 *
	 */
	static __InterpretDotValue = function(dotvalue) {
		var _arg0;
		if is_string(dotvalue) {
			_arg0 = string(dotvalue);
			if string_char_at(_arg0, 1) == "." {
				_arg0 = string_copy(_arg0, 2, string_length(_arg0) - 1);
			}
		} else {
			return dotvalue;
		}
		var _arr = string_split(_arg0, ".");
		var _tmp;
		var _a;

		if array_length(_arr) >= 3 {
			var _i = 0;
			var _main_obj = __InterpretValue(string(_arr[_i]) + "." + string(_arr[_i+1]));
			var _val = _main_obj;
			var _attr = _arr[_i+2];
			for (_i=3; _i<array_length(_arr)+1; _i+=1)
				{
				_tmp = __InterpretObject(_main_obj, false);
				if (_tmp != undefined)
					{
					_main_obj = _tmp;
					}
				else
					{
					if is_struct(_main_obj)
						{
						_tmp = variable_struct_get(_main_obj, _attr);
						if (_tmp != undefined) _main_obj = _tmp;
						if _i == array_length(_arr) {
							if _main_obj != undefined return _main_obj;
						}
						_attr = _arr[_i];
						}
					else if is_array(_main_obj)
						{
						_tmp = array_get(_main_obj, _attr);
						if (_tmp != undefined) _main_obj = _tmp;
						if _i == array_length(_arr) {
							if _main_obj != undefined return _main_obj;
						}
						_attr = _arr[_i];
						}
					}
				if _main_obj != undefined {
					if (variable_instance_exists(_main_obj, _attr))
						{
						_main_obj = variable_instance_get(_main_obj, _attr);
						_val = _main_obj;
						_attr = _arr[_i];
						if _i == array_length(_arr)-1
							{
							return _val;
							}
					} else {
						return undefined;
					}
				} else {
					return undefined;
				}
			}
		} else if (array_length(_arr) == 2) {
			if (is_string(_arr[0])) {
				if (_arr[0] == "global") {
					if (variable_global_exists(_arr[1])) {
						return variable_global_get(_arr[1]);
					}
				}
			}
			_arr[0] = __InterpretObject(_arr[0], false);
			if (_arr[0] != undefined) {
				if (variable_instance_exists(_arr[0], _arr[1])) {
					return variable_instance_get(_arr[0], _arr[1]);
				}
			}
		} else if (array_length(_arr) == 1) {
			if (variable_global_exists(_arr[0])) {
				_a = Kengine.asset_types.script.assets.GetInd(_arr[0], __KengineCmpUtils.cmp_val1_val2_name);
				if _a != -1 {
					_a = Kengine.asset_types.script.assets.Get(_a);
					if __KengineStructUtils.IsPrivate(_a) {
						return undefined;
					} else {
						return _a.id;
					}
				} else {
					return variable_global_get(_arr[0]);	
				}
			} else {
				_tmp = __InterpretObject(_arr[0], false);
				if (_tmp != undefined) {
					return _tmp;
				}
			}
		}
		return undefined;
	}

	/**
	 * @function __InterpretTxr
	 * @memberof Kengine.Utils.Parser
	 * @description Interprets a source text of a custom (txr) script.
	 * @see Kengine.Utils.Execute
	 * @private
	 * @param {String|Array<Any>} src_or_pg source text or a compiled pg
	 * @param {Struct|Id.DsMap} [context] as a ds_map or a struct.
	 * @return {Any}
	 *
	 */
	static __InterpretTxr = function(src_or_pg, context=undefined) {
		static _txr = __KengineParserUtils.interpreter;

		var _compiled;
		if is_string(src_or_pg) {
			_compiled = _txr.Compiler._compile(src_or_pg);
		} else {
			_compiled = src_or_pg;
		}
		var _dsa;
		context = context ?? {};
		if is_struct(context) {
			_dsa = ds_map_create(); // Create a temporary DS map.
			var _dsan = struct_get_names(context);
			for (var i=0; i<array_length(_dsan); i++) {
				ds_map_add(_dsa, _dsan[i], context[$ _dsan[i]]);
			}
		} else {
			_dsa = context;
		}
		var _thread = _txr.System._thread_create(_compiled, _dsa);
		_txr.System._thread_resume(_thread);
		var _result = _thread[__TXR_THREAD.RESULT];
		_txr.System._thread_destroy(_thread);
	
		if is_struct(context) {	// Clean up temporary DS map.
			ds_map_destroy(_dsa);
		}
		return _result;
	}

	/**
	 * @function InterpretAsset
	 * @memberof Kengine.Utils.Parser
	 * @description Interprets a script asset.
	 * @param {String|Kengine.Asset} asset Asset or name of the asset.
	 * @param {Any} this `this` arg in the asset runtime script.
	 * @param {Struct} [dict] An extra context in the asset runtime script.
	 * @param {Array<Any>} [args] `arguments` in the asset runtime script.
	 * @return {Any}
	 *
	 */
	static InterpretAsset = function(asset, this=undefined, dict=undefined, args=undefined) {
		var _scr = asset;
		dict = dict ?? {};
		args = args ?? [];

		if not is_instanceof(asset, __KengineAsset) {
			_scr = __KengineUtils.GetAsset(KENGINE_CUSTOM_SCRIPT_ASSETTYPE_NAME, asset);
		}

		if not _scr.is_compiled {
			_scr.Compile();
		}

		if this == undefined and dict[$ "this"] != undefined {
			this = dict.this;
		}

		var dict2 = __KengineStructUtils.Merge({a: dict}, {a: {
			this: this,
			script_asset: _scr,
			script_name: _scr.name,
			arguments: args,
		}}, true).a;
		
		dict2[$ "self"] = this;

		return __InterpretTxr(_scr.pg, dict2);
	}

	static __Interpret = function(thing, context=undefined) {
		var _scr
		if is_instanceof(thing, __KengineAsset) {
			if not thing.is_compiled {
				thing.Compile();
			}
			_scr = thing.pg;
		} else if is_string(thing) {
			_scr = thing;
		} else if is_callable(thing) {
			var _args = []
			if context != undefined {
				if struct_exists(context, "arguments") {
					_args = context.arguments;
				}
			}
			return __KengineUtils.Execute(_scr, _args);
		}
		return __InterpretTxr(_scr, context);
	}

}
