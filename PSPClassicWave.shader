Shader "Custom/PSP Classic Wave" {
	Properties
	{
		[Header(Colors)]
		_TopColor("Top Color", Color) = (0.04, 0.19, 0.54,1)
		_BottomColor("Bottom Color", Color) = (0.04, 0.69, 0.87,1)
		[Header(Frequency)]
		_Frequency("Wave Frequency", Range(1, 10)) = 4.29
		[Header(Speed)]
		_OuterWavesSpeed("Outer Waves Speed", Range(0, 1)) = 0.044
		_InnerWavesSpeed("Inner Waves Speed", Range(0, 1)) = 0.064
		[Header(Amplitude)]
		_OuterWavesAmplitude("Outer Waves Amplitude", Range(0, 1)) = 0.5
		_InnerWavesAmplitude("Inner Waves Amplitude", Range(0, 1)) = 0.18
		[Header(Falloff)]
		_OuterWave1Falloff("Outer Wave 1 Falloff Distance", Range(0, 2)) = 2
		_OuterWave2Falloff("Outer Wave 2 Falloff Distance", Range(0, 2)) = 2
		_InnerWave1Falloff("Inner Wave 1 Falloff Distance", Range(0, 2)) = 1
		_InnerWave2Falloff("Inner Wave 2 Falloff Distance", Range(0, 2)) = 1
	}

	CGINCLUDE
	#include "UnityCG.cginc"

	struct appdata
	{
		float4 vertex : POSITION;
		float2 uv : TEXCOORD0;
	};

	struct v2f
	{
		float2 uv : TEXCOORD0;
		float4 vertex : SV_POSITION;
	};

	v2f vert(appdata v)
	{
		v2f o;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uv = v.uv;
		return o;
	}
	ENDCG

	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
				
			float4 _TopColor, _BottomColor;

			fixed4 frag(v2f i) : SV_Target 
			{
				return lerp(_BottomColor, _TopColor,i.uv.y);
			}
			ENDCG
		}

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			float _Frequency;
			float _OuterWavesAmplitude ,_InnerWavesAmplitude;
			float _OuterWavesSpeed, _InnerWavesSpeed;
			float _OuterWave1Falloff, _OuterWave2Falloff, _InnerWave1Falloff, _InnerWave2Falloff;

			float CreateOuterWave(float2 uv, int speedMultiplier)
			{
				return sin((uv.x + (_Time.y * (_OuterWavesSpeed + (0.0025 * speedMultiplier)))) * _Frequency) * _OuterWavesAmplitude;
			}

			float CreateInnerWave(float2 uv, int speedMultiplier)
			{
				return sin((uv.x + (_Time.y * (_InnerWavesSpeed + (0.0025 * speedMultiplier)))) * _Frequency) * _InnerWavesAmplitude;
			}
			
			fixed4 frag(v2f i) : SV_Target 
			{
				float2 uv = i.uv;
				// Used for coloring the wave
				float3 white = float3(1,1,1);
				// Create the sine waves, at this point they just create a color gradient over the x axis
				float topOuterWave = CreateOuterWave(uv,1);
				float bottomOuterWave = CreateOuterWave(uv,20);
				float topInnerWave = CreateInnerWave(uv,8);
				float bottomInnerWave = CreateInnerWave(uv,40);

				// Create a copy, these will be used to offset and define each wave's size
				float topOuterWaveFalloff = topOuterWave;
				float bottomOuterWaveFalloff = bottomOuterWave;
				float topInnerWaveFalloff = topInnerWave;
				float bottomInnerWaveFalloff = bottomInnerWave;
				
				// Create the S-shapes
				topOuterWave += 1 - (1 - uv.y) * 6;
				bottomOuterWave += 1 - (uv.y * 6);
				topInnerWave += 1 - (uv.y) * 2.5;
				bottomInnerWave += 1 - (1 - uv.y) * 2.5;

				// These are the same S shapes but vertically offset 
				topOuterWaveFalloff += 1 - (1-uv.y-0.2) * 6;
				bottomOuterWaveFalloff += 1 - ((uv.y-0.2) * 6);
				topInnerWaveFalloff += 1 - ((uv.y-0.1) * 2.2);
				bottomInnerWaveFalloff += 1 - (((1-uv.y-0.1)) * 2.2);
				
				// Add a small falloff to the crisp waves, otherwise they get aliased like crazy
				float wave1 = 1 - smoothstep(0, 0.025, topOuterWave);
				float wave2 = 1 - smoothstep(0, 0.025, bottomOuterWave);
				float wave3 = 1 - smoothstep(0, 0.025, topInnerWave);
				float wave4 = 1 - smoothstep(0, 0.025, bottomInnerWave);

				// Create the actual falloff
				float wave1Falloff = 1 -smoothstep(0, _OuterWave1Falloff, topOuterWaveFalloff);
				float wave2Falloff = 1 -smoothstep(0, _OuterWave2Falloff, bottomOuterWaveFalloff);
				float wave3Falloff = 1 -smoothstep(0, _InnerWave1Falloff, topInnerWaveFalloff);
				float wave4Falloff = 1 -smoothstep(0, _InnerWave2Falloff, bottomInnerWaveFalloff);
				
				// Subtract the calculated falloff from the sharp wave
				// So that all that is left is a falloff ending in the sharp cut of the wave
				wave1 -= wave1Falloff;
				wave2 -= wave2Falloff;
				wave3 -= wave3Falloff;
				wave4 -= wave4Falloff;

				// Clamp back to 0-1 since some of the values are currently below 0
				wave1 = saturate(wave1);
				wave2 = saturate(wave2);
				wave3 = saturate(wave3);
				wave4 = saturate(wave4);

				// Get the final contribution from all the waves
				float wave = wave1 + wave2 + wave3 + wave4;
				return float4(white,wave);
			}
			ENDCG
		}
	}
}
	
