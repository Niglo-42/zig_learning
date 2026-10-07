const std = @import("std");
const print = std.debug.print;

pub fn ft_putchar(c: u8) void{
    print("{c}", .{c});
}
pub fn main() void {
    const c = 'm';
    ft_putchar(c);
}