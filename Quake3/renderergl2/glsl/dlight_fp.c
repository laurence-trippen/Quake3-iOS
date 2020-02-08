const char *fallbackShader_dlight_fp =
"uniform sampler2D u_DiffuseMap;\n"
"\n"
"uniform int       u_AlphaTest;\n"
"\n"
"varying vec2      var_Tex1;\n"
"varying vec4      var_Color;\n"
"\n"
"\n"
"void main()\n"
"{\n"
"	vec4 color = texture2D(u_DiffuseMap, var_Tex1);\n"
"\n"
"	float alpha = color.a * var_Color.a;\n"
"	if (u_AlphaTest == 1)\n"
"	{\n"
"		if (alpha == 0.0)\n"
"			discard;\n"
"	}\n"
"	else if (u_AlphaTest == 2)\n"
"	{\n"
"		if (alpha >= 0.5)\n"
"			discard;\n"
"	}\n"
"	else if (u_AlphaTest == 3)\n"
"	{\n"
"		if (alpha < 0.5)\n"
"			discard;\n"
"	}\n"
"	\n"
"	gl_FragColor.rgb = color.rgb * var_Color.rgb;\n"
"	gl_FragColor.a = alpha;\n"
"}\n"
;
