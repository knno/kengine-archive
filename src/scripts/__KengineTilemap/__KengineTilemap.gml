/**
 * @function Tilemap
 * @memberof Kengine
 * @new_name Kengine.Tilemap
 * @param {Kengine.Asset} tileset
 * @param {Id.Buffer|Array} tiledata A buffer of type s32 or array which has the indices of tiles.
 * @description A tilemap representation to replicate internal tilemaps behavior.
 *
 */
function __KengineTilemap(tileset, tiledata, _x, _y, width, height) constructor {
	self.tileset = tileset;
	self.frame = 0;
	self.__frame = 0;
	self.frame_count = tileset.frame_count;

	self.vertex_buffers = [];

	if is_array(tiledata) {
		var _total = array_length(tiledata);
		self.buffer = buffer_create(4*_total, buffer_fixed, 4);
		for (var _i=0; _i<_total; _i++) {
			buffer_write(self.buffer, buffer_s32, tiledata[_i]);
		}

	} else {
		self.buffer = tiledata; // data of buffer_s32 : ind = 0,1,2....
	}

	self.__lastbuild = undefined;

	var _tilepotcount = __KengineTileUtils.GetMaskValue(self.tileset);

	/// feather ignore GM1044
	/**
	 * @name mask
	 * @type {Constant.TileMask|Real}
	 * @memberof Kengine.Tilemap
	 *
	 */
	self.mask = tile_mirror | tile_flip | tile_rotate | (_tilepotcount - 1);

	self.x = _x;
	self.y = _y;
	self.width = width; // cells
	self.height = height; // cells
	self.tile_width = tileset.tile_width; // pixels
	self.tile_height = tileset.tile_height; // pixels

	GetX = function() { return self.x; }
	GetY = function() { return self.y; }
	SetX = function(x) { self.x = x; }
	SetY = function(y) { self.y = y; }

	GetWidth = function() { return self.width; }
	GetHeight = function() { return self.height; }
	SetWidth = function(width) { self.width = width; }
	SetHeight = function(height) { self.height = height; }

	GetTileWidth = function() { return self.tile_width; }
	GetTileHeight = function() { return self.tile_height; }
	SetTileWidth = function(tile_width) { self.tile_width = tile_width; }
	SetTileHeight = function(tile_height) { self.tile_height = tile_height; }

	GetRows = GetWidth;
	GetColumns = GetHeight;

	/**
	 * @function SetMask
	 * @memberof Kengine.Tilemap
	 * @description Sets the mask for the tilemap.
	 * @param {Constant.TileMask|Real} mask
	 *
	 */
	SetMask = function(mask) {
		self.mask = mask;
	}

	GetMask = function() {
		return self.mask;
	}

	__Draw = function() {
		shader_set(__KengineTileUtils.shader);
		texture_set_stage(__KengineTileUtils.shader_tileset_sampler_index, self.tileset.GetTexture());
		vertex_submit(self.vertex_buffers[self.frame], pr_trianglelist, -1);
		shader_reset();
	}

	Rebuild = function() {
		var grid_width = self.width;
		var grid_height = self.height;
		var tile_width = self.tile_width;
		var tile_height = self.tile_height;
		var tileset_width = self.tileset.sprite.GetWidth();
		var tileset_height = self.tileset.sprite.GetHeight();
		var frame_count = self.frame_count;

		if self.__lastbuild != undefined {
			if grid_width == self.__lastbuild.grid_width 
			and grid_height == self.__lastbuild.grid_height
			and tile_width == self.__lastbuild.tile_width
			and tile_height == self.__lastbuild.tile_height
			and tileset_width == self.__lastbuild.tileset_width
			and tileset_height == self.__lastbuild.tileset_height 
			and frame_count == self.frame_count {
				return;
			}
		}

		self.__lastbuild = {
			grid_width,
			grid_height,
			tile_width,
			tile_height,
			tileset_width,
			tileset_height,
			frame_count,
		}

		for (var _i=0; _i<array_length(self.vertex_buffers); _i++) {
			if (self.vertex_buffers[_i] != undefined) {
				try {
					vertex_delete_buffer(self.vertex_buffers[_i]);
				} catch (e) {
					//
				}
			}
		}

		var fmt = __KengineTileUtils.vertex_format;

		var col, t, tx, ty, tu, tv, tu2, tv2, data, v;
		for (var _i=0; _i<frame_count; _i++) {
			var vertex_buffer = vertex_create_buffer();
			vertex_begin(vertex_buffer, fmt);
			buffer_seek(self.buffer, buffer_seek_start, 0);
			for (var _y = 0; _y < grid_height; _y++) {
				for (var _x = 0; _x < grid_width; _x++) {
					col = c_white;

					try {
						v = buffer_read(self.buffer, buffer_s32);
					}
					catch (e) {
						break;
					}

					t = __KengineTileUtils.TileGetIndex(v);
					t = self.tileset.GetFrameIndex(t, _i);

					tx = (t) mod (tileset_width/tile_width);
					ty = (t) div (tileset_width/tile_height);
					tu = tx*(tile_width/tileset_width);
					tv = ty*(tile_height/tileset_height);
					tu2 = tu + tile_width/tileset_width;
					tv2 = tv + tile_height/tileset_height;

					vertex_position(vertex_buffer, (_x) * tile_width, (_y) * tile_height);
					vertex_color(vertex_buffer, col, 1);
					vertex_texcoord(vertex_buffer, tu, tv);

					vertex_position(vertex_buffer, (_x+1) * tile_width, (_y) * tile_height);
					vertex_color(vertex_buffer, col, 1);
					vertex_texcoord(vertex_buffer, tu2, tv);

					vertex_position(vertex_buffer, (_x) * tile_width, (_y+1) * tile_height);
					vertex_color(vertex_buffer, col, 1);
					vertex_texcoord(vertex_buffer, tu, tv2);

					vertex_position(vertex_buffer, (_x) * tile_width, (_y+1) * tile_height);
					vertex_color(vertex_buffer, col, 1);
					vertex_texcoord(vertex_buffer, tu, tv2);

					vertex_position(vertex_buffer, (_x+1) * tile_width, (_y) * tile_height);
					vertex_color(vertex_buffer, col, 1);
					vertex_texcoord(vertex_buffer, tu2, tv);

					vertex_position(vertex_buffer, (_x+1) * tile_width, (_y+1) * tile_height);
					vertex_color(vertex_buffer, col, 1);
					vertex_texcoord(vertex_buffer, tu2, tv2);
				}
			}
			vertex_end(vertex_buffer);
			vertex_freeze(vertex_buffer);
			self.vertex_buffers[_i] = vertex_buffer;
		}
	}

	__Step = function() {
		self.x = other.x;
		self.y = other.y;

		self.__frame += self.tileset.fps/game_get_speed(gamespeed_fps);
		self.frame = floor(self.__frame);
		if self.frame >= self.frame_count {
			self.frame = 0;
			self.__frame = 0;
		}
	}
}
