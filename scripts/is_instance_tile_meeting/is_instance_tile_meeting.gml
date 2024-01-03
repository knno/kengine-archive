/**
 * @function is_instance_tile_meeting
 * @description	Return whether tile is met by the instance's bounding box rectangle.
 * @param {String} tile_layer Tile layer.
 * @param {Array<Real>|Real} tiles The tile index or an array of tile indices.
 * @param {Id.Instance} inst The instance of which rectangle to be checked.
 * @param {Real} [xoffset] The X offset to be checked, from the instance's X position. Defaults to 0.
 * @param {Real} [yoffset] The Y offset to be checked, from the instance's Y position. Defaults to 0.
 * @memberof Kengine.fn.tiles
 * @return {Bool}
 *
 */
function is_instance_tile_meeting(tile_layer, tiles, inst, xoffset=0, yoffset=0) {
	var _layer = tile_layer;
	var tm = layer_tilemap_get_id(_layer);
	var tile = undefined;

	if (!tm) {
		return false;
	}
	var _x1 = tilemap_get_cell_x_at_pixel(tm, inst.bbox_left + xoffset, inst.y),
	    _y1 = tilemap_get_cell_y_at_pixel(tm, inst.x, inst.bbox_top + yoffset),
	    _x2 = tilemap_get_cell_x_at_pixel(tm, inst.bbox_right + xoffset, inst.y),
	    _y2 = tilemap_get_cell_y_at_pixel(tm, inst.x, inst.bbox_bottom + yoffset);

	for(var _x = _x1; _x <= _x2; _x++){
	  for(var _y = _y1; _y <= _y2; _y++){
		var _tilemap = tilemap_get(tm, _x, _y);
		if (_tilemap) {
			tile = tile_get_index(_tilemap)
		    if(tile){
			  if is_array(tiles) {
				  if array_find_index(tiles, tile) != -1 {
					  return true;
				  }
			  } else {
				 return true; 
			  }
			  return true;
		    }
		}
	  }
	}
	return false;
}