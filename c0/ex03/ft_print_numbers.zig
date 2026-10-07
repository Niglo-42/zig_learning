const std = @import("std");
const print = std.debug.print;

pub fn ft_print_numbers() void{

    for (0..10) |i|{
        print("{d}", .{i});
    }
    print("\n", .{});
}