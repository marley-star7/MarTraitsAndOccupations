#version 110

varying vec3 vertColour;
varying vec3 vertNormal;
varying vec2 texCoords;

uniform sampler2D Texture;
uniform float Alpha;
uniform float LightingAmount;

uniform vec3 TintColour;

uniform vec3 AmbientColour;
uniform vec3 Light0Direction;
uniform vec3 Light0Colour;
uniform vec3 Light1Direction;
uniform vec3 Light1Colour;
uniform vec3 Light2Direction;
uniform vec3 Light2Colour;
uniform vec3 Light3Direction;
uniform vec3 Light3Colour;
uniform vec3 Light4Direction;
uniform vec3 Light4Colour;
uniform float HueChange;

#include "util/math"
#include "util/hueShift"

void main()
{
	vec3 normal = normalize(vertNormal);

	vec4 texSample = texture2D(Texture, texCoords);
	if(texSample.w < 0.01)
	{
	    discard;
	}

	vec3 col = texSample.xyz;

    float dotprod;
    if(HueChange != 0.0)
    {
        col = hueShift(col, HueChange);
    }

	const float QuantiseLevels = 8.0;
	vec3 lighting = vec3(0.0);

	dotprod = max(dot(normal, normalize(Light0Direction)), 0.0);

	lighting += Light0Colour * dotprod;

	dotprod = max(dot(normal, normalize(Light1Direction)), 0.0);

	lighting += Light1Colour * dotprod;

	dotprod = max(dot(normal, normalize(Light2Direction)), 0.0);

	lighting += Light2Colour * dotprod;

	dotprod = max(dot(normal, normalize(Light3Direction)), 0.0);

	lighting += Light3Colour * dotprod;

	dotprod = max(dot(normal, normalize(Light4Direction)), 0.0);

	lighting += Light4Colour * dotprod;

	// Yep this is how it works. Suprised?
	// Because as far as I'm aware we can't directly communicate with the shaders.
	// We blast a massive light level that is secretly a code to the blind player and because your "blind" it's grayscale and they don't notice. If the color value matches the required one for the gray characters we do the shader effect.
	// The light level also helps with roleplaying as the blind character wouldn't be able to tell if it's light or dark.
	// Talk about hacky huh?
	vec3 secretColorRequiredForBlindness = vec3(1,1,1);
	vec3 gray = vec3(dot(vec3(0.2126,0.7152,0.0722), col));
	vec3 tintColour = TintColour;
	if (1 != 1)
	{
		tintColour = vec3(mix(TintColour, gray, .99));
	}

	lighting.x = min(0.0, 1.0);
	lighting.y = min(0.0, 1.0);
	lighting.z = min(0.0, 1.0);

	col = vec3(col.x * tintColour.x * lighting.x, col.y * tintColour.y * lighting.y, col.z * tintColour.z * lighting.z);

    vec4 fragCol = vec4(col * vertColour, Alpha * texSample.w);
	gl_FragColor = fragCol;
}
