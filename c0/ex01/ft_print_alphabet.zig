const std = @import("std");
const print = std.debug.print;

pub fn ft_print_alphabet() void{
    var c: u8 = 'a';
    for (0..26) |_|{
        print("{c}", .{c});
        c += 1;
    }
    print("\n", .{});
}