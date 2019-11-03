Shader "Cloth/OwnModel"
{
    Properties
    {
	   _Color("Color", Color) = (1,1,1,1)
		_MainTex("Main Tex", 2D) = "white" {}
		_NormalTex("Normal Map", 2D) = "bump" {}
		_Roughness("Roughness", Range(0.01,1)) = 0.5
		_Fresnel("Fresnel F0 Value", Range(0,1)) = 0.04
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf OwnModel fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

		sampler2D _MainTex;
		sampler2D _NormalTex;
		float _Roughness;
		float _Fresnel;
		fixed4 _Color;

        struct Input
        {
			float2 uv_NormalTex;
			float2 uv_MainTex;
        };

       

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
			fixed4 c = _Color * tex2D(_MainTex, IN.uv_MainTex);
			float3 normalMap = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
			o.Normal = normalMap.rgb;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
        }

		half Fresnel(half HdotV)
		{
			return _Fresnel + (1. - _Fresnel) * pow((1. - HdotV), 5.);
		}

		half NDF(half NdotH)
		{
			half pi = 3.14159;
			half r = _Roughness;
			half halfr = r / 2;
			float b;
			b =  (1. / 3.);
			half a = -b * r + b;
			half power = 3 * (r * r);
			return (1 - pow(NdotH, power)) * NdotH + a;
		}

		inline half4 LightingOwnModel(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {

			float pi = 3.14159;
			//wektory//
			half3 dirL = normalize(lightDir);
			half3 dirV = normalize(viewDir);
			half3 dirH = normalize(dirL + dirV);
			half3 dirN = normalize(s.Normal);
			//wektory//
			//skalary//
			//z max// 
			half NdotH = max(0.1, dot(dirN, dirH));
			half HdotV = max(0.1, dot(dirH, dirV));
			half NdotL = max(0.1, dot(dirN, dirL));
			half NdotV = max(0.1, dot(dirN, dirV));
			//z max//
			//skalary//
			//fresnel//
			float fresnel = Fresnel(HdotV);
			//fresnel//
			//NDF//
			float distribution = NDF(NdotH);
			//NDF//
			//Diffuse//
			
			half diff = max(0.0, dot(s.Normal, lightDir)); 
			
			//Diffuse//
			//Specular//
			half specular = distribution * fresnel / (4. * (NdotL + NdotV - NdotL * NdotV));
			
			specular *= NdotL;
			
			//Specular//
			half4 c;
			
			c.rgb = (s.Albedo *_LightColor0.rgb * diff + _LightColor0.rgb * specular) * atten;
			c.a = s.Alpha;
			return c;
		}
        ENDCG
    }
    FallBack "Diffuse"
}
