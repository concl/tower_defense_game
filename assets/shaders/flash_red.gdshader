shader_type canvas_item;

uniform float flash_amount : hint_range(0.0, 1.0) = 0.0;
uniform vec4 flash_color : source_color = vec4(1.0, 0.0, 0.0, 1.0); // red

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    // Blend between original texture color and flash color
    COLOR = mix(tex_color, flash_color, flash_amount) * tex_color.a;
}