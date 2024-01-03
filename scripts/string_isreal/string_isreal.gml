/** 
 * @function string_isreal
 * @description	Return whether string can be "real" or not.
 * @param {String} str The string to be checked.
 * @memberof Kengine.fn.strings
 * @return {Bool}
 * 
 */
function string_isreal(str) {
	var n = string_length(string_digits(str));
	return n and (n == string_length(str) - (string_char_at(str, 1) == "-") - (string_pos(".", str) != 1));
}
