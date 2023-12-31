#version 150

#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;
int id = gl_VertexID % 4;

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform int FogShape;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

void main() {
    // vanilla behavior
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    vertexDistance = fog_distance(ModelViewMat, IViewRotMat * Position, FogShape);
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
    texCoord0 = UV0;
    vec2 texOffset = 32/textureSize(Sampler0, 0);
    vec4 specialPixel;

        // v Code borrowed from PuckiSilver (https://github.com/PuckiSilver/NoShadow)
    if (Color == vec4(78/255., 92/255., 36/255., Color.a) && Position.z == 0.03) {
        vertexColor = texelFetch(Sampler2, UV2 / 16, 0); // remove color from no shadow marker
    } else if (Color == vec4(19/255., 23/255., 9/255., Color.a) && Position.z == 0) {
        vertexColor = vec4(0); // remove shadow
    }
        // ^ Code borrowed from PuckiSilver (https://github.com/PuckiSilver/NoShadow)  
    

        //force stuff into top left corner
     else if(Color == vec4(1.,0.,0., Color.a)){
				vertexColor = vec4(1.,1.,1., 1.);
        		gl_Position.x -= 1;
				gl_Position.y += 1;

        //remove stext shadow
	} else if(Color == vec4(63/255., 0., 0., Color.a)){ 
        		gl_Position.x -= 1;
				gl_Position.y += 1;
        	}

    ivec2 iUV0 = ivec2(UV0 * textureSize(Sampler0, 0) + vec2(0.5));
    ivec2[] corners = ivec2[](
        ivec2(0, 0),
        ivec2(0, -1),
        ivec2(-1, -1),
        ivec2(-1, 0)
    );
    
    vec4 topleft = texelFetch(Sampler0, iUV0 + corners[gl_VertexID % 4] * 32, 0);

    if (ivec4(topleft * 255 + vec4(0.5)) == ivec4(211, 56, 255, 19)) {
        gl_Position.xy += vec2(-1, 1);
    }

}