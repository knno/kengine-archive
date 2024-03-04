/// feather ignore all

#region Configs
#macro __TXR_VALUE_CALLS 1
#endregion

#region Internal
enum __TXR_NODE {
	NUMBER = 1, // (val:number)
	IDENT = 2, // (name:string)
	UNOP = 3, // (unop, node)
	BINOP = 4, // (binop, a, b)
	CALL = 5, // (script, args_array)
	BLOCK = 6, // (nodes_array) { ...nodes }
	RET = 7, // (node) return <node>
	DISCARD = 8, // (node) - when we don't care
	IF_THEN = 9, // (cond_node, then_node)
	IF_THEN_ELSE = 10, // (cond_node, then_node, else_node)
	STRING = 11, // (val:string)
	SET = 12, // (binop, node, value:node)
	WHILE = 13,
	DO_WHILE = 14,
	FOR = 15,
	BREAK = 16,
	CONTINUE = 17,
	ARGUMENT = 18, // (index:int)
	ARGUMENT_COUNT = 19,
	LABEL = 20, // (name:string)
	JUMP = 21, // (name:string)
	JUMP_PUSH = 22, // (name:string)
	JUMP_POP = 23, // ()
	SELECT = 24, // (call_node, nodes, ?default_node)
	PREFIX = 25, // (node, delta) ++x/--x
	POSTFIX = 26, // (node, delta) x++/x--
	ADJFIX = 27, // (node, delta) x+=1/x-=1 (statement)
	SWITCH = 28, // (expr, case_values, case_exprs, ?default_node)
	FIELD = 29, // (node, field:string)
	ARRAY_ACCESS = 30, // (node, index)
	ARRAY_LITERAL = 31, // (nodes)
	VALUE_CALL = 32, // (node, args_array)
	OBJECT_LITERAL = 33, // (key_strings, value_nodes)
}
enum __TXR_UNOP {
	NEGATE = 1, // -value
	INVERT = 2, // !value
}
enum __TXR_BUILD_FLAG {
	NO_OPS = 1, // no <expr> + ...
	NO_SUFFIX = 2, // no <expr>.field, <expr>[index], etc.
}
enum __TXR_ACTION {
		NUMBER = 1, // (value:number): push(value)
		IDENT = 2, // (name): push(self[name])
		UNOP = 3, // (unop): push(-pop())
		BINOP = 4, // (op): a = pop(); b = pop(); push(binop(op, a, b))
		CALL = 5, // (script, argc): 
		RET = 6, // (): return pop()
		DISCARD = 7, // (): pop() - for when we don't care for output
		JUMP = 8, // (pos): pc = pos
		JUMP_UNLESS = 9, // (pos): if (!pop()) pc = pos
		STRING = 10, // (value:string): push(value)
		SET_IDENT = 11, // (name:string): self[name] = pop()
		BAND = 12, // (pos): if (peek()) pop(); else pc = pos
		BOR = 13, // (pos): if (peek()) pc = pos; else pop()
		JUMP_IF = 14, // (pos): if (pop()) pc = pos
		GET_LOCAL = 15, // (name): push(locals[name])
		SET_LOCAL = 16, // (name): locals[name] = pop()
		JUMP_PUSH = 17, // (pos): js.push(pc); pc = pos
		JUMP_POP = 18, // (): pc = js.pop()
		SELECT = 19, // (pos_array, def_pos): the simplest jumptable
		DUP = 20, // push(top())
		SWITCH = 21, // (pos): if (pop() == peek()) { pop(); pc = pos; }
		LABEL = 22, // (name:string) [does nothing]
		GET_FIELD = 23, // (name:string): push(pop().name)
		SET_FIELD = 24, // (name:string): { v = pop(); pop().name = v; }
		GET_ARRAY = 25, // (): i = pop(); push(pop()[i])
		SET_ARRAY = 26, // (): v = pop(); i = pop(); pop()[i] = v;
		ARRAY_LITERAL = 27, // (n): 
		VALUE_CALL = 28, // (argc): args = pop#argc(); fn = pop(); push(fn(...args))
		OBJECT_LITERAL = 29, // (field_names): 
		SIZEOF = 30,
	}
enum __TXR_TOKEN {
	EOF = 0, // <end of file>
	OP = 1, // + - * / % div
	PAR_OPEN = 2, // (
	PAR_CLOSE = 3, // )
	NUMBER = 4, // 37
	IDENT = 5, // some
	COMMA = 6, // ,
	RET = 7, // return
	IF = 8,
	ELSE = 9,
	STRING = 10, // "hi!"
	CUB_OPEN = 11, // {
	CUB_CLOSE = 12, // }
	SET = 13, // = += -= etc
	UNOP = 14, // !
	WHILE = 15,
	DO = 16,
	FOR = 17,
	SEMICO = 18, // ;
	BREAK = 19,
	CONTINUE = 20,
	VAR = 21,
	ARGUMENT = 22, // argument#
	ARGUMENT_COUNT = 23,
	LABEL = 24,
	JUMP = 25,
	JUMP_PUSH = 26,
	JUMP_POP = 27,
	COLON = 28, // :
	SELECT = 29,
	OPTION = 30,
	DEFAULT = 31,
	ADJFIX = 32, // (delta) ++/--
	SWITCH = 33,
	CASE = 34,
	PERIOD = 35, // .
	SQB_OPEN = 36,
	SQB_CLOSE = 37,
}
enum __TXR_OP {
	SET  =   -1, // =
	MUL  = 0x01, // *
	FDIV = 0x02, // /
	FMOD = 0x03, // %
	IDIV = 0x04, // div
	ADD  = 0x10, // +
	SUB  = 0x11, // -
	SHL  = 0x20, // <<
	SHR  = 0x21, // >>
	IAND = 0x30, // &
	IOR  = 0x31, // |
	IXOR = 0x32, // ^
	EQ   = 0x40, // ==
	NE   = 0x41, // !=
	LT   = 0x42, // <
	LE   = 0x43, // <=
	GT   = 0x44, // >
	GE   = 0x45, // >=
	BAND = 0x50, // &&
	BOR  = 0x60, // ||
	MAXP = 0x70, // maximum priority
}
enum __TXR_THREAD {
	ACTIONS,
	POS,
	//
	STACK,
	JUMPSTACK,
	LOCALS,
	//
	RESULT, // status-specific, e.g. returned value or error text
	STATUS,
	//
	SIZEOF,
}
enum __TXR_THREAD_STATUS {
		NONE, // not ran yet
		RUNNING, // in process
		FINISHED, // finished executing in a normal way
		ERROR, // hit an error
		YIELD, // requested to yield
		JUMP, // requested to transit to a different position
	}
#endregion

