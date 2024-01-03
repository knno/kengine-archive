/**
 * @function string_explode
 * @description	Return an array of strings parsed from a given string of elements separated by a delimiter.
 * @param {String} delimiter
 * @param {String} str
 * @memberof Kengine.fn.strings
 * @return {Array<String>}
 *
 */
function string_explode(delimiter, str) {
	{
		var arr;
		var del = delimiter;
		var _str = str + del;
		var len = string_length(del);
		var ind = 0;
		repeat (string_count(del, _str)) {
			var pos = string_pos(del, _str) - 1;
			arr[ind] = string_copy(_str, 1, pos);
			_str = string_delete(_str, 1, pos + len);
			ind++;
		}
		return arr;
	}

}
