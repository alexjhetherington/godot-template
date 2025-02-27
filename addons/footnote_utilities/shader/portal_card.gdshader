shader_type spatial;
render_mode shadows_disabled, unshaded;

uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;

uniform vec4 albedo_colour : source_color = vec4(1,1,1,1);
uniform sampler2D albedo_texture : source_color,filter_nearest,repeat_enable;

uniform float view_distance_full_opacity : hint_range(0.0, 50.0) = 0;
uniform float view_distance_zero_opacity : hint_range(-1.0, 50.0) = -1;

uniform float depth_full_opacity : hint_range(0.0, 50.0) = 0;
uniform float depth_zero_opacity : hint_range(0.0, 50.0) = 0;
uniform float depth_ease_power : hint_range(1.0, 4.0) = 1.0;

void fragment() {
	vec4 tex = texture(albedo_texture, UV);
	ALBEDO = albedo_colour.rgb * tex.rgb;
	
	vec4 upos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0, FRAGCOORD.z, 1.0);
	vec3 pixel_position = upos.xyz / upos.w;
	float fragment_depth = -pixel_position.z;
	
	float fragment_depth_clamped = clamp(fragment_depth, view_distance_zero_opacity, view_distance_full_opacity);
	float view_distance_opacity =  (fragment_depth_clamped - view_distance_zero_opacity) / (view_distance_full_opacity - view_distance_zero_opacity);
	
	float world_depth = texture(DEPTH_TEXTURE, SCREEN_UV).x;
	vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, world_depth);
	vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
  	view.xyz /= view.w;
  	float linear_depth = -view.z - fragment_depth;

	float depth_opacity =  (linear_depth - depth_zero_opacity) / (depth_full_opacity - depth_zero_opacity);
	depth_opacity = clamp (depth_opacity, 0, 1);
	//depth_opacity = depth_opacity * depth_opacity;
	depth_opacity = 1.0 - pow(1.0 - depth_opacity, depth_ease_power);
	ALPHA = tex.a * depth_opacity * view_distance_opacity;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
