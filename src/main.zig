const std = @import("std");
const print = std.debug.print;
const rl = @import("raylib");

const sprite = @import("sprite.zig");
const item = @import("item.zig");
const table = @import("table.zig");

pub fn main() anyerror!void {
    const screenWidth: i32 = 700;
    const screenHeight: i32 = 450;

    rl.initWindow(screenWidth, screenHeight, "Craftware");
    defer rl.closeWindow(); // Close window and OpenGL context

    var apple_item
        = try item.Item.init("assets/apple.png", 0, 0, 0.15, true);
    defer apple_item.deinit();

    var crafting_table = try table.Table.init("assets/crafting_table.png",
                225, 0, 1.75);
    crafting_table.sprite.rect.y = (screenHeight / 2) - (crafting_table.sprite.rect.height / 2);
    defer crafting_table.deinit();

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        // hex color #222222
        rl.clearBackground(rl.Color.init(34, 34, 34, 255));

        // ! input and update does nothing rn
        crafting_table.input();
        crafting_table.update();
        crafting_table.render();

        apple_item.input();
        // ! does nothing as of now
        apple_item.update();
        apple_item.render();
    }
}
