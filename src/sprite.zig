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

    // Check if point is in the sprites rect
    pub fn contains(self: *const Sprite, vec2: rl.Vector2) bool {
        // uglyahhh
        if(vec2.x >= self.rect.x and vec2.x <= self.rect.x + self.rect.width
        and vec2.y >= self.rect.y and vec2.y <= self.rect.y + self.rect.height) {
            return true;
        }

        return false;
    }
};
