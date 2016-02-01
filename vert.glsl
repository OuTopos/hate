attribute float z;
uniform vec2 camera_position = vec2(0.0, 0.0);
uniform vec2 parallax_offset = vec2(0.0, 0.0);
varying vec4 vpos;
varying vec4 apa;

vec4 position( mat4 transform_projection, vec4 vertex_position )
{
	apa = vec4(vertex_position.x + z, vertex_position.y, vertex_position.z, vertex_position.w);
	vpos = transform_projection * apa;
	//vpos.x = vpos.x + ZPosition;
	//vpos.y = vpos.y / ((-vpos.z * -1) - vpos.y);
	//VaryingColor = vec4(1 - 1*ZPosition, 1 - 1*ZPosition, 1 - 0.5*ZPosition, 1);
	return vpos;
}