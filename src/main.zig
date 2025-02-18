// raylib-zig (c) Nikolas Wipper 2023

const std = @import("std");
const rl = @import("raylib");

const sprite = @import("sprite.zig");

pub fn main() anyerror!void {
    const screenWidth = 450;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "Craftware");
    defer rl.closeWindow(); // Close window and OpenGL context

    var apple_sprite = try sprite.Sprite.load("assets/apple.png");
    defer apple_sprite.unload();


    //const apple_original_origin = rl.Vector2 {
    //    .x = apple_sprite.rect.x, .y = apple_sprite.rect.y
    //};

    var offset_x: f32 = 0;
    var offset_y: f32 = 0;
    var is_dragging: bool = false;

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        // hex color #222222
        rl.clearBackground(rl.Color.init(34, 34, 34, 255));

        rl.drawTexture(
            apple_sprite.texture,
            @intFromFloat(apple_sprite.rect.x),
            @intFromFloat(apple_sprite.rect.y),
            rl.Color.white
        );

        const mouse_pos = rl.getMousePosition();

        // When mouse is first pressed, calculate the offset
        if (rl.isMouseButtonPressed(rl.MouseButton.left)) {
            if (apple_sprite.contains(mouse_pos)) {
                is_dragging = true;
                offset_x = apple_sprite.rect.x - mouse_pos.x;
                offset_y = apple_sprite.rect.y - mouse_pos.y;
            }
        }

        // While dragging, update position using the stored offset
        if (is_dragging and rl.isMouseButtonDown(rl.MouseButton.left)) {
            apple_sprite.rect.x = mouse_pos.x + offset_x;
            apple_sprite.rect.y = mouse_pos.y + offset_y;
        }

        // Stop dragging when mouse button is released
        if (rl.isMouseButtonReleased(rl.MouseButton.left)) {
            is_dragging = false;
        }
    }

}
