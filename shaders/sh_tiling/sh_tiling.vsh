attribute vec2 in_Position;                  // (x,y)
attribute vec4 in_Colour;                    // (r,g,b,a)
//attribute vec3 in_Normal;                  // (x,y,z)     unused in this shader.
attribute vec2 in_TileCoord;				 // (u,v)

varying vec4 v_vColour;
varying vec2 v_vTileCoord;

void main() {
    vec4 object_space_pos = vec4( in_Position.x, in_Position.y, 0.0, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    v_vColour = in_Colour;
    v_vTileCoord = in_TileCoord;
}