#region Constructors
function __TxrBuilder() constructor {
	static _build_list = undefined;
	static _build_node = undefined;
	static _build_pos = undefined;
	static _build_len = undefined;
	static _build_can_break = undefined;
	static _build_can_continue = undefined;
	static _build_locals = ds_map_create();

	/// @param flags
	static _build_expr = function(flags) {
		var tk = _build_list[|_build_pos++];
		var closed;
		switch (tk[0]) {
			case __TXR_TOKEN.NUMBER: _build_node = [__TXR_NODE.NUMBER, tk[1], tk[2]]; break;
			case __TXR_TOKEN.STRING: _build_node = [__TXR_NODE.STRING, tk[1], tk[2]]; break;
			case __TXR_TOKEN.IDENT:
				var tkn = _build_list[|_build_pos];
				_build_node = [__TXR_NODE.IDENT, tk[1], tk[2]];
				if (tkn[0] == __TXR_TOKEN.PAR_OPEN) { // `ident(`
					_build_pos += 1;
					// look up the function
					var _args = [], _argc = 0;
					var _fn = __TxrSystem._function_map[?tk[2]];
					var _fn_script, _fn_argc;
					if (_fn == undefined) {
						if (__TXR_VALUE_CALLS) {
							_fn_script = undefined;
							_fn_argc = -1;
						} else {
							_fn_script = __TXR.DefaultFunction;
							if (_fn_script != -1) {
								_fn_argc = -1;
								_args[_argc++] = [__TXR_NODE.STRING, tk[1], tk[2]];
							} else return __TxrSystem._throw_at("Unknown function `" + tk[2] + "`", tk);
						}
					} else {
						_fn_script = _fn[0];
						_fn_argc = _fn[1];
					}
					if (_build_expr_call(tk, _fn_script, _fn_argc, _args, _argc, _build_node)) return true;
				}
				break;
			case __TXR_TOKEN.ARGUMENT: _build_node = [__TXR_NODE.ARGUMENT, tk[1], tk[2], tk[3]]; break;
			case __TXR_TOKEN.ARGUMENT_COUNT: _build_node = [__TXR_NODE.ARGUMENT_COUNT, tk[1]]; break;
			case __TXR_TOKEN.PAR_OPEN: // (value)
				if (_build_expr(0)) return true;
				tk = _build_list[|_build_pos++];
				if (tk[0] != __TXR_TOKEN.PAR_CLOSE) return __TxrSystem._throw_at("Expected a `)`", tk);
				break;
			case __TXR_TOKEN.OP: // -value, +value
				switch (tk[2]) {
					case __TXR_OP.ADD:
						if (_build_expr(__TXR_BUILD_FLAG.NO_OPS)) return true;
						break;
					case __TXR_OP.SUB:
						if (_build_expr(__TXR_BUILD_FLAG.NO_OPS)) return true;
						_build_node = [__TXR_NODE.UNOP, tk[1], __TXR_UNOP.NEGATE, _build_node];
						break;
					default: return __TxrSystem._throw_at("Expected an expression", tk);
				}
				break;
			case __TXR_TOKEN.UNOP: // !value
				if (_build_expr(__TXR_BUILD_FLAG.NO_OPS)) return true;
				_build_node = [__TXR_NODE.UNOP, tk[1], tk[2], _build_node];
				break;
			case __TXR_TOKEN.ADJFIX: // ++value
				if (_build_expr(__TXR_BUILD_FLAG.NO_OPS)) return true;
				_build_node = [__TXR_NODE.PREFIX, tk[1], _build_node, tk[2]];
				break;
			case __TXR_TOKEN.SQB_OPEN: // [...values]
				closed = false;
				var args = [], argc = 0;
				while (_build_pos < _build_len) {
					// hit a closing `]` yet?
					tkn = _build_list[|_build_pos];
					if (tkn[0] == __TXR_TOKEN.SQB_CLOSE) {
						_build_pos += 1;
						closed = true;
						break;
					}
					// read the value:
					if (_build_expr(0)) return true;
					args[argc++] = _build_node;
					// skip a `,`:
					tkn = _build_list[|_build_pos];
					if (tkn[0] == __TXR_TOKEN.COMMA) {
						_build_pos += 1;
					} else if (tkn[0] != __TXR_TOKEN.SQB_CLOSE) {
						return __TxrSystem._throw_at("Expected a `,` or `]`", tkn);
					}
				}
				if (!closed) return __TxrSystem._throw_at("Unclosed `[]` after", tk);
				_build_node = [__TXR_NODE.ARRAY_LITERAL, tk[1], args];
				break;
			case __TXR_TOKEN.CUB_OPEN: // {...key-value pairs }
				closed = false;
				var _keys = [], _values = [], _found = 0;
				while (_build_pos < _build_len) {
					// hit a closing `]` yet?
					tkn = _build_list[|_build_pos];
					if (tkn[0] == __TXR_TOKEN.CUB_CLOSE) {
						_build_pos += 1;
						closed = true;
						break;
					}
					//
					tkn = _build_list[|_build_pos++];
					if (tkn[0] != __TXR_TOKEN.IDENT) return __TxrSystem._throw_at("Expected a field name", tkn);
					_keys[_found] = tkn[2];
					//
					tkn = _build_list[|_build_pos++];
					if (tkn[0] != __TXR_TOKEN.COLON) return __TxrSystem._throw_at("Expected a `:`", tkn);
					// read the value:
					if (_build_expr(0)) return true;
					_values[_found++] = _build_node;
					// skip a `,`:
					tkn = _build_list[|_build_pos];
					if (tkn[0] == __TXR_TOKEN.COMMA) {
						_build_pos += 1;
					} else if (tkn[0] != __TXR_TOKEN.CUB_CLOSE) {
						return __TxrSystem._throw_at("Expected a `,` or `}`", tkn);
					}
				}
				if (!closed) return __TxrSystem._throw_at("Unclosed `{}` after", tk);
				_build_node = [__TXR_NODE.OBJECT_LITERAL, tk[1], _keys, _values];
				break;
			default: return __TxrSystem._throw_at("Expected an expression", tk);
		}
	
		// handle postfixes after expression
		while (_build_pos < _build_len) {
			tk = _build_list[|_build_pos];
			var _break = false;
			switch (tk[0]) {
				case __TXR_TOKEN.PERIOD: // value.field?
					if ((flags & __TXR_BUILD_FLAG.NO_SUFFIX) == 0) {
						_build_pos += 1;
						tk = _build_list[|_build_pos];
						if (tk[0] != __TXR_TOKEN.IDENT) return __TxrSystem._throw_at("Expected a field name", tk);
						_build_pos += 1;
						_build_node = [__TXR_NODE.FIELD, tk[1], _build_node, tk[2]];
					} else return __TxrSystem._throw_at("Unexpected `.`", tk);
					break;
				case __TXR_TOKEN.SQB_OPEN: // value[index]?
					if ((flags & __TXR_BUILD_FLAG.NO_SUFFIX) == 0) {
						_build_pos += 1;
						var node = _build_node;
						if (_build_expr(__TXR_BUILD_FLAG.NO_OPS)) return true;
					
						tk = _build_list[|_build_pos];
						if (tk[0] != __TXR_TOKEN.SQB_CLOSE) return __TxrSystem._throw_at("Expected a closing []", tk);
						_build_pos += 1;
						_build_node = [__TXR_NODE.ARRAY_ACCESS, tk[1], node, _build_node];
					} else return __TxrSystem._throw_at("Unexpected `.`", tk);
					break;
				case __TXR_TOKEN.PAR_OPEN: // value(...)
					if ((flags & __TXR_BUILD_FLAG.NO_SUFFIX) == 0) {
						if (__TXR_VALUE_CALLS) {
							_build_pos += 1;
							if (_build_expr_call(tk, undefined, -1, [], 0, _build_node)) return true;
						} else return __TxrSystem._throw_at("Can't call this", tk);
					} else return __TxrSystem._throw_at("Unexpected `(`", tk);
					break;
				case __TXR_TOKEN.ADJFIX: // value++?
					if ((flags & __TXR_BUILD_FLAG.NO_SUFFIX) == 0) {
						_build_pos += 1;
						_build_node = [__TXR_NODE.POSTFIX, tk[1], _build_node, tk[2]];
					} else return __TxrSystem._throw_at("Unexpected postfix", tk);
					break;
				case __TXR_TOKEN.OP: // value + ...?
					if ((flags & __TXR_BUILD_FLAG.NO_OPS) == 0) {
						_build_pos += 1;
						if (_build_ops(tk)) return true;
						flags |= __TXR_BUILD_FLAG.NO_SUFFIX;
					} else _break = true;
					break;
				default: _break = true;
			}
			if (_break) break;
		}
		return false;
	}

	/// @returns {bool} whether encountered an error
	static _build = function() {
		_build_list = __TxrSystem._parse_tokens;
		_build_pos = 0;
		_build_len = ds_list_size(_build_list) - 1; // (the last item is EOF)
		_build_can_break = false;
		_build_can_continue = false;
		ds_map_clear(_build_locals);
		var nodes = [];
		var found = 0;
		while (_build_pos < _build_len) {
			if (_build_stat()) return true;
			nodes[found++] = _build_node;
		}
		_build_node = [__TXR_NODE.BLOCK, 0, nodes];
		return false;
	}

	static _build_ops = function() {
		var nodes = ds_list_create();
		ds_list_add(nodes, _build_node);
		var ops = ds_list_create();
		ds_list_add(ops, argument0);
		//
		var tk;
		while (1) {
			// try to read the next expression and add it to list:
			if (_build_expr(__TXR_BUILD_FLAG.NO_OPS)) {
				ds_list_destroy(nodes);
				ds_list_destroy(ops);
				return true;
			}
			ds_list_add(nodes, _build_node);
			// if followed by an operator, add that too, stop otherwise:
			tk = _build_list[|_build_pos];
			if (tk[0] == __TXR_TOKEN.OP) {
				_build_pos++;
				ds_list_add(ops, tk);
			} else break;
		}
		// Nest operators from top to bottom priority:
		var n = ds_list_size(ops);
		var pmax = (__TXR_OP.MAXP >> 4);
		var pri = 0;
		while (pri < pmax) {
			for (var i = 0; i < n; i++) {
				tk = ops[|i];
				if ((tk[2] >> 4) != pri) continue;
				nodes[|i] = [__TXR_NODE.BINOP, tk[1], tk[2], nodes[|i], nodes[|i + 1]];
				ds_list_delete(nodes, i + 1);
				ds_list_delete(ops, i);
				n -= 1; i -= 1;
			}
			pri += 1;
		}
		// Cleanup and return:
		_build_node = nodes[|0];
		ds_list_destroy(nodes);
		ds_list_destroy(ops);
		return false;
	}

	static _build_expr_call = function(tk, _fn_script, _fn_argc, _args, _argc, _value_expr) {
		// read the arguments and the closing `)`:
		var closed = false;
		while (_build_pos < _build_len) {
			// hit a closing `)` yet?
			var tkn = _build_list[|_build_pos];
			if (tkn[0] == __TXR_TOKEN.PAR_CLOSE) {
				_build_pos += 1;
				closed = true;
				break;
			}
			// read the argument:
			if (_build_expr(0)) return true;
			_args[_argc++] = _build_node;
			// skip a `,`:
			tkn = _build_list[|_build_pos];
			if (tkn[0] == __TXR_TOKEN.COMMA) {
				_build_pos += 1;
			} else if (tkn[0] != __TXR_TOKEN.PAR_CLOSE) {
				return __TxrSystem._throw_at("Expected a `,` or `)`", tkn);
			}
		}
		if (!closed) return __TxrSystem._throw_at("Unclosed `()` after", tk);
		// find the function, verify argument count, and finally pack up:
		if (_fn_argc >= 0 && _argc != _fn_argc) return __TxrSystem._throw_at("`" + tk[2] + "` takes "
			+ string(_fn_argc) + " argument(s), got " + string(_argc), tk);
		if (_fn_script == undefined) {
			_build_node = [__TXR_NODE.VALUE_CALL, tk[1], _value_expr, _args, _fn_argc];
		} else _build_node = [__TXR_NODE.CALL, tk[1], _fn_script, _args, _fn_argc];
		return false;
	}

	static _build_loop_body = function() {
		var could_break = _build_can_break;
		var could_continue = _build_can_continue;
		_build_can_break = true;
		_build_can_continue = true;
		var trouble = _build_stat();
		_build_can_break = could_break;
		_build_can_continue = could_continue;
		return trouble;
	}

	static _build_stat = function() {
		var tk = _build_list[|_build_pos++], tkn;
		switch (tk[0]) {
			case __TXR_TOKEN.RET: // return <expr>
				if (_build_expr(0)) return true;
				_build_node = [__TXR_NODE.RET, tk[1], _build_node];
				break;
			case __TXR_TOKEN.IF: // if <condition-expr> <then-statement> [else <else-statement>]
				if (_build_expr(0)) return true;
				var _cond = _build_node;
				if (_build_stat()) return true;
				var _then = _build_node;
				tkn = _build_list[|_build_pos];
				if (tkn[0] == __TXR_TOKEN.ELSE) { // else <else-statement>
					_build_pos += 1;
					if (_build_stat()) return true;
					_build_node = [__TXR_NODE.IF_THEN_ELSE, tk[1], _cond, _then, _build_node];
				} else _build_node = [__TXR_NODE.IF_THEN, tk[1], _cond, _then];
				break;
			case __TXR_TOKEN.SELECT: // select func(...) { option <v1>: <x1>; option <v2>: <x2> }
				if (_build_expr(0)) return true;
				// verify that it's a vararg function call:
				var _func = _build_node;
				if (_func[0] != __TXR_NODE.CALL) return __TxrSystem._throw_at("Expected a function call", _func);
				if (_func[4] != -1) return __TxrSystem._throw_at("Function does not accept extra arguments", _func);
				var _args = _func[3];
				var _argc = array_length(_args);
				//
				tkn = _build_list[|_build_pos++];
				if (tkn[0] != __TXR_TOKEN.CUB_OPEN) return __TxrSystem._throw_at("Expected a `{`", tkn);
				var _opts = [], _optc = 0;
				var _default = undefined;
				var closed = false;
				while (_build_pos < _build_len) {
					tkn = _build_list[|_build_pos++];
					if (tkn[0] == __TXR_TOKEN.CUB_CLOSE) {
						closed = true;
						break;
					} else if (tkn[0] == __TXR_TOKEN.OPTION || tkn[0] == __TXR_TOKEN.DEFAULT) {
						var nodes = [], found = 0;
						if (tkn[0] == __TXR_TOKEN.OPTION) {// option <value>: ...statements
							if (_build_expr(0)) return true;
							_args[@_argc++] = _build_node;
							_opts[@_optc++] = [__TXR_NODE.BLOCK, tk[1], nodes];
						} else { // default: ...statements
							_default = [__TXR_NODE.BLOCK, tk[1], nodes];
						}
						//
						tkn = _build_list[|_build_pos++];
						if (tkn[0] != __TXR_TOKEN.COLON) return __TxrSystem._throw_at("Expected a `:`", tkn);
						// now read statements until we hit `option` or `}`:
						while (_build_pos < _build_len) {
							tkn = _build_list[|_build_pos];
							if (tkn[0] == __TXR_TOKEN.CUB_CLOSE
								|| tkn[0] == __TXR_TOKEN.OPTION
								|| tkn[0] == __TXR_TOKEN.DEFAULT
							) break;
							if (_build_stat()) return true;
							nodes[@found++] = _build_node;
						}
					} else return __TxrSystem._throw_at("Expected an `option` or `}`", tkn);
				}
				_build_node = [__TXR_NODE.SELECT, tk[1], _func, _opts, _default];
				break;
			case __TXR_TOKEN.SWITCH: // switch (expr) { ...cases [default:] }
				if (_build_expr(0)) return true;
				var _expr = _build_node;
				// this is pretty much the same as select but without argument packing
				tkn = _build_list[|_build_pos++];
				if (tkn[0] != __TXR_TOKEN.CUB_OPEN) return __TxrSystem._throw_at("Expected a `{`", tkn);
				//
				var _args = [], _opts = [], _optc = 0;
				var _default = undefined;
				var closed = false;
				var could_break = _build_can_break;
				_build_can_break = true;
				while (_build_pos < _build_len) {
					tkn = _build_list[|_build_pos++];
					if (tkn[0] == __TXR_TOKEN.CUB_OPEN) {
						closed = true;
						break;
					} else if (tkn[0] == __TXR_TOKEN.CASE || tkn[0] == __TXR_TOKEN.DEFAULT) {
						var nodes = [], found = 0;
						if (tkn[0] == __TXR_TOKEN.CASE) {// case <value>: ...statements
							if (_build_expr(0)) return true;
							_args[@_optc] = _build_node;
							_opts[@_optc++] = [__TXR_NODE.BLOCK, tk[1], nodes];
						} else { // default: ...statements
							_default = [__TXR_NODE.BLOCK, tk[1], nodes];
						}
						//
						tkn = _build_list[|_build_pos++];
						if (tkn[0] != __TXR_TOKEN.COLON) return __TxrSystem._throw_at("Expected a `:`", tkn);
						// now read statements until we hit `option` or `}`:
						while (_build_pos < _build_len) {
							tkn = _build_list[|_build_pos];
							if (tkn[0] == __TXR_TOKEN.CUB_CLOSE
								|| tkn[0] == __TXR_TOKEN.CASE
								|| tkn[0] == __TXR_TOKEN.DEFAULT
							) break;
							if (_build_stat()) return true;
							nodes[@found++] = _build_node;
						}
					} else return __TxrSystem._throw_at("Expected an `option` or `}`", tkn);
				}
				_build_can_break = could_break;
				_build_node = [__TXR_NODE.SWITCH, tk[1], _expr, _args, _opts, _default];
				break;
			case __TXR_TOKEN.CUB_OPEN: // { ... statements }
				var nodes = [], found = 0, closed = false;
				while (_build_pos < _build_len) {
					tkn = _build_list[|_build_pos];
					if (tkn[0] == __TXR_TOKEN.CUB_CLOSE) {
						_build_pos += 1;
						closed = true;
						break;
					}
					if (_build_stat()) return true;
					nodes[@found++] = _build_node;
				}
				if (!closed) return __TxrSystem._throw_at("Unclosed {} starting", tk);
				_build_node = [__TXR_NODE.BLOCK, tk[1], nodes];
				break;
			case __TXR_TOKEN.WHILE: // while <condition-expr> <loop-expr>
				if (_build_expr(0)) return true;
				var _cond = _build_node;
				if (_build_loop_body()) return true;
				_build_node = [__TXR_NODE.WHILE, tk[1], _cond, _build_node];
				break;
			case __TXR_TOKEN.DO: // do <loop-expr> while <condition-expr>
				if (_build_loop_body()) return true;
				var _loop = _build_node;
				// expect a `while`:
				tkn = _build_list[|_build_pos];
				if (tkn[0] != __TXR_TOKEN.WHILE) return __TxrSystem._throw_at("Expected a `while` after do", tkn);
				_build_pos += 1;
				// read condition:
				if (_build_expr(0)) return true;
				_build_node = [__TXR_NODE.DO_WHILE, tk[1], _loop, _build_node];
				break;
			case __TXR_TOKEN.FOR: // for (<init>; <cond-expr>; <post>) <loop>
				// see if there's a `(`:
				tkn = _build_list[|_build_pos];
				var _par = tkn[0] == __TXR_TOKEN.PAR_OPEN;
				if (_par) _build_pos += 1;
				// read init:
				if (_build_stat()) return true;
				var _init = _build_node;
				// read condition:
				if (_build_expr(0)) return true;
				var _cond = _build_node;
				tkn = _build_list[|_build_pos];
				if (tkn[0] == __TXR_TOKEN.SEMICO) _build_pos += 1;
				// read post-statement:
				if (_build_stat()) return true;
				var _post = _build_node;
				// see if there's a matching `)`?:
				if (_par) {
					tkn = _build_list[|_build_pos];
					if (tkn[0] != __TXR_TOKEN.PAR_CLOSE) return __TxrSystem._throw_at("Expected a `)`", tkn);
					_build_pos += 1;
				}
				// finally read the loop body:
				if (_build_loop_body()) return true;
				_build_node = [__TXR_NODE.FOR, tk[1], _init, _cond, _post, _build_node];
				break;
			case __TXR_TOKEN.BREAK:
				if (_build_can_break) {
					_build_node = [__TXR_NODE.BREAK, tk[1]];
				} else return __TxrSystem._throw_at("Can't `break` here", tk);
				break;
			case __TXR_TOKEN.CONTINUE:
				if (_build_can_continue) {
					_build_node = [__TXR_NODE.CONTINUE, tk[1]];
				} else return __TxrSystem._throw_at("Can't `continue` here", tk);
				break;
			case __TXR_TOKEN.VAR:
				var nodes = [], found = 0;
				do {
					tkn = _build_list[|_build_pos++];
					if (tkn[0] != __TXR_TOKEN.IDENT) return __TxrSystem._throw_at("Expected a variable name", tkn);
					var name = tkn[2];
					tkn = _build_list[|_build_pos];
					_build_locals[?name] = true;
					// check for value:
					if (tkn[0] == __TXR_TOKEN.SET) {
						_build_pos += 1;
						if (_build_expr(0)) return true;
						nodes[found++] = [__TXR_NODE.SET, tkn[1], __TXR_OP.SET,
							[__TXR_NODE.IDENT, tkn[1], name], _build_node];
					}
					// check for comma:
					tkn = _build_list[|_build_pos];
					if (tkn[0] == __TXR_TOKEN.COMMA) {
						_build_pos += 1;
					} else break;
				} until (_build_pos >= _build_len);
				_build_node = [__TXR_NODE.BLOCK, tk[1], nodes];
				break;
			case __TXR_TOKEN.LABEL:
				tkn = _build_list[|_build_pos++];
				if (tkn[0] != __TXR_TOKEN.IDENT) return __TxrSystem._throw_at("Expected a label name", tkn);
				var name = tkn[2];
				tkn = _build_list[|_build_pos];
				if (tkn[0] == __TXR_TOKEN.COLON) _build_pos++; // allow `label some:`
				if (_build_stat()) return true;
				_build_node = [__TXR_NODE.LABEL, tk[1], name, _build_node];
				break;
			case __TXR_TOKEN.JUMP:
				tkn = _build_list[|_build_pos++];
				if (tkn[0] != __TXR_TOKEN.IDENT) return __TxrSystem._throw_at("Expected a label name", tkn);
				_build_node = [__TXR_NODE.JUMP, tk[1], tkn[2]];
				break;
			case __TXR_TOKEN.JUMP_PUSH:
				tkn = _build_list[|_build_pos++];
				if (tkn[0] != __TXR_TOKEN.IDENT) return __TxrSystem._throw_at("Expected a label name", tkn);
				_build_node = [__TXR_NODE.JUMP_PUSH, tk[1], tkn[2]];
				break;
			case __TXR_TOKEN.JUMP_POP: _build_node = [__TXR_NODE.JUMP_POP, tk[1]]; break;
			default:
				_build_pos -= 1;
				if (_build_expr(__TXR_BUILD_FLAG.NO_OPS)) return true;
				var _expr = _build_node;
				switch (_expr[0]) {
					case __TXR_NODE.PREFIX: case __TXR_NODE.POSTFIX:
						_expr[@1] = __TXR_NODE.ADJFIX;
						break;
					case __TXR_NODE.CALL:
					case __TXR_NODE.VALUE_CALL:
						// select expressions are allowed to be statements,
						// and are compiled to `discard <value>` so that we don't clog the stack
						_build_node = [__TXR_NODE.DISCARD, _expr[1], _expr];
						break;
					default:
						tkn = _build_list[|_build_pos];
						if (tkn[0] == __TXR_TOKEN.SET) { // node = value
							_build_pos += 1;
							if (_build_expr(0)) return true;
							_build_node = [__TXR_NODE.SET, tkn[1], tkn[2], _expr, _build_node];
						} else return __TxrSystem._throw_at("Expected a statement", _build_node);
				}
		}
		// allow a semicolon after statements:
		tk = _build_list[|_build_pos];
		if (tk[0] == __TXR_TOKEN.SEMICO) _build_pos += 1;
	}
}
__TxrBuilder();

