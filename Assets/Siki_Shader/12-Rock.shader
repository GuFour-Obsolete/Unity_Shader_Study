// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader"Siki/12-Rock"
{
  Properties
  {
    //_Diffuse("Diffuse Color",Color)=(1,1,1,1)
    _Color("Color",Color)=(1,1,1,1)
    _MainTex("Main Tex",2D) = "white"{} 
  }

  SubShader
  {
    pass
    {
      Tags{"LightMode"="ForwardBase"}

      CGPROGRAM  
      #include"Lighting.cginc"
      #pragma vertex vert
      #pragma fragment frag

      fixed4 _Color;
      float4 _MainTex_ST;
      sampler2D _MainTex; 

      struct a2v
      {
        float4 vertex : POSITION;
        float3 normal : NORMAL; 
        float4 texcoord : TEXCOORD0;
      };

      struct v2f
      {
        float4 svPos : SV_POSITION;
        float3 worldNormal : TEXCOORD0;
        float4 worldVertex : TEXCOORD1; 
        float2 uv : TEXCOORD2;
      };

      v2f vert(a2v v)
      {
        v2f f;
        //模型顶点坐标=>裁剪顶点坐标
        f.svPos = UnityObjectToClipPos(v.vertex);
        //模型法线=>世界空间法线
        f.worldNormal = UnityObjectToWorldNormal(v.normal);
        //世界空间顶点=>模型空间顶点
        f.worldVertex = mul(v.vertex,unity_WorldToObject);
        f.uv=v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
        return f;
      }

      fixed4 frag(v2f f):SV_TARGET
      {
        //世界空间法线=>归一化获取方向
        fixed3 normalDir = normalize(f.worldNormal);
        //世界空间顶点=>获取世界空间光源照射这一点的方向=>归一化=>
        //得到光源照射到这一顶点的方向
        fixed3 lightDir = normalize(WorldSpaceLightDir(f.worldVertex));

        fixed3 texColor = tex2D(_MainTex,f.uv.xy) * _Color.rgb;
        //混合光源颜色、预设属性颜色、乘以法线方向与光照方向的夹角
        fixed3 diffuse = _LightColor0.rgb * texColor * 
        max(dot(normalDir,lightDir),0); 
        
        //叠加漫反射颜色、高光反射颜色、环境光颜色=>得到最终呈现的颜色
        fixed3 tempColor = diffuse + UNITY_LIGHTMODEL_AMBIENT.rgb * texColor;

        return fixed4(tempColor,1);
      } 
      ENDCG
    }
  }
  Fallback"Specular" 
}