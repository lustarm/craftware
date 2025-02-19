const std = @import("std");
const rl = @import("raylib");

const sprite = @import("sprite.zig");

pub const Table = struct {
    sprite: sprite.Sprite,

    // Table box
    start_x: f32,
    end_x: f32,

    start_y: f32,
    end_y: f32,

    pub fn init(path: [:0]const u8, x: f32, y: f32, scale: f32) !Table {
        const sprite_ = try sprite.Sprite.load(path, x, y, scale);

        return Table {
            .sprite = sprite_,
            .start_x = 252.0,
            .start_y = 132.0,
            .end_x = 435.0,
            .end_y = 315.0,
        };
    }

    pub fn deinit(self: *Table) void {
        self.sprite.unload();
    }

    pub fn input(_: *Table, _: *sprite.Sprite) void {
        // when a sprite is dragged over
        // check and see if its a valid
        // box, if so we will center the
        // sprite and put it in the box.
    }

    pub fn update(_: *Table) void {

    }

    pub fn render(self: *Table) void {
        self.sprite.render();
    }
};
