const std = @import("std");
const rl = @import("raylib");

pub const Sprite = struct {
    texture: rl.Texture2D,
    rect: rl.Rectangle,
    image: rl.Image,

    scale: f32,

    pub fn load(path: [:0]const u8, x: f32, y: f32, scale: f32) !Sprite {
        const image = try rl.loadImage(path); // Load the image first
        const texture = try rl.loadTextureFromImage(image); // Create texture from image

        const rect = rl.Rectangle{
            .x = x,
            .y = y,
            .width = @as(f32, @floatFromInt(texture.width)) * scale,
            .height = @as(f32, @floatFromInt(texture.height)) * scale,
        };

        return Sprite{
            .texture = texture,
            .rect = rect,
            .image = image,
            .scale = scale,
        };
    }

    pub fn unload(self: *const Sprite) void {
        rl.unloadTexture(self.texture);
        rl.unloadImage(self.image);
    }

    pub fn render(self: *const Sprite) void {
        rl.drawTextureEx(
            self.texture,
            rl.Vector2 {
                .x = self.rect.x,
                .y = self.rect.y,
            },
            0.0, // rotation
            self.scale,
            rl.Color.white,
        );
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
