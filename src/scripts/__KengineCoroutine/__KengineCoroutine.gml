
/**
 * @function Coroutine
 * @new_name Kengine.Coroutine
 * @memberof Kengine
 * @description .
 * @param {String} [name]
 * @param {Array<function>} [functions=undefined]
 * @param {Function} [callback=undefined]
 * @param {Function} [halt_callback=undefined]
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
		self.status = KENGINE_COROUTINES_STATUS.RUNNING;
		var _donefunc = false;
		while (array_length(self.__functions) > self.current_function) {
			__RunSingle();
		}
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

	__marked_as_delete = false;

	__RunSingle = function() {
		var this = self;
		var _i = this.current_function;
		this.current_function ++;
		var m;
		if array_length(this.__functions) > 0 and _i < array_length(this.__functions) {
			try {
				if is_array(this.__functions[_i]) {
					if is_array(this.__functions[_i][1]) {
						m = this.__functions[_i][0];
						this.result = method_call(m, this.__functions[_i][1]);
					} else {
						this.result = this.__functions[_i][0]();
					}
				} else {
					this.result = this.__functions[_i]();
				}
				array_push(this.results, this.result);
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
		}

		if this.current_function >= array_length(this.__functions) {
			var children = array_filter(Kengine.coroutines, method({this}, function(c) {
				return string_starts_with(c.name, this.name) and c.name != this.name;
			}));
			if array_length(children) > 0 {
				var _all_done = true;
				for (var _j=0; _j<array_length(children); _j++) {
					if children[_j].status != KENGINE_COROUTINES_STATUS.DONE {
						_all_done = false;
						break;
					}
				}
				if _all_done {
					this.status = KENGINE_COROUTINES_STATUS.DONE;
				}
			} else {
				this.status = KENGINE_COROUTINES_STATUS.DONE;
			}
		}

		if this.status == KENGINE_COROUTINES_STATUS.DONE {
			if is_method(this.callback) {
				method({coroutine: this}, this.callback)()
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
			__RunSingle();
		}
	})

	Destroy = method(self, function() {
		self.__marked_as_delete = true
		return true;
	})

	array_push(Kengine.coroutines, self);

}
