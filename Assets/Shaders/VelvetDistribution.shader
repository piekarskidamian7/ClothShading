Shader "Cloth/VelvetDistribution"
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
			Tags { "RenderType" = "Opaque" }
			LOD 200

			CGPROGRAM
			// Physically based Standard lighting model, and enable shadows on all light types
			#pragma surface surf AshikhiminDistrubutionBasedBRDF fullforwardshadows
			sampler2D _MainTex;
			sampler2D _NormalTex;
			float _Roughness;
			float _Fresnel;
			fixed4 _Color;

			#pragma target 3.0

			struct Input
			{
				float2 uv_NormalTex;
				float2 uv_MainTex;
			};

			UNITY_INSTANCING_BUFFER_START(Props)

			UNITY_INSTANCING_BUFFER_END(Props)

			void surf(Input IN, inout SurfaceOutput o)
			{
				fixed4 c = _Color * tex2D(_MainTex, IN.uv_MainTex);
				float3 normalMap = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
				o.Normal = normalMap.rgb;
				o.Albedo = c.rgb;
				o.Alpha = c.a;
			}

			half Fresnel(half HdotV) {
				return _Fresnel + (1. - _Fresnel) * pow((1 - HdotV), 5.);
			}

			half NDF(half NdotH) {
				
				half r2 = _Roughness * _Roughness;
				half pi = 3.14159;
				half cNorm = 1. / (pi * (1. + (4 * r2)));
				half cos2H = NdotH * NdotH;
				half sin2H = 1. - cos2H;    //z wlasnosci sin^2a + cos^2a = 1
				half cot2H = cos2H / sin2H;	// z wlasnosci cota = cosa/sina
				half e = exp(-cot2H / r2);
				return  cNorm * (1. + 4.  * e);
			}

			half4 LightingAshikhiminDistrubutionBasedBRDF(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {


				half pi = 3.14159;
				half3 dirL = normalize(lightDir);
				half3 dirV = normalize(viewDir);
				half3 dirH = normalize(dirL + dirV);
				half3 dirN = normalize(s.Normal);

				half NdotH = max(0.01, dot(dirN, dirH));
				half HdotV = max(0.01, dot(dirH, dirV));
				half NdotL = max(0.1, dot(dirN, dirL));
				half NdotV = max(0.1, dot(dirN, dirV));

				half distribution = NDF(NdotH);// NDF
				
				
				float fresnel = Fresnel(HdotV);
				//// wspolczynnik Fresnela -  Shlick////
				//// BRDF specular////					
				half specular = fresnel * distribution / (NdotL + NdotV - NdotL * NdotV);
				specular *= NdotL;
				//// BRDF specular////
				//// BRDF diffuse ////
				half diff = max(0.0, dot(s.Normal, lightDir)); // Lambert
				
				//// BRDF diffuse ////
				

				

				half4 c;
				c.rgb = (s.Albedo *_LightColor0.rgb * diff + _LightColor0.rgb * specular) * atten ;
				
				//c.rgb = (specular * _LightColor0) * atten;
				c.a = s.Alpha;
				return c;
			}
		
			
		
			ENDCG
		}
			FallBack "Diffuse"
}
