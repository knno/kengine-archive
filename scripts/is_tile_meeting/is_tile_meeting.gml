/**
 * @function is_tile_meeting
 * @description	Return whether tile is met by a rectangle.
 * @param {String} tile_layer Tile layer.
 * @param {Array<Real>|Real} tiles The tile index or an array of tile indices.
 * @param {Real} x1 The top left x of the rectangle to be checked.
 * @param {Real} y1 The top left y of the rectangle to be checked.
 * @param {Real} x2 The bottom right x of the rectangle to be checked.
 * @param {Real} y2 The bottom right y of the rectangle to be checked.
 * @return {Bool}
 *
 */

function is_tile_meeting(tile_layer, tiles, x1,y1,x2,y2) {
	var _layer = tile_layer;
	var tm = layer_tilemap_get_id(_layer);
	var tile = undefined;

	if (!tm) {
		return false;
	}
	var _x1 = tilemap_get_cell_x_at_pixel(tm, x1, y1), // bbox_left + (_x - x), y
	    _y1 = tilemap_get_cell_y_at_pixel(tm, x1, y1), // x, bbox_top + (_y - y)
	    _x2 = tilemap_get_cell_x_at_pixel(tm, x2, y2), // bbox_right + (_x - x), y
	    _y2 = tilemap_get_cell_y_at_pixel(tm, x2, y2); // x, bbox_bottom + (_y - y)

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