function __TxrCompiler() constructor {
	static _compile_list = ds_list_create();
	static _compile_labels = ds_map_create();
	static _exec_args = ds_list_create();

	/// @param q node
	/// @returns {bool} whether encountered an error
	static _compile_getter = function(q) {
		var out = _compile_list;
		switch (q[0]) {
			case __TXR_NODE.IDENT:
				var s = q[2];
				/*// example of global_some -> global.some
				if (string_length(s) > 7 && string_copy(s, 1, 7) == "global_") {
					out.add([__TXR_ACTION.STRING, q[1], string_delete(s, 1, 7)]);
					out.add([__TXR_ACTION.CALL, q[1], scr_txr_demo_global_get, 1]);
				} else
				//*/
				if (ds_map_exists(__TxrSystem._constant_map, s)) {
					var val = __TxrSystem._constant_map[?s];
					if (is_string(val)) {
						ds_list_add(out, [__TXR_ACTION.STRING, q[1], val]);
					} else {
						ds_list_add(out, [__TXR_ACTION.NUMBER, q[1], val]);
					}
				} else if (ds_map_exists(__TxrBuilder._build_locals, s)) {
					ds_list_add(out, [__TXR_ACTION.GET_LOCAL, q[1], s]);
				} else {
					ds_list_add(out, [__TXR_ACTION.IDENT, q[1], s]);
				}
				return false;
			case __TXR_NODE.FIELD:
				if (_compile_expr(q[2])) return true;
				ds_list_add(out, [__TXR_ACTION.GET_FIELD, q[1], q[3]]);
				return false;
			case __TXR_NODE.ARRAY_ACCESS:
				if (_compile_expr(q[2])) return true;
				if (_compile_expr(q[3])) return true;
				ds_list_add(out, [__TXR_ACTION.GET_ARRAY, q[1]]);
				return false;
			default: return __TxrSystem._throw_at("Expression is not gettable", q);
		}
	}

	/// @param q node
	/// @returns {bool} whether encountered an error
	static _compile_setter = function(q) {
		var out = _compile_list;
		switch (q[0]) {
			case __TXR_NODE.IDENT:
				var s = q[2];
				/*// example of global_some -> global.some
				if (string_length(s) > 7 && string_copy(s, 1, 7) == "global_") {
					out.add([__TXR_ACTION.STRING, q[1], string_delete(s, 1, 7)]);
					out.add([__TXR_ACTION.CALL, q[1], scr_txr_demo_global_set, 2]);
				} else
				//*/
				if (ds_map_exists(__TxrSystem._constant_map, s)) {
					return __TxrSystem._throw_at("Constants are not settable", q);
				} else if (ds_map_exists(__TxrBuilder._build_locals, s)) {
					ds_list_add(out, [__TXR_ACTION.SET_LOCAL, q[1], s]);
				} else {
					ds_list_add(out, [__TXR_ACTION.SET_IDENT, q[1], s]);
				}
				return false;
			case __TXR_NODE.FIELD:
				if (_compile_expr(q[2])) return true;
				ds_list_add(out, [__TXR_ACTION.SET_FIELD, q[1], q[3]]);
				return false;
			case __TXR_NODE.ARRAY_ACCESS:
				if (_compile_expr(q[2])) return true;
				if (_compile_expr(q[3])) return true;
				ds_list_add(out, [__TXR_ACTION.SET_ARRAY, q[1]]);
				return false;
			default: return __TxrSystem._throw_at("Expression is not settable", q);
		}
	}

	/// @param start_pos
	/// @param end_pos
	/// @param break_pos
	/// @param continue_pos
	static _compile_patch_break_continue = function(start_pos, end_pos, break_pos, continue_pos) {
		var out = _compile_list;
		for (var i = start_pos; i < end_pos; i++) {
			var act = out[|i];
			if (act[0] == __TXR_ACTION.JUMP) switch (act[2]) {
				case -10: if (break_pos >= 0) act[@2] = break_pos; break;
				case -11: if (continue_pos >= 0) act[@2] = continue_pos; break;
			}
		}
	}

	/// @returns {bool} whether encountered an error
	static _compile_expr = function(q) {
		var out = _compile_list;
		switch (q[0]) {
			case __TXR_NODE.NUMBER: ds_list_add(out, [__TXR_ACTION.NUMBER, q[1], q[2]]); break;
			case __TXR_NODE.STRING: ds_list_add(out, [__TXR_ACTION.STRING, q[1], q[2]]); break;
			case __TXR_NODE.IDENT: case __TXR_NODE.FIELD: case __TXR_NODE.ARRAY_ACCESS:
				if (_compile_getter(q)) return true;
				break;
			case __TXR_NODE.ARGUMENT: ds_list_add(out, [__TXR_ACTION.GET_LOCAL, q[1], q[3]]); break;
			case __TXR_NODE.ARGUMENT_COUNT: ds_list_add(out, [__TXR_ACTION.GET_LOCAL, q[1], "argument_count"]); break;
			case __TXR_NODE.UNOP:
				if (_compile_expr(q[3])) return true;
				ds_list_add(out, [__TXR_ACTION.UNOP, q[1], q[2]]);
				break;
			case __TXR_NODE.BINOP:
				switch (q[2]) {
					case __TXR_OP.BAND:
						if (_compile_expr(q[3])) return true;
						var jmp = [__TXR_ACTION.BAND, q[1], 0];
						ds_list_add(out, jmp);
						if (_compile_expr(q[4])) return true;
						jmp[@2] = ds_list_size(out);
						break;
					case __TXR_OP.BOR:
						if (_compile_expr(q[3])) return true;
						var jmp = [__TXR_ACTION.BOR, q[1], 0];
						ds_list_add(out, jmp);
						if (_compile_expr(q[4])) return true;
						jmp[@2] = ds_list_size(out);
						break;
					default:
						if (_compile_expr(q[3])) return true;
						if (_compile_expr(q[4])) return true;
						ds_list_add(out, [__TXR_ACTION.BINOP, q[1], q[2]]);
				}
				break;
			case __TXR_NODE.CALL:
			case __TXR_NODE.VALUE_CALL:
				var _is_value_call = q[0] == __TXR_NODE.VALUE_CALL;
				if (_is_value_call) if (_compile_expr(q[2])) return true;
				var args = q[3];
				var argc = array_length(args);
				for (var i = 0; i < argc; i++) {
					if (_compile_expr(args[i])) return true;
				}
				if (_is_value_call) {
					ds_list_add(out, [__TXR_ACTION.VALUE_CALL, q[1], argc])
				} else ds_list_add(out, [__TXR_ACTION.CALL, q[1], q[2], argc]);
				break;
			case __TXR_NODE.BLOCK:
				var nodes = q[2];
				var n = array_length(nodes);
				for (var i = 0; i < n; i++) {
					if (_compile_expr(nodes[i])) return true;
				}
				break;
			case __TXR_NODE.RET:
				if (_compile_expr(q[2])) return true;
				ds_list_add(out, [__TXR_ACTION.RET, q[1]]);
				break;
			case __TXR_NODE.DISCARD:
				if (_compile_expr(q[2])) return true;
				ds_list_add(out, [__TXR_ACTION.DISCARD, q[1]]);
				break;
			case __TXR_NODE.IF_THEN: // -> <cond>; jump_unless(l1); <then>; l1:
				if (_compile_expr(q[2])) return true;
				var jmp = [__TXR_ACTION.JUMP_UNLESS, q[1], 0];
				ds_list_add(out, jmp);
				if (_compile_expr(q[3])) return true;
				jmp[@2] = ds_list_size(out);
				break;
			case __TXR_NODE.IF_THEN_ELSE: // -> <cond>; jump_unless(l1); <then>; goto l2; l1: <else>; l2:
				if (_compile_expr(q[2])) return true;
				var jmp_else = [__TXR_ACTION.JUMP_UNLESS, q[1], 0];
				ds_list_add(out, jmp_else);
				if (_compile_expr(q[3])) return true;
				var jmp_then = [__TXR_ACTION.JUMP, q[1], 0];
				ds_list_add(out, jmp_then);
				jmp_else[@2] = ds_list_size(out);
				if (_compile_expr(q[4])) return true;
				jmp_then[@2] = ds_list_size(out);
				break;
			case __TXR_NODE.SELECT:
				// select [l1, l2], l3
				// l1: option 1; jump l4
				// l2: option 2; jump l4
				// l3: default
				// l4: ...
				if (_compile_expr(q[2])) return true;
				// selector node:
				var opts = q[3];
				var optc = array_length(opts);
				var sel_jmps = array_create(optc);
				var opt_jmps = array_create(optc);
				var _sel = [__TXR_ACTION.SELECT, q[1], sel_jmps, 0];
				ds_list_add(out, _sel);
				// options:
				for (var i = 0; i < optc; i++) {
					sel_jmps[@i] = ds_list_size(out);
					if (_compile_expr(opts[i])) return true;
					var jmp = [__TXR_ACTION.JUMP, q[1], 0];
					opt_jmps[@i] = jmp;
					ds_list_add(out, jmp);
				}
				// default;
				_sel[@3] = ds_list_size(out);
				if (q[4] != undefined) {
					if (_compile_expr(q[4])) return true;
				}
				// point end-of-option jumps to the end of select:
				for (var i = 0; i < optc; i++) {
					var jmp = opt_jmps[i];
					jmp[@2] = ds_list_size(out);
				}
				break;
			case __TXR_NODE.SWITCH:
				var args = q[3];
				var opts = q[4];
				var optc = array_length(opts);
				var arg_jmps = array_create(optc);
				// header:
				if (_compile_expr(q[2])) return true;
				for (var i = 0; i < optc; i++) { // value; switchjump <case label>
					if (_compile_expr(args[i])) return true;
					var jmp = [__TXR_ACTION.SWITCH, q[1], 0];
					arg_jmps[@i] = jmp;
					ds_list_add(out, jmp);
				}
				//
				ds_list_add(out, [__TXR_ACTION.DISCARD, q[1]]);
				var def_jmp = [__TXR_ACTION.JUMP, q[1], 0];
				ds_list_add(out, def_jmp);
				//
				var pos_start = ds_list_size(out);
				for (var i = 0; i < optc; i++) {
					var jmp = arg_jmps[i];
					jmp[@2] = ds_list_size(out);
					if (_compile_expr(opts[i])) return true;
				}
				//
				def_jmp[@2] = ds_list_size(out);
				if (q[5] != undefined) if (_compile_expr(q[5])) return true;
				//
				var pos_break = ds_list_size(out);
				_compile_patch_break_continue(pos_start, pos_break, pos_break, -1);
				break;
			case __TXR_NODE.SET:
				if (q[2] == __TXR_OP.SET) {
					if (_compile_expr(q[4])) return true;
				} else {
					// a %= b -> get a; get b; fmod; set a
					if (_compile_getter(q[3])) return true;
					if (_compile_expr(q[4])) return true;
					ds_list_add(out, [__TXR_ACTION.BINOP, q[1], q[2]]);
				}
				if (_compile_setter(q[3])) return true;
				break;
			case __TXR_NODE.ADJFIX: // a++; -> get a; push 1; add; set a
				if (_compile_getter(q[2])) return true;
				ds_list_add(out, [__TXR_ACTION.NUMBER, q[1], q[3]]);
				ds_list_add(out, [__TXR_ACTION.BINOP, q[1], __TXR_OP.ADD]);
				if (_compile_setter(q[2])) return true;
				break;
			case __TXR_NODE.PREFIX: // a++; -> get a; push 1; add; dup; set a
				if (_compile_getter(q[2])) return true;
				ds_list_add(out, [__TXR_ACTION.NUMBER, q[1], q[3]]);
				ds_list_add(out, [__TXR_ACTION.BINOP, q[1], __TXR_OP.ADD]);
				ds_list_add(out, [__TXR_ACTION.DUP, q[1]]);
				if (_compile_setter(q[2])) return true;
				break;
			case __TXR_NODE.POSTFIX:  // a++; -> get a; dup; push 1; add; set a
				if (_compile_getter(q[2])) return true;
				ds_list_add(out, [__TXR_ACTION.DUP, q[1]]);
				ds_list_add(out, [__TXR_ACTION.NUMBER, q[1], q[3]]);
				ds_list_add(out, [__TXR_ACTION.BINOP, q[1], __TXR_OP.ADD]);
				if (_compile_setter(q[2])) return true;
				break;
			case __TXR_NODE.WHILE:
				// l1: {cont} <condition> jump_unless l2
				var pos_cont = ds_list_size(out);
				if (_compile_expr(q[2])) return true;
				var jmp = [__TXR_ACTION.JUMP_UNLESS, q[1], 0];
				ds_list_add(out, jmp);
				// <loop> jump l1
				var pos_start = ds_list_size(out);
				if (_compile_expr(q[3])) return true;
				ds_list_add(out, [__TXR_ACTION.JUMP, q[1], pos_cont]);
				// l2: {break}
				var pos_break = ds_list_size(out);
				jmp[@2] = pos_break;
				_compile_patch_break_continue(pos_start, pos_break, pos_break, pos_cont);
				break;
			case __TXR_NODE.DO_WHILE:
				// l1: <loop>
				var pos_start = ds_list_size(out);
				if (_compile_expr(q[2])) return true;
				// l2: {cont} <condition> jump_if l1
				var pos_cont = ds_list_size(out);
				if (_compile_expr(q[3])) return true;
				ds_list_add(out, [__TXR_ACTION.JUMP_IF, q[1], pos_start]);
				// l3: {break}
				var pos_break = ds_list_size(out);
				_compile_patch_break_continue(pos_start, pos_break, pos_break, pos_cont);
				break;
			case __TXR_NODE.FOR:
				if (_compile_expr(q[2])) return true;
				// l1: <condition> jump_unless l3
				var pos_loop = ds_list_size(out);
				if (_compile_expr(q[3])) return true;
				var jmp = [__TXR_ACTION.JUMP_UNLESS, q[1], 0];
				ds_list_add(out, jmp);
				// <loop>
				var pos_start = ds_list_size(out);
				if (_compile_expr(q[5])) return true;
				// l2: {cont} <post> jump l1
				var pos_cont = ds_list_size(out);
				if (_compile_expr(q[4])) return true;
				ds_list_add(out, [__TXR_ACTION.JUMP, q[1], pos_loop]);
				// l3: {break}
				var pos_break = ds_list_size(out);
				jmp[@2] = pos_break;
				_compile_patch_break_continue(pos_start, pos_break, pos_break, pos_cont);
				break;
			case __TXR_NODE.BREAK: ds_list_add(out, [__TXR_ACTION.JUMP, q[1], -10]); break;
			case __TXR_NODE.CONTINUE: ds_list_add(out, [__TXR_ACTION.JUMP, q[1], -11]); break;
			case __TXR_NODE.LABEL:
				ds_list_add(out, [__TXR_ACTION.LABEL, q[1], q[2]]);
				var lbs = _compile_labels[?q[2]];
				if (lbs == undefined) {
					lbs = [ds_list_size(out)];
					_compile_labels[?q[2]] = lbs;
				} else lbs[@0] = ds_list_size(out);
				_compile_expr(q[3]);
				break;
			case __TXR_NODE.JUMP:
			case __TXR_NODE.JUMP_PUSH:
				var lbs = _compile_labels[?q[2]];
				if (lbs == undefined) {
					lbs = [undefined];
					_compile_labels[?q[2]] = lbs;
				}
				var i = (q[0] == __TXR_NODE.JUMP ? __TXR_ACTION.JUMP : __TXR_ACTION.JUMP_PUSH);
				var jmp = [i, q[1], undefined];
				ds_list_add(out, jmp);
				lbs[@array_length(lbs)] = jmp;
				break;
			case __TXR_NODE.JUMP_POP:
				ds_list_add(out, [__TXR_ACTION.JUMP_POP, q[1]]);
				break;
			case __TXR_NODE.ARRAY_LITERAL:
				var args = q[2];
				var argc = array_length(args);
				for (var i = 0; i < argc; i++) {
					if (_compile_expr(args[i])) return true;
				}
				ds_list_add(out, [__TXR_ACTION.ARRAY_LITERAL, q[1], argc]);
				break;
			case __TXR_NODE.OBJECT_LITERAL:
				var _keys = q[2];
				var _values = q[3];
				var n = array_length(_keys);
				for (var i = 0; i < n; i++) {
					if (_compile_expr(_values[i])) return true;
				}
				ds_list_add(out, [__TXR_ACTION.OBJECT_LITERAL, q[1], _keys]);
				break;
			default: return __TxrSystem._throw_at("Cannot compile node type " + string(q[0]), q);
		}
		return false;
	}

	static _compile = function(code) {
		if (__TxrSystem._parse(code)) return undefined;
		if (__TxrBuilder._build()) return undefined;
		var out = _compile_list;
		ds_list_clear(out);
		var lbm = _compile_labels;
		ds_map_clear(lbm);
		if (_compile_expr(__TxrBuilder._build_node)) return undefined;
		//
		var k = ds_map_find_first(lbm);
		repeat (ds_map_size(lbm)) {
			var lbs = lbm[?k];
			var lb;
			if (lbs[0] == undefined && array_length(lbs) > 1) {
				lb = lbs[1];
				__TxrSystem._throw_at("Using undeclared label " + k, lb);
				return undefined;
			}
			var _i = array_length(lbs);
			while (--_i >= 1) {
				lb = lbs[_i];
				lb[@2] = lbs[0];
			}
			k = ds_map_find_next(lbm, k);
		}
		//
		var _n = ds_list_size(out);
		var _arr = array_create(_n);
		for (var _i = 0; _i < _n; _i++) _arr[_i] = out[|_i];
		ds_list_clear(out);
		return _arr;
	}
}
__TxrCompiler();

