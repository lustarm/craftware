// raylib-zig (c) Nikolas Wipper 2023

const std = @import("std");
const rl = @import("raylib");

const sprite = @import("sprite.zig");

pub fn main() anyerror!void {
    const screenWidth = 600;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "Craftware");
    defer rl.closeWindow(); // Close window and OpenGL context

    var apple_sprite = try sprite.Sprite.load("assets/apple.png");
    defer apple_sprite.unload();

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        // input update render

        // hex color #222222
        rl.clearBackground(rl.Color.init(34, 34, 34, 255));

        apple_sprite.update();

        rl.drawTextureEx(
            apple_sprite.texture,
            rl.Vector2 {
                .x = apple_sprite.rect.x,
                .y = apple_sprite.rect.y,
            },
            0.0, // rotation
            apple_sprite.scale,
            rl.Color.white,
        );
    }
}
