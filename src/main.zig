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

        // ! change this to game loop and
        // ! just have sprite update
        apple_sprite.update();
    }

}
