const std = @import("std");
const rl = @import("raylib");

pub const Sprite = struct {
    texture: rl.Texture2D,
    rect: rl.Rectangle,
    image: rl.Image, // Add this to store the image data

    scale: f32,

    offset_x: f32,
    offset_y: f32,

    origin_x: f32,
    origin_y: f32,

    draggable: bool,
    dragging: bool,

    pub fn load(path: [:0]const u8) !Sprite {
        const image = try rl.loadImage(path); // Load the image first
        const texture = try rl.loadTextureFromImage(image); // Create texture from image

        const scale = 0.15; // 15%
        const rect = rl.Rectangle{
            .x = 0,
            .y = 0,
            .width = @as(f32, @floatFromInt(texture.width)) * scale,
            .height = @as(f32, @floatFromInt(texture.height)) * scale,
        };

        return Sprite{
            .texture = texture,
            .rect = rect,
            .image = image,
            .scale = scale,
            .offset_x = 0,
            .offset_y = 0,
            .origin_x = rect.x,
            .origin_y = rect.y,
            .draggable = true,
            .dragging = false,
        };
    }

    pub fn unload(self: *const Sprite) void {
        rl.unloadTexture(self.texture);
        rl.unloadImage(self.image);
    }

    pub fn isPixelTransparent(self: *const Sprite, x: i32, y: i32) bool {
        if (x < 0 or y < 0 or x >= self.image.width or y >= self.image.height) {
            return true;
        }

        // Get the color at the specified pixel
        const color = rl.getImageColor(self.image, x, y);
        return color.a < 128; // Consider pixels with alpha < 128 as transparent
    }

    pub fn getImageCoordinates(self: *const Sprite, screen_x: f32, screen_y: f32) struct { x: i32, y: i32 } {
        // Convert screen coordinates to image coordinates
        const img_x = @as(i32, @intFromFloat((screen_x - self.rect.x) / self.scale));
        const img_y = @as(i32, @intFromFloat((screen_y - self.rect.y) / self.scale));
        return .{ .x = img_x, .y = img_y };
    }

    pub fn update(self: *Sprite) void {
        if (!self.draggable) {
            std.debug.print("ERROR: Trying to drag undraggable item\n", .{});
            return;
        }

        const mouse_pos = rl.getMousePosition();

        if (rl.isMouseButtonPressed(rl.MouseButton.left)) {
            if (self.contains(mouse_pos)) {
                // Convert mouse position to image coordinates
                const img_coords = self.getImageCoordinates(mouse_pos.x, mouse_pos.y);

                // Only start dragging if clicking on a non-transparent pixel
                if (!self.isPixelTransparent(img_coords.x, img_coords.y)) {
                    self.dragging = true;
                    self.offset_x = self.rect.x - mouse_pos.x;
                    self.offset_y = self.rect.y - mouse_pos.y;
                }
            }
        }

        // Rest of the drag function remains the same
        if (self.dragging and rl.isMouseButtonDown(rl.MouseButton.left)) {
            self.rect.x = mouse_pos.x + self.offset_x;
            self.rect.y = mouse_pos.y + self.offset_y;
        }

        // check later if released and in valid spot
        if (rl.isMouseButtonReleased(rl.MouseButton.left)) {
            self.dragging = false;
            self.rect.x = self.origin_x;
            self.rect.y = self.origin_y;
        }
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
