function __KenginePanels() : __KengineStruct() constructor {
	static name = "Panels";

    static focused_panel = undefined;
    static interact_enabled = true;
    static draw_enabled = true;
    static __input_histories = [];

	static __scrollbar_timer = 0
	static __scrollbar_drag = -1
	static __scrollbar_mxprev = -1
	static __scrollbar_myprev = -1
	static __scrollbar_current = undefined

    static panels = new __KengineCollection();

    static PanelOptions = __KenginePanelsPanelOptions;
    static Panel = __KenginePanelsPanel;

    static PanelItem = __KenginePanelsPanelItem;
    static PanelItemInputBox = __KenginePanelsPanelItemInputBox;
    static Console = __KenginePanelsConsole;
	static Scrollbar = __KenginePanelsScrollbar;

	static DrawGui = function() {
		var _p;
		var panels = __KenginePanels.panels;
		if panels != undefined {
			for (var _i=0; _i<panels.Length(); _i++) {
				_p = panels.Get(_i);
				if __KenginePanels.draw_enabled {if _p.Draw != undefined _p.Draw();}
			}
		}
	}

	static Step = function() {
		var panels = __KenginePanels.panels;
		if panels != undefined {
			var _p;
			var _j = undefined, _l = undefined;

			for (var _i=0; _i<panels.Length(); _i++) {
				_p = panels.Get(_i);
				if _p = Kengine.console continue;

				if __KenginePanels.interact_enabled {if _p.Step != undefined _p.Step();}
				if _p.focus_enabled and _p.__is_focused _j = _p;
			}
			Kengine.console.Step();

			if __KenginePanels.focused_panel != undefined {
				if not __KenginePanels.focused_panel.focus_enabled {
					__KenginePanels.focused_panel = undefined;
				}
			}

			if _j == undefined __KenginePanels.focused_panel = undefined;
		}
		
		if Kengine.status == "READY" {
			/*if Kengine.watcher == undefined {
				var parElement = new __KenginePanelsPanelItemDbgElement("div");
				var status = new __KenginePanelsPanelItemDbgElement("span", Kengine.status);
				status.color = c_aqua;
				var _br = new __KenginePanelsPanelItemDbgElement("br", "\n")
				var item = new __KenginePanelsPanelItemDbgElement("div", {
					//Extensions: Kengine.Extensions,
					//Utils: Kengine.Utils,
					instances: Kengine.instances.__all,
					asset_types: struct_get_names(Kengine.asset_types),
				});
				array_push(parElement.children, status, _br, item);
				Kengine.watcher = new Kengine.Extensions.Panels.Panel({
					title: "Watcher",
					x: 0,
					y: 0,
					height: 350,
					width: 300,
					children: [parElement]
				});
				Kengine.watcher.add = function(watch) {
				}
			}*/
		}

	}
}

function ken_init_ext_panels() {
    #region Error types
    #endregion

    #region Events
    #endregion

    var _panels = new __KenginePanels();


	var __StartConsole = function() {
		var _console_options = {
			alpha: 0.8, focus_enabled: false,
		}
		_console_options.log_file = KENGINE_CONSOLE_LOG_FILE
		_console_options.log_enabled = KENGINE_CONSOLE_LOG_ENABLED
		var _console = new __KenginePanelsConsole(_console_options);

		var _inputbox = new __KenginePanelsPanelItemInputBox({
			x: 0, y: _console.height, width: _console.width, height: 25,
			readonly: false, active: true, visible: true, value: "",
			valign: fa_top, autoc_enabled: true, history_enabled: true,
			background: _console.box_colors[0], alpha: _console.alpha,
			focus_enabled: false,
		})
		_console.__Add(_inputbox);
		_console.inputbox = _inputbox;
		return _console;
	}


	if KENGINE_CONSOLE_ENABLED {
		Kengine.console = __StartConsole()
		obj_kengine.console = Kengine.console

		// Manage backlog.
		var _console_backlog = Kengine.__console_backlog;
		var _col;
		for (var _i=0; _i<array_length(_console_backlog); _i++) {
			switch (_console_backlog[_i].kind) {
				case "echo_error":
					Kengine.console.echo_error(_console_backlog[_i].msg);
					break;
				case "echo_ext":
					switch (string_lower(_console_backlog[_i].color)) {
						case "debug":
							_col = Kengine.console.color_debug; break;
						case "echo":
							_col = Kengine.console.color_echo; break;
						case "error":
							_col = Kengine.console.color_error; break;
						default:
							_col = _console_backlog[_i].color;
							break;
					}
					Kengine.console.echo_ext(_console_backlog[_i].msg, _col, _console_backlog[_i].notify, _console_backlog[_i].write);
					break;
				case "echo":
					Kengine.console.echo(_console_backlog[_i].msg);
					break;
				case "debug":
					Kengine.console.debug(_console_backlog[_i].msg);
					break;
				case "verbose":
					Kengine.console.verbose(_console_backlog[_i].msg, _console_backlog[_i].verbosity);
					break;
			}
		}
	}

	Kengine.Extensions.Add(_panels);
}