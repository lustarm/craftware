const std = @import("std");
const rl = @import("raylib");

pub const Sprite = struct {
    texture: rl.Texture2D,
    rect: rl.Rectangle,

    // ! drag offset
    offset_x: f32,
    offset_y: f32,

    draggable: bool,
    dragging: bool,

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
            .offset_x = 0,
            .offset_y = 0,
            .draggable = true,
            .dragging = false,
        };
    }

    pub fn unload(self: *const Sprite) void {
        rl.unloadTexture(self.texture);
    }

    // ! will maybe return error later?
    pub fn update(self: *Sprite) void {
        self.drag();
    }

    pub fn drag(self: *Sprite) void {
        if(!self.draggable) {
            std.debug.print("ERROR: Trying to drag undraggable item\n", .{});
            return;
        }

        const mouse_pos = rl.getMousePosition();

        // When mouse is first pressed, calculate the offset
        if (rl.isMouseButtonPressed(rl.MouseButton.left)) {
            if (self.contains(mouse_pos)) {
                self.dragging = true;
                self.offset_x = self.rect.x - mouse_pos.x;
                self.offset_y = self.rect.y - mouse_pos.y;
            }
        }

        // While dragging, update position using the stored offset
        if (self.dragging and rl.isMouseButtonDown(rl.MouseButton.left)) {
            self.rect.x = mouse_pos.x + self.offset_x;
            self.rect.y = mouse_pos.y + self.offset_y;
        }

        // Stop dragging when mouse button is released
        if (rl.isMouseButtonReleased(rl.MouseButton.left)) {
            std.debug.print("Stopped dragging\n", .{});
            self.dragging = false;
        }
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
