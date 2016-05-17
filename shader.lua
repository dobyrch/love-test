local shader = {}

shader.damaged = love.graphics.newShader [[
	extern number time;

	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
		vec4 pixel = Texel(texture, texture_coords);
		number flash = time;

		while (flash >= 8.0 / 60.0)
			flash -= 8.0 / 60.0;

		if (flash > 4.0 / 60.0)
			return pixel;

		if (pixel.r + pixel.g + pixel.b > 1.5) {
			pixel = vec4(0, 0, 0, pixel.a);
		} else if (pixel.r + pixel.g + pixel.b < 0.5) {
			pixel = vec4(1, 1, 0.5, pixel.a);
		} else {
			pixel = vec4(1, 0, 0, pixel.a);
		}

		return pixel;
	}
]]

return shader
