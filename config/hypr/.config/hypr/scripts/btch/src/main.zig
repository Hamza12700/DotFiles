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

inline fn getFile(name: []const u8, buffSize: usize) ![]u8 {
  const file = try fs.openFileAbsolute(name, .{});
  var buffer: [buffSize]u8 = undefined;

  const read_bytes = try file.read(buffer[0..]);
  const contents = buffer[0..read_bytes];
  file.close();

  return contents;
}

pub fn main() !void {
  const args = std.os.argv;
  if (args.len > 1) {
    const stdout = std.io.getStdOut().writer();
    const capacity = try getFile("/sys/class/power_supply/BAT0/capacity", 5);
    const state = try getFile("/sys/class/power_supply/BAT0/status", 10);

    if (std.mem.eql(u8, state, "Charging\n")) {
      try stdout.print("State: Charging\n", .{});
      try stdout.print("Battery: {s}", .{capacity});
      std.process.exit(0);
    }

    try stdout.print("Battery: {s}", .{capacity});
    std.process.exit(0);
  }

  while (true) {
    const battery_capacity = try getFile("/sys/class/power_supply/BAT0/capacity", 5);
    const battery_state = try getFile("/sys/class/power_supply/BAT0/status", 8);

    const battery_state_str = std.mem.trim(u8, battery_state, "\n");

    const battery_cap_trim = std.mem.trim(u8, battery_capacity, "\n");
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
