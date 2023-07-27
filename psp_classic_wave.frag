uniform sampler2D g_Texture0; // {"material":"framebuffer","label":"ui_editor_properties_framebuffer","hidden":true}
uniform float g_Time;

uniform vec3 u_topColor; // {"default":"0.04 0.19 0.54","material":"Background: Top Color","type":"color"}
uniform vec3 u_bottomColor; // {"default":"0.04 0.69 0.89","material":"Background: Bottom Color","type":"color"}
uniform float u_Frequency; // {"material":"Wave Frequency","default":4.29,"range":[0,10]}
uniform float u_OuterWavesAmplitude; // {"material":"Outer Waves Amplitude","default":0.5,"range":[0,1]}
uniform float u_InnerWavesAmplitude; // {"material":"Inner Waves Amplitude","default":0.18,"range":[0,1]}
uniform float u_OuterWavesSpeed; // {"material":"Outer Waves Speed","default":0.54,"range":[0,1]}
uniform float u_InnerWavesSpeed; // {"material":"Inner Waves Speed","default":0.18,"range":[0,1]}
uniform float u_OuterWavesFalloff; // {"material":"Outer Waves Falloff","default":2,"range":[0,2]}
uniform float u_InnerWavesFalloff; // {"material":"Inner Waves Falloff","default":1,"range":[0,1]}

varying vec2 v_TexCoord;

void main()
{
    vec2 uv = v_TexCoord;
    vec3 white = vec3(1.0, 1.0, 1.0);
    float time = g_Time * 0.1875;
    float magic = 0.0025;

    float topOuterWave = sin((uv.x + (time * (u_OuterWavesSpeed + (magic * 1.0)))) * u_Frequency) * u_OuterWavesAmplitude;
    float bottomOuterWave = sin((uv.x + (time * (u_OuterWavesSpeed + (magic * 20.0)))) * u_Frequency) * u_OuterWavesAmplitude;
    float topInnerWave = sin((uv.x + (time * (u_InnerWavesSpeed + (magic * 8.0)))) * u_Frequency) * u_InnerWavesAmplitude;
    float bottomInnerWave = sin((uv.x + (time * (u_InnerWavesSpeed + (magic * 40.0)))) * u_Frequency) * u_InnerWavesAmplitude;

    float topOuterWaveFalloff = topOuterWave;
    float bottomOuterWaveFalloff = bottomOuterWave;
    float topInnerWaveFalloff = topInnerWave;
    float bottomInnerWaveFalloff = bottomInnerWave;

    topOuterWave += 1.0 - (1.0 - uv.y) * 6.0;
    bottomOuterWave += 1.0 - (uv.y * 6.0);
    topInnerWave += 1.0 - (uv.y) * 2.5;
    bottomInnerWave += 1.0 - (1.0 - uv.y) * 2.5;

    topOuterWaveFalloff += 1.0 - (1.0 - uv.y - 0.2) * 6.0;
    bottomOuterWaveFalloff += 1.0 - ((uv.y - 0.2) * 6.0);
    topInnerWaveFalloff += 1.0 - ((uv.y - 0.1) * 2.2);
    bottomInnerWaveFalloff += 1.0 - (((1.0 - uv.y - 0.1)) * 2.2);

    float wave1 = 1.0 - smoothstep(0.0, 0.025, topOuterWave);
    float wave2 = 1.0 - smoothstep(0.0, 0.025, bottomOuterWave);
    float wave3 = 1.0 - smoothstep(0.0, 0.025, topInnerWave);
    float wave4 = 1.0 - smoothstep(0.0, 0.025, bottomInnerWave);

    float wave1Falloff = 1.0 - smoothstep(0.0, u_OuterWavesFalloff, topOuterWaveFalloff);
    float wave2Falloff = 1.0 - smoothstep(0.0, u_OuterWavesFalloff, bottomOuterWaveFalloff);
    float wave3Falloff = 1.0 - smoothstep(0.0, u_InnerWavesFalloff, topInnerWaveFalloff);
    float wave4Falloff = 1.0 - smoothstep(0.0, u_InnerWavesFalloff, bottomInnerWaveFalloff);

    wave1 -= wave1Falloff;
    wave2 -= wave2Falloff;
    wave3 -= wave3Falloff;
    wave4 -= wave4Falloff;

    wave1 = clamp(wave1, 0.0, 1.0);
    wave2 = clamp(wave2, 0.0, 1.0);
    wave3 = clamp(wave3, 0.0, 1.0);
    wave4 = clamp(wave4, 0.0, 1.0);

    float wave = wave1 + wave2 + wave3 + wave4;
    vec4 waveContribution = vec4(white,wave);
	vec4 background = vec4(mix(u_topColor, u_bottomColor, uv.y), 1.0);
    gl_FragColor = mix(background, waveContribution, wave);
}