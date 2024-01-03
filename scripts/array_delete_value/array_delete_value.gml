/**
 * @function array_delete_value(array, value, _all);
 * @param {Array<Any>} array
 * @param {Any} value
 * @param {Bool} _all
 * @return {Real} Count of deleted indices.
 * 
 */
function array_delete_value(array, value, _all=false) {
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