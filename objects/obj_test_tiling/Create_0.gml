// Create a vertex buffer
vertex_buffer = vertex_create_buffer();

grid_width = 5;
grid_height = 5;
tile_size = 16;
grid_tile_size = 16;
tileset_width = sprite_get_width(spr_tiling);
tileset_height = sprite_get_height(spr_tiling);

// Create vertex format
vertex_format_begin()
vertex_format_add_position();
vertex_format_add_color();
vertex_format_add_texcoord();
fmt = vertex_format_end();


var col, t, tx, ty, tu, tv, tu2, tv2;
vertex_begin(vertex_buffer, fmt);
for (var _y = 0; _y < grid_height; _y++) {
    for (var _x = 0; _x < grid_width; _x++) {
		col = c_white;
		t = choose(0,1,2,3,);
		tx = (t) mod (tileset_width/tile_size);
		ty = (t) div (tileset_width/tile_size);
		tu = tx*(tile_size/tileset_width);
		tv = ty*(tile_size/tileset_height);
		tu2 = tu + tile_size/tileset_width;
		tv2 = tv + tile_size/tileset_height;

		vertex_position(vertex_buffer, (_x) * grid_tile_size, (_y) * grid_tile_size);
		vertex_color(vertex_buffer, col, 1);
		vertex_texcoord(vertex_buffer, tu, tv);

		vertex_position(vertex_buffer, (_x+1) * grid_tile_size, (_y) * grid_tile_size);
		vertex_color(vertex_buffer, col, 1);
		vertex_texcoord(vertex_buffer, tu2, tv);

		vertex_position(vertex_buffer, (_x) * grid_tile_size, (_y+1) * grid_tile_size);
		vertex_color(vertex_buffer, col, 1);
		vertex_texcoord(vertex_buffer, tu, tv2);

		vertex_position(vertex_buffer, (_x) * grid_tile_size, (_y+1) * grid_tile_size);
		vertex_color(vertex_buffer, col, 1);
		vertex_texcoord(vertex_buffer, tu, tv2);

		vertex_position(vertex_buffer, (_x+1) * grid_tile_size, (_y) * grid_tile_size);
		vertex_color(vertex_buffer, col, 1);
		vertex_texcoord(vertex_buffer, tu2, tv);

		vertex_position(vertex_buffer, (_x+1) * grid_tile_size, (_y+1) * grid_tile_size);
		vertex_color(vertex_buffer, col, 1);
		vertex_texcoord(vertex_buffer, tu2, tv2);
		
		//show_debug_message("x1 {0}, y1 {1}, x2 {2}, y2 {3}", (_x) * grid_tile_size, (_y) * grid_tile_size,(_x+1) * grid_tile_size, (_y+1) * grid_tile_size);
		//show_debug_message("u1 {0}, v1 {1}, u2 {2}, v2 {3}", tu, tv, tu2, tv2);
	}
}
vertex_end(vertex_buffer);


tile_type_to_color = [
	c_red, c_yellow, c_green, c_blue,
];
// Create a surface to sample
surface = surface_create(grid_width * tile_size, grid_height * tile_size);
surface_set_target(surface);
draw_clear_alpha(c_black, 0);
for (var _x = 0; _x < grid_width; _x++) {
    for (var _y = 0; _y < grid_height; _y++) {
        var tile_type = choose(0,1,2,3); // choose_tile_type(_x, _y);
        draw_set_color(c_white); 
        draw_rectangle(_x * tile_size, _y * tile_size, (_x + 1) * tile_size, (_y + 1) * tile_size, false);
    }
}
surface_reset_target();

// Create a surface to sample the tileset texture
tileset_surface = surface_create(tileset_width, tileset_height);
surface_set_target(tileset_surface);
draw_clear_alpha(c_black, 0);
draw_sprite(spr_tiling, 0, 0, 0);
surface_reset_target();
