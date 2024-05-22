/**
 * @typedef {Kengine.Extensions.Panels.PanelItemOptions} PanelItemInputBoxOptions
 * @memberof Kengine.Extensions.Panels
 * @see {@link KengineOptions}
 * 
 * @property {Bool} [readonly]
 * @property {String} [identifier]
 * @property {Bool} [box_enabled]
 * @property {Bool} [autoc_enabled]
 * @property {Bool} [history_enabled]
 * @property {Bool} [active]
 * @property {Real} [background]
 * @property {String} [text]
 * 
 * @description PanelItemInputBox options struct.
 * 
 */
function __KenginePanelsPanelItemInputBoxOptions(options) : __KenginePanelsPanelItemOptions(options) constructor {
    __default_width = 20;
    __default_height = 16;
	__default_color = c_white;
	__default_alpha = 1;

	__start(options)
    __add("readonly", true)
    __add("identifier", "input_all")
    __add("box_enabled", undefined)
    __add("autoc_enabled", false)
    __add("history_enabled", false)
    __add("active", undefined)
    __add("background", undefined)
    __add("text", "")
    __done()
}
/**
 * @function PanelItemInputBox
 * @memberof Kengine.Extensions.Panels
 * @description A `PanelItemInputBox` is a text box that can be readonly or writable on self or parent focus.
 * @param {Struct} options an initial struct for setting options.
 */
