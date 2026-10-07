const std = @import("std");
const print = std.debug.print;

fn backtrack(nb: []u8, pos: usize, start: usize, len: usize) void {
    if (pos == len) {
        print("{s}\n", .{nb});
        return;
    }
    for (start..10) |i| {
        nb[pos] = '0' + @as(u8, @intCast(i));
        backtrack(nb, pos + 1, @as(u8, @intCast(i)) + 1, len);
    }
}

pub fn ft_print_ncomb(n: usize) void {
    var nb: [11]u8 = undefined;
    nb[n] = 0;
    backtrack(&nb, 0, 0, n);
}
