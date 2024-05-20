const std = @import("std");
const c = @cImport(@cInclude("stdlib.h"));
const fs = std.fs;

const BatteryLevel = enum { None, Half, Low };
var battery_level_status = BatteryLevel.None;

inline fn notify(title: []const u8, battery_cap: u7) !void {
    var buffer: [100]u8 = undefined;
    const command = try std.fmt.bufPrintZ(&buffer, "notify-send \"{s}\" {d}%", .{ title, battery_cap });
    _ = c.system(command.ptr);
}

pub fn main() !void {
    const args = std.os.argv;
    if (args.len > 1) {
        var battery_capacity = try fs.openFileAbsolute("/sys/class/power_supply/BAT0/capacity", .{ .mode = .read_only });
        var buffer: [5]u8 = undefined;
        const read_bytes = try battery_capacity.read(buffer[0..]);
        battery_capacity.close();
        std.debug.print("Battery: {s}", .{buffer[0..read_bytes]});
        std.process.exit(0);
    }
    while (true) {
        var battery_capacity = try fs.openFileAbsolute("/sys/class/power_supply/BAT0/capacity", .{ .mode = .read_only });
        var battery_state = try fs.openFileAbsolute("/sys/class/power_supply/BAT0/status", .{ .mode = .read_only });

        var battery_capacity_buffer: [5]u8 = undefined;
        const battery_cap_read_bytes = try battery_capacity.read(battery_capacity_buffer[0..]);
        battery_capacity.close();

        var battery_state_buffer: [8]u8 = undefined;
        const battery_state_read_bytes = try battery_state.read(battery_state_buffer[0..]);
        battery_state.close();

        const battery_state_raw = battery_state_buffer[0..battery_state_read_bytes];
        const battery_state_str = std.mem.trim(u8, battery_state_raw, "\n");

        const battery_cap_raw = battery_capacity_buffer[0..battery_cap_read_bytes];
        const battery_cap_trim = std.mem.trim(u8, battery_cap_raw, "\n");
        const battery_level = try std.fmt.parseInt(u7, battery_cap_trim, 10);

        if (std.mem.eql(u8, battery_state_str, "Full")) {
            try notify("Battery is fully charged", battery_level);
        } else {
            switch (battery_level) {
                40...50 => {
                    if (battery_level_status != .Half) {
                        try notify("Battery is half", battery_level);
                        battery_level_status = .Half;
                    }
                },
                20...30 => {
                    if (battery_level_status != .Low) {
                        try notify("Battery is low", battery_level);
                        battery_level_status = .Low;
                    }
                },
                10...19 => {
                    try notify("Battery is almost empty", battery_level);
                },
                else => {},
            }
        }
        std.posix.nanosleep(60, 0);
    }
}
