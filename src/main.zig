const std = @import("std");
const rl = @import("raylib");

const sprite = @import("sprite.zig");

pub fn main() anyerror!void {
    const screenWidth = 700;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "Craftware");
    defer rl.closeWindow(); // Close window and OpenGL context

    var apple_sprite
        = try sprite.Sprite.load("assets/apple.png", 0, 0, 0.15, true);
    defer apple_sprite.unload();

    var crafting_table_sprite =
        try sprite.Sprite.load("assets/crafting_table.png", 350, screenHeight/2, 1, false);
    defer crafting_table_sprite.unload();

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        // hex color #222222
        rl.clearBackground(rl.Color.init(34, 34, 34, 255));

        crafting_table_sprite.render();

        apple_sprite.update();
        apple_sprite.render();
    }
}
