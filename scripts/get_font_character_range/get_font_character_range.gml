/**
 * @function get_font_character_range
 * @description	Return array of min, max for the characters in the provided string. Useful for creating fonts.
 * @param {String} strs A string that contains characters to be used for the range.
 * @memberof Kengine.fn.fonts
 * @return {Array<Real>} [min, max]
 *
 */
function get_font_character_range(strs) {
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