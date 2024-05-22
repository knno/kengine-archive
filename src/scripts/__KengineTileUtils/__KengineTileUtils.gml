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

	/**
	 * @name vertex_format
	 * @memberof Kengine.Utils.Tiles
	 * @type {Id.VertexFormat}
	 * @description The vertex format for Kengine tileset system.
	 *
	 */
	static vertex_format = undefined;
	vertex_format = __CreateVertexFormat();

	/**
	 * @function GetMaskValue
	 * @memberof Kengine.Utils.Tiles
	 * @param {Kengine.Tilemap|Kengine.Asset} tileset_asset
	 * @description Returns the mask value for a tileset asset.
	 *
	 */
	static GetMaskValue = function (tileset_asset) {
		if is_instanceof(tileset_asset, __KengineTilemap) {
			tileset_asset = tileset_asset.tileset;
		}
		var _tile_count = tileset_asset.tile_count;
	    return power(2, ceil(log2(_tile_count)));
	}

	/**
	 * @function SetupTilemapSolidMask
	 * @memberof Kengine.Utils.Tiles
	 * @param {Kengine.Tilemap} tilemap The tilemap
	 * @description Sets up a bit value and return the offset in the mask for a tilemap.
	 * @return {Real}
	 *
	 */
	static SetupTilemapSolidMask = function (tilemap) {
	    var count = __KengineTileUtils.GetMaskValue(tilemap.tileset);
		/// feather ignore GM1044
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

	static __CreateTilemap = function(asset, tiledata, _x, _y, width, height, depth) {
		var _tilemap_object = instance_create_depth(0,0,depth, obj_ken_tilemap);
		_tilemap_object.tilemap = new __KengineTilemap(asset, tiledata, _x, _y, width, height);
		_tilemap_object.tilemap.Rebuild();
		return _tilemap_object;
	}
}
