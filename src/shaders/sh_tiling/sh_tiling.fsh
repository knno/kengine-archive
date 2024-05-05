varying vec2 v_vTileCoord;
varying vec4 v_vColour;
uniform sampler2D u_TilesetSampler;

void main() {
    vec4 tileset_color = texture2D(u_TilesetSampler, v_vTileCoord);
    gl_FragColor = v_vColour * tileset_color;
}
