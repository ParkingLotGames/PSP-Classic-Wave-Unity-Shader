Shader "Custom/PSP Classic Wave Overlay" {
	Properties
	{
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

	SubShader
	{
		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			HLSLPROGRAM
			#include "PSPClassicWave.hlsl"
			#pragma vertex vert
			#pragma fragment fragSecondPass
			ENDHLSL
		}
	}
}
	