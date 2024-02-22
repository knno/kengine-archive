/**
 * @namespace parser
 * @memberof Kengine.utils
 * @description Parser utils.
 *
 */

Kengine.utils.parser = {
	__opts: {
		private: true,
	},
	constants: {
		default_private: false, // DO NOT CHANGE UNLESS YOU KNOW WHAT YOU ARE DOING.
	},
	_TXR: new _TXR(),
};

/**
 * @function interpret_val
 * @memberof Kengine.utils.parser
 * @description Interprets a value in custom script's TXR language.
 * @private
 * @param {Any} val
 * @return {Any}
 *
 */
Kengine.utils.parser.interpret_val = function(val, ex=undefined) {
	return Kengine.utils.parser.interpret("return " + string(val) + (string_ends_with(string_trim(val), ";") ? "" : ";"), ex);
}

/**
 * @function interpret_obj
 * @memberof Kengine.utils.parser
 * @description Interprets a value as an object. Try to find what kind of object it is. Maybe a YYasset or a KAsset script.
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
		var _arg0 = string_lower(arg0);
		a = asset_get_index(_arg0);
		if a == -1 {
			// Possibley an indexed script asset that is public...
			a = Kengine.asset_types.script.assets.get_ind(arg0, Kengine.cmps.cmp_val1_val2_name)
			if a != -1 {
				a = Kengine.asset_types.script.assets.get(a);
				if Kengine.utils.is_private(a) {
					a = -1;
				} else {
					return a.id;
				}
			}
		}
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
			
		} else if asset_get_type(arg0) == asset_script {
			a = Kengine.asset_types.script.assets.get_ind(arg0, Kengine.cmps.cmp_val1_val2_name)
			if a != -1 {
				a = Kengine.asset_types.script.assets.get(a);
				if Kengine.utils.is_private(a) {
					a = -1;
				} else {
					return a.id;
				}
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
	var arr = string_split(arg0, ".");

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
			var a = Kengine.asset_types.script.assets.get_ind(arr[0], Kengine.cmps.cmp_val1_val2_name);
			if a != -1 {
				a = Kengine.asset_types.script.assets.get(a);
				if Kengine.utils.is_private(a) {
					return undefined;
				} else {
					return a.id;
				}
			} else {
				return variable_global_get(arr[0]);	
			}
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
 * @description Interprets a source text of a custom script.
 * @see Kengine.utils.execute_script
 * @private
 * @param {String|Array<Any>} src_or_pg source text or a compiled pg
 * @param {Struct|Id.DsMap} [context] as a ds_map or a struct.
 * @return {Any}
 *
 */
Kengine.utils.parser.interpret = function(src_or_pg, context=undefined) {
	var compiled;
	var txr = Kengine.utils.parser._TXR;
	if is_string(src_or_pg) {
		compiled = txr.Compiler._compile(src_or_pg);
	} else {
		compiled = src_or_pg;
	}
	var dsa;
	context = context ?? {};
	if is_struct(context) {
		dsa = ds_map_create(); // Create a temporary DS map.
		var dsan = struct_get_names(context);
		for (var i=0; i<array_length(dsan); i++) {
			ds_map_add(dsa, dsan[i], context[$ dsan[i]]);
		}
	} else {
		dsa = context;
	}
	var th = txr.System._thread_create(compiled, dsa);
	txr.System._thread_resume(th);
	var result = th[__TXR_THREAD.RESULT];
	txr.System._thread_destroy(th);

	if is_struct(context) {	// Clean up temporary DS map.
		ds_map_destroy(dsa);
	}
	return result;
}

/**
 * @function interpret_asset
 * @memberof Kengine.utils.parser
 * @description Interprets an asset.
 * @private
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
		scr = Kengine.utils.get_asset(KENGINE_CUSTOM_SCRIPT_ASSETTYPE_NAME, asset);
	}

	if not scr.is_compiled {
		scr.compile();
	}

	var dict2 = Kengine.utils.structs.merge({a: dict}, {a: {
		this: this,
		script_asset: scr,
		script_name: scr.name,
		arguments: args,
	}}, true).a;

	return Kengine.utils.parser.interpret(scr.pg, dict2);
}

/**
 * @namespace txr
 * @memberof Kengine.utils.parser
 * @description TXR compatibility utils.
 * 
 */
