/**
 * @typedef {Struct} PanelOptions
 * @memberof Kengine.Extensions.Panels
 * @description Panel options struct.
 * 
 */
function __KenginePanelsPanelOptions(options) : __KengineOptions() constructor {
	__start(options)
    __add("x", 0)
    __add("y", 0)
    __add("width", 200)
    __add("height", 50)
    __add("title", "Untitled Panel")
    __add("children", [])
    __add("collapse_enabled", true)
    __add("collapse_height", 30)
    __add("collapsed", false)
    __add("drag_enabled", true)
    __add("focus_enabled", true)
    __add("inner_box_enabled", true)
    __add("draw_collapsed", false)
    __add("visible", true)
    __add("alpha", 1)
    __add("box_colors", [
		$883300, $883300, $883300, $883300,
    ])
    __add("inner_box_colors", [
		c_black, c_black, c_black, c_black,
    ])
    __done()
}

/**
 * @function Panel
 * @memberof Kengine.Extensions.Panels
 * @description A base panel that represents a window.
 * @param {Kengine.Extensions.Panels.PanelOptions} options an initial `Kengine.Extensions.Panels.PanelOptions` for setting options of this panel.
 * 
 */
function __KenginePanelsPanel(options=undefined) constructor {
	// TODO: Add events.

	if not is_instanceof(options, __KenginePanelsPanelOptions) {
		options = new __KenginePanelsPanelOptions(options);
	}
	x = undefined
    y = undefined
    width = undefined
    height = undefined
    title = undefined
    children = undefined
    collapse_enabled = undefined
    collapse_height = undefined
    collapsed = undefined
    drag_enabled = undefined
    focus_enabled = undefined
    inner_box_enabled = undefined
    draw_collapsed = undefined
    visible = undefined
    alpha = undefined
    box_colors = undefined
    inner_box_colors = undefined
    __KengineOptions.__Apply(options, self);

	__is_focused = false;

	__drag_anchor = false;
	__mb_drag = false;
	__mb_press_count = 0;
	__mb_press_timer = 0;
	__drag_anchor_x = 0;
	__drag_anchor_y = 0;
	__mouse_x = 0;
	__mouse_y = 0;

	self.__Step = function() {
		var _mouse_click_interval = 15; // fps
		var _mouse_x = device_mouse_x_to_gui(0);
		var _mouse_y = device_mouse_y_to_gui(0);
		x = clamp(x, 0, window_get_width()-width);
		y = clamp(y, 0, window_get_height()-self.collapse_height-16);

		var _hh = self.collapse_height;
		if not self.collapsed {
			_hh = self.height;
		} else {
			if _hh == 0 _hh = 16;
		}

		if visible {
			var _mouse_inside = false;
			if _mouse_x >= x and _mouse_y >= y and _mouse_x < x + width and _mouse_y < y + _hh {
				_mouse_inside = true;
			}

			var _mb_pressed, _mb_held, _mb_released, _mb_pressed_twice = false, _mb_pressed_thrice = false;
			if mouse_check_button_pressed(mb_left) {_mb_pressed = true;} else {_mb_pressed = false;}
			if mouse_check_button(mb_left) {_mb_held = true;} else {_mb_held = false;}
			if mouse_check_button_released(mb_left) {_mb_released = true;} else {_mb_released = false;}

			if _mb_pressed {
				if focus_enabled {
					if not _mouse_inside {__is_focused = false;} else {__is_focused = true;}
				}
				if (__mb_press_timer > 0) {
					__mb_press_count += 1;
					
					if __mb_press_count == 2 {
						_mb_pressed_twice = true;
					} else if __mb_press_count == 3 {
						_mb_pressed_thrice = true;
					}
					
				} else {
					__mb_press_count = 1;
				}
				__mb_press_timer = _mouse_click_interval;
				__mouse_x = _mouse_x;
				__mouse_y = _mouse_y;

			} else if _mb_held and not __mb_drag and _mouse_inside {
				if (_mouse_x != __mouse_x or _mouse_y != __mouse_y) and !__mb_drag and __mb_press_count == 1 and drag_enabled and __is_focused {
					if (_mouse_y < y + collapse_height)
						{
						__mb_drag = true;
						__drag_anchor = false;
						}
				}
				if not __mb_drag and (_mouse_x == __mouse_x and _mouse_y == __mouse_y) {
					__mb_drag = false;
				}

			} else if _mb_held and __mb_drag and _mouse_inside {
				if not __drag_anchor {
					//mouse_clear(mb_left); _mb_pressed = false; _mb_held = false; _mb_released = false;
					__drag_anchor = true;
					__drag_anchor_x = x - __mouse_x;
					__drag_anchor_y = y - __mouse_y;
				}
			}
			
			if _mb_held and __drag_anchor and __mb_drag and __is_focused {
				x = clamp(_mouse_x + __drag_anchor_x, 0, window_get_width()-width);
				y = clamp(_mouse_y + __drag_anchor_y, 0, window_get_height()-collapse_height-16);
			}

			if __mb_press_timer > 0 {
				__mb_press_timer --;
				if __mb_press_timer < 0 {
					__mb_press_timer = 0;
					__mb_press_count = 0;
				}
			}
			
			if _mb_released and __mb_drag {
				__mb_drag = false;
				__drag_anchor = false;
			}
			
			if _mb_pressed_twice and _mouse_inside and collapse_enabled {
				if (_mouse_y < y + collapse_height)
					{
					collapsed = not collapsed;
					}
			}
		}

		for (var _i=0; _i<array_length(children); _i++) {
			if children[_i].Step != undefined children[_i].Step();
		}
	}

	self.__Draw = function() {
		
		draw_set_alpha(alpha);

		var _hh = collapse_height;

		if draw_collapsed {
			_hh = height;
		} else {
			if not visible return;
			if not collapsed {
				_hh = height;
			} else {
				if _hh == 0 _hh = 16;
			}
		}

		if __is_focused { draw_set_alpha(alpha) } else { draw_set_alpha(0.9*alpha); }
		draw_rectangle_color(x,y,x+width,y+_hh,box_colors[0],box_colors[1],box_colors[2],box_colors[3],false);

		if inner_box_enabled {
			if not self.collapsed {
				draw_set_alpha(0.75);
				draw_rectangle_color(x+5,y+5+collapse_height,x+width-5,y+_hh-5,inner_box_colors[0],inner_box_colors[1],inner_box_colors[2],inner_box_colors[3],false);
			}
		}

		if __is_focused { draw_set_alpha(1*alpha); } else { draw_set_alpha(0.80*alpha); }
		draw_rectangle(x,y,x+width,y+_hh, true);

		draw_set_font(font_ken_panels);
		draw_set_valign(fa_middle);
		draw_set_halign(fa_center);
		if __is_focused { draw_set_alpha(1*alpha); } else { draw_set_alpha(0.75*alpha); }
		draw_text(x+round(width/2), y+round(collapse_height/2), title);

		draw_set_alpha(1*alpha);
		draw_set_valign(fa_top);
		draw_set_halign(fa_left);

		if not self.collapsed {
			self.__DrawContents();
		}
	}

	self.Step = function() {
		self.__Step();
	}

	self.Draw = function() {
		self.__Draw();
	}

	self.Add = function(item) {
		var _a = array_length(self.children);
		item.parent = self;
		self.children[_a] = item;
		return _a - 1;
	}

	self.__DrawContents = function() {
		for (var _i=0; _i<array_length(children); _i++) {
			if children[_i].Draw != undefined children[_i].Draw();
		}
	}

	self.id = __KenginePanels.panels.Add(self)
}
