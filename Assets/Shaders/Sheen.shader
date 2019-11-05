Shader "Cloth/Sheen"
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
        Tags { "RenderType" = "Opaque"}
        LOD 200

        CGPROGRAM
        
        #pragma surface surf Sheen fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0
		sampler2D _MainTex;
		sampler2D _NormalTex;
		float _Roughness;
		float _Fresnel;
		fixed4 _Color;
		


		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
		// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		struct Input
		{
			float2 uv_NormalTex;
			float2 uv_MainTex;
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			fixed4 c = _Color * tex2D(_MainTex, IN.uv_MainTex);
			float3 normalMap = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
			o.Normal = normalMap.rgb;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		half Fresnel(half HdotV)
		{
			return _Fresnel + (1. - _Fresnel) * pow((1 - HdotV), 5.);
		}


		half Interpolation(half x0, half x1) { //interpolacja dla wartosci 0<r<1;
			half r = _Roughness;
			half r2 = (1 - r);
			half part1 = (1 - r) * (1 - r);
			half part2 = 1. - part1;
			half i = part1 * x0 + part2 * x1;
			return i;
		}


		half NDF(half NdotH)
		{
			half pi = 3.14159;
			half r = _Roughness;
			half invR = 1. / r;
			half cos2h = pow(NdotH, 2);
			half sin2h = 1. - cos2h;
			half sinh = sqrt(sin2h);
			return  ((2. + invR) * pow(sinh, invR)) / (2. * pi);
		}

		

		half Lterm(half x, half a, half b, half c, half d, half e) {
			half  l = a / (1. + b * pow(x, c)) + d * x + e;
			return  l;
		}

		
		float Gterm(float NdotL, float NdotV) {

			// a, b, c, d, e //
			half a0 = 25.3245;
			half a1 = 21.5473;
			half b0 = 3.32435;
			half b1 = 3.82987;
			half c0 = 0.16801;
			half c1 = 0.19823;
			half d0 = -1.27393;
			half d1 = -1.97760;
			half e0 = -4.85967;
			half e1 = -4.32054;
			// a, b, c, d, e //
			//interpolacja dla r>0 oraz r<1//
			half a = Interpolation(a0, a1);
			half b = Interpolation(b0, b1);
			half c = Interpolation(c0, c1);
			half d = Interpolation(d0, d1);
			half e = Interpolation(e0, e1);
		
			//interpolacja dla r>0 oraz r<1//
			//Lambda dla kierunku swiatla//
			half lambdaL=1;
			if(NdotL < 0.5)
			{
				
				lambdaL = exp(Lterm(NdotL, a, b, c, d, e));
			}
			else
			{
				
				lambdaL = exp(2 * Lterm(0.5, a, b, c, d, e) - Lterm((1. - NdotL), a, b, c, d, e));
			}
			
			lambdaL = pow(lambdaL, 1. + 2. * pow((1 - NdotL), 8)); // terminator softening
			//Lambda dla kierunku swiatla//
			//Lambda dla kierunku obserwacji//
			half lambdaV=1;
			
			if(NdotV < 0.5)
			{
				lambdaV =  exp(Lterm(NdotV, a, b, c, d, e));
				
			}
			else
			{
				
				lambdaV =  exp(2. * Lterm(0.5, a, b, c, d, e) - Lterm((1 - NdotV), a, b, c, d, e));
			} 

			
			
			//Lambda dla kierunku obserwacji//
			return 1 / (1 + lambdaL + lambdaV);
		}
		

		
		inline half4 LightingSheen(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {

			float pi = 3.14159;
			//wektory//
			half3 dirL = normalize(lightDir);
			half3 dirV = normalize(viewDir);
			half3 dirH = (dirL + dirV) / 2;
			half3 dirN = normalize(s.Normal);
			//wektory//
			//skalary//
			half NdotH = dot(dirN, dirH);
			half HdotV = dot(dirH, dirV);
			half NdotL = max(dot(dirN, dirL),0.1);
			half NdotV = max(dot(dirN, dirV),0.1);
			//half NdotL = dot(dirN, dirL);
			//half NdotV = dot(dirN, dirV);
			//skalary//
			//Fresnel//
			half fresnel = Fresnel(HdotV);// aproksymacja Schlicka 
			//Fresnel//
			//maskowanie i cieniowanie//

			half geometry = Gterm(NdotL, NdotV);
			//maskowanie i cieniowanie//
			//funckja dystrybucji//
			half distribution = NDF(NdotH);
			//funckja dystrybucji//
			//specular//
			//half specular = (fresnel * distribution ) / (4. * NdotL * NdotV); //wlasny model test1
			half specular = (fresnel * distribution * geometry) / (4. * NdotL * NdotV);
			specular *= NdotL;
			//specular//
			//diffuse//
			half diff = max(0.0, dot(s.Normal, lightDir));
			//diffuse//
			
			half4 c;
			c.rgb = (s.Albedo *_LightColor0.rgb * diff + _LightColor0.rgb * specular) * atten;

			//c.rgb = (specular * _LightColor0) * atten;
			c.a = s.Alpha;
			return c;
		}

        ENDCG
    }
    FallBack "Diffuse"
}
