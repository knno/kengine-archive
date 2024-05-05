/// @description Insert description here
// You can write your code in this editor

if Kengine.status == "READY" {
	if sprite_index != spr_ken_logo {
		sprite_index = spr_ken_logo;
	}
}

var spw = sprite_get_width(spr_ken_logo);

draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,0,c_white,1);
draw_set_color(c_white);
draw_set_valign(fa_middle);
draw_set_halign(fa_center)
draw_text(x, bbox_bottom + 20, Kengine.status);

draw_set_color(c_gray);
for (var _i=0;_i<array_length(Kengine.coroutines); _i++) {
	draw_text(x, bbox_bottom + 20 + 20 + _i*16, Kengine.coroutines[_i].name + ": " + (Kengine.coroutines[_i].status == KENGINE_COROUTINES_STATUS.RUNNING ? "RUNNING" : (Kengine.coroutines[_i].status == KENGINE_COROUTINES_STATUS.DONE ? "DONE" : "IDLE")));
}
draw_set_valign(fa_top);
draw_set_halign(fa_left)
draw_set_color(c_white);
