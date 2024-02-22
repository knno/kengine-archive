/**
 * @namespace panels
 * @memberof Kengine
 * @description Panel utils.
 *
 */
Kengine.panels = {
	focused: undefined,
	collection: undefined,
};

Kengine.panels._autoc_instance_vars = [
	"id", "visible", "solid", "persistent", "depth", "alarm",
	"toString", "direction", "friction", "gravity", "gravity_direction", "hspeed", "vspeed",
	"speed", "xstart", "ystart", "x", "y", "xprevious", "yprevious", "object_index",
	"sprite_index", "sprite_width", "sprite_height", "sprite_xoffset", "sprite_yoffset",
	"image_alpha", "image_angle", "image_blend", "image_index", "image_number", "image_speed", "image_xscale", "image_yscale",
	"mask_index", "bbox_bottom", "bbox_left", "bbox_right", "bbox_top",
	"path_index", "path_position", "path_positionprevious", "path_speed", "path_scale", "path_orientation", "path_endaction",
	"timeline_index", "timeline_running", "timeline_speed", "timeline_position", "timeline_loop",
	"in_sequence", "sequence_instance",
	"phy_active", "phy_angular_velocity", "phy_angular_damping", "phy_linear_velocity_x", "phy_linear_velocity_y", "phy_linear_damping", "phy_speed_x", "phy_speed_y", "phy_position_x", "phy_position_y", "phy_position_xprevious", "phy_position_yprevious", "phy_rotation", "phy_fixed_rotation", "phy_bullet", "phy_speed", "phy_com_x", "phy_com_y", "phy_dynamic", "phy_kinematic", "phy_inertia", "phy_mass", "phy_sleeping", "phy_collision_points", "phy_collision_x", "phy_collision_y", "phy_col_normal_x", "phy_col_normal_y",
];

Kengine.panels._input_histories = [];


/**
 * @typedef {Struct} PanelOptions
 * @memberof Kengine.panels.Panel
 * @description Panel options struct.
 * @todo Needs documentation
 * 
 */

/**
 * @function Panel
 * @constructor
 * @new_name Kengine.panels.Panel
 * @memberof Kengine.panels
 * @todo Needs documentation
 * @description A base panel that represents a window.
 * @param {Kengine.panels.Panel.PanelOptions} options an initial struct for setting options.
 * 
 */
function __KenginePanelsPanel(options) constructor {
	self.options = options;
	// TODO: Add events.

	id = Kengine.panels.collection.add(self);

	var _structs = Kengine.utils.structs;

	self.x = _structs.set_default(self.options, "x", 0);
	self.y = _structs.set_default(self.options, "y", 0);
	self.width = _structs.set_default(self.options, "width", 200);
	self.height = _structs.set_default(self.options, "height", 50);
	self.title = _structs.set_default(self.options, "title", "Untitled Panel");
	self.children = _structs.set_default(self.options, "children", []);

	self.collapsed = _structs.set_default(self.options, "collapsed", false);

	self.drag_enabled = _structs.set_default(self.options, "drag_enabled", true);
	self.collapse_enabled = _structs.set_default(self.options, "collapse_enabled", true);
	self.focus_enabled = _structs.set_default(self.options, "focus_enabled", true); // If disabled, always-focused mode.
	self.inner_box_enabled = _structs.set_default(self.options, "inner_box_enabled", true);

	self.box_colors = _structs.set_default(self.options, "box_colors", [
		$883300, $883300, $883300, $883300,
	]);

	self.inner_box_colors = _structs.set_default(self.options, "inner_box_colors", [
		c_black, c_black, c_black, c_black,
	]);

	self.alpha = _structs.set_default(options, "alpha", 1);

	self.collapse_height = _structs.set_default(self.options, "collapse_height", 30);
	self.draw_collapsed = _structs.set_default(self.options, "draw_collapsed", false);
	self.visible = _structs.set_default(self.options, "visible", true);

	is_focused = false;

	_drag_anchor = false;
	_mb_drag = false;
	_mb_press_count = 0;
	_mb_press_timer = 0;
	_drag_anchor_x = 0;
	_drag_anchor_y = 0;

	_m_x = 0;
	_m_y = 0;

	self._step = function() {
		var _mouse_click_interval = 15; // fps
		var _mouse_x = device_mouse_x_to_gui(0);
		var _mouse_y = device_mouse_y_to_gui(0);
		x = clamp(x, 0, window_get_width()-width);
		y = clamp(y, 0, window_get_height()-collapse_height-16);

		var hh = collapse_height;
		if not self.collapsed {
			hh = height;
		} else {
			if hh == 0 hh = 16;
		}

		if self.visible {
			var _m_inside = false;
			if _mouse_x >= x and _mouse_y >= y and _mouse_x < x + width and _mouse_y < y + hh {
				_m_inside = true;
			}
			var _mb_pressed, _mb_held, _mb_released, _mb_pressed_twice = false, _mb_pressed_thrice = false;
			if mouse_check_button_pressed(mb_left) {_mb_pressed = true;} else {_mb_pressed = false;}
			if mouse_check_button(mb_left) {_mb_held = true;} else {_mb_held = false;}
			if mouse_check_button_released(mb_left) {_mb_released = true;} else {_mb_released = false;}

			if _mb_pressed {
				if focus_enabled {
					if not _m_inside {is_focused = false;} else {is_focused = true;}
				}
				if (_mb_press_timer > 0) {
					_mb_press_count += 1;
					
					if _mb_press_count == 2 {
						_mb_pressed_twice = true;
					} else if _mb_press_count == 3 {
						_mb_pressed_thrice = true;
					}
					
				} else {
					_mb_press_count = 1;
				}
				_mb_press_timer = _mouse_click_interval;
				_m_x = _mouse_x;
				_m_y = _mouse_y;

			} else if _mb_held and not _mb_drag and _m_inside {
				if (_mouse_x != _m_x or _mouse_y != _m_y) and !_mb_drag and _mb_press_count == 1 and drag_enabled and is_focused {
					if (_mouse_y < y + collapse_height)
						{
						_mb_drag = true;
						_drag_anchor = false;
						}
				}
				if not _mb_drag and (_mouse_x == _m_x and _mouse_y == _m_y) {
					_mb_drag = false;
				}

			} else if _mb_held and _mb_drag and _m_inside {
				if not _drag_anchor {
					//mouse_clear(mb_left); _mb_pressed = false; _mb_held = false; _mb_released = false;
					_drag_anchor = true;
					_drag_anchor_x = x - _m_x;
					_drag_anchor_y = y - _m_y;
				}
			}
			
			if _mb_held and _drag_anchor and _mb_drag and is_focused {
				x = clamp(_mouse_x + _drag_anchor_x, 0, window_get_width()-width);
				y = clamp(_mouse_y + _drag_anchor_y, 0, window_get_height()-collapse_height-16);
			}


			if _mb_press_timer > 0 {
				_mb_press_timer --;
				if _mb_press_timer < 0 {
					_mb_press_timer = 0;
					_mb_press_count = 0;
				}
			}
			
			if _mb_released and _mb_drag {
				_mb_drag = false;
				_drag_anchor = false;
			}
			
			if _mb_pressed_twice and _m_inside and collapse_enabled {
				if (_mouse_y < y + collapse_height)
					{
					collapsed = not collapsed;
					}
			}
		}

		for (var i=0; i<array_length(children); i++) {
			if children[i].step != undefined children[i].step();
		}
	}
	self._draw = function() {
		
		draw_set_alpha(alpha);

		var hh = collapse_height;
		if self.draw_collapsed {
			hh = height;
		} else {
			if not self.visible return;
			if not self.collapsed {
				hh = height;
			} else {
				if hh == 0 hh = 16;
			}
		}

		if is_focused { draw_set_alpha(alpha) } else { draw_set_alpha(0.9*alpha); }
		draw_rectangle_color(x,y,x+width,y+hh,box_colors[0],box_colors[1],box_colors[2],box_colors[3],false);

		if inner_box_enabled {
			if not self.collapsed {
				draw_set_alpha(0.75);
				draw_rectangle_color(x+5,y+5+collapse_height,x+width-5,y+hh-5,inner_box_colors[0],inner_box_colors[1],inner_box_colors[2],inner_box_colors[3],false);
			}
		}

		if is_focused { draw_set_alpha(1*alpha); } else { draw_set_alpha(0.80*alpha); }
		draw_rectangle(x,y,x+width,y+hh, true);

		draw_set_font(ken__fnt_panels);
		draw_set_valign(fa_middle);
		draw_set_halign(fa_center);
		if is_focused { draw_set_alpha(1*alpha); } else { draw_set_alpha(0.75*alpha); }
		draw_text(x+round(width/2), y+round(collapse_height/2), title);

		draw_set_alpha(1*alpha);
		draw_set_valign(fa_top);
		draw_set_halign(fa_left);

		if not self.collapsed {
			self.draw_contents();
		}
	}

	self.step = function() {
		self._step();
	}
	self.draw = function() {
		self._draw();
	}

	self.add = function(item) {
		var _a = array_length(self.children);
		item.parent = self;
		self.children[_a] = item;
		return _a - 1;
	}

	self.draw_contents = function() {
		for (var i=0; i<array_length(children); i++) {
			if children[i].draw != undefined children[i].draw();
		}
	}

	self.options = undefined; // cleanup
}