Kengine.utils.parser.txr = {

	/** 
	 * @function dot2ident
	 * @memberof Kengine.utils.parser.txr
	 * @private
	 * @param {String} dot
	 * @return {String}
	 * 
	 */
	dot2ident: function(dot) {
		return string_replace_all(dot, ".", "___");
	},

	/** 
	 * @function ident2dot
	 * @memberof Kengine.utils.parser.txr
	 * @private
	 * @param {String} ident 
	 * @return {String}
	 * 
	 */
	ident2dot: function(ident) {
		return string_replace_all(ident, "___", ".");
	},

	/**
	 * @function get_ident
	 * @memberof Kengine.utils.parser.txr
	 * @private
	 * @param {String} ident
	 * @param {Struct} locals
	 * @param {Bool} convertdot
	 * @return {Any}
	 * 
	 */
	get_ident: function(ident, locals, convertdot=true) {
		if convertdot {
			ident = Kengine.utils.parser.txr.ident2dot(ident);
		}
		var curr = undefined;
		if locals != undefined {
			curr = locals[$ ident];
		}

		var k_ = curr;
		switch(ident) {
			case "Kengine": curr = {
				asset_types: Kengine.asset_types,
				utils: Kengine.utils,
				mods: Kengine.mods,
			}; break;
			case "global": curr = locals break;
			case "R": curr = Kengine.asset_types; break;
			case "Fn": curr = Kengine.utils; break;
		}
		if curr != undefined {
			return curr;
		}

		curr = Kengine.utils.parser.interpret_keyval(ident);
		if curr != undefined {
			// Do return arrays.
			if is_array(curr) {
				return curr;
			}
			// Use rulings.
			var r = 0;
			var rules = KENGINE_PARSER_FIELD_RULES;
			for (var i=0; i<array_length(rules); i++) {
				switch (rules[i]) {
					case "?": // allow only not private (public)
						if ! Kengine.utils.is_private(curr) == true {
							continue
						} else {
							r = "1";
						}
						break;
					case "!?": // allow only private (not public)
						if ! Kengine.utils.is_private(curr) == false {
							continue
						} else {
							r = "2";
						}
						break;
				}
			}
			if r == 0 {
				return curr;
			}
		} else {
			return undefined;
		}
	},

	/**
	 * @function set_ident
	 * @memberof Kengine.utils.parser.txr
	 * @private
	 * @param {String} ident
	 * @param {Any} val
	 * @param {Struct} locals
	 * @param {Bool} convertdot
	 * @return {Bool}
	 * 
	 */
	set_ident: function(ident, val, locals, convertdot=true) {
		if convertdot {
			ident = Kengine.utils.parser.txr.ident2dot(ident);
		}

		var curr = Kengine.utils.parser.txr.get_ident(ident, locals, false); // s_1;

		if curr != undefined {
			variable_instance_set(curr, s_2, val);
			return true;
		}
		Kengine.utils.parser._TXR.System._function_error = ident + " is not assignable.";
		var obj = Kengine.utils.structs.get(Kengine.utils.parser._TXR.System._thread_current[__TXR_THREAD.LOCALS], "script_object");
		var ev = Kengine.utils.structs.get(Kengine.utils.parser._TXR.System._thread_current[__TXR_THREAD.LOCALS], "event");
		Kengine.console.echo_error("Error in: " + string(obj) + ", event: " + string(ev) + ": " + string(Kengine.utils.parser._TXR.System._function_error));
		return false;
	},

	/**
	 * @function get_field
	 * @memberof Kengine.utils.parser.txr
	 * @private
	 * @param {Any} curr
	 * @param {String} field
	 * @param {Struct} locals
	 * @return {Any}
	 * 
	 */
	get_field: function(curr, field, locals) {
		if Kengine.utils.is_public(curr, field) {
			curr = variable_instance_get(curr, field);
			if not Kengine.utils.is_private(curr) return curr;
		}
		var __ap = Kengine.utils.structs.get(locals, "__allow_private");
		if __ap != undefined {
			if __ap {
				if Kengine.utils.is_private(curr, field) {
					return variable_instance_get(curr, field);
				}
			}
		}
	},

	/**
	 * @function set_field
	 * @memberof Kengine.utils.parser.txr
	 * @private
	 * @param {Any} curr
	 * @param {String} field
	 * @param {Any} value
	 * @param {Struct} locals
	 * @return {Any}
	 * 
	 */
	set_field: function(curr, field, value, locals) {
		if Kengine.utils.is_public(curr, field) {
			if not Kengine.utils.is_readonly(curr, field) {
				variable_instance_set(curr, field, value);
				return value;
			} else {
				throw "Cannot set readonly member.";
			}
		}
		var __ap = Kengine.utils.structs.get(locals, "__allow_private");
		if __ap != undefined {
			if __ap {
				if Kengine.utils.is_private(curr, field) {
					variable_instance_set(curr, field, value);
					return value;
				}
			}
		}
	},
}

function ken_init_ext_parser() {
	/// txr_init();
	/// txr_function_default = ken_txr_default_function;
	/// txr_function_ident = Kengine.utils.parser.txr.get_ident;
	/// txr_function_set_ident = Kengine.utils.parser.txr.set_ident;
	
	// Get scripts that start with ken_txr_ and add them to TXR functions.
	var txrs = Kengine.asset_types.script.assets.filter(function(val) { return string_starts_with(val.name, "ken_txr_");});
	for (var i=0; i<array_length(txrs); i++;) {
		Kengine.utils.parser._TXR.System._function_add(string_replace(txrs[i].name, "ken_txr_", ""), txrs[i].id, -1);
	}
}