function __KenginePanelsPanelItemInputBox(options) : __KenginePanelsPanelItem(options) constructor {

    if not is_instanceof(options, __KenginePanelsPanelItemInputBoxOptions) {
		options = new __KenginePanelsPanelItemInputBoxOptions(options);
	}
    KengineOptions.__Apply(options, self);

    self.value_temp = self.value;
	if self.active == undefined {
		self.active = false;
		if parent != undefined {
			if __KengineStructUtils.Exists(parent, "active_child") {
				if parent.active_child == undefined {
					if not self.readonly self.active = true;
				}
			}
		}
	}

	cursor_pos = max(0,string_length(value) - 1);
	__cursor_talpha = 1;
	__cursor_tspeed = .5;
	__cursor_ttimer = 0;
	__mcursor_start = 0;
	cursor_color = c_white;
	box_enabled = !readonly;

	__kbd_key_timer = 0;
	__kbd_last_key = vk_nokey;
	__kbd_sel_start = -1;
	__kbd_hold_timer = .5;

	history_pos = 0;

	autoc = "";
	__autoc_pos = 0;

	__xoffset = 0;
	draw_set_font(font);
	__str_height = string_height("|");
	__str_width = string_width("_");

	self.Step = function() {
		var _x = x + parent.content_x
		var _y = y + parent.content_y
		var _mouse_x = device_mouse_x_to_gui(0);
		var _mouse_y = device_mouse_y_to_gui(0);
		var _game_speed = game_get_speed(gamespeed_fps);
		if not readonly {
			if visible and parent.visible {
				var _temp_pos;
				var _m_inside = false;
				if _mouse_x >= parent.x + _x and _mouse_y >= parent.y + _y and _mouse_x < parent.x + _x + width and _mouse_y < parent.y + _y + height {
					_m_inside = true;
				}
				var _mb_pressed, _mb_held, _mb_released, _mb_pressed_twice = false, _mb_pressed_thrice = false;
				if mouse_check_button_pressed(mb_left) {_mb_pressed = true;} else {_mb_pressed = false;}
				if mouse_check_button(mb_left) {_mb_held = true;} else {_mb_held = false;}
				if mouse_check_button_released(mb_left) {_mb_released = true;} else {_mb_released = false;}
				
				if _mb_pressed and _m_inside {
					active = true;
				} else if _mb_pressed and (not _m_inside) and active {
					active = false;
				}
				
				if active {
					if _m_inside {
						window_set_cursor(cr_beam);
						if _mb_pressed {
							__mcursor_start = min((_mouse_x - (parent.x + _x)) / __str_width, string_length(value));
							__mcursor_start += __xoffset;
						} else if _mb_held {
							cursor_pos = min((_mouse_x - (parent.x + _x)) / __str_width, string_length(value));
							cursor_pos += __xoffset;
							selection_set(__mcursor_start, cursor_pos);
						} else if _mb_released {
							__mcursor_start = 0;
						}
					} else {
						window_set_cursor(cr_default);
					}
					/// feather ignore GM1044
					if keyboard_lastkey == __kbd_last_key {
						__kbd_key_timer ++;
					} else {
						__kbd_key_timer = 0;
					}

					// Backspace
					if __KengineInputUtils.keyboard_check(vk_backspace) & (__kbd_key_timer == 0 or __kbd_key_timer > __kbd_hold_timer*_game_speed) {
						if __kbd_sel_start != -1 {
							selection_remove();
						}
					}

					// Arrows + Ctrl Arrows
					if (__KengineInputUtils.keyboard_check(vk_left) & (__kbd_key_timer == 0 or __kbd_key_timer > __kbd_hold_timer*_game_speed)) {
						if (__KengineInputUtils.keyboard_check(vk_shift)) {
							if (__kbd_sel_start == -1) {
								// Begin selection
								__kbd_sel_start = cursor_pos;
								}
							} else {
								// Remove selection
								__kbd_sel_start = -1;
							}
							if (__KengineInputUtils.keyboard_check(vk_control)) {
								var cp = cursor_pos;
								cursor_pos = __KengineStringUtils.PosDirection(value, " ", 1, cursor_pos);
								if (cursor_pos > cp) {cursor_pos = 0;}
							}
							autoc = "";
							__cursor_talpha = 1;
							__cursor_ttimer = 0;
							if cursor_pos>0 cursor_pos -= 1;
					} else if (__KengineInputUtils.keyboard_check(vk_right) & (__kbd_key_timer == 0 or __kbd_key_timer > __kbd_hold_timer*_game_speed)) {
						if (__KengineInputUtils.keyboard_check(vk_shift)) {
							if (__kbd_sel_start == -1) {
								__kbd_sel_start = cursor_pos;
							}
						} else {
							__kbd_sel_start = -1;
						}
						if (__KengineInputUtils.keyboard_check(vk_control)) {
							var cp = cursor_pos-1
							cursor_pos = __KengineStringUtils.PosDirection(value, " ", -1, cursor_pos+1);
							if (cursor_pos < cp) {cursor_pos = string_length(value);}
						}
						autoc = "";
						__cursor_talpha = 1;
						__cursor_ttimer = 0;
						if cursor_pos<string_length(value) cursor_pos += 1;
					
					}

					// History
					if history_enabled {
						if __KengineInputUtils.keyboard_check_pressed(vk_down) {
							if array_length(__KenginePanels.__input_histories) > 0 {
								autoc = "";
								__cursor_talpha = 1; __cursor_ttimer = 0;
								if history_pos > 0 {
									history_pos --;
								} else {
									history_pos = array_length(__KenginePanels.__input_histories) - 1;
								}
								value = __KenginePanels.__input_histories[history_pos];
								value_temp = value;
								cursor_pos = string_length(value);
								keyboard_string = value;
								__KengineInputUtils.keyboard_clear(vk_down);
							}
						} else if __KengineInputUtils.keyboard_check_pressed(vk_up) {
							if array_length(__KenginePanels.__input_histories) > 0 {
								autoc = "";
								__cursor_talpha = 1; __cursor_ttimer = 0;
								if history_pos < array_length(__KenginePanels.__input_histories) - 1 {
									history_pos ++;
								} else {
									history_pos = 0;
								}
								value = __KenginePanels.__input_histories[history_pos];
								value_temp = value;
								cursor_pos = string_length(value);
								keyboard_string = value;
								__KengineInputUtils.keyboard_clear(vk_up);
							}
						}
					}
					
					// Copy paste
					if __KengineInputUtils.keyboard_check(vk_control) and (__KengineInputUtils.keyboard_check_pressed(ord("X")) or __KengineInputUtils.keyboard_check_pressed(ord("C"))) {
						var copy;
						if __kbd_sel_start != -1 {
							copy = selection_get();
						} else {
							copy = text;
						}
						clipboard_set_text(copy);
						if __KengineInputUtils.keyboard_check_pressed(ord("X")) {
							_temp_pos = cursor_pos;
							var _temp_pos_ltr = false;
							if cursor_pos > __kbd_sel_start {
								_temp_pos_ltr = true;
							}
							selection_remove();
							if _temp_pos_ltr {
								cursor_pos = _temp_pos - string_length(copy);
							} else {
								cursor_pos = _temp_pos;
							}
						}
						__cursor_talpha = 1;
						__cursor_ttimer = 0;
						if __KengineInputUtils.keyboard_check_pressed(ord("X")) {
							__KengineInputUtils.keyboard_clear(ord("X"));
						} else {
							__KengineInputUtils.keyboard_clear(ord("C"));
						}
					} else if __KengineInputUtils.keyboard_check(vk_control) and __KengineInputUtils.keyboard_check_pressed(ord("V")) {
						_temp_pos = cursor_pos;
						if clipboard_has_text() {
							if __kbd_sel_start != -1 {
								selection_remove();
							}
							var copied = clipboard_get_text();
							__cursor_talpha = 1;
							__cursor_ttimer = 0;
							value = string_insert(copied, value, cursor_pos+1);
							value_temp = value;
							keyboard_string = value;
							cursor_pos = _temp_pos + string_length(copied);
						}
						__KengineInputUtils.keyboard_clear(ord("V"));
					}

					// Autocomplete
					if __KengineInputUtils.keyboard_check_pressed(vk_tab) and autoc_enabled {
						if value != "" {
							__cursor_talpha = 1;
							__cursor_ttimer = 0;
							value = autoc_find_next(value, __KengineInputUtils.keyboard_check(vk_shift));
							// cursor_pos = string_length(value);
							value_temp = value;
							keyboard_string = value;
						}
						__KengineInputUtils.keyboard_clear(vk_tab);
					}

					// Cursor
					if __cursor_ttimer < __cursor_tspeed * _game_speed { __cursor_ttimer ++;} else {__cursor_ttimer = 0; __cursor_talpha = !__cursor_talpha;}

					// Keyboard selection
					if __kbd_sel_start == cursor_pos {__kbd_sel_start = -1;}
					
					draw_set_font(font);

					// Spacing, typing and backspace.
					value = keyboard_string;
					if value != value_temp { // New character
						autoc = "";
						__cursor_talpha = 1;
						__cursor_ttimer = 0;
						if keyboard_key == vk_backspace {
							if string_length(value) > 0 and cursor_pos >= 0 {
								// Remove char at cursor especially \#
								var _a = string_copy(value_temp, 0, cursor_pos - 1);
								var _b = string_copy(value_temp, cursor_pos + 1, string_length(value_temp) - cursor_pos + 1);
								if cursor_pos > 0 cursor_pos--;
								value = _a + _b;
							} else {
								cursor_pos = 0;
							}
							value_temp = value;
							keyboard_lastchar = "";
							keyboard_string = value;
							__KengineInputUtils.keyboard_clear(keyboard_key);
							keyboard_key = vk_nokey;

						} else if keyboard_key != vk_enter {
							if __kbd_sel_start != -1 {
								_temp_pos = cursor_pos;
								selection_remove();
								value = string_delete(value, string_length(value), 1);
								value_temp = value;
								cursor_pos = _temp_pos;
							}
							// Put char at cursor
							var _a = string_copy(value_temp, 0, cursor_pos);
							var _b = string_copy(value_temp, cursor_pos + 1, string_length(value_temp) - cursor_pos + 2);
							cursor_pos++;

							// If backspace or delete char, use empty.
							if keyboard_lastchar == ansi_char(127) or keyboard_lastchar == ansi_char(8) {
								keyboard_lastchar = "";
								cursor_pos --;
							}

							value = _a + keyboard_lastchar + _b;
							value_temp = value;
							keyboard_lastchar = "";
							keyboard_string = value;
							__KengineInputUtils.keyboard_clear(keyboard_key);
							keyboard_key = vk_nokey;
							__kbd_key_timer = 0;
						}
					}
					value_temp = value;
					keyboard_string = value;

					// (cleanup)
					if(keyboard_lastkey != vk_lshift and
						keyboard_lastkey != vk_rshift and
						keyboard_lastkey != vk_lcontrol and 
						keyboard_lastkey != vk_rcontrol) {__kbd_last_key = keyboard_lastkey;}

					if (__KengineInputUtils.keyboard_check_released(vk_left)
					or __KengineInputUtils.keyboard_check_released(vk_right)) {
						__kbd_last_key= vk_nokey;
						__kbd_key_timer= 0;
						keyboard_lastkey = vk_nokey;
						keyboard_key = vk_nokey;
						keyboard_lastchar = "";
					}
				}
			}
		}
	}

	self.Draw = function() {

		var _val = value;
		if cursor_pos*__str_width > width {
			__xoffset = max(__xoffset, round(cursor_pos - width/__str_width));
		} else if cursor_pos < __xoffset {
			__xoffset = cursor_pos;
		}
		_val = string_copy(_val, 1+__xoffset, string_length(_val)-__xoffset);

		/// feather ignore GM1044
		draw_set_font(font);
		draw_set_valign(valign);
		draw_set_halign(halign);
		draw_set_alpha(alpha);

		if box_enabled {
			if background {
				draw_set_color(background);
				draw_rectangle(parent.x+x,parent.y+y,parent.x+x+width,parent.y+y+height, false);
			}
			if !active {
				draw_set_color(c_dkgray);
			} else {
				draw_set_color(c_gray);
			}
			draw_rectangle(parent.x+x,parent.y+y,parent.x+x+width,parent.y+y+height, true);
		}

		// Draw keyboard selection start, if found, to the cursor position.
		if __kbd_sel_start != -1 {
			var x1, x2, y1, y2, st;
			if __kbd_sel_start < cursor_pos {
				x1 = parent.x + x + 3 + __kbd_sel_start * __str_width;
				x2 = x1 + (cursor_pos - __kbd_sel_start) * __str_width;
				st = string_copy(value, __kbd_sel_start + 1, cursor_pos - __kbd_sel_start);
			} else {
				x1 = parent.x + x + 3 + cursor_pos * __str_width;
				x2 = x1 + (__kbd_sel_start - cursor_pos) * __str_width;
				st = string_copy(value, cursor_pos + 1, __kbd_sel_start - cursor_pos);
			}
			y1 = parent.y + y + 1 + 5;
			y2 = y1 + __str_height;
			x1 -= __xoffset * __str_width;
			x2 -= __xoffset * __str_width;
			draw_set_color(box_colors[1]);
			draw_rectangle(x1,y1,x2,y2, false);
			draw_set_color(color);
		}

		draw_set_color(color);
		draw_text(parent.x+x+3, parent.y+y+1 + 5, _val);

		// Draw cursor
		if __cursor_talpha {
			var cursor_offset = string_width(string_copy(value, 0, cursor_pos - __xoffset));

			draw_set_color(cursor_color);
			draw_set_alpha(1);
			draw_line(
				parent.x + x + 5 + cursor_offset,
				parent.y + y + 1 + 4,
				parent.x + x + 5 + cursor_offset,
				parent.y + y + 1 + __str_height + 4
			);
			draw_set_color(color);
		}
	}
	
	/**
	 * @function selection_get
	 * @memberof Kengine.panel.PanelItemInputBox
	 * @description Gets the selected part from the text value.
	 * @return {String} The selected string of the text value.
	 */
	selection_get = function() {
		var _cpos = cursor_pos;
		var _sel = __kbd_sel_start;
		var _t = value;
		if (_cpos < _sel) {
			return string_copy(_t, _cpos+1, _sel - _cpos);
		} else {
			return string_copy(_t, _sel+1, _cpos - _sel);
		}
	}
	selection_remove = function() {
		if (__kbd_sel_start > cursor_pos) {
			value = string_delete(value, cursor_pos + 1, __kbd_sel_start - cursor_pos);
		} else {
			value = string_delete(value, __kbd_sel_start + 1, cursor_pos - __kbd_sel_start);
		}
		value_temp = value;
		keyboard_string = value;
		cursor_pos = min(__kbd_sel_start-1, string_length(value));
		__kbd_sel_start = -1;
		}
	selection_set = function(start_pos, cursorpos) {
		self.__kbd_sel_start = start_pos;
		if cursorpos != undefined {
			self.cursor_pos = cursorpos;
		}
	}

	autoc_add_ind = function(reversed) {
		__autoc_pos += reversed ? -1 : 1;
		if __autoc_pos >= array_length(__KenginePanels._autocs) {
			__autoc_pos = 0;
		}
		if __autoc_pos < 0 {
			__autoc_pos = array_length(__KenginePanels._autocs) - 1;
		}
		return __autoc_pos;
	}

	autoc_find_next = function(str, reversed=false) {
		var _i, _indexing;
		_indexing = false;
		var __bb = "";
		if string_char_at(str, 1) == "/" {
			__bb = "/";
		}

		if autoc == "" or autoc == str {
			__autoc_pos = 0;
			autoc = string_copy(str, 1+string_length(__bb), string_length(str));
			__KenginePanels._autocs = [];
			_indexing = true;
		}

		// pop last word
		var _x = string_split(autoc, " ");
		autoc = _x[array_length(_x)-1];
		_x[array_length(_x)-1] = "";
		
		var _a1, _b1;
		if string_pos("global.", autoc) == 1 {
			// pre dot
			_a1 = "global";
			// post dot
			_b1 = string_copy(autoc, string_pos(_a1, autoc)+1, string_length(_a1) - string_pos(_a1, autoc)+1);
		}
		var _autoc_no_dot = autoc;
		if string_char_at(autoc, string_length(autoc)) == "." {
			_autoc_no_dot = string_delete(autoc, string_length(autoc), 1);
		}
		if string_count(".", _autoc_no_dot) > 0 {
			_a1 = string_copy(_autoc_no_dot, 0, string_last_pos(".", _autoc_no_dot)-1);
			_b1 = string_copy(_autoc_no_dot, string_last_pos(".", _autoc_no_dot)+1, string_length(_autoc_no_dot) - string_last_pos(".", _autoc_no_dot)+1);
		} else {
			_a1 = _autoc_no_dot;
			_b1 = "";
		}
		
		if _indexing {
			var _n;
			var _do_autoc = false;
			if _a1 != undefined {
				var _inter = __KengineStructUtils.SetDefault(parent, "interpreter", __KenginePanelsConsole.__default_interpreter);
				var _a = _inter(_a1, 2);
				if is_array(_a) {
					if array_length(_a) > 0 {
						_a = _a[0];
					}
				}
				if typeof(_a) == "ref" {
					if instance_exists(_a) {
						var _variables = variable_instance_get_names(_a);
						for (var _j=0; _j<array_length(_variables); _j++) {
							_do_autoc = true;
							if __KengineStructUtils.IsPrivate(_a, _variables[_j]) == true {
								_do_autoc = false;
							}
							if __KengineStructUtils.IsPublic(_a, _variables[_j]) {	
								_do_autoc = true;
							}
							if _do_autoc {
								if string_pos(_b1, _variables[_j]) == 1 or _b1 == "" {
									__KenginePanels._autocs[array_length(__KenginePanels._autocs)] = _variables[_j];
								}
							}
						}
						var _v = variable_instance_get_names(_a);
						for (var _j=0; _j<array_length(_v); _j++) {							
							_do_autoc = true;
							if __KengineStructUtils.IsPrivate(_a, _v[_j]) == true {
								_do_autoc = false;
							}
							if __KengineStructUtils.IsPublic(_a, _v[_j]) {	
								_do_autoc = true;
							}
							if _do_autoc {
								if string_pos(_b1, _v[_j]) == 1 or _b1 == "" {
									__KenginePanels._autocs[array_length(__KenginePanels._autocs)] = _v[_j];
								}
							}
						}
					}
				} else if is_struct(_a) {
					if __KengineStructUtils.IsPrivate(_a) != true {
						var _d = struct_get_names(_a);
						for (var _j=0; _j<array_length(_d);_j+=1) {
							_do_autoc = true;
							if __KengineStructUtils.IsPrivate(_a, _d[_j]) == true {
								_do_autoc = false;
							}
							if __KengineStructUtils.IsPublic(_a, _d[_j]) {	
								_do_autoc = true;
							}
							if _do_autoc {
								// if string_char_at(_d[j], 0) == "_" continue;
								if string_pos(_b1, _d[_j]) == 1 or _b1 == "" {
									__KenginePanels._autocs[array_length(__KenginePanels._autocs)] = _d[_j];
								}
							}
						}
					}
				} else {
					// Scripts and methods.
					var scrs = Kengine.asset_types.script.assets.Filter(function(val) {
						return not __KengineStructUtils.IsPrivate(val);
					});
					for (var _j=0; _j<array_length(scrs); _j++) {
						_n = scrs[_j].name;
						_do_autoc = true;
						if __KengineStructUtils.IsPrivate(scrs[_j]) == true {
							_do_autoc = false;
						}
						if __KengineStructUtils.IsPublic(scrs[_j]) == true {
							_do_autoc = true;
						}
						if _do_autoc {
							// if string_char_at(_n, 0) == "_" continue;
							if string_pos(_b1, _n) == 1 or _b1 == "" {
								if string_pos(_a1, _n) == 1 {
									__KenginePanels._autocs[array_length(__KenginePanels._autocs)] = _n;
								}
							}
						}
					}
				}
			}

			// TXR map
			var txr_a = ds_map_keys_to_array(__KengineParserUtils.interpreter.System._function_map);
			for (_i=0; _i<array_length(txr_a);_i++) {
				_n = txr_a[_i];
				if string_pos(autoc, _n) == 1 {
					__KenginePanels._autocs[array_length(__KenginePanels._autocs)] = _n;
				}
			}

			// Instances
			with all {
				_n = string(object_get_name(object_index));
				if string_pos(other.autoc, _n) == 1 {
					__KenginePanels._autocs[array_length(__KenginePanels._autocs)] = _n;
				}
				_n = string(real(id));
				if string_pos(other.autoc, _n) == 1 {
					__KenginePanels._autocs[array_length(__KenginePanels._autocs)] = _n;
				}
			}

			// Constants ...etc.
			if struct_exists(__KenginePanels, "default_autocs") {
				for (_i=0; _i<array_length(__KenginePanels.default_autocs); _i++) {
					__KenginePanels._autocs[array_length(__KenginePanels._autocs)] = __KenginePanels.default_autocs[_i];
				}
			}
			if struct_exists(parent, "default_autocs") {
				if parent.default_autocs != undefined {
					var _dautocs;
					if is_array(parent.default_autocs) {
						_dautocs = parent.default_autocs;
					} else if is_method(parent.default_autocs) {
						_dautocs = parent.default_autocs(self);
					}
					for (_i=0; _i<array_length(_dautocs); _i++) {
						__KenginePanels._autocs[array_length(__KenginePanels._autocs)] = _dautocs[_i];
					}
				}
			}
		}
		var _autoc = string_split(autoc, ".");
		_autoc = _autoc[array_length(_autoc)-1];

		for (_i=0; _i<array_length(__KenginePanels._autocs); _i++) {
			if string_pos(_autoc, __KenginePanels._autocs[_i]) == 1 {
				if __autoc_pos == _i {
					__bb = string_copy(autoc, 1, string_length(autoc) - string_length(_autoc));
					autoc_add_ind(reversed);
					var ret = __bb + __KenginePanels._autocs[_i];
					cursor_pos = string_length(ret);
					return ret;
				}
			}
			if string_pos(autoc, __KenginePanels._autocs[_i]) == 1 {
				if __autoc_pos == _i {
					autoc_add_ind(reversed);
					var ret = __bb + __KenginePanels._autocs[_i];
					cursor_pos = string_length(ret);
					return ret;
				}
			}
		}
		cursor_pos = string_length(str);
		return str;
	}
}
