const std = @import("std");
const print = std.debug.print;

pub fn main(init: std.process.Init) void {
    var args = init.minimal.args.iterate();

    const prog_name = args.next();
    _ = prog_name;

    while (args.next()) |arg|{
        print("{s}\n", .{arg});
    }
}