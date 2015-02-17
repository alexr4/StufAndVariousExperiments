uniform mat4 transform;
uniform mat3 normalMatrix;
uniform mat4 texMatrix;

attribute vec4 vertex;
attribute vec3 normal;
attribute vec4 color;
attribute vec2 texCoord;

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform sampler2D displacementMap;
uniform float displaceStrength;

void main()
{
	vec4 newVertexPos;
	vec4 dv;
	float df;

	vertColor = color;
	vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);

	dv = texture2D(displacementMap, vertTexCoord.xy );
	
	df = 0.30*dv.x + 0.59*dv.y + 0.11*dv.z;
	
	newVertexPos = vec4(normal * df * displaceStrength, 0.0) + vertex;

	gl_Position = transform * newVertexPos;
}