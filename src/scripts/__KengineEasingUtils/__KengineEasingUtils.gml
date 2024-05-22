/**
 * @namespace Easing
 * @memberof Kengine.Utils
 * @description A struct containing Kengine easing utilitiy functions
 *
 */
function __KengineEasingUtils() : __KengineStruct() constructor {
    /** 
     * @function EaseIn
     * @memberof Kengine.Utils.Easing
     * @description Takes a value and applies ease-in transition on, starting from `_start` and ending after `_duration` with added `_change`.
     * @param {Real} value The value to be applied.
     * @param {Real} start The start value.
     * @param {Real} change The end or change of the value.
     * @param {Real} duration The duration in steps.
     * @see Kengine.Utils.Easing.ease_out
     * @see Kengine.Utils.Easing.ease_inout
     * @example
     * // Step event
     * _x2 = Kengine.Utils.Easing.EaseIn(_x1, 0, 2, 60); // _x2 is from 0 to 2 in 60 steps eased-in.
     * @return {Real} Converted real value to ease-in
     * 
     */
    static EaseIn = function(value, start, change, duration){
        value /= duration;
        return change*value*value + start;
    }
    
    /** 
     * @function EaseInOut
     * @memberof Kengine.Utils.Easing
     * @description Takes a value and applies ease-in-out transition on, starting from `_start` and ending after `_duration` with added `_change`.
     * @param {Real} value The value to be applied.
     * @param {Real} start The start value.
     * @param {Real} change The end or change of the value.
     * @param {Real} duration The duration in steps.
     * @see Kengine.Utils.Easing.ease_in
     * @see Kengine.Utils.Easing.ease_out
     * @example
     * // Step event
     * _x2 = Kengine.Utils.Easing.EaseInOut(_x1, 0, 2, 60); // _x2 is from 0 to 2 in 60 steps eased-in-out.
     * @return {Real} Converted real value to ease-in-out
     *
     */
    static EaseInOut = function(value, start, change, duration){
        value /= duration/2;
        if (value < 1) return change/2*value*value+ start;
        value -= 1;
        return -change/2 * (value*(value-2) - 1) + start;
    }

    /** 
     * @function EaseOut
     * @memberof Kengine.Utils.Easing
     * @description Takes a value and applies ease-out transition on, starting from `_start` and ending after `_duration` with added `_change`.
     * @param {Real} value The value to be applied.
     * @param {Real} start The start value.
     * @param {Real} change The end or change of the value.
     * @param {Real} duration The duration in steps.
     * @see Kengine.Utils.Easing.ease_in
     * @see Kengine.Utils.Easing.ease_inout
     * @example
     * // Step event
     * _x2 = Kengine.Utils.Easing.EaseOut(_x1, 0, 2, 60); // _x2 is from 0 to 2 in 60 steps eased-out.
     * @return {Real} Converted real value to ease-out
     *
     */
    static EaseOut = function(value, start, change, duration){
        value /= duration;
        return -change * value*(value-2) + start;
    }
}