/**
 * @typedef {Struct} PanelItemOptions
 * @memberof Kengine.panels.PanelItem
 * @description PanelItem options struct.
 * @todo Needs documentation
 * 
 */

/**
 * @function PanelItem
 * @constructor
 * @abstract
 * @new_name Kengine.panels.PanelItem
 * @todo Needs documentation
 * @memberof Kengine.panels
 * @description A base panel item that represents things like {@link kengine~panel.PanelItemInputBox} ...etc.
 * @param {Kengine.panels.PanelItem.PanelItemOptions} options an initial struct for setting options.
 * 
 */
function __KenginePanelsPanelItem(options) constructor {
	self.options = options;

	default_width = 20;
	default_height = 16;
	default_color = c_white;
	default_alpha = 1;
	var _structs = Kengine.utils.structs;

	parent = _structs.set_default(self.options, "parent", undefined);
	x = _structs.set_default(self.options, "x", 0);
	y = _structs.set_default(self.options, "y", 0);
	width = _structs.set_default(self.options, "width", (parent != undefined ? parent.width : default_width));
	height = _structs.set_default(self.options, "height", default_height);

	var fnt = _structs.get(self.options, "font");
	self.font = _structs.set_default(self.options, "font", (is_instanceof(fnt, Kengine.Asset)) ? fnt.id : (fnt ?? ken__fnt_panels));

	self.halign = _structs.set_default(self.options, "halign", fa_left);
	self.valign = _structs.set_default(self.options, "valign", fa_top);

	self.color = _structs.exists(self.options, "color") ? _structs.get(self.options, "color") : (parent != undefined ? (_structs.exists(parent, "color") ? parent.color : default_color ) : default_color);
	self.alpha = _structs.exists(self.options, "alpha") ? _structs.get(self.options, "alpha") : (parent != undefined ? (_structs.exists(parent, "alpha") ? parent.alpha : default_alpha ) : default_alpha);

	self.box_colors = _structs.set_default(options, "box_colors", [
		$200,c_dkgrey,$200,c_dkgrey,
	]);

	self.visible = _structs.set_default(options, "visible", true);
	self.value = _structs.set_default(options, "value", undefined);

	self._get_value = function() {
		return self.value;
	}
	self.get_value = function() {
		return self._get_value();
	}
	self.step = undefined;
	self.draw = undefined;

	self.options = undefined;
}

/**
 * @function PanelItemGUIElement
 * @constructor
 * @abstract
 * @new_name Kengine.panels.PanelItemGUIElement
 * @todo Needs documentation
 * @memberof Kengine.panels
 * @description A base panel item that represents a GUI element to draw. This is for watching variables.
 * @param {Kengine.panels.PanelItem.PanelItemOptions} options an initial struct for setting options.
 * 
 */