function __TxrSerializer() constructor {

	static _action_print = function(q) {
		var i, n;
		var s = "[" + __TxrSystem._print_pos(q[1]) + "]";
		switch (q[0]) {
			case __TXR_ACTION.NUMBER: return __TxrSystem._sfmt("% number %", s, q[2]);
			case __TXR_ACTION.STRING: return __TxrSystem._sfmt("% string `%`", s, q[2]);
			case __TXR_ACTION.BINOP: return __TxrSystem._sfmt("% binop %", s, __TxrSystem._op_names[q[2]]);
			case __TXR_ACTION.DISCARD: return s + " discard";
			case __TXR_ACTION.DUP: return s + " dup";
			case __TXR_ACTION.CALL: return __TxrSystem._sfmt("% %(%)", s, script_get_name(q[2]), q[3]);
			case __TXR_ACTION.IDENT: return __TxrSystem._sfmt("% get ident %", s, q[2]);
			case __TXR_ACTION.SET_IDENT: return __TxrSystem._sfmt("% set ident %", s, q[2]);
			case __TXR_ACTION.GET_FIELD: return __TxrSystem._sfmt("% get field %", s, q[2]);
			case __TXR_ACTION.SET_FIELD: return __TxrSystem._sfmt("% set field %", s, q[2]);
			case __TXR_ACTION.GET_LOCAL: return __TxrSystem._sfmt("% get local %", s, q[2]);
			case __TXR_ACTION.SET_LOCAL: return __TxrSystem._sfmt("% set local %", s, q[2]);
			case __TXR_ACTION.JUMP: return __TxrSystem._sfmt("% jump %", s, q[2]);
			case __TXR_ACTION.JUMP_IF: return __TxrSystem._sfmt("% jump_if %", s, q[2]);
			case __TXR_ACTION.JUMP_UNLESS: return __TxrSystem._sfmt("% jump_unless %", s, q[2]);
			case __TXR_ACTION.SWITCH: return __TxrSystem._sfmt("% switch_jump %", s, q[2]);
			case __TXR_ACTION.GET_ARRAY: return s + " get array";
			case __TXR_ACTION.SET_ARRAY: return s + " set array";
			case __TXR_ACTION.ARRAY_LITERAL: return __TxrSystem._sfmt("% create array(%)", s, q[2]);
			case __TXR_ACTION.VALUE_CALL: return __TxrSystem._sfmt("% value call(%)", s, q[2]);
			default:
				s = __TxrSystem._sfmt("% A%", s, q[0]);
				n = array_length(q);
				for (i = 2; i < n; i++) s += " " + string(q[i]);
				return s;
		}
	}

	/// @param buffer
	/// @return action
	static _action_read = function(b) {
		var t = buffer_read(b, buffer_u8);
		var p = buffer_read(b, buffer_u32);
		switch (t) {
			case __TXR_ACTION.NUMBER: return [t, p, buffer_read(b, buffer_f64)];
			case __TXR_ACTION.UNOP:
			case __TXR_ACTION.BINOP:
				return [t, p, buffer_read(b, buffer_u8)];
			case __TXR_ACTION.CALL:
				var q = asset_get_index(buffer_read(b, buffer_string));
				return [t, p, q, buffer_read(b, buffer_u32)];
			case __TXR_ACTION.RET:
			case __TXR_ACTION.DISCARD:
			case __TXR_ACTION.JUMP_POP:
			case __TXR_ACTION.DUP:
			case __TXR_ACTION.GET_ARRAY:
			case __TXR_ACTION.SET_ARRAY:
				return [t, p];
			case __TXR_ACTION.JUMP:
			case __TXR_ACTION.JUMP_UNLESS:
			case __TXR_ACTION.JUMP_IF:
			case __TXR_ACTION.JUMP_PUSH:
			case __TXR_ACTION.BAND:
			case __TXR_ACTION.BOR:
			case __TXR_ACTION.SWITCH:
			case __TXR_ACTION.ARRAY_LITERAL:
				return [t, p, buffer_read(b, buffer_s32)];
				break;
			case __TXR_ACTION.STRING:
			case __TXR_ACTION.LABEL:
			case __TXR_ACTION.SET_IDENT:
			case __TXR_ACTION.IDENT:
			case __TXR_ACTION.GET_LOCAL:
			case __TXR_ACTION.SET_LOCAL:
			case __TXR_ACTION.GET_FIELD:
			case __TXR_ACTION.SET_FIELD:
				return [t, p, buffer_read(b, buffer_string)];
				break;
			case __TXR_ACTION.SELECT:
				var n = buffer_read(b, buffer_u32);
				var w = array_create(n);
				for (var i = 0; i < n; i++) w[i] = buffer_read(b, buffer_s32);
				return [t, p, w, buffer_read(b, buffer_s32)];
				//
				//
			default:
				show_error(__TxrSystem._sfmt("Please add a read for action type % to txr_action_read!", t), 1);
		}
	}

	/// @param a action
	/// @param b buffer
	static _action_write = function(a, b) {
		buffer_write(b, buffer_u8, a[0]);
		buffer_write(b, buffer_u32, a[1]);
		switch (a[0]) {
			case __TXR_ACTION.NUMBER: buffer_write(b, buffer_f64, a[2]); break;
			case __TXR_ACTION.UNOP: buffer_write(b, buffer_u8, a[2]); break;
			case __TXR_ACTION.BINOP: buffer_write(b, buffer_u8, a[2]); break;
			case __TXR_ACTION.CALL:
				buffer_write(b, buffer_string, script_get_name(a[2]));
				buffer_write(b, buffer_u32, a[3]);
				break;
			case __TXR_ACTION.RET:
			case __TXR_ACTION.DISCARD:
			case __TXR_ACTION.JUMP_POP:
			case __TXR_ACTION.DUP:
			case __TXR_ACTION.GET_ARRAY:
			case __TXR_ACTION.SET_ARRAY:
				break;
			case __TXR_ACTION.JUMP:
			case __TXR_ACTION.JUMP_UNLESS:
			case __TXR_ACTION.JUMP_IF:
			case __TXR_ACTION.JUMP_PUSH:
			case __TXR_ACTION.BAND:
			case __TXR_ACTION.BOR:
			case __TXR_ACTION.SWITCH:
			case __TXR_ACTION.ARRAY_LITERAL:
				buffer_write(b, buffer_s32, a[2]);
				break;
			case __TXR_ACTION.STRING:
			case __TXR_ACTION.LABEL:
			case __TXR_ACTION.SET_IDENT:
			case __TXR_ACTION.IDENT:
			case __TXR_ACTION.GET_LOCAL:
			case __TXR_ACTION.SET_LOCAL:
			case __TXR_ACTION.GET_FIELD:
			case __TXR_ACTION.SET_FIELD:
				buffer_write(b, buffer_string, a[2]);
				break;
			case __TXR_ACTION.SELECT:
				var w = a[2];
				var n = array_length(w);
				buffer_write(b, buffer_u32, n);
				for (var i = 0; i < n; i++) buffer_write(b, buffer_s32, w[i]);
				buffer_write(b, buffer_s32, a[3]);
				break;
			default:
				show_error(__TxrSystem._sfmt("Please add a writer for action type % to txr_action_write!", a[0]), 1);
		}
	}

	static _program_print = function(pg) {
		gml_pragma("global", "__TxrSystem._program_print_buf = buffer_create(1024, buffer_grow, 1);");
		var n = array_length(pg);
		var nn = string_length(string(n));
		var b = __TxrSystem._program_print_buf;
		buffer_seek(b, 0, 0);
		for (var i = 0; i < n; i++) {
			var ist = string(i);
			repeat (nn - string_length(ist)) buffer_write(b, buffer_u8, ord(" "));
			buffer_write(b, buffer_text, ist);
			buffer_write(b, buffer_u8, ord(" "));
			buffer_write(b, buffer_text, _action_print(pg[i]));
			buffer_write(b, buffer_u8, 13);
			buffer_write(b, buffer_u8, 10);
		}
		buffer_write(b, buffer_u8, 0);
		buffer_seek(b, 0, 0);
		return buffer_read(b, buffer_string);
	}

	/// @param b buffer
	static _program_read = function(b) {
		var n = buffer_read(b, buffer_u32);
		var w = array_create(n);
		for (var i = 0; i < n; i++) {
			w[i] = txr_action_read(b);
		}
		return w;
	}

	/// @param w program
	/// @param b buffer
	static _program_write = function(w, b) {
		var n = array_length(w);
		buffer_write(b, buffer_u32, n);
		for (var i = 0; i < n; i++) {
			_action_write(w[i], b);
		}
		return b;
	}

	/// @param b buffer
	/// @return thread
	static _thread_read = function(b) {
		var th/*:txr_thread*/ = array_create(__TXR_THREAD.SIZEOF);
		th[@__TXR_THREAD.STATUS] = buffer_read(b, buffer_u8);
		th[@__TXR_THREAD.POS] = buffer_read(b, buffer_s32);
		th[@__TXR_THREAD.RESULT] = _value_read(b);
		var s = ds_stack_create();
		repeat (buffer_read(b, buffer_u32)) ds_stack_push(s, _value_read(b));
		th[@__TXR_THREAD.STACK] = s;
		//
		s = ds_stack_create();
		repeat (buffer_read(b, buffer_u32)) ds_stack_push(s, buffer_read(b, buffer_s32));
		th[@__TXR_THREAD.JUMPSTACK] = s;
		var m = ds_map_create();
		n = buffer_read(b, buffer_u32);
		repeat (n) {
			var v = _value_read(b);
			m[?v] = _value_read(b);
		}
		th[@__TXR_THREAD.LOCALS] = m;
		var n = buffer_read(b, buffer_u32);
		var w = array_create(n);
		for (var i = 0; i < n; i++) {
			w[i] = _action_read(b);
		}
		th[@__TXR_THREAD.ACTIONS] = w;
		//
		return th;
	}

	/// @param th txr_thread
	/// @param b buffer
	static _thread_write = function(th, b) {
		buffer_write(b, buffer_u8, th[__TXR_THREAD.STATUS]);
		buffer_write(b, buffer_s32, th[__TXR_THREAD.POS]);
		_value_write(th[__TXR_THREAD.RESULT], b);
		var s = th[__TXR_THREAD.STACK];
		var n = ds_stack_size(s), i;
		var w = array_create(n), v;
		buffer_write(b, buffer_u32, n);
		for (i = 0; i < n; i++) w[i] = ds_stack_pop(s);
		while (--i >= 0) {
			v = w[i];
			_value_write(v, b);
			ds_stack_push(s, v);
		}
		//
		s = th[__TXR_THREAD.JUMPSTACK];
		n = ds_stack_size(s);
		w = array_create(n);
		buffer_write(b, buffer_u32, n);
		for (i = 0; i < n; i++) w[i] = ds_stack_pop(s);
		while (--i >= 0) {
			v = w[i];
			buffer_write(b, buffer_s32, v);
			ds_stack_push(s, v);
		}
		var m = th[__TXR_THREAD.LOCALS];
		n = ds_map_size(m);
		buffer_write(b, buffer_u32, n);
		v = ds_map_find_first(m);
		repeat (n) {
			_value_write(v, b);
			_value_write(m[?v], b);
			v = ds_map_find_next(m, v);
		}
		w = th[__TXR_THREAD.ACTIONS];
		n = array_length(w);
		buffer_write(b, buffer_u32, n);
		for (i = 0; i < n; i++) {
			_action_write(w[i], b);
		}
	}

	/// @param b buffer
	static _value_read = function(b) {
		switch (buffer_read(b, buffer_u8)) {
			case 1: return buffer_read(b, buffer_f64);
			case 2: return buffer_read(b, buffer_u64);
			case 3: return buffer_read(b, buffer_s32);
			case 4: return buffer_read(b, buffer_bool);
			case 5: return buffer_read(b, buffer_string);
			case 6:
				var n = buffer_read(b, buffer_u32);
				var r = array_create(n);
				for (var i = 0; i < n; i++) {
					r[i] = _value_read(b);
				}
				return r;
			default: return undefined;
		}
	}

	/// @param v value
	/// @param b buffer
	static _value_write = function(v, b) {
		if (is_real(v)) {
			buffer_write(b, buffer_u8, 1);
			buffer_write(b, buffer_f64, v);
		} else if (is_int64(v)) {
			buffer_write(b, buffer_u8, 2);
			buffer_write(b, buffer_u64, v);
		} else if (is_int32(v)) {
			buffer_write(b, buffer_u8, 3);
			buffer_write(b, buffer_s32, v);
		} else if (is_bool(v)) {
			buffer_write(b, buffer_u8, 4);
			buffer_write(b, buffer_bool, v);
		} else if (is_string(v)) {
			buffer_write(b, buffer_u8, 5);
			buffer_write(b, buffer_string, v);
		} else if (is_array(v)) {
			buffer_write(b, buffer_u8, 6);
			var n = array_length(v);
			buffer_write(b, buffer_u32, n);
			for (var i = 0; i < n; i++) {
				_value_write(v[i], b);
			}
		} else {
			buffer_write(b, buffer_u8, 0);
		}
	}
}
__TxrSerializer();

