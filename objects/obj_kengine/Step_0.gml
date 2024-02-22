/// @description General Step functions

#region Kengine.debug


#endregion Kengine.debug


#region Kengine.spinner
Kengine.utils.ascii.__current_braille_timer++;
if Kengine.utils.ascii.__current_braille_timer > 5 {
	Kengine.utils.ascii.__current_braille_timer = 0;
	switch (Kengine.utils.ascii.__current_braille) {
		case "⠁": Kengine.utils.ascii.__current_braille = "⠂"; break;
		case "⠂": Kengine.utils.ascii.__current_braille = "⠄"; break;
		case "⠄": Kengine.utils.ascii.__current_braille = "⡀"; break;
		case "⡀": Kengine.utils.ascii.__current_braille = "⢀"; break;
		case "⢀": Kengine.utils.ascii.__current_braille = "⠠"; break;
		case "⠠": Kengine.utils.ascii.__current_braille = "⠐"; break;
		case "⠐": Kengine.utils.ascii.__current_braille = "⠈"; break;
		default: Kengine.utils.ascii.__current_braille = "⠁"; break;
	}
}

Kengine.utils.ascii.__current_spinner_timer++;
if Kengine.utils.ascii.__current_spinner_timer > 5 {
	Kengine.utils.ascii.__current_spinner_timer = 0;
	switch (Kengine.utils.ascii.__current_spinner) {
		case "◴": Kengine.utils.ascii.__current_spinner = "◷"; break;
		case "◷": Kengine.utils.ascii.__current_spinner = "◶"; break;
		case "◶": Kengine.utils.ascii.__current_spinner = "◵"; break;
		default: Kengine.utils.ascii.__current_spinner = "◴"; break;
	}
}
#endregion Kengine.spinner


#region Kengine.tests
if Kengine.tests != undefined {
	if (Kengine.tests.test_manager != undefined) {
		if (Kengine.tests.test_manager.step_enabled) {
				Kengine.tests.test_manager.step();
		}
	}
}
#endregion Kengine.tests


#region Kengine.panels
var p;

var j = 0, l = undefined, col = Kengine.panels.collection;
if col != undefined {
	for (var i=0; i<col.length(); i++;) {
		p = col.get(i);
		if j == 2 {
			Kengine.panels.focused = undefined;
			break;
		}
		if not p.is_focused {
			continue;
		}
		j += 1;
		l = p;
	}
	if j == 1 and l != undefined {
		Kengine.panels.focused = l;
	}


	for (var i=0; i<col.length(); i++;) {
		p = col.get(i);
		if Kengine.panels.interact_enabled {if p.step != undefined p.step();}
	}
}
#endregion Kengine.panels
