/**
 * @namespace Arrays
 * @memberof Kengine.Utils
 * @description A struct containing Kengine arrays utilitiy functions
 *
 */
function __KengineArrayUtils() : __KengineStruct() constructor {
		
    /**
     * @function DeleteValue
     * @memberof Kengine.Utils.Arrays
     * @description Delete value from an array.
     * @param {Array<Any>} array
     * @param {Any} value
     * @param {Bool} _all
     * @return {Real} Count of deleted indices.
     * 
     */
    static DeleteValue = function(array, value, _all=false) {
        var index = 0;
        if (!_all) {
            repeat (array_length(array)) {
                if (array[index] == value){ array_delete(array, index, 1); return 1;}
                index++;
            }
        } else {
            var count = 0;
            repeat (array_length(array)) {
                if (array[index] == value) {array_delete(array, index, 1); count++;} else {index++;};
            }
            return count;
        }
        return 0;
    }
    
    /** 
     * @function MinMax
     * @memberof Kengine.Utils.Arrays
     * @description Return the minimum and maximum numbers in an array
     * @param {Array} arr The input array
     * @returns {Array<Any>} An array containing the minimum and maximum numbers
     * 
     */
    static MinMax = function(arr) {
        var min_val = arr[0];
        var max_val = arr[0];

        for (var i = 1; i < array_length(arr); i++) {
            if (arr[i] < min_val) {
                min_val = arr[i];
            }
            if (arr[i] > max_val) {
                max_val = arr[i];
            }
        }

        return [min_val, max_val];
    }

    /** 
     * @function Concat
     * @memberof Kengine.Utils.Arrays
     * @description Return arrays' values as a single array.
     * @param {Array<Array<Any>>} arrays
     * @returns {Array<Any>}
     * 
     */
    static Concat = function(arrays) {
        var _a = [];
        for (var _i=0; _i<array_length(arrays); _i++) {
			for (var _j=0; _j<array_length(arrays[_i]); _j++) {
	            array_push(_a, arrays[_i][_j]);
			}
        }
        return _a;
    }
}
//__KengineArrayUtils();