function __TxrSystem() constructor {
	static _error = "";
	static _function_error = undefined;
	static _thread_current = undefined;
	static _parse_tokens = ds_list_create();
	static _function_map = ds_map_create(); // <funcname:string, [script, argcount]>
	static _constant_map = ds_map_create(); // <constname:string, value>
	static _op_names = array_create(__TXR_OP.MAXP, "an operator");
	_op_names[@__TXR_OP.MUL] = "*";
	_op_names[@__TXR_OP.FDIV] = "/";
	_op_names[@__TXR_OP.FMOD] = "%";
	_op_names[@__TXR_OP.IDIV] = "div";
	_op_names[@__TXR_OP.ADD] = "+";
	_op_names[@__TXR_OP.SUB] = "-";
	_op_names[@__TXR_OP.SHL] = "<<";
	_op_names[@__TXR_OP.SHR] = ">>";
	_op_names[@__TXR_OP.IAND] = "&";
	_op_names[@__TXR_OP.IOR] = "|";
	_op_names[@__TXR_OP.IXOR] = "^";
	_op_names[@__TXR_OP.EQ] = "==";
	_op_names[@__TXR_OP.NE] = "!=";
	_op_names[@__TXR_OP.LT] = "<";
	_op_names[@__TXR_OP.LE] = "<=";
	_op_names[@__TXR_OP.GT] = ">";
	_op_names[@__TXR_OP.GE] = ">=";
	_op_names[@__TXR_OP.BAND] = "&&";
	_op_names[@__TXR_OP.BOR] = "||";

	/// @param {int} p pos
	/// @returns {string}
	/// TXR stores positions as row*32000+col. This function decodes that to readable format.
	static _print_pos = function(p) {
		var c = p % 32000;
		var cs; if (c >= 31999) cs = ".."; else cs = string(c + 1);
		return "line " + string(1 + (p - c) / 32000) + ", col " + cs;
	}

	/// @description _sfmt(format, ...values)
	/// @param format
	/// @param  ...values
	static _sfmt = function() {
		// _sfmt("%/% hp", 1, 2) -> "1/2 hp"
		var f = argument[0];
		var w = _sfmt_map[?f], i, n;
		if (w == undefined) {
			w[0] = "";
			_sfmt_map[?f] = w;
			i = string_pos("%", f);
			n = 0;
			while (i) {
				w[n++] = string_copy(f, 1, i - 1);
				f = string_delete(f, 1, i);
				i = string_pos("%", f);
			}
			w[n++] = f;
		} else n = array_length(w);
		//
		var b = _sfmt_buf;
		buffer_seek(b, buffer_seek_start, 0);
		buffer_write(b, buffer_text, w[0]);
		var m = argument_count;
		for (i = 1; i < n; i++) {
			if (i < m) {
				f = string(argument[i]);
				if (f != "") buffer_write(b, buffer_text, f);
			}
			f = w[i];
			if (f != "") buffer_write(b, buffer_text, f);
		}
		buffer_write(b, buffer_u8, 0);
		buffer_seek(b, buffer_seek_start, 0);
		return buffer_read(b, buffer_string);
	}
	static _sfmt_buf = buffer_create(1024, buffer_grow, 1);
	static _sfmt_map = ds_map_create();

	/// @desc _throw(error_text, position)
	/// @param error_text
	/// @param position
	static _throw = function(error_text, position) {
		_error =  error_text + " at " + string(position);
		return true;
	}

	/// @param error_text
	/// @param token
	static _throw_at = function(error_text, token) {
		if (token[0] == __TXR_TOKEN.EOF) {
			return _throw(error_text, "<EOF>");
		} else return _throw(error_text, _print_pos(token[1]));
	}

	static _parse = function(str) {
		var len = string_length(str);
		var out = _parse_tokens;
		ds_list_clear(out);
		var pos = 1;
		var line_start = 1;
		var line_number = 0;
		while (pos <= len) {
			var start = pos;
			var inf = line_number * 32000 + clamp(pos - line_start, 0, 31999);
			var char = string_ord_at(str, pos);
			pos += 1;
			switch (char) {
				case ord(" "): case ord("\t"): case ord("\r"): break;
				case ord("\n"): line_number++; line_start = pos; break;
				case ord(";"): ds_list_add(out, [__TXR_TOKEN.SEMICO, inf]); break;
				case ord(":"): ds_list_add(out, [__TXR_TOKEN.COLON, inf]); break;
				case ord("("): ds_list_add(out, [__TXR_TOKEN.PAR_OPEN, inf]); break;
				case ord(")"): ds_list_add(out, [__TXR_TOKEN.PAR_CLOSE, inf]); break;
				case ord("{"): ds_list_add(out, [__TXR_TOKEN.CUB_OPEN, inf]); break;
				case ord("}"): ds_list_add(out, [__TXR_TOKEN.CUB_CLOSE, inf]); break;
				case ord("["): ds_list_add(out, [__TXR_TOKEN.SQB_OPEN, inf]); break;
				case ord("]"): ds_list_add(out, [__TXR_TOKEN.SQB_CLOSE, inf]); break;
				case ord(","): ds_list_add(out, [__TXR_TOKEN.COMMA, inf]); break;
				case ord("."): ds_list_add(out, [__TXR_TOKEN.PERIOD, inf]); break;
				case ord("+"):
					switch (string_ord_at(str, pos)) {
						case ord("="): // +=
							pos += 1;
							ds_list_add(out, [__TXR_TOKEN.SET, inf, __TXR_OP.ADD]);
							break;
						case ord("+"): // ++
							pos += 1;
							ds_list_add(out, [__TXR_TOKEN.ADJFIX, inf, 1]);
							break;
						default:
							ds_list_add(out, [__TXR_TOKEN.OP, inf, __TXR_OP.ADD]);
					}
					break;
				case ord("-"):
					switch (string_ord_at(str, pos)) {
						case ord("="): // -=
							pos += 1;
							ds_list_add(out, [__TXR_TOKEN.SET, inf, __TXR_OP.SUB]);
							break;
						case ord("-"): // --
							pos += 1;
							ds_list_add(out, [__TXR_TOKEN.ADJFIX, inf, -1]);
							break;
						default:
							ds_list_add(out, [__TXR_TOKEN.OP, inf, __TXR_OP.SUB]);
					}
					break;
				case ord("*"):
					if (string_ord_at(str, pos) == ord("=")) { // *=
						pos += 1;
						ds_list_add(out, [__TXR_TOKEN.SET, inf, __TXR_OP.MUL]);
					} else ds_list_add(out, [__TXR_TOKEN.OP, inf, __TXR_OP.MUL]);
					break;
				case ord("/"):
					switch (string_ord_at(str, pos)) {
						case ord("="): // /=
							pos += 1;
							ds_list_add(out, [__TXR_TOKEN.SET, inf, __TXR_OP.FDIV]);
							break;
						case ord("/"): // line comment
							while (pos <= len) {
								char = string_ord_at(str, pos);
								if (char == ord("\r") || char == ord("\n")) break;
								pos += 1;
							}
							break;
						case ord("*"): // block comment
							pos += 1;
							while (pos <= len) {
								if (string_ord_at(str, pos) == ord("*")
								&& string_ord_at(str, pos + 1) == ord("/")) {
									pos += 2;
									break;
								}
								pos += 1;
							}
							break;
						default: ds_list_add(out, [__TXR_TOKEN.OP, inf, __TXR_OP.FDIV]);
					}
					break;
				case ord("%"):
					if (string_ord_at(str, pos) == ord("=")) { // %=
						pos += 1;
						ds_list_add(out, [__TXR_TOKEN.SET, inf, __TXR_OP.FMOD]);
					} else ds_list_add(out, [__TXR_TOKEN.OP, inf, __TXR_OP.FMOD]);
					break;
				case ord("!"):
					if (string_ord_at(str, pos) == ord("=")) { // !=
						pos += 1;
						ds_list_add(out, [__TXR_TOKEN.OP, inf, __TXR_OP.NE]);
					} else ds_list_add(out, [__TXR_TOKEN.UNOP, inf, __TXR_UNOP.INVERT]);
					break;
				case ord("="):
					if (string_ord_at(str, pos) == ord("=")) { // ==
						pos += 1;
						ds_list_add(out, [__TXR_TOKEN.OP, inf, __TXR_OP.EQ]);
					} else ds_list_add(out, [__TXR_TOKEN.SET, inf, __TXR_OP.SET]);
					break;
				case ord("<"):
					switch (string_ord_at(str, pos)) {
						case ord("="): // <=
							pos += 1;
							ds_list_add(out, [__TXR_TOKEN.OP, inf, __TXR_OP.LE]);
							break;
						case ord("<"): // <<
							pos += 1;
							ds_list_add(out, [__TXR_TOKEN.OP, inf, __TXR_OP.SHL]);
							break;
						default:
							ds_list_add(out, [__TXR_TOKEN.OP, inf, __TXR_OP.LT]);
					}
					break;
				case ord(">"):
					switch (string_ord_at(str, pos)) {
						case ord("="): // >=
							pos += 1;
							ds_list_add(out, [__TXR_TOKEN.OP, inf, __TXR_OP.GE]);
							break;
						case ord(">"): // >>
							pos += 1;
							ds_list_add(out, [__TXR_TOKEN.OP, inf, __TXR_OP.SHR]);
							break;
						default:
							ds_list_add(out, [__TXR_TOKEN.OP, inf, __TXR_OP.GT]);
					}
					break;
				case ord("'"): case ord("\""): // ord('"') in GMS1
					while (pos <= len) {
						if (string_ord_at(str, pos) == char) break;
						pos += 1;
					}
					if (pos <= len) {
						pos += 1;
						ds_list_add(out, [__TXR_TOKEN.STRING, inf,
							string_copy(str, start + 1, pos - start - 2)]);
					} else return __TxrSystem._throw("Unclosed string starting", __TxrSystem._print_pos(inf));
					break;
				case ord("|"):
					switch (string_ord_at(str, pos)) {
						case ord("|"): // ||
							pos += 1;
							ds_list_add(out, [__TXR_TOKEN.OP, inf, __TXR_OP.BOR]);
							break;
						case ord("="): // |=
							pos += 1;
							ds_list_add(out, [__TXR_TOKEN.SET, inf, __TXR_OP.IOR]);
							break;
						default:
							ds_list_add(out, [__TXR_TOKEN.OP, inf, __TXR_OP.IOR]);
					}
					break;
				case ord("&"):
					switch (string_ord_at(str, pos)) {
						case ord("&"): // &&
							pos += 1;
							ds_list_add(out, [__TXR_TOKEN.OP, inf, __TXR_OP.BAND]);
							break;
						case ord("="): // &=
							pos += 1;
							ds_list_add(out, [__TXR_TOKEN.SET, inf, __TXR_OP.IAND]);
							break;
						default:
							ds_list_add(out, [__TXR_TOKEN.OP, inf, __TXR_OP.IAND]);
					}
					break;
				case ord("^"):
					if (string_ord_at(str, pos) == ord("=")) { // ^=
						pos += 1;
						ds_list_add(out, [__TXR_TOKEN.SET, inf, __TXR_OP.IXOR]);
					} else ds_list_add(out, [__TXR_TOKEN.OP, inf, __TXR_OP.IXOR]);
					break;
				default:
					if (char >= ord("0") && char <= ord("9")) {
						var pre_dot = true;
						while (pos <= len) {
							char = string_ord_at(str, pos);
							if (char == ord(".")) {
								if (pre_dot) {
									pre_dot = false;
									pos += 1;
								} else break;
							} else if (char >= ord("0") && char <= ord("9")) {
								pos += 1;
							} else break;
						}
						var val = real(string_copy(str, start, pos - start));
						ds_list_add(out, [__TXR_TOKEN.NUMBER, inf, val]);
					}
					else if (char == ord("_")
						|| (char >= ord("a") && char <= ord("z"))
						|| (char >= ord("A") && char <= ord("Z"))
					) {
						while (pos <= len) {
							char = string_ord_at(str, pos);
							if (char == ord("_")
								|| (char >= ord("0") && char <= ord("9"))
								|| (char >= ord("a") && char <= ord("z"))
								|| (char >= ord("A") && char <= ord("Z"))
							) {
								pos += 1;
							} else break;
						}
						var name = string_copy(str, start, pos - start);
						switch (name) {
							case "true": ds_list_add(out, [__TXR_TOKEN.NUMBER, inf,true]); break;
							case "false": ds_list_add(out, [__TXR_TOKEN.NUMBER, inf,false]); break;
							case "mod": ds_list_add(out, [__TXR_TOKEN.OP, inf, __TXR_OP.FMOD]); break;
							case "div": ds_list_add(out, [__TXR_TOKEN.OP, inf, __TXR_OP.IDIV]); break;
							case "if": ds_list_add(out, [__TXR_TOKEN.IF, inf]); break;
							case "else": ds_list_add(out, [__TXR_TOKEN.ELSE, inf]); break;
							case "return": ds_list_add(out, [__TXR_TOKEN.RET, inf]); break;
							case "while": ds_list_add(out, [__TXR_TOKEN.WHILE, inf]); break;
							case "do": ds_list_add(out, [__TXR_TOKEN.DO, inf]); break;
							case "for": ds_list_add(out, [__TXR_TOKEN.FOR, inf]); break;
							case "break": ds_list_add(out, [__TXR_TOKEN.BREAK, inf]); break;
							case "continue": ds_list_add(out, [__TXR_TOKEN.CONTINUE, inf]); break;
							case "var": ds_list_add(out, [__TXR_TOKEN.VAR, inf]); break;
							case "argument_count": ds_list_add(out, [__TXR_TOKEN.ARGUMENT_COUNT, inf]); break;
							case "label": ds_list_add(out, [__TXR_TOKEN.LABEL, inf]); break;
							case "jump": ds_list_add(out, [__TXR_TOKEN.JUMP, inf]); break;
							case "call": ds_list_add(out, [__TXR_TOKEN.JUMP_PUSH, inf]); break;
							case "back": ds_list_add(out, [__TXR_TOKEN.JUMP_POP, inf]); break;
							case "select": ds_list_add(out, [__TXR_TOKEN.SELECT, inf]); break;
							case "option": ds_list_add(out, [__TXR_TOKEN.OPTION, inf]); break;
							case "default": ds_list_add(out, [__TXR_TOKEN.DEFAULT, inf]); break;
							case "switch": ds_list_add(out, [__TXR_TOKEN.SWITCH, inf]); break;
							case "case": ds_list_add(out, [__TXR_TOKEN.CASE, inf]); break;
							default:
								if (string_length(name) > 8 && string_copy(name, 1, 8) == "argument") {
									var sfx = string_delete(name, 1, 8); // substring(8) in non-GML
									if (string_digits(sfx) == sfx) {
										ds_list_add(out, [__TXR_TOKEN.ARGUMENT, inf, real(sfx), name]);
										break;
									}
								}
								ds_list_add(out, [__TXR_TOKEN.IDENT, inf, name]);
								break;
						}
					}
					else {
						ds_list_clear(out);
						return __TxrSystem._throw("Unexpected character `" + chr(char) + "`", __TxrSystem._print_pos(inf));
					}
			}
		}
		ds_list_add(out, [__TXR_TOKEN.EOF, string_length(str)]);
		return false;
	}

	/// @param {array} arr actions
	/// @param {array|struct|ds_map<string, any>} ?argd arguments
	/// @returns {txr_thread}
	static _thread_create = function(arr, argd) {
		var th/*:txr_thread*/ = array_create(__TXR_THREAD.SIZEOF);
		th[@__TXR_THREAD.ACTIONS] = arr;
		th[@__TXR_THREAD.POS] = 0;
		th[@__TXR_THREAD.STACK] = ds_stack_create();
		th[@__TXR_THREAD.JUMPSTACK] = ds_stack_create();
		th[@__TXR_THREAD.LOCALS] = {};
		th[@__TXR_THREAD.RESULT] = undefined;
		th[@__TXR_THREAD.STATUS] = __TXR_THREAD_STATUS.RUNNING;
		if (argd != undefined) _thread_set_args(th, argd);
		return th;
	}

	/// @param {txr_thread} th actions
	/// @param {array|struct|ds_map<string, any>} argd arguments
	static _thread_set_args = function(th/*:txr_thread*/, argd) {
		if (argd == undefined) return;
		if (is_array(argd)) { // an array of arguments
			var args/*:any[]*/ = argd /*#as array*/;
			var i = array_length(args);
			var locals = th[__TXR_THREAD.LOCALS];
			locals[$ "argument_count"] = i;
			locals[$ "argument"] = args;
			while (--i >= 0) locals[$ "argument" + string(i)] = args[i];
		} else if (is_struct(argd)) {
			var keys = variable_struct_get_names(argd /*#as struct*/);
			var i = array_length(keys);
			var locals = th[__TXR_THREAD.LOCALS];
			while (--i >= 0) {
				var key = keys[i];
				locals[$ key] = argd[$ key];
			}
		} else if (is_numeric(argd)) {
			var keys = ds_map_keys_to_array(argd /*#as ds_map*/);
			var i = array_length(keys);
			var locals = th[__TXR_THREAD.LOCALS];
			while (--i >= 0) {
				var key = keys[i];
				locals[$ key] = argd[? key];
			}
		}
	}

	static _thread_destroy = function(th/*:txr_thread*/) {
		if (th[__TXR_THREAD.ACTIONS] != undefined) {
			ds_stack_destroy(th[__TXR_THREAD.STACK]);
			ds_stack_destroy(th[__TXR_THREAD.JUMPSTACK]);
			th[@__TXR_THREAD.LOCALS] = undefined;
			th[@__TXR_THREAD.ACTIONS] = undefined;
			th[@__TXR_THREAD.STATUS] = __TXR_THREAD_STATUS.NONE;
		}
	}
	
	/// @param th txr_thread
	/// @param label label_name
	/// @returns {bool} whether succeeded
	static _thread_jump = function(th/*:txr_thread*/, label) {
		// equivalent to running `goto <name>` in thread
		var arr = th[__TXR_THREAD.ACTIONS];
		if (arr == undefined) exit;
		var pos = -1;
		repeat (array_length(arr)) {
			var act = arr[++pos];
			if (act[0] == __TXR_ACTION.LABEL && act[2] == label) {
				th[@__TXR_THREAD.POS] = pos;
				if (th[__TXR_THREAD.STATUS] == __TXR_THREAD_STATUS.RUNNING) {
					th[@__TXR_THREAD.STATUS] = __TXR_THREAD_STATUS.JUMP;
				}
				return true;
			}
		}
		return false;
	}

	/// @param th txr_thread
	/// @param label label_name
	/// @returns {bool} whether succeeded
	static _thread_jump_push = function(th/*:txr_thread*/, label) {
		var arr = th[__TXR_THREAD.ACTIONS];
		if (arr == undefined) exit;
		var pos = -1;
		repeat (array_length(arr)) {
			var act = arr[++pos];
			if (act[0] == __TXR_ACTION.LABEL && act[2] == label) {
				ds_stack_push(th[__TXR_THREAD.JUMPSTACK], th[__TXR_THREAD.POS]);
				th[@__TXR_THREAD.POS] = pos;
				if (th[__TXR_THREAD.STATUS] == __TXR_THREAD_STATUS.RUNNING) {
					th[@__TXR_THREAD.STATUS] = __TXR_THREAD_STATUS.JUMP;
				}
				return true;
			}
		}
		return false;
	}

	/// @param th txr_thread
	/// @param {array|struct|ds_map<string, any>} ?_args arguments
	static _thread_reset = function(th/*:txr_thread*/, _args) {
		th[@__TXR_THREAD.POS] = 0;
		ds_stack_clear(th[__TXR_THREAD.STACK]);
		ds_stack_clear(th[__TXR_THREAD.JUMPSTACK]);
		th[@__TXR_THREAD.LOCALS] = {};
		th[@__TXR_THREAD.RESULT] = undefined;
		th[@__TXR_THREAD.STATUS] = __TXR_THREAD_STATUS.RUNNING;
		if (_args != undefined) _thread_set_args(th, _args);
	}

	/// @param th txr_thread
	/// @param ?val - yield_value only used if resuming a thread after a yield
	/// @return {int} txr_thread_status
	//!#import ds_stack_* in ds_stack
	static _thread_resume = function(th/*:txr_thread*/, val = undefined) {
		var arr = th[__TXR_THREAD.ACTIONS];
		if (arr == undefined) exit;
		var _previous = _thread_current;
		_thread_current = th;
		var stack/*:ds_stack*/ = th[__TXR_THREAD.STACK];
		switch (th[__TXR_THREAD.STATUS]) {
			case __TXR_THREAD_STATUS.ERROR:
			case __TXR_THREAD_STATUS.FINISHED:
				return th[__TXR_THREAD.STATUS];
			case __TXR_THREAD_STATUS.YIELD:
				ds_stack_push(stack, val);
				break;
		}
		th[@__TXR_THREAD.RESULT] = val;
		var pos = th[__TXR_THREAD.POS];
		var len = array_length(arr);
		var locals = th[__TXR_THREAD.LOCALS];
		var q = undefined; 
		var halt = undefined;
		th[@__TXR_THREAD.STATUS] = __TXR_THREAD_STATUS.RUNNING;
		while (pos < len) {
			if (halt == __TXR_THREAD_STATUS.JUMP) {
				halt = undefined;
				pos = th[__TXR_THREAD.POS];
			} else if (halt != undefined) break;
			q = arr[pos++];
			switch (q[0]) {
				case __TXR_ACTION.LABEL: break;
				case __TXR_ACTION.NUMBER: ds_stack_push(stack, q[2]); break;
				case __TXR_ACTION.STRING: ds_stack_push(stack, q[2]); break;
				case __TXR_ACTION.UNOP:
					var v = ds_stack_pop(stack);
					if (q[2] == __TXR_UNOP.INVERT) {
						ds_stack_push(stack, v ? false : true);
					} else if (is_string(v)) {
						halt = "Can't apply unary - to a string";
						continue;
					} else ds_stack_push(stack, -v);
					break;
				case __TXR_ACTION.BINOP:
					var b = ds_stack_pop(stack);
					var a = ds_stack_pop(stack);
					if (q[2] == __TXR_OP.EQ) {
						a = (a == b);
					}
					else if (q[2] == __TXR_OP.NE) {
						a = (a != b);
					}
					else if (is_string(a) || is_string(b)) {
						if (q[2] == __TXR_OP.ADD) {
							if (!is_string(a)) a = string(a);
							if (!is_string(b)) b = string(b);
							a += b;
						} else {
							halt = _sfmt("Can't apply % to `%`[%] and `%`[%]", 
								_op_names[q[2]], a, typeof(a), b, typeof(b));
							continue;
						}
					}
					else if (is_numeric(a) && is_numeric(b)) switch (q[2]) {
						case __TXR_OP.ADD: a += b; break;
						case __TXR_OP.SUB: a -= b; break;
						case __TXR_OP.MUL: a *= b; break;
						case __TXR_OP.FDIV: a /= b; break;
						case __TXR_OP.FMOD: if (b != 0) a %= b; else a = 0; break;
						case __TXR_OP.IDIV: if (b != 0) a = a div b; else a = 0; break;
						case __TXR_OP.SHL: a = (a << b); break;
						case __TXR_OP.SHR: a = (a >> b); break;
						case __TXR_OP.IAND: a &= b; break;
						case __TXR_OP.IOR: a |= b; break;
						case __TXR_OP.IXOR: a ^= b; break;
						case __TXR_OP.LT: a = (a < b); break;
						case __TXR_OP.LE: a = (a <= b); break;
						case __TXR_OP.GT: a = (a > b); break;
						case __TXR_OP.GE: a = (a >= b); break;
						default:
							halt = _sfmt("Can't apply %", _op_names[q[2]]);
							continue;
					} else {
						halt = _sfmt("Can't apply % to `%`[%] and `%`[%]", 
							_op_names[q[2]], a, typeof(a), b, typeof(b));
						continue;
					}
					ds_stack_push(stack, a);
					break;
				case __TXR_ACTION.IDENT:
					var f = __TXR.GetIdent;
					if is_undefined(f) {
						ds_stack_push(stack, self[$ q[2]]);
					} else {
						try {
							ds_stack_push(stack, f(q[2], locals));
						} catch (e) {
							halt = _sfmt(e, q[2]);
							break;
						}
					}
					break;
				case __TXR_ACTION.SET_IDENT:
					var value = ds_stack_pop(stack);
					var f = __TXR.SetIdent;
					if is_undefined(f) {
						self[$ q[2]] = value;
					} else {
						try {
							// Note - The function should handle setting the value.
							f(q[2], value, locals);
						} catch (e) {
							halt = _sfmt(e, q[2]);
						}
					}
					break;
				case __TXR_ACTION.GET_FIELD:
					var v = ds_stack_pop(stack);
					var f = __TXR.GetField;
					if is_undefined(v) {
						halt = _sfmt("Cannot access (%) of undefined", q[2]);
						break;
					}
					if is_undefined(f) {
						v = variable_instance_get(v, q[2]);
					} else {
						try {
							v = f(v, q[2], locals);
						} catch (e) {
							halt = _sfmt(e, q[2]);
							break;
						}
					}
					ds_stack_push(stack, v);
					break;
				case __TXR_ACTION.SET_FIELD:
					var v = ds_stack_pop(stack);
					var f = __TXR.SetField;
					if is_undefined(v) {
						halt = _sfmt("Cannot access (%) of undefined", q[2]);
						break;
					} if is_undefined(f) {
						variable_instance_set(v, q[2], ds_stack_pop(stack));
					} else {
						try {
							v = f(v, q[2], ds_stack_pop(stack), locals);
						} catch (e) {
							halt = _sfmt(e, q[2]);
							break;
						}
					}
					break;
				case __TXR_ACTION.GET_LOCAL:
					ds_stack_push(stack, locals[$ q[2]]);
					break;
				case __TXR_ACTION.SET_LOCAL:
					locals[$ q[2]] = ds_stack_pop(stack);
					break;
				case __TXR_ACTION.CALL:
				case __TXR_ACTION.VALUE_CALL:
					var args = __TxrCompiler._exec_args;
					var _is_value_call = (q[0] == __TXR_ACTION.VALUE_CALL);
					ds_list_clear(args);
					var argc = q[_is_value_call ? 2 : 3];
					var i = argc, v;
					while (--i >= 0) args[|i] = ds_stack_pop(stack);
					_function_error = undefined;
					th[@__TXR_THREAD.POS] = pos;
					var fn = _is_value_call ? ds_stack_pop(stack) : q[2];
					try {
						switch (argc) {
							case  0: v = fn(); break;
							case  1: v = fn(args[|0]); break;
							case  2: v = fn(args[|0], args[|1]); break;
							case  3: v = fn(args[|0], args[|1], args[|2]); break;
							case  4: v = fn(args[|0], args[|1], args[|2], args[|3]); break;
							case  5: v = fn(args[|0], args[|1], args[|2], args[|3], args[|4]); break;
							case  6: v = fn(args[|0], args[|1], args[|2], args[|3], args[|4], args[|5]); break;
							case  7: v = fn(args[|0], args[|1], args[|2], args[|3], args[|4], args[|5], args[|6]); break;
							case  8: v = fn(args[|0], args[|1], args[|2], args[|3], args[|4], args[|5], args[|6], args[|7]); break;
							case  9: v = fn(args[|0], args[|1], args[|2], args[|3], args[|4], args[|5], args[|6], args[|7], args[|8]); break;
							case 10: v = fn(args[|0], args[|1], args[|2], args[|3], args[|4], args[|5], args[|6], args[|7], args[|8], args[|9]); break;
							case 11: v = fn(args[|0], args[|1], args[|2], args[|3], args[|4], args[|5], args[|6], args[|7], args[|8], args[|9], args[|10]); break;
							case 12: v = fn(args[|0], args[|1], args[|2], args[|3], args[|4], args[|5], args[|6], args[|7], args[|8], args[|9], args[|10], args[|11]); break;
							case 13: v = fn(args[|0], args[|1], args[|2], args[|3], args[|4], args[|5], args[|6], args[|7], args[|8], args[|9], args[|10], args[|11], args[|12]); break;
							case 14: v = fn(args[|0], args[|1], args[|2], args[|3], args[|4], args[|5], args[|6], args[|7], args[|8], args[|9], args[|10], args[|11], args[|12], args[|13]); break;
							case 15: v = fn(args[|0], args[|1], args[|2], args[|3], args[|4], args[|5], args[|6], args[|7], args[|8], args[|9], args[|10], args[|11], args[|12], args[|13], args[|14]); break;
							case 16: v = fn(args[|0], args[|1], args[|2], args[|3], args[|4], args[|5], args[|6], args[|7], args[|8], args[|9], args[|10], args[|11], args[|12], args[|13], args[|14], args[|15]); break;
							// and so on
							default:
								halt = _sfmt("Too many arguments for a call (%)", q[3]);
								continue;
						}
						// hit an error?:
						halt = _function_error;
					} catch (e) {
						halt = e.message;
					}
					if (halt != undefined) continue;
					// thread yielded/destroyed?:
					if (th[__TXR_THREAD.STATUS] != __TXR_THREAD_STATUS.RUNNING) {
						halt = th[__TXR_THREAD.STATUS];
						if (halt == __TXR_THREAD_STATUS.JUMP) {
							th[@__TXR_THREAD.STATUS] = __TXR_THREAD_STATUS.RUNNING;
							ds_stack_push(stack, v);
						}
						continue;
					}
					ds_stack_push(stack, v);
					break;
				case __TXR_ACTION.RET: pos = len; break;
				case __TXR_ACTION.DISCARD:
					if (ds_stack_empty(stack)) show_error("Discard on an empty stack! Suspicious.", 0);
					ds_stack_pop(stack);
					break;
				case __TXR_ACTION.JUMP: pos = q[2]; break;
				case __TXR_ACTION.JUMP_UNLESS:
					if (ds_stack_pop(stack)) {
						// OK!
					} else pos = q[2];
					break;
				case __TXR_ACTION.JUMP_IF:
					if (ds_stack_pop(stack)) pos = q[2];
					break;
				case __TXR_ACTION.BAND:
					if (ds_stack_top(stack)) {
						ds_stack_pop(stack);
					} else pos = q[2];
					break;
				case __TXR_ACTION.BOR:
					if (ds_stack_top(stack)) {
						pos = q[2];
					} else ds_stack_pop(stack);
					break;
				case __TXR_ACTION.JUMP_PUSH:
					ds_stack_push(th[__TXR_THREAD.JUMPSTACK], pos);
					pos = q[2];
					break;
				case __TXR_ACTION.JUMP_POP:
					pos = ds_stack_pop(th[__TXR_THREAD.JUMPSTACK]);
					break;
				case __TXR_ACTION.SELECT:
					var v = ds_stack_pop(stack);
					var posx = q[2];
					if (is_numeric(v) && v >= 0 && v < array_length(posx)) {
						pos = posx[v];
					} else pos = q[3];
					break;
				case __TXR_ACTION.DUP:
					ds_stack_push(stack, ds_stack_top(stack));
					break;
				case __TXR_ACTION.SWITCH:
					var v = ds_stack_pop(stack);
					if (v == ds_stack_top(stack)) {
						ds_stack_pop(stack);
						pos = q[2];
					}
					break;
				case __TXR_ACTION.GET_ARRAY:
					var i = ds_stack_pop(stack);
					var a = ds_stack_pop(stack);
					if (is_array(a)) {
						if (is_numeric(i)) {
							if (i >= 0 && i < array_length(a)) {
								ds_stack_push(stack, a[i]);
							} else halt = _sfmt("Index `%` is out of range (0...% excl.) for get", i, array_length(a));
						} else halt = _sfmt("`%` (%) is not an index for get", i, typeof(i));
					} else halt = _sfmt("`%` (%) is not an array for get", a, typeof(a));
					break;
				case __TXR_ACTION.SET_ARRAY:
					var i = ds_stack_pop(stack);
					var a = ds_stack_pop(stack);
					var v = ds_stack_pop(stack);
					if (is_array(a)) {
						if (is_numeric(i)) {
							if (i >= 0 && i < 32000) {
								a[@i] = v;
							} else halt = _sfmt("Invalid index `%` for set", i);
						} else halt = _sfmt("`%` (%) is not an index for set", i, typeof(i));
					} else halt = _sfmt("`%` (%) is not an array for set", a, typeof(a));
					break;
				case __TXR_ACTION.ARRAY_LITERAL:
					var i = q[2];
					var a = array_create(i);
					while (--i >= 0) a[i] = ds_stack_pop(stack);
					ds_stack_push(stack, a);
					break;
				case __TXR_ACTION.OBJECT_LITERAL:
					var _keys = q[2];
					var i = array_length(_keys);
					var o = {};
					while (--i >= 0) {
						o[$ _keys[i]] = ds_stack_pop(stack);
					}
					ds_stack_push(stack, o);
					break;
				default:
					halt = _sfmt("Can't run action ID %", q[0]);
					continue;
			}
		}
		if (halt == undefined) {
			th[@__TXR_THREAD.STATUS] = __TXR_THREAD_STATUS.FINISHED;
			if (ds_stack_empty(stack)) {
				th[@__TXR_THREAD.RESULT] = 0;
			} else th[@__TXR_THREAD.RESULT] = ds_stack_pop(stack);
		} else if (is_string(halt)) {
			th[@__TXR_THREAD.STATUS] = __TXR_THREAD_STATUS.ERROR;
			th[@__TXR_THREAD.RESULT] = halt + " at " + _print_pos(q[1]);
		}
		th[@__TXR_THREAD.POS] = pos;
		_thread_current = _previous;
		return th[__TXR_THREAD.STATUS];
	}

	/// Causes the currently executing thread to yield,
	/// suspending it's execution. The thread can later
	/// be resumed by calling txr_thread_resume(th, result)
	/// and `result` will be returned to the resuming code.
	/// See https://en.wikipedia.org/wiki/Coroutine
	static _thread_yield = function() {
		var th/*:txr_thread*/ = _thread_current;
		if (th != undefined) {
			th[@__TXR_THREAD.STATUS] = __TXR_THREAD_STATUS.YIELD;
			return th;
		} else return undefined;
	}

	/// @param {string} _name
	/// @param {string|number|undefined} _value
	/// Registers a constant
	static _constant_add = function(_name, _value) {
		if (is_string(_value) || is_numeric(_value) || is_undefined(_value)) {
			_constant_map[?_name] = _value;
		} else show_error("Expected a string or a number for constant, got " + typeof(_value), true);
	}

	/// @param {string} _name
	/// @param {script|function} _script
	/// @param {int} _argc args count
	/// Registers a script for use as a function in TXR programs
	static _function_add = function(_name, _script, _argc) {
		_function_map[?_name] = [_script, _argc];
	}

	/// @param {array} _actions
	/// @param {array|struct|ds_map} ?_args
	static _exec_actions = function(_actions, _args) {
		var th/*:txr_thread*/ = txr_thread_create(_actions, _args);
		var result = undefined;
		switch (_thread_resume(th)) {
			case txr_thread_status.finished:
				__TxrSystem._error = "";
				result = th[txr_thread.result];
				break;
			case txr_thread_status.error:
				__TxrSystem._error = th[txr_thread.result];
				break;
			default:
				__TxrSystem._error = "Thread paused execution but you are using txr_exec instead of txr_thread_resume";
				break;
		}
		txr_thread_destroy(th);
		return result;
	}
	
	/// @param {string} _code
	/// @param {array|struct|ds_map} ?_args
	static _exec_string = function(_code, _args = undefined) {
		var _actions = __TxrCompiler._compile(_code);
		if (_actions == undefined) return undefined;
		return _exec_actions(_actions, _args);
	}

	/// @param {string|array} _code_or_actions
	/// @param {array|struct|ds_map} ?_args
	static _exec = function(_code_or_actions, _args = undefined) {
		if (is_string(_code_or_actions)) {
			return _exec_string(_code_or_actions /*#as string*/, _args);
		} else {
			return _exec_actions(_code_or_actions /*#as array*/, _args);
		}
	}

}
__TxrSystem();
#endregion

