/** 
 * @function ease_inout
 * @description Take a value and apply ease-in-out transition on, starting from `_start` and ending after `_duration` with added `_change`.
 * @param {Real} value The value to be applied.
 * @param {Real} start The start value.
 * @param {Real} change The end or change of the value.
 * @param {Real} duration The duration in steps.
 * @memberof Kengine.fn.easing
 * @example
 * // Step event
 * _x2 = ease_inout(_x1, 0, 2, 60); // _x2 is from 0 to 2 in 60 steps eased-in-out.
 * @return {Real} Converted real value to ease-in-out
 * @see Kengine~fn~easing.ease_in
 * @see Kengine~fn~easing.ease_out
 *
 */
function ease_inout(value, start, change, duration){
	value /= duration/2;
	if (value < 1) return change/2*value*value+ start;
	value -= 1;
	return -change/2 * (value*(value-2) - 1) + start;
}