function __KenginePanelsPanelItemGUIElement(options) : __KenginePanelsPanelItem(options) constructor {
	var _structs = Kengine.utils.structs;

	self.id = _structs.set_default(options, "id", -1);
	self.type = _structs.set_default(options, "type", "div");
	self.class = _structs.set_default(options, "class", "");
	self.padding = _structs.set_default(options, "padding", 32);
	self.children = _structs.set_default(options, "children", []);
	self.lvl = _structs.set_default(options, "lvl", 0);
	hover = false;

	self.valueprevious = self.value;

	self.step = function() {
		if self.value != self.valueprevious {
			self.children = [];
			self.create_layout(self.value);
			self.valueprevious = self.value;
		}
		/*if self.type == "div" {
			var cx = parent.x + x;
			var cy = parent.y + y;
			var element;
			for (var i = 0; i < array_length(self.children); i++) {
				element = self.children[i];
				step_mouse(element, cx, cy);
			}
		}*/
	}

	self.draw = function () {
		draw_set_font(font);
		draw_set_valign(valign);
		draw_set_halign(halign);
		draw_set_alpha(alpha);
		var u = parent.x + x;
		var v = parent.y + y + parent.collapse_height;
		var u0 = u;
		var ele, c, w,h, uv;
		w = 0; h = 0;
		c = draw_get_color();

		for (var i = 0; i < array_length(self.children); i++) {
			ele = self.children[i];
			if ele.visible {
				if ele.class == "arrow" {
					draw_set_color(ele.hover ? $DD9900 : c);
				} else {
					draw_set_color(c);
				}
				if ele.type == "div" {
					u = u0;
				}
				uv = draw_child(ele, u + self.padding, v + self.padding);
				u = uv[0] - self.padding; v = uv[1] - self.padding;
				draw_set_color(c);
				if ele.type == "br" or ele.type == "div" {
					if ele.value != "" {
						h = string_height(ele.value);
						v += h;
					} else {
						u = u0;
					}
				}
				if ele.class == "extra" {
					h = string_height(ele.value);
					v += h;						
					u = u0;
				}
				if ele.value != "\n" and ele.value != "\\n" {
					w = string_width(ele.value);
					u += w
				} else {
					u = u0;
				}
			}
		}
	}

	self.draw_child = function(element, _x, _y) {
		var c = draw_get_color();
		var ele;
		var uv;
		var u = _x;
		var v = _y;
		var w = 0, h = 0;

		var _mouse_x = device_mouse_x_to_gui(0);
		var _mouse_y = device_mouse_y_to_gui(0);
		var u0 = u;
		if array_length(element.children) > 0 {
			for (var i = 0; i < array_length(element.children); i++) {
				ele = element.children[i];
				if ele.visible {
					if ele.class == "arrow" {
						draw_set_color(ele.hover ? $DD9900 : c);
					} else {
						draw_set_color(c);
					}
					if ele.type == "div" {
						u = u0;
					}
					uv = draw_child(ele, u + self.padding, v);
					u = uv[0] - self.padding; v = uv[1];
					draw_set_color(c);
					if ele.type == "br" or ele.type == "div" {
						if ele.value != "" {
							h = string_height(ele.value);
							v += h;
						} else {
							u = u0;
						}
					}
					if ele.class == "extra" {
						h = string_height(ele.value);
						v += h;						
						u = u0;
					}
					if ele.value != "\n" and ele.value != "\\n" {
						w = string_width(ele.value);
						u += w
					} else {
						u = u0;
					}
				}
			}
			u = u0;
		} else {
			if element.visible {
				w = string_width(element.value);
				h = string_height(element.value);
				element.hover = false;
				if (_mouse_x >= u && _mouse_x <= u + w && _mouse_y >= v && _mouse_y <= v + h) {
					element.hover = true;
					if mouse_check_button_pressed(mb_left) {
						if element.class == "arrow" {
							set_element_toggle(element);
							mouse_clear(mb_left);
						}
					}
				}
				if element.class == "arrow" {
					draw_set_color(element.hover ? $DD9900: element.color);
				} else {
					draw_set_color(element.color);
				}
				draw_text(u, v, string(element.value));
				u = u0;
				if element.class == "arrow" {
					if not element.toggled {
						var i = array_find_index(element.parent.children, method({element}, function (val) {
							return val == element;
						}));
						var is = false;
						for (var j=i+1; j<array_length(element.parent.children); j++;) {
							if element.parent.children[j].class == "nested" {
								is = true
								break;
							}
							if element.parent.children[j].type == "br" break;
						}
						
						if is {
							v += h;
							u -= w;
						}
					}
				}
			}
		}
		return [u, v];
	}

	create_layout = function(obj, par) {
		if obj == "" {
			return;
		}

		par = par ?? self;
		var created_arrow = false;
		var span, br;
		var _arrow = false;
		var _is_struct = false;
		var _array = undefined;
		var _extra = "";

		switch typeof(obj) {
			case "struct":
			case "ref":
				_arrow = true;
				_is_struct = true;
				_array = struct_get_names(obj);
				_extra = "";
				break;
				
			case "array":
				_arrow = true;
				_is_struct = false;
				_array = obj;
				_extra = string("[{0}]", array_length(obj));
				break;
				
			default:
				span = new __KenginePanelsPanelItemGUIElement({
					"type": "span",
					"value": (!created_arrow ? " " : "") + string(obj),
					"parent": par,
				});
				array_push(par.children, span);

				br = new __KenginePanelsPanelItemGUIElement({
					"type": "br",
					"class": "",
					"value": "\n",
					"parent": par,
				});
				array_push(par.children, br);

				return;
		}
		
		if _arrow {
			span = new __KenginePanelsPanelItemGUIElement({
				"type": "span",
				"value": "▼", // 
				"class": "arrow",
				"parent": par,
				"color": c_gray,
			});
			span.toggled = true;
			array_push(par.children, span); // index 0
			created_arrow = span;
		}
		
		if _extra != "" {
			span = new __KenginePanelsPanelItemGUIElement({
				"type": "span",
				"value": _extra,
				"class": "extra",
				"parent": par,
				"color": c_gray,
			});
			array_push(par.children, span);
		}

		var _n, _v, _p;

		var _pcreated = false;
		for (var i=0; i<array_length(_array); i++) {
			if _is_struct {
				_n = _array[i];
				_v = obj[$ _n];
				_p = par;
			} else {
				_n = "";
				_v = obj[i];
				_p = new __KenginePanelsPanelItemGUIElement({
					"type": "div",
					"value": "",
					"parent": par,
					"class": "nested",
				});
				array_push(par.children, _p);
			}

			/*if (typeof(_v) == "array" or typeof(_v) == "struct" or typeof(_v) == "ref") {
				if typeof(_v) == "array" {
					// Now create arrow for array.
					span = new __KenginePanelsPanelItemGUIElement({
						"type": "span",
						"value": "[",
						"class": "arrow",
						"parent": _p,
						"color": c_gray,
					});
					span.toggled = true;
					array_push(_p.children, span); // index 0
					created_arrow = span;
				}
			}*/

			if _n != "" {
				span = new __KenginePanelsPanelItemGUIElement({
					"type": "span",
					"value": _n + ": ",
					"parent": _p,
					"class": "def",
					"color": c_gray,
				});			
				array_push(_p.children, span);
			}
			created_arrow = false;
			create_layout(_v, _p);
		}
		br = new __KenginePanelsPanelItemGUIElement({
			"type": "br",
			"value": "",
			"parent": par,
		});
		array_push(par.children, br);
	}

	set_element_visibility = function(element, visibility) {
		for (var i=0; i<array_length(element.children); i++) {
			element.children[i].visible = visibility;
		}
		element.visible = visibility;
	}

	set_element_toggle = function(element) {
		var i = array_find_index(element.parent.children, method({element}, function (val) {
			return val == element;
		}));
		var lvl = element.lvl;
		if element.toggled {
			element.value = "►";
			for (var j=i+1; j<array_length(element.parent.children); j++;) {
				if element.parent.children[j].type == "br" break;
				set_element_visibility(element.parent.children[j], false);
				if element.parent.children[j].class == "arrow" {
					set_element_toggle(element.parent.children[j]);
				}
			}
		} else {
			element.value = "▼";
			for (var j=i+1; j<array_length(element.parent.children); j++;) {
				if element.parent.children[j].type == "br" break;
				set_element_visibility(element.parent.children[j], true);
				if element.parent.children[j].class == "arrow" {
					set_element_toggle(element.parent.children[j]);
				}
			}
		}
		element.toggled = not element.toggled;
	}

	step_mouse = function(element, _x, _y) {
		var ele;
		var uv;
		var u = _x;
		var v = _y;
		var w = 0, h = 0;
		var mx, my;

		var _mouse_x = device_mouse_x_to_gui(0);
		var _mouse_y = device_mouse_y_to_gui(0);
		mx = _mouse_x;
		my = _mouse_y;

		var u0 = u;
		if element.visible {
			ele = element;
			
			if array_length(ele.children) > 0 {
				for (var j=0; j<array_length(element.children); j++) {
					ele = element.children[j];
					if ele.visible {
						if ele.type == "div" {
							u = u0;
						}
						var _x1 = u;
						var _y1 = v;
						w = string_width(ele.value);
						h = string_height(ele.value);
						ele.hover = false;
					
						/*
						if (mx >= _x1 && mx <= _x1 + w && my >= _y1 && my <= _y1 + h) {
							ele.hover = true;
							if mouse_check_button_pressed(mb_left) {
								if ele.class == "arrow" {
									var i = array_find_index(ele.parent.children, method({ele}, function (val) {
										return val == ele;
									}));
									if ele.toggled {
										set_element_visibility(ele.parent.children[i + 4], false);
									} else {
										set_element_visibility(ele.parent.children[i + 4], true);
									}
									ele.toggled = not ele.toggled;
								}
							}
						}*/

						uv = step_mouse(ele, u, v);
						u = uv[0]; v = uv[1];

						if ele.type == "br" or ele.type == "div" {
							if ele.value != "" {
								h = string_height(ele.value);
								v += h;
							} else {
								u = u0;
							}
						}
						if ele.class == "extra" {
							h = string_height(ele.value);
							v += h;						
							u = u0;
						}
						if ele.value != "\n" {
							u += string_width(ele.value);
						} else {
							u = u0;
						}
					}
				}
			} else if array_length(ele.children) == 0 {
				var _x1 = u;
				var _y1 = v;
				w = string_width(ele.value);
				h = string_height(ele.value);
				ele.hover = false;
				if (mx >= _x1 && mx <= _x1 + w && my >= _y1 && my <= _y1 + h) {
					ele.hover = true;
					if mouse_check_button_pressed(mb_left) {
						if ele.class == "arrow" {
							var i = array_find_index(ele.parent.children, method({ele}, function (val) {
								return val == ele;
							}));
							if ele.toggled {
								set_element_visibility(ele.parent.children[i + 4], false);
							} else {
								set_element_visibility(ele.parent.children[i + 4], true);
							}
							ele.toggled = not ele.toggled;
						}
					}
				}
			}
		}
		return [u, v];		
	}

	if self.type == "div" { create_layout(self.value); }
}

