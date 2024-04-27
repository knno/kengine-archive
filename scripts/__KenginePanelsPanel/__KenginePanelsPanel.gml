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
	__add("content_x", 0)
	__add("content_y", 0)
	__add("content_width", -1)
	__add("content_height", -1)
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
	if options == undefined return;

	if not is_instanceof(options, __KenginePanelsPanelOptions) {
		options = new __KenginePanelsPanelOptions(options);
	}
	x = undefined
    y = undefined
    width = undefined
    height = undefined
	content_x = undefined
	content_y = undefined
    content_width = undefined
    content_height = undefined
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
	__auto_content_wh = false;
	if content_width == -1 and content_height == -1 {
		__auto_content_wh = true;
	}
	if content_width <= width content_width = width
	if content_height <= height content_height = height
	__overflow_x = width < content_width
	__overflow_y = height < content_height
	__scrollbar_x = undefined
	__scrollbar_y = undefined

	for (var _i=0; _i<array_length(self.children); _i++) {
		self.children[_i].parent = self;
	}

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

			var _mb_pressed, _mb_held, _mb_released, _mb_pressed_twice = false, _mb_pressed_thrice = false, _mw_down = false, _mw_up = false;
			if mouse_check_button_pressed(mb_left) {_mb_pressed = true;} else {_mb_pressed = false;}
			if mouse_check_button(mb_left) {_mb_held = true;} else {_mb_held = false;}
			if mouse_check_button_released(mb_left) {_mb_released = true;} else {_mb_released = false;}
			if _mouse_inside {if mouse_wheel_down() _mw_down = true; if mouse_wheel_up() _mw_up = true;}
			if content_width < width content_width = width
			if content_height < height content_height = height
			__overflow_x = width < content_width
			__overflow_y = height < content_height

			var _focus = (focus_enabled == false) or (focus_enabled and __is_focused);

			if _mb_pressed {
				if focus_enabled {
					if _mouse_inside {
						__KenginePanels.focused_panel = self;
						__is_focused = true;
					} else {
						__is_focused = false;
					}
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

			} else if __KenginePanels.focused_panel == self and _mb_held and not __mb_drag and _mouse_inside {
				if (_mouse_x != __mouse_x or _mouse_y != __mouse_y) and !__mb_drag and __mb_press_count == 1 and drag_enabled and _focus {
					if (_mouse_y < y + collapse_height)
						{
						__mb_drag = true;
						__drag_anchor = false;
						}
				}
				if not __mb_drag and (_mouse_x == __mouse_x and _mouse_y == __mouse_y) {
					__mb_drag = false;
				}

			} else if __KenginePanels.focused_panel == self and _mb_held and __mb_drag and _mouse_inside {
				__mouse_x = _mouse_x;
				__mouse_y = _mouse_y;
				if not __drag_anchor {
					//mouse_clear(mb_left); _mb_pressed = false; _mb_held = false; _mb_released = false;
					__drag_anchor = true;
					__drag_anchor_x = x - __mouse_x;
					__drag_anchor_y = y - __mouse_y;
				}
			}
			
			if __KenginePanels.focused_panel == self and _mb_held and __drag_anchor and __mb_drag and _focus {
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
			
			if __KenginePanels.focused_panel == self and _mb_pressed_twice and _mouse_inside and collapse_enabled {
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

		if not collapsed {
			if __overflow_x {
				self.__scrollbar_x = self.__scrollbar_x ?? new __KenginePanelsScrollbar(KENGINE_PANELS_SCROLLBAR_TYPE.HORIZONTAL, 0, spr_ken_panels_scrollbar, true);
			} else {
				if is_instanceof(self.__scrollbar_x, __KenginePanelsScrollbar) {
					delete self.__scrollbar_x
				}
				self.__scrollbar_x = undefined
			}
			if self.__overflow_y {
				self.__scrollbar_y = self.__scrollbar_y ?? new __KenginePanelsScrollbar(KENGINE_PANELS_SCROLLBAR_TYPE.VERTICAL, 0, spr_ken_panels_scrollbar, true);
			} else {
				if is_instanceof(self.__scrollbar_y, __KenginePanelsScrollbar) {
					delete self.__scrollbar_y
				}
				self.__scrollbar_y = undefined;
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
			var th, sph, spw, wh;
			if self.__scrollbar_x != undefined {
				spw = sprite_get_width(self.__scrollbar_x.spr);
				th = 0.5*ceil(content_width/width);
				wh = (width-10-spw*3)/th
				self.__scrollbar_x.DrawSlots(x+5, y+_hh-16, th, wh, content_width);
				self.content_x = -self.__scrollbar_x.value
			}
			if self.__scrollbar_y != undefined {
				sph = sprite_get_height(self.__scrollbar_y.spr);
				th = 0.5*ceil(content_height/height);
				wh = (height-10-collapse_height-sph*2)/th
				self.__scrollbar_y.DrawSlots(x+width-16, y+5+collapse_height, th, wh, content_height);
				self.content_y = -self.__scrollbar_y.value
			}
			self.__DrawContents();
		}
	}

	self.Step = function() {
		self.__Step();
	}

	self.Draw = function() {
		self.__Draw();
	}

	self.__Add = function(item) {
		var _a = array_length(self.children);
		item.parent = self;
		self.children[_a] = item;
		return _a - 1;
	}

	self.__DrawContents = function() {
		var th, _mw = 0, _mh = 0;
		for (var _i=0; _i<array_length(children); _i++) {
			if children[_i].Draw != undefined children[_i].Draw();
			_mw = max(_mw, - self.content_x + children[_i].width);
			_mh = max(_mh, - self.content_y + children[_i].height);
		}
		if __auto_content_wh {
			content_width = _mw;
			content_height = _mh;
		}
	}

	self.id = __KenginePanels.panels.Add(self);
}
