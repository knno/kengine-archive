/**
 * @function is_booleanable
 * @description	Return whether a value can be a boolean. such as "ON", 1, or "true".
 * @param {Any} value The value to be checked as boolean.
 * @return {Bool} Whether it accepts to_boolean or not.
 * @memberof Kengine.fn.data
 *
 */
function is_booleanable(value) {
	if typeof(value) == ty_real {
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
