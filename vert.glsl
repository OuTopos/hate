attribute float z;
uniform vec2 camera_position = vec2(0.0, 0.0);
uniform vec2 parallax_offset = vec2(0.0008, 0.0);
varying vec4 vpos;

vec4 position( mat4 transform_projection, vec4 vertex_position )
{
	//vpos = vec4(vertex_position.x + (vertex_position.x - camera_position.x) * z * parallax_offset.x, vertex_position.y + (vertex_position.y - camera_position.y) * z * parallax_offset.y, vertex_position.z, vertex_position.w);
	//vpos = transform_projection * vpos;

	//vertex_position = vec4(vertex_position.x, vertex_position.y, z, vertex_position.w);
	vpos = transform_projection * vertex_position;
	
	vpos.x = vpos.x * (1 + parallax_offset.x * z);
	vpos.y = vpos.y * (1 + parallax_offset.y * z);
	vpos.z = z / 16777216;

	//VaryingColor = vec4(1 - 1*ZPosition, 1 - 1*ZPosition, 1 - 0.5*ZPosition, 1);
	return vpos;
}