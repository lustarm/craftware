const std = @import("std");
const rl = @import("raylib");

const sprite = @import("sprite.zig");

pub const Table = struct {
    sprite: sprite.Sprite,

    pub fn init(path: [:0]const u8, x: f32, y: f32, scale: f32) !Table {
        const sprite_ = try sprite.Sprite.load(path, x, y, scale);

        return Table {
            .sprite = sprite_,
        };
    }

    pub fn deinit(self: *Table) void {
        self.sprite.unload();
    }

    pub fn input(_: *Table) void {}

    pub fn update(_: *Table) void {}

    pub fn render(self: *Table) void {
        self.sprite.render();
    }
};
