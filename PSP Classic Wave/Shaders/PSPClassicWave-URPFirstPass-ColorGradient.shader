Shader "Custom/Vertical Color Gradient" {
	Properties
	{
		[Header(Colors)]
		_TopColor("Top Color", Color) = (0.04, 0.19, 0.54,1)
		_BottomColor("Bottom Color", Color) = (0.04, 0.69, 0.87,1)
	}

	SubShader
	{
		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			HLSLPROGRAM
			#include "PSPClassicWave.hlsl"
			#pragma vertex vert
			#pragma fragment fragFirstPass
			ENDHLSL
		}
	}
}
	