/**
 * @function PanelItemInputBox
 * @constructor
 * @new_name Kengine.panels.PanelItemInputBox
 * @memberof Kengine.panels
 * @description A `PanelItemInputBox` is a text box that can be readonly or writable on self or parent focus.
 * @param {Struct} options an initial struct for setting options.
 */
function __KenginePanelsPanelItemInputBox(options) : __KenginePanelsPanelItem(options) constructor {
	self.text = "";
	self.readonly = Kengine.utils.structs.set_default(options, "readonly", true);
	self.identifier = Kengine.utils.structs.set_default(options, "identifier", "__all"); // for autoc, history...
	self.box_enabled = Kengine.utils.structs.set_default(options, "box_enabled", (self.readonly ? false : true));
	self.autoc_enabled = Kengine.utils.structs.set_default(options, "autoc_enabled", false);
	self.history_enabled = Kengine.utils.structs.set_default(options, "history_enabled", false);
	self.active = Kengine.utils.structs.set_default(options, "active", undefined);
	self.background = Kengine.utils.structs.set_default(options, "background", undefined);
	self.value_temp = self.value;
	if self.active == undefined {
		self.active = false;
		if parent != undefined {
			if Kengine.utils.structs.exists(parent, "active_child") {
				if parent.active_child == undefined {
					if not self.readonly self.active = true;
				}
			}
		}
	}

	cursor_pos = max(0,string_length(self.value) - 1);
	cursor_talpha = 1;
	cursor_tspeed = .5;
	cursor_ttimer = 0;
	cusror_color = c_white;

	kbd_key_timer = 0;
	kbd_last_key = vk_nokey;
	kbd_sel_start = -1;
	kbd_hold_timer = .5;

	history_pos = 0;

	autoc = "";
	autoc_pos = 0;

	draw_set_font(font);
	str_height = string_height("|");
	str_width = string_width("_");

	self.step = function() {
		var _mouse_x = device_mouse_x_to_gui(0);
		var _mouse_y = device_mouse_y_to_gui(0);
		var game_speed = game_get_speed(gamespeed_fps);
		// 1. Editable?
		if not readonly {
		// 1.1 Cursor
			if visible and parent.visible {
				var temp_pos;
				var _m_inside = false;
				if _mouse_x >= parent.x + x and _mouse_y >= parent.y + y and _mouse_x < parent.x + x + width and _mouse_y < parent.y + y + height {
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
					if keyboard_lastkey == kbd_last_key {
						kbd_key_timer ++;
					} else {
						kbd_key_timer = 0;
					}

					// Backspace
					if Kengine.utils.input.keyboard_check(vk_backspace) & (kbd_key_timer == 0 or kbd_key_timer > kbd_hold_timer*game_speed) {
						if kbd_sel_start != -1 {
							selection_remove();
						}
					}

					// Arrows + Ctrl Arrows
					if (Kengine.utils.input.keyboard_check(vk_left) & (kbd_key_timer == 0 or kbd_key_timer > kbd_hold_timer*game_speed)) {
						if (Kengine.utils.input.keyboard_check(vk_shift)) {
							if (kbd_sel_start == -1) {
								// Begin selection
								kbd_sel_start = cursor_pos;
								}
							} else {
								// Remove selection
								kbd_sel_start = -1;
							}
							if (Kengine.utils.input.keyboard_check(vk_control)) {
								var cp = cursor_pos;
								cursor_pos = Kengine.utils.strings.string_pos_direction(value, " ", 1, cursor_pos);
								if (cursor_pos > cp) {cursor_pos = 0;}
							}
							autoc = "";
							cursor_talpha = 1;
							cursor_ttimer = 0;
							if cursor_pos>0 cursor_pos -= 1;
					} else if (Kengine.utils.input.keyboard_check(vk_right) & (kbd_key_timer == 0 or kbd_key_timer > kbd_hold_timer*game_speed)) {
						if (Kengine.utils.input.keyboard_check(vk_shift)) {
							if (kbd_sel_start == -1) {
								kbd_sel_start = cursor_pos;
							}
						} else {
							kbd_sel_start = -1;
						}
						if (Kengine.utils.input.keyboard_check(vk_control)) {
							var cp = cursor_pos-1
							cursor_pos = Kengine.utils.strings.string_pos_direction(value, " ", -1, cursor_pos+1);
							if (cursor_pos < cp) {cursor_pos = string_length(value);}
						}
						autoc = "";
						cursor_talpha = 1;
						cursor_ttimer = 0;
						if cursor_pos<string_length(value) cursor_pos += 1;
					
					}

					// History
					if history_enabled {
						if Kengine.utils.input.keyboard_check_pressed(vk_down) {
							if array_length(Kengine.panels._input_histories) > 0 {
								autoc = "";
								cursor_talpha = 1; cursor_ttimer = 0;
								if history_pos > 0 {
									history_pos --;
								} else {
									history_pos = array_length(Kengine.panels._input_histories) - 1;
								}
								value = Kengine.panels._input_histories[history_pos];
								value_temp = value;
								cursor_pos = string_length(value);
								keyboard_string = value;
								Kengine.utils.input.keyboard_clear(vk_down);
							}
						} else if Kengine.utils.input.keyboard_check_pressed(vk_up) {
							if array_length(Kengine.panels._input_histories) > 0 {
								autoc = "";
								cursor_talpha = 1; cursor_ttimer = 0;
								if history_pos < array_length(Kengine.panels._input_histories) - 1 {
									history_pos ++;
								} else {
									history_pos = 0;
								}
								value = Kengine.panels._input_histories[history_pos];
								value_temp = value;
								cursor_pos = string_length(value);
								keyboard_string = value;
								Kengine.utils.input.keyboard_clear(vk_up);
							}
						}
					}
					
					// Copy paste
					if Kengine.utils.input.keyboard_check(vk_control) and (Kengine.utils.input.keyboard_check_pressed(ord("X")) or Kengine.utils.input.keyboard_check_pressed(ord("C"))) {
						var copy;
						if kbd_sel_start != -1 {
							copy = selection_get();
						} else {
							copy = text;
						}
						clipboard_set_text(copy);
						if Kengine.utils.input.keyboard_check_pressed(ord("X")) {
							var temp_pos_ltr = false;
							if cursor_pos > kbd_sel_start {
								temp_pos_ltr = true;
							}
							selection_remove();
							if temp_pos_ltr {
								cursor_pos = temp_pos - string_length(copy);
							} else {
								cursor_pos = temp_pos;
							}
						}
						cursor_talpha = 1;
						cursor_ttimer = 0;
						if Kengine.utils.input.keyboard_check_pressed(ord("X")) {
							Kengine.utils.input.keyboard_clear(ord("X"));
						} else {
							Kengine.utils.input.keyboard_clear(ord("C"));
						}
					} else if Kengine.utils.input.keyboard_check(vk_control) and Kengine.utils.input.keyboard_check_pressed(ord("V")) {
						temp_pos = cursor_pos;
						if clipboard_has_text() {
							if kbd_sel_start != -1 {
								selection_remove();
							}
							var copied = clipboard_get_text();
							cursor_talpha = 1;
							cursor_ttimer = 0;
							value = string_insert(copied, value, cursor_pos+1);
							value_temp = value;
							keyboard_string = value;
							cursor_pos = temp_pos + string_length(copied);
						}
						Kengine.utils.input.keyboard_clear(ord("V"));
					}

					// Autocomplete
					if Kengine.utils.input.keyboard_check_pressed(vk_tab) and autoc_enabled {
						if value != "" {
							cursor_talpha = 1;
							cursor_ttimer = 0;
							value = autoc_find_next(value, keyboard_check(vk_shift));
							// cursor_pos = string_length(value);
							value_temp = value;
							keyboard_string = value;
						}
						Kengine.utils.input.keyboard_clear(vk_tab);
					}

					// Cursor
					if cursor_ttimer < cursor_tspeed * game_speed { cursor_ttimer ++;} else {cursor_ttimer = 0; cursor_talpha = !cursor_talpha;}

					// Keyboard selection
					if kbd_sel_start == cursor_pos {kbd_sel_start = -1;}
					
					draw_set_font(font);

					// Spacing, typing and backspace.
					if string_width(keyboard_string) < width {
						value = keyboard_string;
						if value != value_temp { // New character
							autoc = "";
							cursor_talpha = 1;
							cursor_ttimer = 0;
							if keyboard_key == vk_backspace {
								if string_length(value) > 0 and cursor_pos >= 0 {
									// Remove char at cursor especially \#
									var a = string_copy(value_temp, 0, cursor_pos - 1);
									var b = string_copy(value_temp, cursor_pos + 1, string_length(value_temp) - cursor_pos + 1);
									if cursor_pos > 0 cursor_pos--;
									value = a + b;
								} else {
									cursor_pos = 0;
								}
								value_temp = value;
								keyboard_lastchar = "";
								keyboard_string = value;
								Kengine.utils.input.keyboard_clear(keyboard_key);
								keyboard_key = vk_nokey;

							} else if keyboard_key != vk_enter {
								if kbd_sel_start != -1 {
									temp_pos = cursor_pos;
									selection_remove();
									value = string_delete(value, string_length(value), 1);
									value_temp = value;
									cursor_pos = temp_pos;
								}
								// Put char at cursor
								var a = string_copy(value_temp, 0, cursor_pos);
								var b = string_copy(value_temp, cursor_pos + 1, string_length(value_temp) - cursor_pos + 2);
								cursor_pos++;

								// If backspace or delete char, use empty.
								if keyboard_lastchar == ansi_char(127) or keyboard_lastchar == ansi_char(8) {
									keyboard_lastchar = "";
									cursor_pos --;
								}

								value = a + keyboard_lastchar + b;
								value_temp = value;
								keyboard_lastchar = "";
								keyboard_string = value;
								Kengine.utils.input.keyboard_clear(keyboard_key);
								keyboard_key = vk_nokey;
								kbd_key_timer = 0;
							}
						}
						value_temp = value;
						keyboard_string = value;
					} else {
						keyboard_string = value_temp;
					}

					// (cleanup)
					if(keyboard_lastkey != vk_lshift and
						keyboard_lastkey != vk_rshift and
						keyboard_lastkey != vk_lcontrol and 
						keyboard_lastkey != vk_rcontrol) {kbd_last_key = keyboard_lastkey;}

					if (Kengine.utils.input.keyboard_check_released(vk_left)
					or Kengine.utils.input.keyboard_check_released(vk_right)) {
						kbd_last_key= vk_nokey;
						kbd_key_timer= 0;
						keyboard_lastkey = vk_nokey;
						keyboard_key = vk_nokey;
						keyboard_lastchar = "";
					}
				}
			}
		// 1.3 History (identifier)
		// 1.4 Autocomplete (identifier)
		// 1.5 Enter is Submit			
		}
	}

	self.draw = function() {
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
		draw_set_color(color);

		draw_text(parent.x+x+3, parent.y+y+1 + 5, value);

		// Draw keyboard selection start, if found, to the cursor position.
		if kbd_sel_start != -1 {
			var x1, x2, y1, y2, st;
			if kbd_sel_start < cursor_pos {
				x1 = parent.x + x + 3 + kbd_sel_start * str_width;
				x2 = x1 + (cursor_pos - kbd_sel_start) * str_width;
				st = string_copy(value, kbd_sel_start + 1, cursor_pos - kbd_sel_start);
			} else {
				x1 = parent.x + x + 3 + cursor_pos * str_width;
				x2 = x1 + (kbd_sel_start - cursor_pos) * str_width;
				st = string_copy(value, cursor_pos + 1, kbd_sel_start - cursor_pos);
			}
			y1 = parent.y + y + 1 + 5;
			y2 = y1 + str_height;
			gpu_set_blendmode_ext(bm_dest_colour, bm_zero);
			draw_set_color(box_colors[0]);
			draw_rectangle(x1,y1,x2,y2, false);
			gpu_set_blendmode(bm_normal);
			draw_set_color(color);
		}
		
		// Draw cursor
		if cursor_talpha {
			var cursor_offset = string_width(string_copy(value, 0, cursor_pos));
		
			draw_set_color(cusror_color);
			draw_set_alpha(1);
			draw_line(
				parent.x + x + 5 + cursor_offset,
				parent.y + y + 1 + 4,
				parent.x + x + 5 + cursor_offset,
				parent.y + y + 1 + str_height + 4
			);
			draw_set_color(color);
		}
	}
	
	/**
	 * @function selection_get
	 * @memberof Kengine.panel.PanelItemInputBox
	 * @description Get the selected part from the text value.
	 * @return {String} The selected string of the text value.
	 */
	selection_get = function() {
		var cpos = cursor_pos;
		var sel = kbd_sel_start;
		var t = value;
		if (cpos < sel) {
			return string_copy(t, cpos+1, sel - cpos);
		} else {
			return string_copy(t, sel+1, cpos - sel);
		}
	}
	selection_remove = function() {
		if (kbd_sel_start > cursor_pos) {
			value = string_delete(value, cursor_pos + 1, kbd_sel_start - cursor_pos);
		} else {
			value = string_delete(value, kbd_sel_start + 1, cursor_pos - kbd_sel_start);
		}
		value_temp = value;
		keyboard_string = value;
		cursor_pos = min(kbd_sel_start-1, string_length(value));
		kbd_sel_start = -1;
		}
	selection_set = function(start_pos, cursorpos) {
		self.kbd_sel_start = start_pos;
		if cursorpos != undefined {
			self.cursor_pos = cursorpos;
		}
	}

	autoc_add_ind = function(reversed) {
		autoc_pos += reversed ? -1 : 1;
		if autoc_pos >= array_length(Kengine.panels._autocs) {
			autoc_pos = 0;
		}
		if autoc_pos < 0 {
			autoc_pos = array_length(Kengine.panels._autocs) - 1;
		}
		return autoc_pos;
	}

	autoc_find_next = function(str, reversed=false) {
		var i, indexing;
		indexing = false;
		var __b = "";
		if string_char_at(str, 1) == "/" {
			__b = "/";
		}

		if autoc == "" or autoc == str {
			autoc_pos = 0;
			autoc = string_copy(str, 1+string_length(__b), string_length(str));
			Kengine.panels._autocs = [];
			indexing = true;
		}

		// pop last word
		var _x = string_split(autoc, " ");
		autoc = _x[array_length(_x)-1];
		_x[array_length(_x)-1] = "";
		autoc_extra_pre = string_join_ext(" ", _x);
		
		var a, b;
		if string_pos("global.", autoc) == 1 {
			// pre dot
			a = "global";
			// post dot
			b = string_copy(autoc, string_pos(a, autoc)+1, string_length(a) - string_pos(a, autoc)+1);
		}
		var autoc_no_dot = autoc;
		if string_char_at(autoc, string_length(autoc)) == "." {
			autoc_no_dot = string_delete(autoc, string_length(autoc), 1);
		}
		if string_count(".", autoc_no_dot) > 0 {
			a = string_copy(autoc_no_dot, 0, string_last_pos(".", autoc_no_dot)-1);
			b = string_copy(autoc_no_dot, string_last_pos(".", autoc_no_dot)+1, string_length(autoc_no_dot) - string_last_pos(".", autoc_no_dot)+1);
		} else {
			a = autoc_no_dot;
			b = "";
		}
		
		if indexing {
			var n;
			var _do_autoc = false;
			if a != undefined {
				var _inter = Kengine.utils.structs.set_default(parent, "interpret", Kengine.utils.parser.interpret);
				var _a = _inter(a, 2);
				if is_array(_a) {
					if array_length(_a) > 0 {
						_a = _a[0];
					}
				}
				if typeof(_a) == "ref" {
					if instance_exists(_a) {
						for (var j=0; j<array_length(Kengine.panels._autoc_instance_vars); j++) {
							_do_autoc = true;
							if Kengine.utils.is_private(_a, Kengine.panels._autoc_instance_vars[j]) == true {
								_do_autoc = false;
							}
							if Kengine.utils.is_public(_a, Kengine.panels._autoc_instance_vars[j]) {	
								_do_autoc = true;
							}
							if _do_autoc {
								if string_pos(b, Kengine.panels._autoc_instance_vars[j]) == 1 or b == "" {
									Kengine.panels._autocs[array_length(Kengine.panels._autocs)] = Kengine.panels._autoc_instance_vars[j];
								}
							}
						}
						var _v = variable_instance_get_names(_a);
						for (var j=0; j<array_length(_v); j++) {							
							_do_autoc = true;
							if Kengine.utils.is_private(_a, _v[j]) == true {
								_do_autoc = false;
							}
							if Kengine.utils.is_public(_a, _v[j]) {	
								_do_autoc = true;
							}
							if _do_autoc {
								if string_pos(b, _v[j]) == 1 or b == "" {
									Kengine.panels._autocs[array_length(Kengine.panels._autocs)] = _v[j];
								}
							}
						}
					}
				} else if is_struct(_a) {
					if Kengine.utils.is_private(_a) != true {
						var _d = struct_get_names(_a);
						for (var j=0; j<array_length(_d);j+=1) {
							_do_autoc = true;
							if Kengine.utils.is_private(_a, _d[j]) == true {
								_do_autoc = false;
							}
							if Kengine.utils.is_public(_a, _d[j]) {	
								_do_autoc = true;
							}
							if _do_autoc {
								// if string_char_at(_d[j], 0) == "_" continue;
								if string_pos(b, _d[j]) == 1 or b == "" {
									Kengine.panels._autocs[array_length(Kengine.panels._autocs)] = _d[j];
								}
							}
						}
					}
				} else {
					// Scripts and methods.
					var scrs = Kengine.asset_types.script.assets.filter(function(val) {
						return not Kengine.utils.is_private(val);
					});
					for (var j=0; j<array_length(scrs); j++) {
						var _n = scrs[j].name;
						_do_autoc = true;
						if Kengine.utils.is_private(scrs[j]) == true {
							_do_autoc = false;
						}
						if Kengine.utils.is_public(scrs[j]) == true {
							_do_autoc = true;
						}
						if _do_autoc {
							// if string_char_at(_n, 0) == "_" continue;
							if string_pos(b, _n) == 1 or b == "" {
								if string_pos(a, _n) == 1 {
									Kengine.panels._autocs[array_length(Kengine.panels._autocs)] = _n;
								}
							}
						}
					}
				}
			}

			// TXR map
			var txr_a = ds_map_keys_to_array(Kengine.utils.parser._TXR.System._function_map);
			for (i=0; i<array_length(txr_a);i++;) {
				n = txr_a[i];
				if string_pos(autoc, n) == 1 {
					Kengine.panels._autocs[array_length(Kengine.panels._autocs)] = n;
				}
			}

			// Instances
			with all {
				n = string(object_get_name(object_index));
				if string_pos(other.autoc, n) == 1 {
					Kengine.panels._autocs[array_length(Kengine.panels._autocs)] = n;
				}
				n = string(real(id));
				if string_pos(other.autoc, n) == 1 {
					Kengine.panels._autocs[array_length(Kengine.panels._autocs)] = n;
				}
			}

			// Constants ...etc.
			if struct_exists(Kengine.panels, "default_autocs") {
				for (i=0; i<array_length(Kengine.panels.default_autocs); i++) {
					Kengine.panels._autocs[array_length(Kengine.panels._autocs)] = Kengine.panels.default_autocs[i];
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
					for (i=0; i<array_length(_dautocs); i++) {
						Kengine.panels._autocs[array_length(Kengine.panels._autocs)] = _dautocs[i];
					}
				}
			}
		}
		var _autoc = string_split(autoc, ".");
		_autoc = _autoc[array_length(_autoc)-1];

		for (i=0; i<array_length(Kengine.panels._autocs); i++) {
			if string_pos(_autoc, Kengine.panels._autocs[i]) == 1 {
				if autoc_pos == i {
					__b = string_copy(autoc, 1, string_length(autoc) - string_length(_autoc));
					autoc_add_ind(reversed);
					var ret = __b + Kengine.panels._autocs[i]; // + autoc_extra_pre + a + "." 
					cursor_pos = string_length(ret);
					return ret;
				}
			}
			if string_pos(autoc, Kengine.panels._autocs[i]) == 1 {
				if autoc_pos == i {
					autoc_add_ind(reversed);
					var ret = __b + Kengine.panels._autocs[i]; // + autoc_extra_pre + a + "." 
					cursor_pos = string_length(ret);
					return ret;
				}
			}
		}
		cursor_pos = string_length(str);
		return str;
	}
}

