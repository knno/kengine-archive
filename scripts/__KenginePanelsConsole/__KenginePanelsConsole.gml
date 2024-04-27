/**
 * @typedef {Struct} ConsoleOptions
 * @memberof Kengine.Extensions.Panels
 * @description Console options struct.
 * 
 */
function __KenginePanelsConsoleOptions(options) : __KenginePanelsPanelOptions(options) constructor {
	__start(options)
    __add("color_echo")
    __add("color_error")
    __add("color_debug")
    __add("notify_enabled", true)
    __add("notify_show_time", 5)
    __add("enabled", true)
    __add("verbosity")
    __add("interpreter")
    __add("toggle_key", 192) // `
    __add("log_file")
    __add("log_enabled")
    __add("font", font_ken_panels)
    __add("lines_max", 250)
    __add("lines_count", 30)
    __add("lines_notify", 10)
    __done()
}

/**
 * @function Console
 * @memberof Kengine.Extensions.Panels
 * @description A console is an extended {@link Kengine.Extensions.Panels.Panel} with many features for debugging.
 * @param {Kengine.Extensions.Panels.ConsoleOptions} options an initial struct for setting options.
 */
function __KenginePanelsConsole(options=undefined) : __KenginePanelsPanel(options) constructor {
	var c_echo = $DD9900, c_error = $2000ff, c_debug = $008800;
    
	if not is_instanceof(options, __KenginePanelsConsoleOptions) {
		options = new __KenginePanelsConsoleOptions(options);
	}
	if false { // feather ignore GM2047
		color_echo = undefined
		color_error = undefined
		color_debug = undefined
		notify_enabled = undefined
		notify_show_time = undefined
		enabled = undefined
		verbosity = undefined
		toggle_key = undefined
		log_file = undefined
		lines_max = undefined
		lines_count = undefined
		lines_notify = undefined
		inputbox = undefined
		log_enabled = undefined
	}
	__KengineOptions.__Apply(options, self);

	notify_timer = 0;
	notify_state = 0; // 0 = idle, 1 = notify mode

	// 0 = disable, 1 = only error, 2 = error + info, 3 = error + warnings + info, 4 = error + warnings + info + debug
	verbosity = verbosity ?? ((KENGINE_DEBUG) ? 4 : 3)
	color_echo = color_echo ?? c_echo
	color_error = color_error ?? c_error
	color_debug = color_debug ?? c_debug

	draw_set_font(font)
	str_height = string_height("|")
	str_width = string_width("_")
	texts = []
	texts_color = []

	x = 0; y = 0;
	width = window_get_width(); // height is dynamic.
	collapse_height = 0;
	collapse_enabled = false; 
	focus_enabled = false;
	__is_focused = true;
	collapsed = true;
	visible = false;
	title = "";
	default_autocs = [];
	drag_enabled = false;
	box_colors = [
		$300500, $300500, $300500, $300500,
	];

	scroll_pos = 0;
	scroll_hpos = 0;
	static __default_interpreter = function(value) {
		if string_count(";", value) > 0 and string_pos(";", value) != string_length(string_trim(value)) {
			return __KengineParserUtils.__Interpret(value, {__allow_private: KENGINE_CONSOLE_ALLOW_PRIVATE, script_object: "console", event: "input"});
		} else {
			return __KengineParserUtils.__InterpretValue(value, {__allow_private: KENGINE_CONSOLE_ALLOW_PRIVATE, script_object: "console", event: "input"});
		}
	};
	interpreter = interpreter ?? __default_interpreter
	font = __KengineStructUtils.SetDefault(options, "font", font_ken_panels);

	lines_notify_current = 0;

	scroll_inc = 3;
	log_write_timer = -1;
	log_write_queue = ds_queue_create();

	Clear = function() {
		for (var _i=0; _i<lines_max; _i++) {
			texts[_i] = "";
			texts_color[_i] = color_echo;
		}
	}
	clear = Clear;

	// Initial
	Clear();
	height = str_height * lines_count + 4;
	length = floor(width/str_width)-1;

	__LogWriteDequeue = function() {
		var _q = [];
		while ds_queue_size(log_write_queue) > 0 {
			_q[array_length(_q)] = ds_queue_dequeue(log_write_queue);
		}
		var _i=0;
		var _f = file_text_open_append(log_file);
		for (_i=0; _i<array_length(_q); _i++) {
			file_text_write_string(_f, _q[_i]);
			file_text_writeln(_f);
		}
		file_text_close(_f);
		return true;
	}

	self.Draw = function() {
		var _i;
		self.content_width = self.width
		self.content_height = self.height

		if notify_state == 1 {
			self.draw_collapsed = true;
			height = str_height*(lines_notify_current);
		} else {
			self.draw_collapsed = false;
		}
		self.__Draw();
		draw_set_font(font);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_set_alpha(1);
		if visible and not self.collapsed {
			// Draw console lines.
			var _texty;
			var offset;
			for (_i=lines_count + scroll_pos + 1; _i > scroll_pos - 1; _i--) {
				if _i>= array_length(texts_color)
				or _i>= array_length(texts) {
					continue;
				}
				_texty = texts[_i];
				if scroll_hpos > 0 {
					offset = floor(scroll_hpos/str_width);
					_texty = string_copy(_texty, offset, string_length(_texty)-offset);
				}
				draw_set_color(texts_color[_i]);
				draw_set_alpha(alpha * (1 * (1-.5 * not __is_focused)));
				draw_text(x+4-scroll_hpos, y+1+((lines_count-1)-(_i-scroll_pos))*str_height, _texty);
			}
			if scroll_pos > 0 or scroll_hpos > 0 {
				// feather ignore GM1044
				draw_set_color(color_echo);
				draw_triangle(
					width -25-12, height-25-15,
					width -25+12, height-25-15,
					width-25, height-25+5,
					false
				);
			}
			draw_set_color(c_white);
			draw_set_alpha(1);
		} else {

			if notify_state == 1 {
				// If timer ends, show info: off
				if notify_timer == 0 { lines_notify_current=0; notify_state=0; exit;}

				// height = str_height * lines_notify_current + 4;

				var _j = 0;
				for (_i=0; _i<lines_count; _i++) {
					if _j < lines_notify_current and y+1+str_height*(lines_notify_current-1-_j) > 0 {
						if _i>= array_length(texts_color)
						or _i>= array_length(texts) {
							continue;
						}
						draw_set_color(texts_color[_i]);
						draw_set_alpha(alpha);
						draw_text(x+4, y+1+str_height*(lines_notify_current-1-_j), texts[_i]);
						_j++;
					}
				}
				notify_timer--;
				draw_set_color(c_white);
				draw_set_alpha(1);
			}
		}
	}

	echo_ext = function(msg, color, notify=false, write=false) {
		var _arg0, _m, _col, _r;
		_col = color ?? color_echo;
		// Prepare text
		_arg0 = string(msg) ?? "<undefined>";
		if string_char_at(_arg0, 1) == "\"" and string_char_at(_arg0,string_length(_arg0)) == "\"" {
			_arg0 = string_trim(_arg0, ["\""]);
		}
		_r = 1; // Repetition
		if string_length(_arg0) > length {
			// Multiline.
			_r = ceil(string_length(_arg0)/length);
			for (var _i=1; _i<_r; _i++) {
				_arg0 = string_insert(chr(13), _arg0, length*_i+_i+1);
			}
		}

		// Parse multiline to multi echo.
		if string_count(chr(13),_arg0) > 0 or string_count("\n", _arg0) > 0 {
			var new_str = string_replace_all(_arg0, "\\n", "%EscapedNewLine%");
			new_str = string_replace_all(new_str, "\n", chr(13));
			new_str = string_replace_all(new_str, "%EscapedNewLine%", "\\n");
			var _a = string_split(new_str, chr(13));
			for (var _i=0; _i<array_length(_a); _i++) {
				for (_m=lines_max-1; _m>0; _m--) {
					texts[_m] = texts[_m-1];
					texts_color[_m] = texts_color[_m-1];
				}
				texts[0] = _a[_i];
				texts_color[0] = _col;
				if scroll_pos > 0 and scroll_pos < lines_count {
				}
			}
		} else {
			for (_m=lines_max-1; _m>0; _m--) {
				texts[_m] = texts[_m-1];
				texts_color[_m] = texts_color[_m-1];
			}
			texts[0] = _arg0;
			texts_color[0] = _col;
			if scroll_pos > 0 and scroll_pos < lines_count {
				scroll_pos ++;
			}
		}
		
		if notify == true and notify_enabled {
			if lines_notify_current < lines_notify lines_notify_current ++;
			notify_timer = notify_show_time * game_get_speed(gamespeed_fps);
			if not visible or self.collapsed notify_state = 1;
		}

		if write {
			log_write(msg, "INFO");
		}

		return _arg0;
	}
	echo = function(msg) {
		if enabled {
			self.echo_ext(msg, color_echo, true);
			log_write(msg, "INFO");
		}
	}
	echo_error = function(msg) {
		if enabled {
			self.echo_ext(msg, color_error, true);
			log_write(msg, "ERROR");
		}
		__kengine_log(msg);
	}
	debug = function(msg, notify=KENGINE_DEBUG) {
		if enabled {
			self.echo_ext(msg, color_debug, notify);
			log_write(msg, "DEBUG");
		}
	}
	verbose = function(msg, verbosity, notify=KENGINE_DEBUG) {
		if enabled {
			if KENGINE_VERBOSITY > verbosity {
				self.debug(msg, notify);
			}
		}
	}

	Echo = echo
	EchoError = echo_error
	Debug = debug
	Verbose = verbose

	Step = function() {
		var _mouse_x = device_mouse_x_to_gui(0);
		var _mouse_y = device_mouse_y_to_gui(0);
		width = window_get_width();
		inputbox.width = width;

		draw_set_font(font);
		str_height = string_height("|");
		str_width = string_width("_");
		height = str_height * lines_count + 4;
		length = floor(width/str_width)-1;
		inputbox.y = y + height;
		
		log_write_timer --;
		if log_write_timer == 0 {
			__LogWriteDequeue();
			log_write_timer --;
		}

		self.__Step(); // ?

		if __KengineInputUtils.keyboard_check_pressed(vk_enter) {
			if inputbox.value != ""  and  visible  and (not collapsed) {
				__KengineInputUtils.keyboard_clear(vk_enter);
				if inputbox.history_enabled __KenginePanels.__input_histories[array_length(__KenginePanels.__input_histories)] = inputbox.value;
				inputbox.value = string_replace_all(inputbox.value, "\\n", chr(13));
				echo(">"+inputbox.value);
				try {
					self.__InputCheck(inputbox.value);
				} catch (e) {
					self.echo_error(e.message);
					self.debug(e);
					__kengine_log(e);
				}
				keyboard_string = "";
				inputbox.value_last = inputbox.value;
				inputbox.value = "";
				inputbox.cursor_pos = 0;
				inputbox.value_temp = "";
				inputbox.kbd_sel_start = -1;
			}
		}
		
		if toggle_key != undefined {
			if __KengineInputUtils.keyboard_check_pressed(toggle_key) and enabled {
				visible = not visible;
				collapsed = not collapsed;
				lines_notify_current=0; notify_state=0;
				__KengineInputUtils.keyboard_clear(toggle_key);
				keyboard_lastkey = vk_nokey;
				keyboard_lastchar = "";
				if (not collapsed) and (visible) {
					__is_focused = true;
					inputbox.active = true;
				}
			}
		}
		
		if visible and not self.collapsed {
			// Activate input on click inside
			var _m_inside = false;
			if _mouse_x >= x and _mouse_y >= y and _mouse_x < x + width and _mouse_y < y + height {
				_m_inside = true;
			}
			var _mb_pressed, _mb_held, _mb_released, _mb_pressed_twice = false, _mb_pressed_thrice = false;
			if mouse_check_button_pressed(mb_left) {_mb_pressed = true;} else {_mb_pressed = false;}
			if mouse_check_button(mb_left) {_mb_held = true;} else {_mb_held = false;}
			if mouse_check_button_released(mb_left) {_mb_released = true;} else {_mb_released = false;}

			if _m_inside and _mb_pressed {
				if not inputbox.active {
					if __KenginePanels.focused_panel == undefined {
						__KenginePanels.focused_panel = self;
						inputbox.active = true;
						mouse_clear(mb_left);
						keyboard_lastkey = vk_nokey;
						keyboard_lastchar = "";
					}
				}
			}

			// Scrolling
			if __KengineInputUtils.keyboard_check_pressed(vk_pagedown) or mouse_wheel_down() {
				if keyboard_check_direct(vk_shift) {
					scroll_hpos += scroll_inc*3;
				} else {
					if scroll_pos > 0 scroll_pos -= min(scroll_pos, scroll_inc);
				}
				__KengineInputUtils.keyboard_clear(vk_pagedown);
			} else if __KengineInputUtils.keyboard_check_pressed(vk_pageup) or mouse_wheel_up() {
				if keyboard_check_direct(vk_shift) {
					if scroll_hpos > 0 scroll_hpos -= scroll_inc*3;
				} else {
					if scroll_pos < lines_max - lines_count {
						scroll_pos += min(lines_max - lines_count, scroll_inc);
					}
				}
				__KengineInputUtils.keyboard_clear(vk_pageup);
			}
			
			// Clicking triangle
			if _mb_pressed {
				if point_in_triangle(_mouse_x, _mouse_y, width-25-12, height-25-15, width-25+12, height-25-15, width-25, height-25+5) {
					scroll_pos = 0;
					scroll_hpos = 0;
					mouse_clear(mb_left);
				}
			}
		}
	}

	__InputCheck = function(value) {
		try {
			var _result = interpreter(value);
			if not is_undefined(_result) echo(_result);
		} catch (e) {
			self.echo_error(e.message);
			self.debug(e);
			__kengine_log(e);
		}
	}

	log_write = function(msg, kind="INFO") {
		if enabled {
			if log_enabled == true {

				if not ds_exists(log_write_queue, ds_type_queue) {
					log_write_queue = ds_queue_create();
				}

				if kind == "ERROR" and verbosity <= 0 return;
				if kind == "INFO" and verbosity <= 1 return;
				if kind == "WARNING" and verbosity <= 2 return;
				if kind == "DEBUG" and verbosity <= 3 return;

				var date, day, month, year, hour, minute, second;
				date = date_current_datetime();
				day = string(date_get_day(date));
				month = string(date_get_month(date));
				year = string(date_get_year(date));
				hour = string(date_get_hour(date));
				minute = string(date_get_minute(date));
				second = string(date_get_second(date));

				if string_length(day) == 1 {
					day = "0" + day;
				}
				if string_length(month) == 1 {
					month = "0" + month;
				}
				if string_length(year) == 1 {
					year = "0" + year;
				}
				if string_length(hour) == 1 {
					hour = "0" + hour;
				}
				if string_length(minute) == 1 {
					minute = "0" + minute;
				}
				if string_length(second) == 1 {
					second = "0" + second;
				}
				
				if ds_queue_size(log_write_queue) > 10 {
					return __LogWriteDequeue();
				}

				var _q = day+"/"+month+"/"+year+" "+hour+":"+minute+":"+second + " - " + kind + " - "+ string(msg);
				ds_queue_enqueue(log_write_queue, _q);
				log_write_timer = 15;
				return true;
			}
		}
	}

	if enabled {
		log_write("Kengine started - " + string(game_project_name), "INFO");
	}
}
