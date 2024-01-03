 /**
 * @function ken_keyboard_check_released
 * @memberof Kengine.fn.inputs
 * @description Return whether key is released.
 * @param {Struct|Real} key
 * @return {Bool}
 *
 */
function ken_keyboard_check_released(key) {
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
 * @function ken_keyboard_check
 * @memberof Kengine.fn.inputs
 * @description Return whether key is being held down.
 * @param {Struct|Real} key
 * @return {Bool}
 *
 */
function ken_keyboard_check(key) {
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
 * @function ken_keyboard_check_pressed
 * @memberof Kengine.fn.inputs
 * @description Return whether key is pressed.
 * @param {Struct|Real} key
 * @return {Bool}
 *
 */
function ken_keyboard_check_pressed(key) {
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
 * @function ken_keyboard_clear
 * @memberof Kengine.fn.inputs
 * @description Clear keyboard key state.
 * @param {Struct|Real} key
 * @return {Bool|Undefined}
 *
 */
function ken_keyboard_clear(key) {
	if is_struct(key) {
		for (var i=0; i<array_length(key.bindings); i++) {
			keyboard_clear(key.bindings[i]);
		}
		return true;
	} else {
		return keyboard_clear(key);
	}	
}
