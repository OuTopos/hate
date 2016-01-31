attribute float ZPosition;
uniform float XCam = 0;
uniform float YCam = 0;
varying vec4 vpos;

vec4 position( mat4 transform_projection, vec4 vertex_position )
{
	vpos = transform_projection * vertex_position;
	vpos.x = vpos.x + XCam;
	//vpos.y = vpos.y / ((-vpos.z * -1) - vpos.y);
	VaryingColor = vec4(1 - 1*ZPosition, 1 - 1*ZPosition, 1 - 1*ZPosition, 1);
	return vpos;
}