/**
 * @function PanelItemButton
 * @constructor
 * @new_name Kengine.panels.PanelItemButton
 * @memberof Kengine.panels
 * @description A base button.
 * @param {Struct} options
 */
function __KenginePanelsPanelItemButton(options) : __KenginePanelsPanelItem(options) constructor {
	width = sprite_get_width(ken__spr_icons);
	height = sprite_get_height(ken__spr_icons);
	valign = fa_middle;
	halign = fa_center;
	color = struct_exists(options, "color") ? options.color: c_white;
	text_color = Kengine.utils.structs.set_default(options, "text_color", c_white);
	text = Kengine.utils.structs.set_default(options, "text", "OK");
	type = Kengine.utils.structs.set_default(options, "type", "Button");
	checked = Kengine.utils.structs.set_default(options, "checked", false);
	action = Kengine.utils.structs.set_default(options, "action", undefined);
	icon_index = Kengine.utils.structs.set_default(options, "icon_index", -1);
	spr_state = 0;  // 0 single 1 single click 2 toggler 3 toggler click 4 toggled 5 toggled click

	self.draw = function() {
		var spr_ind;
		
		if string_lower(type) == "toggle" {
			spr_ind = (checked ? 4 : 2) + spr_state;
		} else {
			spr_ind = 0 + spr_state;
		}
		
		var _x = parent.x + x;
		var _ys = spr_state == 1 ? 2 : 0;
		var _y = parent.y + y;
		draw_set_font(font);
		draw_set_valign(valign);
		draw_set_halign(halign);
		draw_set_alpha(alpha * parent.alpha);
		draw_set_color(text_color);
		draw_sprite_ext(ken__spr_icons, spr_ind, _x, _y, 1,1,0,color, _alpha);
		if icon_index != -1 {
			draw_sprite_ext(ken__spr_icons, icon_index, _x, _y + _ys, 1,1,0,c_white, _alpha);
		}
		draw_text(_x + width/2, _y + _ys + height/2, text);
	}
	
	self.step = function() {
		var _mouse_x = device_mouse_x_to_gui(0);
		var _mouse_y = device_mouse_y_to_gui(0);
		if x == 0 {
			x += 5;
		}
		if y == 0 {
			y += parent.collapse_height;
		}
		var _x = parent.x + x;
		var _ys = spr_state == 1 ? 2 : 0;
		var _y = parent.y + y;
		if self.visible {
			var _m_inside = false;
			if _mouse_x >= _x and _mouse_y >= _y and _mouse_x < _x + width and _mouse_y < _y + height {
				_m_inside = true;
			}
			var _mb_pressed, _mb_held, _mb_released, _mb_pressed_twice = false, _mb_pressed_thrice = false;
			if mouse_check_button_pressed(mb_left) {_mb_pressed = true;} else {_mb_pressed = false;}
			if mouse_check_button(mb_left) {_mb_held = true;} else {_mb_held = false;}
			if mouse_check_button_released(mb_left) {_mb_released = true;} else {_mb_released = false;}
			
			if _m_inside {_alpha = alpha;} else {_alpha = 0.8*alpha;}
			if _mb_pressed and _m_inside {spr_state = 1;}
			if _mb_released and (not _m_inside) {spr_state = 0;}
			
			if _mb_released and _m_inside {
				if self.action != undefined {self.action(self);}
				spr_state = 0;
			}
		}
	}
}

