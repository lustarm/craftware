const rl = @import("raylib");

pub const Sprite = struct {
    texture: rl.Texture2D,
    rect: rl.Rectangle,

    pub fn load(path: [:0]const u8) !Sprite {
        // Load the texture
        const texture = try rl.loadTexture(path);

        // Create rectangle based on actual texture dimensions
        const rect = rl.Rectangle{
            .x = 0,
            .y = 0,
            .width = @as(f32, @floatFromInt(texture.width)),
            .height = @as(f32, @floatFromInt(texture.height)),
        };

        return Sprite{
            .texture = texture,
            .rect = rect,
        };
    }

    pub fn unload(self: *const Sprite) void {
        rl.unloadTexture(self.texture);
    }
};
