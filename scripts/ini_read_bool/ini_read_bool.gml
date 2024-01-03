/**
 * @function	ini_read_bool
 * @description	Read a key from opened INI and converts it to a boolean value.
 * @param {String} section
 * @param {String} key
 * @param {Bool} default_val
 * @memberof Kengine.fn.files
 * @return {Bool}
 *
 */
function ini_read_bool(section, key, default_val) {
	var _t = ini_read_string(section, key, "false");
	return to_boolean(_t);
}
