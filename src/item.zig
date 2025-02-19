const rl = @import("raylib");

const sprite = @import("sprite.zig");

pub const Item = struct {
    sprite: sprite.Sprite,

    offset_x: f32,
    offset_y: f32,

    origin_x: f32,
    origin_y: f32,

    draggable: bool,
    dragging: bool,

    // -- INIT AND DEINIT
    pub fn init(path: [:0]const u8, x: f32, y: f32, scale: f32, draggable: bool) !Item {
        const sprite_ = try sprite.Sprite.load(path, x, y, scale);

        return Item {
            .sprite = sprite_,
            .offset_x = x,
            .offset_y = y,
            .origin_x = sprite_.rect.x,
            .origin_y = sprite_.rect.y,
            .draggable = draggable,
            .dragging = false,
        };
    }

    pub fn deinit(self: *Item) void {
        self.sprite.unload();
    }

    // -- LOOP
    // input, update, render
    pub fn input(self: *Item) void {
        const mouse_pos = rl.getMousePosition();

        if (rl.isMouseButtonPressed(rl.MouseButton.left)) {
            if (self.sprite.contains(mouse_pos)) {
                // Convert mouse position to image coordinates
                const img_coords = self.getImageCoordinates(mouse_pos.x, mouse_pos.y);

                // Only start dragging if clicking on a non-transparent pixel
                if (!self.isPixelTransparent(img_coords.x, img_coords.y)) {
                    self.dragging = true;
                    self.offset_x = self.sprite.rect.x - mouse_pos.x;
                    self.offset_y = self.sprite.rect.y - mouse_pos.y;
                }
            }
        }

        if (self.dragging and rl.isMouseButtonDown(rl.MouseButton.left)) {
            self.sprite.rect.x = mouse_pos.x + self.offset_x;
            self.sprite.rect.y = mouse_pos.y + self.offset_y;
        }

        // check later if released and in valid spot
        if (rl.isMouseButtonReleased(rl.MouseButton.left)) {
            self.dragging = false;
            self.sprite.rect.x = self.origin_x;
            self.sprite.rect.y = self.origin_y;
        }
    }

    // pub fn update() void {}

    pub fn render(self: *Item) void {
        self.sprite.render();
    }

    // -- HELPER FUNCTIONS

    pub fn isPixelTransparent(self: *const Item, x: i32, y: i32) bool {
        if (x < 0 or y < 0 or x >= self.sprite.image.width or y >= self.sprite.image.height) {
            return true;
        }

        // Get the color at the specified pixel
        const color = rl.getImageColor(self.sprite.image, x, y);
        return color.a < 128; // Consider pixels with alpha < 128 as transparent
    }

    pub fn getImageCoordinates(self: *const Item, screen_x: f32, screen_y: f32) struct { x: i32, y: i32 } {
        // Convert screen coordinates to image coordinates
        const img_x = @as(i32, @intFromFloat((screen_x - self.sprite.rect.x) / self.sprite.scale));
        const img_y = @as(i32, @intFromFloat((screen_y - self.sprite.rect.y) / self.sprite.scale));
        return .{ .x = img_x, .y = img_y };
    }
};
