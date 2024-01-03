/**
 * @function struct_merge
 * @description	Merge struct2 to struct1 recursively.
 * @param {Struct} struct1 The main struct.
 * @param {Struct} struct2 The secondary struct.
 * @param {Bool} merge_arrays Whether to merge arrays.
 * @return {Struct} The first struct after being merged.
 * @memberof Kengine.fn.data
 *
 */
function struct_merge(struct1, struct2, merge_arrays=false) {
	var props = struct_get_names(struct2);
    for(var i = 0; i < array_length(props); i++) {
        var val = struct2[$ props[i]];
        if (is_struct(val)) {
            if !struct_exists(struct1, props[i]) {
				struct1[$ props[i]] = val;
			} else {
				struct_merge(struct1[$ props[i]], val);
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
