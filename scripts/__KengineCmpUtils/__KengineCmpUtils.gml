/**
 * @namespace Cmps
 * @memberof Kengine.Utils
 * @description A struct containing Kengine comparing functions.
 *
 */
function __KengineCmpUtils() : __KengineStruct() constructor {

	static __opts = {
		private: true,
	}

	/**
	 * @function cmp_val1_val2
	 * @memberof Kengine.cmps
	 * @description Return whether val1 equals val2.
	 * @param {Any} val1
	 * @param {Any} val2
	 * @return {Bool}
	 * 
	 */
	static cmp_val1_val2 = function(val1,val2) {return val1 == val2;}

	/**
	 * @function cmp_val1_val2_id
	 * @memberof Kengine.cmps
	 * @description Return whether val1 equals val2.id.
	 * @param {Any} val1
	 * @param {Any} val2
	 * @return {Bool}
	 * 
	 */
	static cmp_val1_val2_id = function(val1,val2) {return val1 == val2.id;}

	/**
	 * @function cmp_val1_id_val2_id
	 * @memberof Kengine.cmps
	 * @description Return whether val1.id equals val2.id.
	 * @param {Any} val1
	 * @param {Any} val2
	 * @return {Bool}
	 * 
	 */
	static cmp_val1_id_val2_id = function(val1,val2) {return val1.id == val2.id;}

	/**
	 * @function cmp_val1_name_val2_name
	 * @memberof Kengine.cmps
	 * @description Return whether val1.name equals val2.name.
	 * @param {Any} val1
	 * @param {Any} val2
	 * @return {Bool}
	 * 
	 */
	static cmp_val1_name_val2_name = function(val1,val2) {return val1.name == val2.name;}

	/**
	 * @function cmp_val1_val2_name
	 * @memberof Kengine.cmps
	 * @description Return whether val1 equals val2.name.
	 * @param {Any} val1
	 * @param {Any} val2
	 * @return {Bool}
	 * 
	 */
	static cmp_val1_val2_name = function(val1,val2) {return val1 == val2.name;}

	/**
	 * @function cmp_val1_val2_index
	 * @memberof Kengine.cmps
	 * @description Return whether val1 equals val2.index.
	 * @param {Any} val1
	 * @param {Any} val2
	 * @return {Bool}
	 * 
	 */
	static cmp_val1_val2_index = function(val1,val2) {return val1 == val2.index;}

	/**
	 * @function cmp_unique_id_name
	 * @memberof Kengine.cmps
	 * @description Return whether val1.id equals val2.id AND val1.name equals val2.name. (Thus, the function name)
	 * @param {Any} val1
	 * @param {Any} val2
	 * @return {Bool}
	 * 
	 */
	static cmp_unique_id_name = function(val1,val2) {return (val1.id == val2.id) and (val1.name == val2.name);}

	/**
	 * @function cmp_unique_attrs
	 * @memberof Kengine.cmps
	 * @description Return whether val1 and val2 have unique attributes via given var struct {unique_attrs}
	 * If the array has any attr as a subarray, it is considered a unique_together. Otherwise, compare that attr for val1 and val2.
	 * Unique together must be both equal.
	 * @param {Any} val1
	 * @param {Any} val2
	 * @return {Bool}
	 * 
	 * @example
	 * // Compare function for id and name. Attributes must be both the same to consider val1 and val2 equal.
	 * my_cmp = method({unique_attrs: [["id", "name"]]}, cmp_unique_attrs);
	 * 
	 * 
	 */
	static cmp_unique_attrs = function(val1,val2) {
		var i=0; var j=0; var a; var h;
		var val1attrs_unique = []; var val2attrs_unique = [];
		var results = [];

		for (i=0; i<array_length(unique_attrs); i++) {
			if is_array(unique_attrs[i]) {
				for (j=0; j<array_length(unique_attrs[i]); j++) {
					a = unique_attrs[i][j];
					h = variable_get_hash(a);
					if struct_exists(val1, a) and struct_exists(val2, a) {
						array_push(val1attrs_unique, struct_get_from_hash(val1, h));
						array_push(val2attrs_unique, struct_get_from_hash(val2, h));
					}
				}
				if array_equals(val1attrs_unique, val2attrs_unique) {
					results[i] = true;
				} else {
					results[i] = false;
				}
			} else {
				a = unique_attrs[i];
				h = variable_get_hash(a);
				if struct_exists(val1, a) and struct_exists(val2, a) {
					if struct_get_from_hash(val1, h) == struct_get_from_hash(val2, h) {
						results[i] = true;
					} else {
						results[i] = false;
					}
				}
			}
		}
		for (i=0; i<array_length(results); i++) {
			if results[i] != true {
				return false;
			}
		}
		if array_length(results) == 0 {
			return false;
		}
		return true;
	}

	/**
	 * @function _cmp_id_or_name
	 * @memberof Kengine.cmps
	 * @private
	 * @param {Any} val
	 * @param {Any} ind
	 * @description A function that takes {id_or_name} var struct, and compares `val` attributes with it.
	 * This is used internally for {@link Kengine.AssetType.GetAssetReplacement}
	 * 
	 */
	static _cmp_id_or_name = function(val, ind) {
		if is_string(id_or_name) {
			return val.name == id_or_name or val.real_name == id_or_name;
		} else {
			return val.id == id_or_name;
		}
	}

}
__KengineCmpUtils();
