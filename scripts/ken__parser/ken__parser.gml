/**
 * @namespace parser
 * @memberof Kengine.utils
 * @description Parser utils.
 *
 */

Kengine.utils.parser = {
	constants: {
		default_private: false,
	}
};

/**
 * @name asset_type_name
 * @memberof Kengine.utils.parser
 * @type {String}
 * @description The default AssetType name for custom scripts.
 *
 */
Kengine.utils.parser.asset_type_name = Kengine.constants.CUSTOM_SCRIPT_ASSETTYPE_NAME;

/**
 * @function interpret_val
 * @memberof Kengine.utils.parser
 * @description Interprets a value in VSL's TXR language.
 * @param {Any} val
 * @return {Any}
 *
 */
Kengine.utils.parser.interpret_val = function(val) {
	return Kengine.utils.parser.interpret("return " + string(val) + ";");
}

/**
 * @function interpret_obj
 * @memberof Kengine.utils.parser
 * @description Interprets a value as an object. Try to find what kind of object it is. Maybe an YYasset?
 * Return undefined if not found.
 * @private
 * @param {Any} val
 * @param {Bool} [show_err] Whether to show errors
 * @return {Any}
 *
 */
Kengine.utils.parser.interpret_obj = function(val, show_err=true) {
	var arg0 = val;
	var a = asset_get_index(arg0);
	if a == -1 {
		arg0 = string_lower(arg0);
		a = asset_get_index(arg0);
	}
	var e = show_err ?? false;

	if a != -1 {
		if asset_get_type(arg0) == asset_object {
			if object_exists(a) {
				var o = instance_find(a, instance_number(a)-1);
				if instance_exists(o) {
					return o;
				} else {
					return a;
				}
			} else {
				if e Kengine.console.echo_error("Object named \"" + string(val)+ "\" does not exist.");
			}
		} else {
			if e Kengine.console.echo_error("Name \"" + string(val) + "\" is not an object.");
		}
	} else {
		if string_digits(arg0) == arg0 {
			var f = undefined;
			var search = arg0;
			if asset_get_type(arg0) == asset_object {
				return asset_get_index(arg0);
			}
			
			if instance_exists(real(search)) {f = real(search);};
			if f != undefined {
				return f;
			} else {
				if e Kengine.console.echo_error("Object id " + string(val) + " does not exist.");
			}
		}
	}
	return undefined;
}

/**
 * @function interpret_keyval
 * @memberof Kengine.utils.parser
 * @description Interprets a dot notation value (keyval)
 * Return undefined if not found.
 * @private
 * @param {Any} keyval
 * @return {Any}
 *
 */
