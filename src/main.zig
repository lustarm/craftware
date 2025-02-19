const std = @import("std");
const rl = @import("raylib");

const sprite = @import("sprite.zig");
const item = @import("item.zig");

pub fn main() anyerror!void {
    const screenWidth: i32 = 700;
    const screenHeight: i32 = 450;

    rl.initWindow(screenWidth, screenHeight, "Craftware");
    defer rl.closeWindow(); // Close window and OpenGL context

    var apple_sprite
        = try item.Item.init("assets/apple.png", 0, 0, 0.15, true);
    defer apple_sprite.deinit();

    var crafting_table_sprite =
        try sprite.Sprite.load("assets/crafting_table.png",
                300, 0, 1.5);
    crafting_table_sprite.rect.y = (screenHeight - (crafting_table_sprite.rect.width / 2)) / 2;
    defer crafting_table_sprite.unload();

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        // hex color #222222
        rl.clearBackground(rl.Color.init(34, 34, 34, 255));

        crafting_table_sprite.render();

        apple_sprite.input();
        // ! does nothing as of now
        apple_sprite.update();
        apple_sprite.render();
    }
}
