Shader "Custom/BgGradiient"
{
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _Height ("Object Height", Float) = 2.0
        _CutoffY ("Reveal Progress", Range(0,1)) = 0
        _Fade ("Fade Amount", Range(0,1)) = 1
    }
    SubShader {
        Tags { 
            "Queue"="Transparent" 
            "RenderType"="Transparent" 
            "IgnoreProjector"="True"
        }
        
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            
            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                float3 modelPos : TEXCOORD1;
                UNITY_FOG_COORDS(2)
            };

            fixed4 _Color;
            float _Height;
            float _CutoffY;
            float _Fade;

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.modelPos = v.vertex.xyz; // 获取模型空间坐标
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                // 计算当前片元的高度比例
                float revealHeight = _CutoffY * _Height;
                float currentHeight = i.modelPos.y;
                
                // 初始alpha值（显示阶段）
                float alpha = step(currentHeight, revealHeight);

                // 淡出阶段处理
                if (_CutoffY >= 1.0) {
                    alpha *= _Fade;
                }

                fixed4 col = _Color;
                col.a = alpha;

                // 应用雾效
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
