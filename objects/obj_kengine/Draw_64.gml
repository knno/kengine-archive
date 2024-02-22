/// @description Panels draw

var p, col = Kengine.panels.collection;
if col != undefined {
	for (var i=0; i<col.length(); i++;) {
		p = col.get(i);
		if Kengine.panels.draw_enabled {if p.draw != undefined p.draw();}
	}
}