Kengine.utils.parser.interpret_keyval = function(keyval) {
	var arg0;
	if is_string(keyval) {
		arg0 = string(keyval);
		if string_char_at(arg0, 1) == "." {
			arg0 = string_copy(arg0, 2, string_length(arg0) - 1);
		}
	} else {
		return keyval;
	}
	var arr = string_explode(".", arg0);

	if array_length(arr) >= 3 {
		var i = 0;
		var main_obj = Kengine.utils.parser.interpret_val(string(arr[i]) + "." + string(arr[i+1]));
		var _val = main_obj;
		var attr = arr[i+2];
		for (i=3; i<array_length(arr)+1; i+=1)
			{
			var tmp = Kengine.utils.parser.interpret_obj(main_obj, false);
			if (tmp != undefined)
				{
				main_obj = tmp;
				}
			else
				{
				if is_struct(main_obj)
					{
					tmp = variable_struct_get(main_obj, attr);
					if (tmp != undefined) main_obj = tmp;
					if i == array_length(arr) {
						if main_obj != undefined return main_obj;
					}
					attr = arr[i];
					}
				else if is_array(main_obj)
					{
					tmp = array_get(main_obj, attr);
					if (tmp != undefined) main_obj = tmp;
					if i == array_length(arr) {
						if main_obj != undefined return main_obj;
					}
					attr = arr[i];
					}
				}
			if main_obj != undefined {
				if (variable_instance_exists(main_obj, attr))
					{
					main_obj = variable_instance_get(main_obj, attr);
					_val = main_obj;
					attr = arr[i];
					if i == array_length(arr)-1
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
	} else if (array_length(arr) == 2) {
		if (is_string(arr[0])) {
			if (arr[0] == "global") {
				if (variable_global_exists(arr[1])) {
					return variable_global_get(arr[1]);
				}
			}
		}
		arr[0] = Kengine.utils.parser.interpret_obj(arr[0], false);
		if (arr[0] != undefined) {
			if (variable_instance_exists(arr[0], arr[1])) {
				return variable_instance_get(arr[0], arr[1]);
			}
		}
	} else if (array_length(arr) == 1) {
		if (variable_global_exists(arr[0])) {
			return variable_global_get(arr[0]);
		} else {
			var tmp = Kengine.utils.parser.interpret_obj(arr[0], false);
			if (tmp != undefined) {
				return tmp;
			}
		}
	}
	return undefined;
}

/**
 * @function interpret
 * @memberof Kengine.utils.parser
 * @private
 * @description Interprets a source text kscript
 * @param {String|Array<Any>} src_or_pg source text or a compiled pg
 * @param {Struct|Id.DsMap} [context] as a ds_map or a struct.
 * @return {Any}
 *
 */
Kengine.utils.parser.interpret = function(src_or_pg, context=undefined) {
	var compiled;
	if is_string(src_or_pg) {
		compiled = txr_compile(src_or_pg);
	} else {
		compiled = src_or_pg;
	}
	var dsa;
	context = context ?? {};
	if is_struct(context) {
		dsa = ds_map_create();
		var dsan = struct_get_names(context);
		for (var i=0; i<array_length(dsan); i++) {
			ds_map_add(dsa, dsan[i], context[$ dsan[i]]);
		}
	} else {
		dsa = context;
	}
	var th = txr_thread_create(compiled, dsa);
	txr_thread_resume(th);
	// var dsan2 = ds_map_keys_to_array(th[txr_thread.locals]);
	// var dsanv = ds_map_values_to_array(th[txr_thread.locals]);
	var result = th[txr_thread.result];
	txr_thread_destroy(th);

	// Did we create a DS map? destroy it.
	if is_struct(context) {
		ds_map_destroy(dsa);
	}
	return result;
}

/**
 * @function interpret_asset
 * @memberof Kengine.utils.parser
 * @private
 * @description Interprets an asset.
 * @param {String|Kengine.Asset} asset Asset or name of the asset.
 * @param {Any} this `this` arg in the asset runtime script.
 * @param {Struct} [dict] An extra context in the asset runtime script.
 * @param {Array<Any>} [args] `arguments` in the asset runtime script.
 * @return {Any}
 *
 */
Kengine.utils.parser.interpret_asset = function(asset, this, dict=undefined, args=undefined) {

	var scr = asset;
	dict = dict ?? {};
	args = args ?? [];

	if not is_instanceof(asset, Kengine.Asset) {
		scr = Kengine.utils.get_asset(Kengine.utils.parser.asset_type_name, asset);
	}

	if not scr.is_compiled {
		scr.compile();
	}

	var dict2 = struct_merge({a: dict}, {a: {
		this: this,
		script_asset: scr,
		script_name: scr.name,
		arguments: args,
	}}, true).a;

	return Kengine.utils.parser.interpret(scr.pg, dict2);
}

Kengine.utils.parser.txr = {

	/** 
	 * @function dot2ident
	 * @memberof Kengine.utils.parser.txr
	 * @param {String} dot 
	 * @return {String}
	 */
	dot2ident: function(dot) {
		return string_replace_all(dot, ".", "___");
	},

	/** 
	 * @function ident2dot
	 * @memberof Kengine.utils.parser.txr
	 * @param {String} ident 
	 * @return {String}
	 */
	ident2dot: function(ident) {
		return string_replace_all(ident, "___", ".");
	},

	get_ident: function(ident, locals, convertdot=true) {
		if convertdot {
			ident = Kengine.utils.parser.txr.ident2dot(ident);
		};
		var pfirst = string_pos(".", ident);
		var s_1; var s_2;
		s_1 = string_copy(ident, 1, pfirst - 1);
		s_2 = string_copy(ident, pfirst + 1, string_length(ident)-pfirst);
		var curr = undefined;
		if locals != undefined {
			curr = locals[$ s_1] ?? locals[$ ident];
		}

		var idents = string_split(ident, ".");
		var k_ = curr;

		for (var i=0; array_length(idents)>0; i++) {
			if i == 0 {
				switch(idents[i]) {
					// case "K": curr = Kengine; break;
					case "R": curr = Kengine.asset_types; break;
					case "Fn": curr = Kengine.utils; break;
				}
				if curr != undefined {
					array_delete(idents, 0, 1);
					k_ = curr;
					continue;
				} else {
					curr = Kengine.utils.parser.interpret_keyval(idents[0]);
					if curr != undefined {
						array_delete(idents, 0, 1);
					}
					k_ = curr;
					continue;
				}
			}
			if array_length(idents) > 0 {
				if typeof(curr) == "string" {
					array_delete(idents, 0, 1);
					if array_length(idents) == 0 {
						k_ = curr;
					} else {
						k_ = curr + "." + string_implode(".", idents);
					}
				} else {
					// feather ignore GM1044
					if is_struct(curr) {
						curr = variable_struct_get(curr, idents[0]);
					}
					array_delete(idents, 0, 1);
					k_ = curr;
				}
			} else {
				k_ = curr;
			}
		}
		
		curr = Kengine.utils.parser.interpret_keyval(k_);
		if curr != undefined {
			// Check privates if wanted.
			if Kengine.utils.structs.get(locals, "_allow_private") == true {
				return curr;
			}
			else {
				if is_array(curr) {return curr;}
				if Kengine.utils.is_private(curr, Kengine.utils.parser.constants.default_private) == false {
					return curr;
				}
			}
		} else {
			return undefined;
		}
	},

	set_ident: function(ident, val, locals, convertdot=true) {
		if convertdot {
			ident = Kengine.utils.parser.txr.ident2dot(ident);
		}
		var plast = string_last_pos(".", ident);
		var s_1 = string_copy(ident, 1, plast - 1);
		var s_2 = string_copy(ident, plast + 1, string_length(ident)-plast);

		var curr;
		if s_1 == "" {
			curr = undefined; // Empty struct.
		} else if s_1 == "global" {
			curr = global;
		} else {
			curr = Kengine.utils.parser.txr.get_ident(s_1, locals, false);
		}

		if curr != undefined {
			variable_instance_set(curr, s_2, val);
			return true;
		}
		txr_function_error = ident + " is not assignable.";
		var obj = txr_thread_current[txr_thread.locals][?"vsl_object"];
		var ev = txr_thread_current[txr_thread.locals][?"vsl_event"];
		Kengine.console.echo_error("Error in " + string(obj) + " event " + string(ev) + ": " + string(txr_function_error));
		return false;
	}
}

function ken_script_create(insta, _x, _y, _layer="Instances", var_struct={}) {
	return ken_instance_create(insta, _x,_y, _layer, var_struct)
}

function ken_init_ext_parser() {
	txr_init();
	txr_function_default = ken__txr_default_function;
	txr_function_add("print", ken__txr_print, 1);
	txr_function_add("print_error", ken__txr_print_error, 1);
	txr_function_add("print_debug", ken__txr_print_debug, 1);
	txr_function_add("array_get", ken__txr_array_get, 2);
	txr_function_add("array_set", ken__txr_array_set, 3);
}
