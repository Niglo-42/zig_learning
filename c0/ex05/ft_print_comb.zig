const std = @import("std");
const print = std.debug.print;

fn backtrack(nb: []u8, pos: usize, start: usize) void {
    const n = nb.len - 1;
    if (pos == n) {
        nb[n] = 0;
        print("{s}\n", .{nb});
        return;
    }
    for (start..10) |i| {
        nb[pos] = '0' + @as(u8, @intCast(i));
        backtrack(nb, pos + 1, @as(u8, @intCast(i)) + 1);
    }
}

pub fn ft_print_comb() void {
    const n: usize = 3;
    var nb: [n + 1]u8 = undefined;
    backtrack(&nb, 0, 0);
}
