/**
 * @function string_implode
 * @description	Return a string from an array of strings joined by a given string as a delimiter.
 * @param {String} delimiter
 * @param {Array<String>} array
 * @memberof Kengine.util.strings
 * @return {String}
 *
 */
function string_implode(delimiter, array) {
	var del = delimiter
	var arr = array;
	var out = "";
	var ind = 0;
	var num = array_length(arr);
	repeat (num-1) {
		out += string(arr[ind]) + del;
		ind++;
	}
	out += string(arr[ind]);
	return out;
}