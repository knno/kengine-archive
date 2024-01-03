/**
 * @function values_map
 * @memberof Kengine.fn.data
 * @param {Struct|Array<Any>} struct_or_array
 * @param {Function} func
 * @param {Struct|Array<Any>} [par] A parameter for recursive calls.
 * @description Visits a struct's or array's values (that are not structs or arrays) and do a function with the values.
 * The returned value from the func is the new value. It accepts argument `val`.
 *
 * NOTE: This requires array copy-on-write disabled!
 *
 */
function values_map(struct_or_array, func, par=undefined){
	if is_struct(struct_or_array) {
		var n = struct_get_names(struct_or_array);
		for (var i=0; i<array_length(n); i++) {
			values_map(struct_or_array[$ n[i]], func, {struct: struct_or_array, ind: n[i]});
		}
	} else if is_array(struct_or_array) {
		var n = array_length(struct_or_array);
		for (var i=0; i<n; i++) {
			values_map(struct_or_array[i], func, {array: struct_or_array, ind: i});
		}
	} else {
		if par != undefined {
			if struct_exists(par, "array") {
				par.array[par.ind] = func(struct_or_array);
			} else {
				par.struct[$ par.ind] = func(struct_or_array);
			}
		}
	}
}