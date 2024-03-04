/**
 * @namespace Input
 * @memberof Kengine.Utils
 * @description A struct containing Kengine input utilitiy functions
 *
 */
function __KengineInputUtils() : __KengineStruct() constructor {
	/**
	 * @function ken_keyboard_check_released
	 * @memberof Kengine.Utils.Input
	 * @description Return whether key is released.
	 * @param {Struct|Real} key
	 * @return {Bool}
	 *
	 */
	static keyboard_check_released = function(key) {
		if is_struct(key) {
			for (var i=0; i<array_length(key.bindings); i++) {
				if keyboard_check_released(key.bindings[i]) return true;
			}
			return false;
		} else {
			return keyboard_check_released(key);
		}
	}

	/**
	 * @function keyboard_check
	 * @memberof Kengine.Utils.Input
	 * @description Return whether key is being held down.
	 * @param {Struct|Real} key
	 * @return {Bool}
	 *
	 */
	static keyboard_check = function(key) {
		if is_struct(key) {
			for (var i=0; i<array_length(key.bindings); i++) {
				if keyboard_check(key.bindings[i]) return true;
			}
			return false;
		} else {
			return keyboard_check(key);
		}
	}

	/**
	 * @function keyboard_check_pressed
	 * @memberof Kengine.Utils.Input
	 * @description Return whether key is pressed.
	 * @param {Struct|Real} key
	 * @return {Bool}
	 *
	 */
	static keyboard_check_pressed = function(key) {
		if is_struct(key) {
			for (var i=0; i<array_length(key.bindings); i++) {
				if keyboard_check_pressed(key.bindings[i]) return true;
			}
			return false;
		} else {
			return keyboard_check_pressed(key);
		}
	}

	/**
	 * @function keyboard_clear
	 * @memberof Kengine.Utils.Input
	 * @description Clear keyboard key state.
	 * @param {Struct|Real} key
	 * @return {Bool|Undefined}
	 *
	 */
	static keyboard_clear = function(key) {
		if is_struct(key) {
			for (var i=0; i<array_length(key.bindings); i++) {
				keyboard_clear(key.bindings[i]);
			}
			return true;
		} else {
			return keyboard_clear(key);
		}	
	}
}
__KengineInputUtils();