/**
 * @function Console
 * @constructor
 * @new_name Kengine.panels.Console
 * @memberof Kengine.panels
 * @description A console is an extended {@link kengine~panel.Panel} with many features for debugging.
 * @param {Struct} options an initial struct for setting options.
 */
function __KenginePanelsConsole(options) : __KenginePanelsPanel(options) constructor {
	var c_echo = $DD9900, c_error = $2000ff, c_debug = $008800;

	color_echo = Kengine.utils.structs.set_default(options, "color_echo", c_echo);
	color_error = Kengine.utils.structs.set_default(options, "color_error", c_error);
	color_debug = Kengine.utils.structs.set_default(options, "color_debug", c_debug);
	notify_enabled = Kengine.utils.structs.set_default(options, "notify_enabled", true);
	notify_show_time = Kengine.utils.structs.set_default(options, "notify_show_time", 5);
	notify_timer = 0;
	notify_state = 0; // 0 = idle, 1 = notify mode
	enabled = Kengine.utils.structs.set_default(options, "enabled", true);

	// 0 = disable, 1 = only error, 2 = error + info, 3 = error + warnings + info, 4 = error + warnings + info + debug
	verbosity = Kengine.utils.structs.exists(options, "verbosity") ? options.verbosity : ((KENGINE_DEBUG) ? 4 : 3);

	str_height = string_height("|");
	str_width = string_width("_");

	x = 0; y = 0;
	width = window_get_width(); // height is dynamic.
	collapse_height = 0;
	collapse_enabled = false; 
	focus_enabled = false;
	is_focused = true;
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
	interpret = struct_exists(options, "interpreter") ? options.interpreter : function(value) {
		if string_count(" ", value) > 0 {
			return Kengine.utils.parser.interpret(value, {__allow_private: KENGINE_CONSOLE_ALLOW_PRIVATE, script_object: "console", event: "input"});
		} else {
			return Kengine.utils.parser.interpret_val(value, {__allow_private: KENGINE_CONSOLE_ALLOW_PRIVATE, script_object: "console", event: "input"});
		}
	};
	toggle_key  = Kengine.utils.structs.set_default(options, "toggle_key", 192); // `
	log_file = Kengine.utils.structs.set_default(options, "log_file", false);
	font = Kengine.utils.structs.set_default(options, "font", ken__fnt_panels);
	
	lines_max = Kengine.utils.structs.set_default(options, "lines_max", 100);
	lines_count = Kengine.utils.structs.set_default(options, "lines_count", 30);
	lines_notify = Kengine.utils.structs.set_default(options, "lines_notify", 10);
	lines_notify_current = 0;

	scroll_inc = 3;
	log_write_timer = -1;
	log_write_queue = ds_queue_create();

	clear = function() {
		for (var i=0; i<lines_max; i++) {
			texts[i] = "";
			texts_color[i] = color_echo;
		}
	}

	// Initial
	clear();
	height = str_height * lines_count + 4;
	length = floor(width/str_width)-1;

	self.input_check = function(value) {
		try {
			var result = self.interpret(value);
			if not is_undefined(result) self.echo(result);
		} catch (e) {
			self.echo_error(e.message);
			show_debug_message(e);
		}
	}

	self.step = function() {
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
			_log_write_dequeue();
			log_write_timer --;
		}

		self._step();
		
		if Kengine.utils.input.keyboard_check_pressed(vk_enter) {
			if inputbox.value != ""  and  visible  and (not collapsed) {
				Kengine.utils.input.keyboard_clear(vk_enter);
				if inputbox.history_enabled Kengine.panels._input_histories[array_length(Kengine.panels._input_histories)] = inputbox.value;
				inputbox.value = string_replace_all(inputbox.value, "\\n", chr(13));
				self.echo(">"+inputbox.value);
				try {
					self.input_check(inputbox.value);
				} catch (e) {
					self.echo_error(e.message);
					self.debug(e);
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
			if Kengine.utils.input.keyboard_check_pressed(toggle_key) and enabled {
				visible = not visible;
				collapsed = not collapsed;
				lines_notify_current=0; notify_state=0;
				Kengine.utils.input.keyboard_clear(toggle_key);
				keyboard_lastkey = vk_nokey;
				keyboard_lastchar = "";
				if (not collapsed) and (visible) {
					is_focused = true;
					inputbox.active = true;
				}
			}
		}
		
		if is_focused and visible and not self.collapsed {
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
					inputbox.active = true;
					mouse_clear(mb_left);
					keyboard_lastkey = vk_nokey;
					keyboard_lastchar = "";
				}
			}

			// Scrolling
			if keyboard_check_pressed(vk_pagedown) or mouse_wheel_down() {
				if keyboard_check_direct(vk_shift) {
					scroll_hpos += scroll_inc*3;
				} else {
					if scroll_pos > 0 scroll_pos -= min(scroll_pos, scroll_inc);
				}
				Kengine.utils.input.keyboard_clear(vk_pagedown);
			} else if keyboard_check_pressed(vk_pageup) or mouse_wheel_up() {
				if keyboard_check_direct(vk_shift) {
					if scroll_hpos > 0 scroll_hpos -= scroll_inc*3;
				} else {
					if scroll_pos < lines_max - lines_count {
						scroll_pos += min(lines_max - lines_count, scroll_inc);
					}
				}
				Kengine.utils.input.keyboard_clear(vk_pageup);
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
	self.draw = function() {
		if notify_state == 1 {
			self.draw_collapsed = true;
			height = str_height*(lines_notify_current);
		} else {
			self.draw_collapsed = false;
		}
		self._draw();
		draw_set_font(font);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_set_alpha(1);
		if self.visible and not self.collapsed and is_focused {
			// Draw console lines.
			var _texty;
			var offset;
			for (i=lines_count + scroll_pos + 1; i > scroll_pos - 1; i--;) {
				if i>= array_length(texts_color)
				or i>= array_length(texts) {
					continue;
				}
				_texty = texts[i];
				if scroll_hpos > 0 {
					offset = floor(scroll_hpos/str_width);
					_texty = string_copy(_texty, offset, string_length(_texty)-offset);
				}
				draw_set_color(texts_color[i]);
				draw_set_alpha(alpha * (1 * (1-.5 * not is_focused)));
				draw_text(x+4-scroll_hpos, y+1+((lines_count-1)-(i-scroll_pos))*str_height, _texty);
			}
			if scroll_pos > 0 or scroll_hpos > 0 {
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

				var j = 0;
				for (i=0; i<lines_count; i++;) {
					if j < lines_notify_current and y+1+str_height*(lines_notify_current-1-j) > 0 {
						if i>= array_length(texts_color)
						or i>= array_length(texts) {
							continue;
						}
						draw_set_color(texts_color[i]);
						draw_set_alpha(alpha);
						draw_text(x+4, y+1+str_height*(lines_notify_current-1-j), texts[i]);
						j++;
					}
				}
				notify_timer--;
				draw_set_color(c_white);
				draw_set_alpha(1);
			}
		}
	}

	echo_ext = function(msg, color, notify=false, write=false) {
		var arg0, m, col, r;
		col = color ?? color_echo;
		// Prepare text
		arg0 = string(msg) ?? "<undefined>";
		if string_char_at(arg0, 1) == "\"" and string_char_at(arg0,string_length(arg0)) == "\"" {
			arg0 = string_trim(arg0, "\"");
		}
		r = 1; // Repetition
		if string_length(arg0) > length {
			// Multiline.
			r = ceil(string_length(arg0)/length);
			for (var i=1; i<r; i++;) {
				arg0 = string_insert(chr(13), arg0, length*i+i+1);
			}
		}

		// Parse multiline to multi echo.
		if string_count(chr(13),arg0) > 0 or string_count("\n", arg0) > 0 {
			var new_str = string_replace_all(arg0, "\\n", "%EscapedNewLine%");
			new_str = string_replace_all(new_str, "\n", chr(13));
			new_str = string_replace_all(new_str, "%EscapedNewLine%", "\\n");
			var a = string_split(new_str, chr(13));
			for (var i=0; i<array_length(a); i++;) {
				for (m=lines_max-1; m>0; m--;) {
					texts[m] = texts[m-1];
					texts_color[m] = texts_color[m-1];
				}
				texts[0] = a[i];
				texts_color[0] = col;
				if scroll_pos > 0 and scroll_pos < lines_count {
				}
			}
		} else {
			for (m=lines_max-1; m>0; m--;) {
				texts[m] = texts[m-1];
				texts_color[m] = texts_color[m-1];
			}
			texts[0] = arg0;
			texts_color[0] = col;
			if scroll_pos > 0 and scroll_pos < lines_count {
				scroll_pos ++;
			}
		}
		
		if notify == true and notify_enabled {
			if lines_notify_current < lines_notify lines_notify_current ++;
			notify_timer = notify_show_time * game_get_speed(gamespeed_fps);
			if not self.visible or self.collapsed notify_state = 1;
		}

		if write {
			log_write(msg, "INFO");
		}

		return arg0;
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
		show_debug_message(msg);
	}
	debug = function(msg) {
		if enabled {
			self.echo_ext(msg, color_debug, false);
			log_write(msg, "DEBUG");
		}
	}
	verbose = function(msg, verbosity) {
		if enabled {
			if KENGINE_VERBOSITY > verbosity {
				self.debug(msg);
				log_write(msg, "DEBUG");
			}
		}
	}
	
	_log_write_dequeue = function() {
		var q = [];
		while ds_queue_size(log_write_queue) > 0 {
			q[array_length(q)] = ds_queue_dequeue(log_write_queue);
		}
		var i=0;
		var _f = file_text_open_append(log_file);
		for (i=0; i<array_length(q); i++) {
			file_text_write_string(_f, q[i]);
			file_text_writeln(_f);
		}
		file_text_close(_f);
		return true;
	}
	
	log_write = function(msg, kind="INFO") {
		if enabled {
			if log_file != false {
				if log_file == true {
					log_file = working_directory + "/" + "kengine.log";
				}

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
					return _log_write_dequeue();
				}

				var q = day+"/"+month+"/"+year+" "+hour+":"+minute+":"+second + " - " + kind + " - "+ string(msg);
				ds_queue_enqueue(log_write_queue, q);
				log_write_timer = 15;
				return true;
			}
		}
	}

	if enabled {
		log_write("Kengine started - " + string(game_project_name), "INFO");
	}
}

function ken_init_ext_panels() {
	
	/**
	 * @name collection
	 * @type {Kengine.Collection}
	 * @memberof Kengine.panels
	 * @description This collection contains all {@link Kengine.panel.Panel} objects created.
	 */
	Kengine.panels.collection = new __KengineCollection();

	Kengine.panels.interact_enabled = true;
	Kengine.panels.draw_enabled = true;

	Kengine.panels.Panel = __KenginePanelsPanel;
	Kengine.panels.PanelItem = __KenginePanelsPanelItem;
	Kengine.panels.PanelItemButton = __KenginePanelsPanelItemButton;
	Kengine.panels.PanelItemInputBox = __KenginePanelsPanelItemInputBox;
	Kengine.panels.Console = __KenginePanelsConsole;
	Kengine.panels.PanelItemGUIElement = __KenginePanelsPanelItemGUIElement;

	// Example
	/*
	var p = new __KenginePanelsPanel({
		x: 200,
		y: 200,
		width: 300,
		height: 300,
		alpha: 0.6,
	});
	var ddiv = new __KenginePanelsPanelItemGUIElement({x: 0, y: 0, value: {
		what: ["indeed", 1, 2, 3],
	}});
	p.add(ddiv);
	*/
}
