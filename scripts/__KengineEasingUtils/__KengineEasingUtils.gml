/**
 * @namespace Easing
 * @memberof Kengine.Utils
 * @description A struct containing Kengine easing utilitiy functions
 *
 */
function __KengineEasingUtils() : __KengineStruct() constructor {
    /** 
     * @function ease_in
     * @memberof Kengine.Utils.Easing
     * @description Take a value and apply ease-in transition on, starting from `_start` and ending after `_duration` with added `_change`.
     * @param {Real} value The value to be applied.
     * @param {Real} start The start value.
     * @param {Real} change The end or change of the value.
     * @param {Real} duration The duration in steps.
     * @see Kengine.Utils.Easing.ease_out
     * @see Kengine.Utils.Easing.ease_inout
     * @example
     * // Step event
     * _x2 = ease_in(_x1, 0, 2, 60); // _x2 is from 0 to 2 in 60 steps eased-in.
     * @return {Real} Converted real value to ease-in
     * 
     */
    static ease_in = function(value, start, change, duration){
        value /= duration;
        return change*value*value + start;
    }
    
    /** 
     * @function ease_inout
     * @memberof Kengine.Utils.Easing
     * @description Take a value and apply ease-in-out transition on, starting from `_start` and ending after `_duration` with added `_change`.
     * @param {Real} value The value to be applied.
     * @param {Real} start The start value.
     * @param {Real} change The end or change of the value.
     * @param {Real} duration The duration in steps.
     * @see Kengine.Utils.Easing.ease_in
     * @see Kengine.Utils.Easing.ease_out
     * @example
     * // Step event
     * _x2 = ease_inout(_x1, 0, 2, 60); // _x2 is from 0 to 2 in 60 steps eased-in-out.
     * @return {Real} Converted real value to ease-in-out
     *
     */
    static ease_inout = function(value, start, change, duration){
        value /= duration/2;
        if (value < 1) return change/2*value*value+ start;
        value -= 1;
        return -change/2 * (value*(value-2) - 1) + start;
    }

    /** 
     * @function ease_out
     * @memberof Kengine.Utils.Easing
     * @description Take a value and apply ease-out transition on, starting from `_start` and ending after `_duration` with added `_change`.
     * @param {Real} value The value to be applied.
     * @param {Real} start The start value.
     * @param {Real} change The end or change of the value.
     * @param {Real} duration The duration in steps.
     * @see Kengine.Utils.Easing.ease_in
     * @see Kengine.Utils.Easing.ease_inout
     * @example
     * // Step event
     * _x2 = ease_out(_x1, 0, 2, 60); // _x2 is from 0 to 2 in 60 steps eased-out.
     * @return {Real} Converted real value to ease-out
     *
     */
    static ease_out = function(value, start, change, duration){
        value /= duration;
        return -change * value*(value-2) + start;
    }
    
}