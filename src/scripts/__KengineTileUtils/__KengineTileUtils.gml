/**
 * @namespace Tiles
 * @memberof Kengine.Utils
 * @description A struct containing Kengine tiles, tilesets and tilemaps utilitiy functions
 *
 */
function __KengineTileUtils() : __KengineStruct() constructor {

	static tilemaps = [];
	
	static mask = tilemap_get_global_mask(); // 2147483647
	static shader = sh_tiling;
	static shader_tileset_sampler_index = shader_get_sampler_index(shader, "u_TilesetSampler");

	__CreateVertexFormat = function() {
		vertex_format_begin()
		vertex_format_add_position();
		vertex_format_add_color();
		vertex_format_add_texcoord();
		var _fmt = vertex_format_end();
		return _fmt;
	}

	static vertex_format = undefined;
	vertex_format = __CreateVertexFormat();

	static GetMaskValue = function (tileset_asset) {
		if is_instanceof(tileset_asset, __KengineTilemap) {
			tileset_asset = tileset_asset.tileset;
		}
		var _tile_count = tileset_asset.tile_count;
	    return power(2, ceil(log2(_tile_count)));
	}

	static SetupTilemapSolidMask = function (tilemap) {
	    var count = __KengineTileUtils.GetMaskValue(tilemap.tileset);
	    tilemap.SetMask(tile_mirror | tile_flip | tile_rotate | (count - 1));
	    var bitoffset = -1;
	    while (floor(count) > 0) {
	        count = count * 0.5;
	        bitoffset += 1;
	    }
	    return bitoffset;
	}

	static TileGetSolid = function (data, bitoffset) {
		return (data >> bitoffset) & 1;
	}

	static TileGetIndex = function(data) {
		return (data & tile_index_mask);
	}
}
