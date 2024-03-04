/**
 * @namespace Structs
 * @memberof Kengine.Utils
 * @description A struct containing Kengine structs utilitiy functions
 *
 */
function __KengineStructUtils() : __KengineStruct() constructor {

    /**
     * @function Exists
     * @memberof Kengine.Utils.Structs
     * @description Check whether a struct member exists.
     * @param {Struct} _struct The struct.
     * @param {String|Struct} name The name or hash key.
     * @return {Bool} Whether the struct member exists.
     *
     */
    static Exists = function(_struct, name) {
		if is_undefined(_struct) return false;

		if !is_struct(_struct) {
            return variable_instance_exists(_struct, name);
        } else if is_string(name) {
			show_debug_message(_struct);
			show_debug_message(name);
            return struct_exists(_struct, name);
        } else if is_struct(name) {
            return struct_exists(_struct, name.name);
        } else {
            //return struct_get_from_hash(_struct, name) != undefined;
        }
    }

    /**
     * @function Get
     * @memberof Kengine.Utils.Structs
     * @description Get a struct member.
     * @param {Struct|Id.Instance|Constant.All|Any} _struct The struct to get from.
     * @param {String|Real|Struct} name The hash key to use. If it's a struct, uses "hash" attr.
     * @return {Any} The value.
     * 
     */
    static Get = function(_struct, name) {
		if is_undefined(_struct) return undefined;
        if __KengineStructUtils.Exists(_struct, name) {
            if !is_struct(_struct) {
                return variable_instance_get(_struct, name);
            }
			return _struct[$ name]; // struct_get(_struct, name);
            // return struct_get_from_hash(_struct, __KengineHashkeyUtils.hash(name));
        }
		return undefined;
    }

    /**
     * @function SetDefault
     * @memberof Kengine.Utils.Structs
     * @description Set a struct member with a default value if it's undefined, otherwise it keeps the value.
     * @param {Struct} _struct The struct.
     * @param {String|Struct} name The name or hash key.
     * @param {Any} value The value.
     * @return {Any} The new value. Or the default value.
     *
     */
    static SetDefault = function(_struct, name, value) {
        if not __KengineStructUtils.Exists(_struct, name) {
            __KengineStructUtils.Set(_struct, name, value);
        }
        return __KengineStructUtils.Get(_struct, name);
    }

    /**
     * @function Set
     * @memberof Kengine.Utils.Structs
     * @description Set a struct member.
     * @param {Struct} _struct The struct.
     * @param {String|Struct} name The name or hash key.
     *
     */
    static Set = function(_struct, name, value) {
        if !is_struct(_struct) {
            variable_instance_set(_struct, name, value);
        }
		_struct[$ name] = value
		return value;

		return struct_set(_struct, name, value);
		// struct_set_from_hash(_struct, __KengineHashkeyUtils.hash(name), value);
    }

    /**
     * @function Merge
     * @memberof Kengine.Utils.Structs
     * @description	Merge struct2 to struct1 recursively.
     * @param {Struct} struct1 The main struct.
     * @param {Struct} struct2 The secondary struct.
     * @param {Bool} merge_arrays Whether to merge arrays.
     * @return {Struct} The first struct after being merged.
     *
    */
    static Merge = function(struct1, struct2, merge_arrays=false) {
        var props = struct_get_names(struct2);
        for(var i = 0; i < array_length(props); i++) {
            var val = struct2[$ props[i]];
            if (is_struct(val)) {
                if !struct_exists(struct1, props[i]) {
                    struct1[$ props[i]] = val;
                } else {
                    __KengineStructUtils.Merge(struct1[$ props[i]], val, merge_arrays);
                }
            } else {
                if is_array(val) and is_array(struct1[$ props[i]]) and merge_arrays {
                    struct1[$ props[i]] = array_concat(struct1[$ props[i]], val);
                } else {
                    struct1[$ props[i]] = val;
                }
            }
        }
        return struct1;
    }

    /**
     * @function DotSet
     * @memberof Kengine.Utils.Structs
     * @description Set a struct member using dot notation.
     * @param {Struct} _struct The struct.
     * @param {String} key The dot notation of key.
     * @param {String} val The value.
     *
     */
    static DotSet = function(_struct, key, val) {
        var keys = string_split(key, ".");
        var curr = _struct;
        var i = 0;
        for (i=0; i<array_length(keys)-1; i++) {
            if not __KengineStructUtils.Exists(curr, keys[i]) {
                __KengineStructUtils.Set(curr, keys[i], {});
            }
            curr = __KengineStructUtils.Get(curr, keys[i]);
        }
        return __KengineStructUtils.Set(curr, keys[i], val);
    }

    /**
     * @function DotGet
     * @memberof Kengine.Utils.Structs
     * @description Get a struct member using dot notation.
     * @param {Struct} _struct The struct.
     * @param {String} key The dot notation of key.
     * @param {Any} [default_val=undefined] The default value to return.
     *
     */
    static DotGet = function(_struct, key, default_val=undefined) {
        var keys = string_split(key, ".");
        var curr = _struct;
        var i = 0;
        for (i=0; i<array_length(keys)-1; i++) {
            if __KengineStructUtils.Exists(curr, keys[i]) {
                curr = __KengineStructUtils.Get(curr, keys[i]);
            } else {
                return default_val;
            }
        }
        return __KengineStructUtils.Get(curr, keys[i]) ?? default_val;
    }


	/**
	 * @function IsPublic
	 * @memberof Kengine.Utils.Structs
	 * @description Return whether `object` or its member is public or not. By reading the struct's `__opts.public`.
     * @param {Any} _object
	 * @param {String} [member_name=undefined] The member if you want to get its access publicity.
	 * @param {Any} [default_val=undefined]
	 * @return {Bool}
	 *
	 */
	static IsPublic = function(_object, member_name=undefined, default_val=undefined) {
        var halt = undefined;
		var rules = KENGINE_PARSER_FIELD_RULES;
		var opts = __KengineStructUtils.Get(_object, "__opts");
		var _pub = false;
		if is_struct(opts) {
			_pub = __KengineStructUtils.Get(opts, "public");
		}
		if _pub == false or _pub == undefined {
			if array_length(rules) > 0 {
				var r = "";
				for (var j=0; j<array_length(rules); j++) {
					switch (rules[j]) {
						case "?": // allow only not private
							if __KengineStructUtils.IsPrivate(_object) == false {
								continue;
							}
							halt = __KengineParserUtils.__Interpreter.System._sfmt("Cannot access private members of (%).", string(_object));
							break;

						case "!?": // allow only is private
							if __KengineStructUtils.IsPrivate(_object) == true {
								continue;
							}
							halt = __KengineParserUtils.__Interpreter.System._sfmt("Cannot access members of (%).", string(_object));
							break;

						default:
							if string_starts_with(rules[j], "!") {
								r = string_copy(rules[j], 2, string_length(rules[j]) - 1);
								if string_starts_with(member_name, r) {
									halt = __KengineParserUtils.__Interpreter.System._sfmt("Cannot access private members of (%).", string(_object));
									break;
								}
							} else {
								r = rules[j];
								if not string_starts_with(member_name, r) {
									halt = __KengineParserUtils.__Interpreter.System._sfmt("Cannot access private members of (%).", string(_object));
									break;
								}
							}
							break;
					}
				}
			}
		} else if is_array(_pub) {
			if !array_contains(_pub, member_name) {
				halt = true; //"Cannot access members of (%)"
			}
		} else if _pub == true {
			halt = undefined;
		} else {
			halt = true; // "Cannot access members of (%)"
		}
		if halt != undefined {
			return false;
		} else {
			return true;
		}
	}

	/**
	 * @function IsPrivate
	 * @memberof Kengine.Utils.Structs
	 * @description Return whether `object` or its member is private or not. (`.__opts.private`)
	 * @param {Any} _object
	 * @param {String|Undefined} [member_name=undefined] The member if you want to get its access privacy.
	 * @param {Bool} [default_val=undefined]
	 * @return {Bool} Whether it is private or not.
	 *
	 */
    static IsPrivate = function(_object, member_name=undefined, default_val=undefined) {
        var o, val;
		default_val = default_val ?? __KengineParser.__default_private

        if is_array(_object) {
			if member_name == undefined {
				return default_val;
			} else {
				throw __KengineErrorUtils.Create(__KengineErrorUtils.Types.array__access_with_name);
			}
		}

		// Mini hack for Assets
		var _tde = undefined;
		if is_instanceof(_object, __KengineCollection) {
			var _type = __KengineStructUtils.Get(_object, "type");
			if _type != undefined {
				_tde = __KengineStructUtils.Get(_object.type, "default_private");
			}
		}

		if is_method(_object) {
			o = static_get(_object);
		} else {
			o = _object;
		}

		if member_name != undefined {
			// Get if the member is private as access AND itself.
			var _dots = string_split(member_name, ".");
			if array_length(_dots) > 1 {
				var _dot = array_pop(_dots);
				_dots = string_join_ext(".", _dots);
				var oo = __KengineStructUtils.DotGet(o, _dot);
				return __KengineStructUtils.IsPrivate(oo, _dot, default_val);
			} else {
				val = __KengineStructUtils.DotGet(o, "__opts.private");
			}
		} else {
			// No member name, Check for the current object itself.
			val = __KengineStructUtils.DotGet(o, "__opts.private") ?? default_val;
		}

		if val == undefined {
			if _tde != undefined { return _tde; }
		}
		if is_array(val) {
			if member_name != undefined {
				return array_contains(val, member_name);
			} else {
				return false; // Only privates are in the array.
			}
		}
		if is_method(val) {return val();} else {return val;}
	}

	/**
	 * @function SetPrivate
	 * @memberof Kengine.Utils.Structs
	 * @description Set `object` or its member is private or not. (`.__opts.private`)
	 * @param {Any} _object
	 * @param {String|Undefined} [member_name=undefined] The member if you want to set its access privacy.
	 * @param {Bool} [private=true] Whether it is private or not.
	 *
	 */
	static SetPrivate = function(_object, member_name=undefined, private=true) {
        var o, val;
		if is_array(_object) {
			throw __KengineErrorUtils.Create(__KengineErrorUtils.Types.array__cannot_be_private);
		}

		if is_method(_object) {
			o = static_get(_object);
		} else {
			o = _object;
		}

		if member_name != undefined {
			// Set the member private as access.. add it to the list.
			var _dots = string_split(member_name, ".");
			if array_length(_dots) > 1 {
				// If a dot is provided...
				var _dot = array_pop(_dots);
				_dots = string_join_ext(".", _dots);
				var oo = __KengineStructUtils.DotGet(o, _dot);
				return __KengineStructUtils.SetPrivate(oo, _dot, private);
			} else {
				val = __KengineStructUtils.DotGet(o, "__opts.private");
				if not is_array(val) {
					val = []
				}
				array_push(val, member_name);
				__KengineStructUtils.DotSet(o, "__opts.private", val);
			}
		} else {
			// No member name, Set for the current object itself as private, by using a bool.
			__KengineStructUtils.DotSet(o, "__opts.private", private);
		}
	}

	/**
	 * @function IsReadonly
	 * @memberof Kengine.Utils.Structs
	 * @description Return whether `object` or its member is readonly or not. (`.__opts.readonly`)
	 * @param {Any} _object
	 * @param {String|Undefined} [member_name=undefined] The member if you want to get its access readonliness.
	 * @param {Bool} [default_val=false]
	 * @return {Bool} Whether it is private or not.
	 *
	 */
	static IsReadonly = function(_object, member_name=undefined, default_val=false) {
		var o, val;

        if is_array(_object) {
			if member_name == undefined {
				return default_val;
			} else {
				throw __KengineErrorUtils.Create(__KengineErrorUtils.Types.array__access_with_name);
			}
		}

		if is_method(_object) {
			o = static_get(_object);
		} else {
			o = _object;
		}

		if member_name != undefined {
			// Get if the member is readonly as access AND itself.
			var _dots = string_split(member_name, ".");
			if array_length(_dots) > 1 {
				var _dot = array_pop(_dots);
				_dots = string_join_ext(".", _dots);
				var oo = __KengineStructUtils.DotGet(o, _dot);
				return __KengineStructUtils.IsReadonly(oo, _dot, default_val);
			} else {
				val = __KengineStructUtils.DotGet(o, "__opts.readonly");
			}
		} else {
			// No member name, Check for the current object itself.
			val = __KengineStructUtils.DotGet(o, "__opts.readonly") ?? default_val;
		}

		if is_array(val) {
			if member_name != undefined {
				return array_contains(val, member_name);
			} else {
				return false; // Only readonlies are in the array.
			}
		}
		if is_method(val) {return val();} else {return val;}
	}

	/**
	 * @function SetReadonly
	 * @memberof Kengine.Struct
	 * @description Set whether `object` or its member is readonly or not. (`.__opts.readonly`)
	 * @param {Any} _object
	 * @param {String|Undefined} [member_name=undefined] The member if you want to set its access readonliness.
	 * @param {Bool} [readonly=true]
	 *
	 */
	static SetReadonly = function(_object, member_name=undefined, readonly=true) {
		var o, val;

		if is_array(_object) {
			throw __KengineErrorUtils.Create(__KengineErrorUtils.Types.array__cannot_be_readonly);
		}

		if is_method(_object) {
			o = static_get(_object);
		} else {
			o = _object;
		}


		if member_name != undefined {
			// Set the member private as access.. add it to the list.
			var _dots = string_split(member_name, ".");
			if array_length(_dots) > 1 {
				// If a dot is provided...
				var _dot = array_pop(_dots);
				_dots = string_join_ext(".", _dots);
				var oo = __KengineStructUtils.DotGet(o, _dot);
				return __KengineStructUtils.SetReadonly(oo, _dot, private);
			} else {
				val = __KengineStructUtils.DotGet(o, "__opts.readonly");
				if not is_array(val) {
					val = []
				}
				array_push(val, member_name);
				__KengineStructUtils.DotSet(o, "__opts.readonly", val);
			}
		} else {
			// No member name, Set for the current object itself as private, by using a bool.
			__KengineStructUtils.DotSet(o, "__opts.readonly", readonly);
		}
	}

}
__KengineStructUtils();
