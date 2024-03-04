/**
 * @namespace Data
 * @memberof Kengine.Utils
 * @description A struct containing Kengine data utilitiy functions
 *
 */
function __KengineDataUtils() : __KengineStruct() constructor {
    /**
     * @function ValuesMap
     * @memberof Kengine.Utils.Data
     * @param {Struct|Array<Any>} struct_or_array
     * @param {Function} func
     * @param {Struct|Array<Any>} [par] A parameter for recursive calls.
     * @description Visit a struct's or array's values (that are not structs or arrays) and do a function with the values.
     * The returned value from the func is the new value. It accepts argument `val`.
     *
     * Note - Disabling copy on write behavior for arrays is required.
     *
     */
    static ValuesMap = function(struct_or_array, func, par=undefined) {
        if is_struct(struct_or_array) {
            var n = struct_get_names(struct_or_array);
            for (var i=0; i<array_length(n); i++) {
                ValuesMap(struct_or_array[$ n[i]], func, {struct: struct_or_array, ind: n[i]});
            }
        } else if is_array(struct_or_array) {
            var n = array_length(struct_or_array);
            for (var i=0; i<n; i++) {
                ValuesMap(struct_or_array[i], func, {array: struct_or_array, ind: i});
            }
        } else {
            if par != undefined {
                if __KengineStructUtils.Exists(par, "array") {
                    par.array[par.ind] = func(struct_or_array);
                } else {
                    par.struct[$ par.ind] = func(struct_or_array);
                }
            }
        }
    }

    /**
     * @function ToBoolean
     * @memberof Kengine.Utils.Data
     * @description	Convert a value to a boolean. such as "ON", 1, 0, or "false"
     * @param {Any} value The value to be converted.
     * @return {Bool} Boolean equivalent of the value.
     *
     */
    static ToBool = function(value) {
        if typeof(value) == ty_real {
            if value > 0 {
                return true;
            }
            return false;
        } else if typeof(value) == "string" {
            var _str;
            _str = string_trim(value, ["\""]);
            _str = string_trim(_str, ["'"]);
            _str = string_lower(_str);
            switch(_str) {
                case "on": case "true": case "yes": case "1": case "1.0": return true;
                default: return false;
            }
        } else {
            return bool(value);
        }
    }

    /**
     * @function IniReadBool
     * @memberof Kengine.Utils.Data
     * @description	Read a key from opened INI and converts it to a boolean value.
     * @param {String} section
     * @param {String} key
     * @param {Bool} default_val
     * @return {Bool}
     *
     */
    static IniReadBool = function(section, key, default_val) {
        var _t = ini_read_string(section, key, "false");
        return ToBool(_t);
    }

    /**
     * @function IsBoolable
     * @memberof Kengine.Utils.Data
     * @description	Return whether a value can be a boolean. such as "ON", 1, or "true".
     * @param {Any} value The value to be checked as boolean.
     * @return {Bool} Whether it accepts ToBool or not.
     *
     */
    static IsBoolable = function(value) {
        if typeof(value) == "real" {
            if value == 1 or value == 0 or value == 1.0 or value == 0.0 {
                return true;
            }
            return false;
        } else if typeof(value) == "string" {
            var _str;
            _str = string_trim(value, ["\""]);
            _str = string_trim(_str, ["'"]);
            _str = string_lower(_str);
            switch(_str) {
                case "on": case "true": case "yes": case "1": case "1.0": return true;
                case "off": case "false": case "no": case "0": case "0.0": return true;
                default: return false;
            }
        }
        return false;
    }

    /**
     * @function GetFontCharRange
     * @memberof Kengine.Utils.Data
     * @description	Return array of min, max for the characters in the provided string. Useful for creating fonts.
     * @param {String} strs A string that contains characters to be used for the range.
     * @return {Array<Real>} [min, max]
     *
     */
    static GetFontCharRange = function(strs) {
        var s = undefined;
        var e = undefined;
        var r = [];
        var ds = ds_list_create();

        var texts;
        var struct_names = variable_struct_get_names(strs);
        for (var i=0; i<array_length(struct_names); i++) {
            var arrr = variable_struct_get(strs, struct_names[i]);
            if array_length(arrr) > 0 {
                texts[i] = string_join_ext(" ", arrr);
            } else {
                return [0, 1608];
            }
        }

        var str = string_join_ext("\n", texts);

        var uni = undefined;
        for (var i=0; i<string_length(str); i++) {
            uni = ord(string_char_at(str,i))
            if ds_list_find_index(ds, uni) == -1 {
                ds_list_add(ds, uni)
            }
        }

        var j = undefined;
        for (var i=0; i<ds_list_size(ds); i++) {
            j = ds_list_find_value(ds, i);
            if s == undefined {
                s = j;
                e = j;
            } else if j == e or j == e + 1 {
                e = j;
            } else {
                array_push(r, [s,e]);
                s = j
                e = j;
            }
        }
        if s != undefined {
            array_push(r, [s,e]);
        }

        ds_list_destroy(ds);	

        var minimum = 0;
        var maximum = 1608;
        for (var i=0; i<array_length(r); i++) {
            minimum = min(r[i][0], minimum);
            maximum = max(r[i][1], maximum);
        }
        return [min(31,minimum), maximum];
    }

}
__KengineDataUtils();
