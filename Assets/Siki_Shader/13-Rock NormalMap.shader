// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader"Siki/13-Normal Map"
{
  Properties
  {
    //_Diffuse("Diffuse Color",Color)=(1,1,1,1)
    _Color("Color",Color)=(1,1,1,1)
    _MainTex("Main Tex",2D) = "white"{}
    _NormalMap("Normal Map",2D)="bump"{}
    _BumpScale("Bump Scale",Float)=1
    //_BumpScale("Bump Scale",Range(0,1))=1
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
      sampler2D _MainTex;
      float4 _MainTex_ST;
      sampler2D _NormalMap;
      float4 _NormalMap_ST;
      float _BumpScale;

      struct a2v
      {
        float4 vertex : POSITION;
        //切线空间的确定是通过《储存到模型里面的》法线和《储存到模型里面的》切线确定的
        float3 normal : NORMAL;
        float4 tangent : TANGENT;//tangent.w是用来确定切线空间中坐标轴的方向的
        float4 texcoord : TEXCOORD0;
      };

      struct v2f
      {
        float4 svPos : SV_POSITION;
        //float3 worldNormal : TEXCOORD0;
        float3 lightDir : TEXCOORD0;//切线空间下平行光的方向
        float4 worldVertex : TEXCOORD1;
        float4 uv : TEXCOORD2;//XY用来存储MainTex的纹理坐标 ZW法线贴图的纹理坐标
      };

      v2f vert(a2v v)
      {
        v2f f;
        //模型顶点坐标=>裁剪顶点坐标
        f.svPos = UnityObjectToClipPos(v.vertex);
        //模型法线=>世界空间法线
        //f.worldNormal = UnityObjectToWorldNormal(v.normal);
        //世界空间顶点=>模型空间顶点
        f.worldVertex = mul(v.vertex,unity_WorldToObject);
        f.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
        f.uv.zw = v.texcoord.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
        
        //调用这个宏定义，会得到一个矩阵rotation，用以把模型空间的方向转换成切线空间下
        TANGENT_SPACE_ROTATION;
        //ObjSpaceLightDir(v.vertex)//得到模型空间下的平行光方向
        f.lightDir = mul(rotation,ObjSpaceLightDir(v.vertex));

        return f;
      }

      //把所有跟法线方向相关的运算都放在切线空间下
      //因为从法线贴图里取得的法线方向是在切线空间下
      fixed4 frag(v2f f):SV_TARGET
      {
        //世界空间法线=>归一化获取方向
        //fixed3 normalDir = normalize(f.worldNormal);

        fixed4 normalColor = tex2D(_NormalMap,f.uv.zw);

        //fixed3 tangentNormal = normalize(normalColor.xyz * 2-1);//切线空间下的法线
        fixed3 tangentNormal = UnpackNormal(normalColor);
        
        tangentNormal.xy = tangentNormal * _BumpScale;

        tangentNormal = normalize(tangentNormal);



        //世界空间顶点=>获取世界空间光源照射这一点的方向=>归一化=>
        //得到光源照射到这一顶点的方向
        fixed3 lightDir = normalize(f.lightDir);

        fixed3 texColor = tex2D(_MainTex,f.uv.xy) * _Color.rgb;
        //混合光源颜色、预设属性颜色、乘以法线方向与光照方向的夹角
        fixed3 diffuse = _LightColor0.rgb * texColor *
        max(dot(tangentNormal,lightDir),0);

        //叠加漫反射颜色、高光反射颜色、环境光颜色=>得到最终呈现的颜色
        fixed3 tempColor = diffuse + UNITY_LIGHTMODEL_AMBIENT.rgb * texColor;

        return fixed4(tempColor,1);
      }
      ENDCG
    }
  }
  //Fallback"Specular"
}