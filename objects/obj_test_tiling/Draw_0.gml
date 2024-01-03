var shader = sh_tiling;
var shindex = shader_get_sampler_index(shader, "u_TilesetSampler");


shader_set(shader);
texture_set_stage(shindex, surface_get_texture(tileset_surface));
//var mat = matrix_build(x, y, 0, 0, 0, 0, 1, 1, 1);
//matrix_set(matrix_world, mat);
vertex_submit(vertex_buffer, pr_trianglelist, surface_get_texture(surface));
//matrix_set(matrix_world, matrix_build_identity());
shader_reset();
