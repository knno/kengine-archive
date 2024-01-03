/**
 * @function to_boolean
 * @description	Convert a value to a boolean. such as "ON", 1, 0, or "false"
 * @param {Any} value The value to be converted.
 * @return {Bool} Boolean equivalent of the value.
 * @memberof Kengine.fn.data
 *
 */
function to_boolean(value) {
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
