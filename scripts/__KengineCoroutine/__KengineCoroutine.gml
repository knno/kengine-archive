
/**
 * @function Coroutine
 * @new_name Kengine.Coroutine
 * @memberof Kengine
 * @description .
 * @param {Array<function>} [functions=undefined]
 * @param {function} [callback=undefined]
 * @param {function} [halt_callback=undefined]
 *
 */
function __KengineCoroutine(name="", functions=undefined, callback=undefined, halt_callback=undefined) : __KengineStruct() constructor {

	if name == "" {
		self.name = string("coroutine-{0}", Kengine.new_uid());
	} else {
		self.name = name;
	}

	if is_method(functions) {
		functions = [ functions ];
	}
	__functions = functions ?? [];

	self.callback = callback;
	__kengine_log($"callback for {self.name} is " + string(callback));
	self.halt_callback = halt_callback;

	status = KENGINE_COROUTINES_STATUS.IDLE;
	result = undefined;
	results = [];
	current_function = -1;
	exception = undefined;

	AddFunction = function(func, args_array=undefined) {
		if not is_undefined(args_array) {
			self.__functions[array_length(self.__functions)] = [func, args_array];
		} else {
			self.__functions[array_length(self.__functions)] = func;
		}
		if not array_contains(Kengine.coroutines, self) {
			Kengine.coroutines[array_length(Kengine.coroutines)] = self;
		}
	}

	Immediate = function() {
		self.current_function = 0;
		var _donefunc = false;
		while (array_length(self.__functions) > 0) {
			__kengine_log("Single of " + string(self.name));
			__RunSingle(self);
		}
		__kengine_log("Complete Immediate of " + string(self.name));
	}

	Start = function() {
		self.current_function = 0;
		if self.status == KENGINE_COROUTINES_STATUS.IDLE or self.status == KENGINE_COROUTINES_STATUS.PAUSED {
			self.status = KENGINE_COROUTINES_STATUS.RUNNING;
			return true;
		}
		return false;
	}

	Pause = function() {
		if self.status == KENGINE_COROUTINES_STATUS.PAUSED or self.status == KENGINE_COROUTINES_STATUS.RUNNING {
			self.status = KENGINE_COROUTINES_STATUS.PAUSED;
			return true;
		}
		return false;
	}

	IsIdle = function() { return self.status == KENGINE_COROUTINES_STATUS.IDLE;}
	IsRunning = function() { return self.status == KENGINE_COROUTINES_STATUS.RUNNING;}
	IsPaused = function() { return self.status == KENGINE_COROUTINES_STATUS.PAUSED;}
	IsDone = function() { return self.status == KENGINE_COROUTINES_STATUS.DONE;}

	static __RunSingle = function(this) {
		var _i = this.current_function;
		try {
			__kengine_log("Coroutine"+ string(this.name) +" function: " + string(_i));
			if is_array(this.__functions[_i]) {
				if is_array(this.__functions[_i][1]) {
					this.result = method_call(this.__functions[_i][0], this.__functions[_i][1]);
				} else {
					this.result = this.__functions[_i][0]();
				}
			} else {
				__kengine_log("Coroutine"+ string(this.name) +" function: " +string(this.__functions[_i]));
				// this.result = this.__functions[_i]();
				__kengine_log("Coroutine"+ string(this.name) +" function: " +string(this.__functions[_i]) + " - complete");
			}
			array_push(this.results, this.result);
			__kengine_log("Coroutine"+ string(this.name) +" function: " + string(this.result));
		} catch (_e) {
			if (__KengineStructUtils.Get(_e, "halt") == true) {
				this.status = KENGINE_COROUTINES_STATUS.FAIL;
				this.exception = _e;
				if is_method(this.halt_callback) {
					method({coroutine: this}, this.halt_callback)();
				} else if is_array(this.halt_callback) {
					method_call(method({coroutine: this}, this.halt_callback[0]), this.halt_callback[1]);
				}
				return;
			} else {
				throw _e;
			}
		}

		this.current_function ++
		if this.current_function >= array_length(this.__functions) {
			this.status = KENGINE_COROUTINES_STATUS.DONE;
		}

		if this.status == KENGINE_COROUTINES_STATUS.DONE {
			__kengine_log($"callback for {self.name} is " + string(callback) + " is running");
			if is_method(this.callback) {
				method({coroutine: this}, this.callback)();
			} else if is_array(this.callback) {
				method_call(method({coroutine: this}, this.callback[0]), this.callback[1]);
			}
		}
	}

	__Step = method(self, function() {
		if self.status == KENGINE_COROUTINES_STATUS.DONE
		or self.status == KENGINE_COROUTINES_STATUS.PAUSED
		or self.status == KENGINE_COROUTINES_STATUS.FAIL return;

		if self.status == KENGINE_COROUTINES_STATUS.RUNNING {
			__RunSingle(self);
		}
	})

	Destroy = function() {
		array_delete(Kengine.coroutines, array_get_index(Kengine.coroutines, self),1);
	}

	array_push(Kengine.coroutines, self);

}
