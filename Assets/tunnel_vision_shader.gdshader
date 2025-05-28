shader_type canvas_item;

// Animation speed (full cycle per second)
uniform float speed = 0.1;
// Where the closure starts (0 = center, 1 = screen edge)
uniform float start_radius : hint_range(0, 1) = 1;
// Edge smoothness
uniform float smoothness  = 1;
// Enable looping (set to 0 for one-shot animation)
uniform int loop = 0;

void fragment() {
    // Aspect ratio correction
    float aspect_ratio = SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
    vec2 centered_uv = (UV - vec2(0.5)) * vec2(aspect_ratio, 1.0);
    float dist = length(centered_uv);

    // Calculate maximum screen distance
    float max_screen_dist = length(vec2(0.5 * aspect_ratio, 0.5));

    // Convert start_radius to actual distance units
    float animation_start = max_screen_dist * start_radius;

    // Animate progress
    float progress = TIME * speed;
    if (loop == 1) {
        progress = mod(progress, 1.0);
    } else {
        progress = clamp(progress, 0.0, 1.0);
    }

    // Calculate current radius
    float current_radius = mix(animation_start, 0.0, progress);

    // Create smooth circle transition
    float alpha = smoothstep(
        current_radius - smoothness,
        current_radius + smoothness,
        dist
    );

    COLOR = vec4(0.0, 0.0, 0.0, alpha);
}