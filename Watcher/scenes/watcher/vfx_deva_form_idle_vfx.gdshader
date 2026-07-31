shader_type canvas_item;

uniform float ray_count = 12.0;      // number of light rays
uniform float ray_speed = 0.15;      // how fast rays shimmer/shift
uniform float ring_speed = 0.4;      // how fast halos expand outward
uniform float ring_count = 3.0;      // how many expanding halos
uniform float pulse_speed = 0.5;
uniform float min_alpha = 0.0;
uniform float max_alpha = 0.1;
uniform float core_size = 0.15;      // bright center
uniform vec4 circle_color : source_color = vec4(1.0, 0.95, 0.7, 0.5);

void fragment() {
    vec2 uv = UV - vec2(0.5);
    float dist = length(uv);
    float angle = atan(uv.y, uv.x);

    // --- radial light rays, shimmering unevenly ---
    float rays = sin(angle * ray_count + sin(TIME * ray_speed) * 3.0);
    rays += 0.5 * sin(angle * ray_count * 0.5 - TIME * ray_speed * 1.3);
    rays = rays * 0.5 + 0.5;                 // 0..1
    rays = pow(rays, 2.0);                    // sharpen into distinct rays
    rays *= smoothstep(0.5, core_size, dist); // rays fade toward the edge

    // --- expanding halo rings ---
    float rings = sin(dist * ring_count * 6.28 - TIME * ring_speed * 6.28);
    rings = rings * 0.5 + 0.5;
    rings = pow(rings, 3.0);                   // thin bright rings
    rings *= smoothstep(0.5, core_size, dist);

    // --- serene bright core ---
    float core = smoothstep(core_size, 0.0, dist);

    // combine: core dominates center, rays + rings radiate outward
    float radiance = core + rays * 0.6 + rings * 0.4;

    // soft outer falloff so nothing has a hard edge
    float falloff = smoothstep(0.5, 0.1, dist);
    radiance *= falloff;

    // slow, calm breathing
    float pulse = sin(TIME * pulse_speed) * 0.5 + 0.5;
    float alpha = mix(min_alpha, max_alpha, pulse);

    COLOR = circle_color * vec4(1.0, 1.0, 1.0, radiance * alpha);
}