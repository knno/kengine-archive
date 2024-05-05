/**
 * @function __KenginePanelsPanelItemDbgElement
 * @private
 * @memberof Kengine.Extensions.Panels
 * @description A base panel item that represents a debug element to draw. This is for watching variables.
 * @param {String} type
 * @param {String} value
 * @param {String} class
 * @param {Real} _padding
 * @param {Real} lvl
 * @param {Undefined|Array<Any>} _children
 * 
 */
function __KenginePanelsPanelItemDbgElement(type="div", value="", class="", _padding=32, lvl=0, _children=undefined) : __KenginePanelsPanelItem() constructor {

	self.value = value
	self.type = type
	self.class = class
	self.padding = _padding
	self.lvl = lvl
	self.children = _children ?? [];
	self.x = 0;
	self.y = 0;

	self.valueprevious = self.value

	hover = false

	__SetElementVisibility = function(element, visibility) {
		if is_array(element.children) {
			for (var _i=0; _i<array_length(element.children); _i++) {
				element.children[_i].visible = visibility;
			}
		}
		element.visible = visibility;
	}

	__ToggleElement = function(element) {
		var _i = array_find_index(element.parent.children, method({element}, function (val) {
			return val == element;
		}));
		var _lvl = element.lvl;
		if element.toggled {
			element.value = "►";
			for (var _j=_i+1; _j<array_length(element.parent.children); _j++) {
				if element.parent.children[_j].type == "br" break;
				__SetElementVisibility(element.parent.children[_j], false);
				if element.parent.children[_j].class == "arrow" {
					__ToggleElement(element.parent.children[_j]);
				}
			}
		} else {
			element.value = "▼";
			for (var _j=_i+1; _j<array_length(element.parent.children); _j++) {
				if element.parent.children[_j].type == "br" break;
				__SetElementVisibility(element.parent.children[_j], true);
				if element.parent.children[_j].class == "arrow" {
					__ToggleElement(element.parent.children[_j]);
				}
			}
		}
		element.toggled = not element.toggled;
	}

	__DrawChild = function(element, _x, _y, x1,y1,x2,y2) {
		var _c = draw_get_color()
		var _ele
		var _uv
		var _u = _x
		var _v = _y
		var _w = 0, _h = 0
		var _mu = 0, _mv = 0;

		var _mouse_x = device_mouse_x_to_gui(0);
		var _mouse_y = device_mouse_y_to_gui(0);
		var _u0 = _u;
		if array_length(element.children) > 0 {
			for (var _i = 0; _i < array_length(element.children); _i++) {
				_ele = element.children[_i];
				if _ele.visible {
					if _ele.class == "arrow" {
						draw_set_color(_ele.hover ? $DD9900 : _c);
					} else {
						draw_set_color(_c);
					}
					if _ele.type == "div" {
						_u = _u0;
					}
					_uv = __DrawChild(_ele, _u + self.padding, _v, x1,y1,x2,y2)
					_u = _uv[0] - self.padding; _v = _uv[1]
					_mu = max(_mu, _uv[2]);
					_mv = max(_mv, _uv[3]);

					draw_set_color(_c)
					if _ele.type == "br" or _ele.type == "div" {
						if _ele.value != "" {
							_h = string_height(_ele.value)
							_v += _h
						} else {
							_u = _u0
						}
					}
					if _ele.class == "arrow" and !_ele.toggled {
						_h = string_height(_ele.value);
						_v += _h;
					}
					if _ele.class == "extra" {
						_h = string_height(_ele.value);
						_v += _h;						
						_u = _u0;
					}
					if _ele.value != "\n" and _ele.value != "\\n" {
						_w = string_width(_ele.value);
						_u += _w
					} else {
						_u = _u0;
					}
					_mu = max(_mu, _u);
					_mv = max(_mv, _v);
				}
			}
			_mu = max(_mu, _u);
			_mv = max(_mv, _v);
			_u = _u0;
		} else {
			if element.visible {
				_w = string_width(element.value);
				_h = string_height(element.value);
				element.hover = false;
				if (_mouse_x >= _u && _mouse_x <= _u + _w && _mouse_y >= _v && _mouse_y <= _v + _h) {
					element.hover = true;
					if mouse_check_button_pressed(mb_left) {
						if element.class == "arrow" {
							__ToggleElement(element);
							mouse_clear(mb_left);
						}
					}
				}
				if element.class == "arrow" {
					draw_set_color(element.hover ? $DD9900: element.color);
				} else {
					draw_set_color(element.color);
				}
				if _u >= x1 and _v >= y1 and _u + _w < x2 and _v + _h < y2 {
					draw_text(_u, _v, string(element.value));
				}
				_mu = max(_mu, _u);
				_mv = max(_mv, _v);
				_u = _u0;
				if element.class == "arrow" {
					if not element.toggled {
						var _i = array_find_index(element.parent.children, method({element}, function (val) {
							return val == element;
						}))
						var _is = false
						for (var _j=_i+1; _j<array_length(element.parent.children); _j++) {
							if element.parent.children[_j].class == "nested" {
								_is = true
								break
							}
							if element.parent.children[_j].type == "br" break
						}
						if _is {
							_v += _h
							_u -= _w
						}
					}
				}
				_mu = max(_mu, _u);
				_mv = max(_mv, _v);
			}
		}
		element.width = _mu + _w;
		element.height = _mv + _h;
		return [_u, _v, element.width, element.height]
	}

	Draw = function () {
		draw_set_font(font);
		draw_set_valign(fa_top);
		draw_set_halign(fa_left);
		draw_set_alpha(alpha);
		var _u = parent.x + parent.content_x + x;
		var _v = parent.y + parent.content_y + y + parent.collapse_height;
		var _u0 = _u;
		var _v0 = _v;
		var _mu = 0;
		var _mv = 0;
		var _ele, _c, _w,_h, _uv;
		_w = 0; _h = 0;
		_c = draw_get_color();

		if is_array(self.children) {
			for (var _i = 0; _i < array_length(self.children); _i++) {
				_ele = self.children[_i];
				if _ele.visible {
					if _ele.class == "arrow" {
						draw_set_color(_ele.hover ? $DD9900 : _c);
					} else {
						draw_set_color(_c);
					}
					if _ele.type == "div" {
						_mu = max(_mu, _u);
						_u = _u0;
					}
					_uv = __DrawChild(_ele, _u + self.padding, _v + self.padding, parent.x, parent.y + parent.collapse_height, parent.x + parent.width, parent.y + parent.height - parent.collapse_height);
					_u = _uv[0] - self.padding; _v = _uv[1] - self.padding;
					_mu = max(_mu, _uv[2]);
					_mv = max(_mv, _uv[3]);

					draw_set_color(_c);
					if _ele.type == "br" or _ele.type == "div" {
						if _ele.value != "" {
							_h = string_height(_ele.value);
							_v += _h;
							_mv = max(_mv, _v);
						} else {
							_mu = max(_mu, _u);
							_u = _u0;
						}
					}
					if _ele.class == "arrow" and !_ele.toggled {
						_h = string_height(_ele.value);
						_v += _h;
						_mv = max(_mv, _v);
					}
					if _ele.class == "extra" {
						_h = string_height(_ele.value);
						_v += _h
						_mv = max(_mv, _v);

						_mu = max(_mu, _u);
						_u = _u0
					}
					if !is_struct(_ele.value) {
						if _ele.value != "\n" and _ele.value != "\\n" {
							_w = string_width(_ele.value);
							_u += _w
							_mu = max(_mu, _u);
						} else {
							_mu = max(_mu, _u);
							_u = _u0
						}
					}
				}
			}
			_mu = max(_mu, _u);
			_mv = max(_mv, _v);
		}

		self.width = _mu - parent.x;
		self.height = _mv - parent.y;
	}

	__CreateLayout = function(obj, par=undefined) {
		if obj == "" return;

		par = par ?? self;
		var _created_arrow = false;
		var _span;
		var _br;
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
				_extra = par==undefined ? "" : " ";
				break;

			case "array":
				_arrow = true;
				_is_struct = false;
				_array = obj;
				_extra = string("[{0}]", array_length(obj));
				break;
				
			default:
				_span = new __KenginePanelsPanelItemDbgElement("span", (!_created_arrow ? " " : "") + string(obj))
				if string_pos("function", string_trim_start(_span.value)) == 1 {
					_span.color = c_gray;
				}
				_span.parent = par;
				array_push(par.children, _span);

				_br = new __KenginePanelsPanelItemDbgElement("br", "\n")
				_br.parent = par;
				array_push(par.children, _br);

				return;
		}
		
		if _arrow {
			_span = new __KenginePanelsPanelItemDbgElement("span", "▼", "arrow");
			_span.parent = par;
			_span.color = c_gray;
			_span.toggled = true;
			array_push(par.children, _span); // index 0
			_created_arrow = _span;
		}
		
		if _extra != "" {
			_span = new __KenginePanelsPanelItemDbgElement("span", _extra, "extra");
			_span.parent = par;
			_span.color = c_gray;
			array_push(par.children, _span);
		}

		var _n, _v, _p;

		var _pcreated = false;

		for (var _i=0; _i<array_length(_array); _i++) {
			if _is_struct {
				_n = _array[_i];
				_v = obj[$ _n];
				_p = new __KenginePanelsPanelItemDbgElement("div", "", "nested")
				_p.parent = par;
				array_push(par.children, _p);
			} else {
				_n = "";
				_v = obj[_i];
				_p = new __KenginePanelsPanelItemDbgElement("div", "", "nested")
				_p.parent = par;
				array_push(par.children, _p);
			}

			if _n != "" {
				_span = new __KenginePanelsPanelItemDbgElement("span", _n + ": ", "def")
				_p.parent = _p;
				_p.color = c_gray;
				array_push(_p.children, _span);
			}
			_created_arrow = false;
			__CreateLayout(_v, _p);
		}
		_br = new __KenginePanelsPanelItemDbgElement("br", "");
		_br.parent = par;
		array_push(par.children, _br);
	}

	Step = function() {
		if self.value != self.valueprevious {
			__CreateLayout(self.value);
			self.valueprevious = self.value;
		}
	}

	__StepMouse = function(element, _x, _y) {
		var _ele;
		var _uv;
		var _u = _x + parent.content_x;
		var _v = _y + parent.content_y;
		var _u0 = _u;
		var _x1, _y1;
		var _w = 0, _h = 0;
		var _mx, _my;
		var _i;

		var _mouse_x = device_mouse_x_to_gui(0);
		var _mouse_y = device_mouse_y_to_gui(0);
		_mx = _mouse_x;
		_my = _mouse_y;

		if element.visible {
			_ele = element;
			
			if is_array(_ele.children) {
				if array_length(_ele.children) > 0 {
					for (var _j=0; _j<array_length(element.children); _j++) {
						_ele = element.children[_j];
						if _ele.visible {
							if _ele.type == "div" {
								_u = _u0
							}
							_x1 = _u;
							_y1 = _v;
							_w = string_width(_ele.value);
							_h = string_height(_ele.value);
							_ele.hover = false;
						
							_uv = __StepMouse(_ele, _u, _v);
							_u = _uv[0]; _v = _uv[1];

							if _ele.type == "br" or _ele.type == "div" {
								if _ele.value != "" {
									_h = string_height(_ele.value);
									_v += _h;
								} else {
									_u = _u0;
								}
							}
							if _ele.class == "arrow" and !_ele.toggled {
								_h = string_height(_ele.value);
								_v += _h;
							}
							if _ele.class == "extra" {
								_h = string_height(_ele.value);
								_v += _h;						
								_u = _u0;
							}
							if _ele.value != "\n" {
								_u += string_width(_ele.value);
							} else {
								_u = _u0;
							}
						}
					}
				} else if array_length(_ele.children) == 0 {
					_x1 = _u
					_y1 = _v
					_w = string_width(_ele.value);
					_h = string_height(_ele.value);
					_ele.hover = false;
					if (_mx >= _x1 && _mx <= _x1 + _w && _my >= _y1 && _my <= _y1 + _h) {
						_ele.hover = true;
						if mouse_check_button_pressed(mb_left) {
							if _ele.class == "arrow" {
								_i = array_find_index(_ele.parent.children, method({ele: _ele}, function (val) {
									return val == ele;
								}));
								if _ele.toggled {
									__SetElementVisibility(_ele.parent.children[_i + 4], false);
								} else {
									__SetElementVisibility(_ele.parent.children[_i + 4], true);
								}
								_ele.toggled = not _ele.toggled;
							}
						}
					}
				}
			}
		}
		return [_u, _v];
	}

	if self.type == "div" { __CreateLayout(self.value); }
}