function __TXR() constructor {
	static System = static_get(__TxrSystem);
	static Serializer = static_get(__TxrSerializer);
	static Compiler = static_get(__TxrCompiler);
	static Builder = static_get(__TxrBuilder);

	/// Override functions for ident's and field's get/set functions:
	/// If overridden, you must set the value to the resolved identifier yourself.

	/// If assigned, any calls to unknown functions will instead call this with
	/// function name as the first argument
	static DefaultFunction = ken_txr_default_function

	/**
	 * @function GetIdent
	 * @memberof Kengine.TXR
	 * @private
	 * @param {String} ident
	 * @param {Struct} locals
	 * @param {Bool} convertdot
	 * @return {Any}
	 * 
	 */
	static GetIdent = function(ident, locals, convertdot=true) {
		if convertdot {
			ident = __KengineParserUtils.__ident2dot(ident);
		}
		var _curr = undefined;

		if locals != undefined {
			_curr = locals[$ ident];
		}

		var k_ = _curr;
		switch(ident) {
			case "global": _curr = locals break;
			default: 
				var _statics = KENGINE_PARSER_STATICS;
				if _statics == undefined {
					break;
				}
				var _dots;
				var _dot;
				var _sta;
				for (var _i=0; _i<array_length(_statics); _i++) {
					if ident ==_statics[_i][0] {
						if array_length(_statics[_i]) == 2 {
							_sta = _statics[_i][1];
						} else {
							_sta = _statics[_i][0];
						}
						_curr = __KengineParserUtils.__InterpretDotValue(_sta);
						break;
					}
				}
				break;
		}
		if _curr != undefined {
			return _curr;
		}

		_curr = __KengineParserUtils.__InterpretDotValue(ident);
		if _curr != undefined {
			// Do return arrays.
			if is_array(_curr) {
				return _curr;
			}
			// Use rulings.
			var r = 0;
			var rules = KENGINE_PARSER_FIELD_RULES;
			for (var i=0; i<array_length(rules); i++) {
				switch (rules[i]) {
					case "?": // allow only not private (public)
						if ! __KengineStructUtils.IsPrivate(_curr) == true {
							continue
						} else {
							r = "1";
						}
						break;
					case "!?": // allow only private (not public)
						if ! __KengineStructUtils.IsPrivate(_curr) == false {
							continue
						} else {
							r = "2";
						}
						break;
				}
			}
			if r == 0 {
				return _curr;
			}
		} else {
			return undefined;
		}
	}

	/**
	 * @function SetIdent
	 * @memberof Kengine.Utils.Parser
	 * @private
	 * @param {String} ident
	 * @param {Any} val
	 * @param {Struct} locals
	 * @param {Bool} convertdot
	 * @return {Bool}
	 * 
	 */
	static SetIdent = function(ident, val, locals, convertdot=true) {
		var _txr = __KengineParserUtils.__Interpreter;
		if convertdot {
			ident = __KengineParserUtils.__ident2dot(ident);
		}

		locals[$ ident] = val;
		return val;

		_txr.System._function_error = ident + " is not assignable.";
		var obj = __KengineStructUtils.Get(_txr.System._thread_current[__TXR_THREAD.LOCALS], "script_object");
		var ev = __KengineStructUtils.Get(_txr.System._thread_current[__TXR_THREAD.LOCALS], "event");
		Kengine.console.echo_error("Error in: " + string(obj) + ", event: " + string(ev) + ": " + string(_txr.System._function_error));
		return false;
	}

	/**
	 * @function GetField
	 * @memberof Kengine.Utils.Parser
	 * @private
	 * @param {Any} curr
	 * @param {String} field
	 * @param {Struct} locals
	 * @return {Any}
	 * 
	 */
	static GetField = function(curr, field, locals) {
		if __KengineStructUtils.IsPublic(curr, field) {
			curr = variable_instance_get(curr, field);
			if not __KengineStructUtils.IsPrivate(curr) return curr;
		}
		var __ap = __KengineStructUtils.Get(locals, "__allow_private");
		if __ap != undefined {
			if __ap {
				if __KengineStructUtils.IsPrivate(curr, field) {
					return variable_instance_get(curr, field);
				}
			}
		}
	}

	/**
	 * @function SetField
	 * @memberof Kengine.Utils.Parser
	 * @private
	 * @param {Any} curr
	 * @param {String} field
	 * @param {Any} value
	 * @param {Struct} locals
	 * @return {Any}
	 * 
	 */
	static SetField = function(curr, field, value, locals) {
		if __KengineStructUtils.IsPublic(curr, field) {
			if not __KengineStructUtils.IsReadonly(curr, field) {
				variable_instance_set(curr, field, value);
				return value;
			} else {
				throw "Cannot set readonly member.";
			}
		}
		var __ap = __KengineStructUtils.Get(locals, "__allow_private");
		if __ap != undefined {
			if __ap {
				if __KengineStructUtils.IsPrivate(curr, field) {
					variable_instance_set(curr, field, value);
					return value;
				}
			}
		}
	}

}	
__TXR();
