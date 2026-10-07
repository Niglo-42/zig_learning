const std = @import("std");
const print = std.debug.print;


fn recur(n: i64) void {
    if (n < 10){
        const c: u8 = @intCast(n + 48);
        print("{c}", .{c});
        return;
    }
    recur(@divTrunc(n, 10));
    const c: u8 = @intCast(@mod(n, 10) + 48);
    print("{c}", .{c});
}

pub fn ft_putnbr(n: i32) void {
    var nb: i64 = n;
    if (n < 0){
        nb = -nb;
        print("-", .{});
    }
    recur(nb);
    print("\n", .{});
}