const std = @import("std");
const print = std.debug.print;

pub fn ft_print_comb2() void {
    var a : u16 = 0;
    var b : u16 = 0;
    while (a < 100) : (a += 1){
        b = a + 1;
        while (b < 100) : (b += 1){
            if (a < 10){
                print("0", .{});
            }
            print("{d} ", .{a});
            if (b < 10){
                print("0", .{});
            }
            if (a != 98){
                print("{d} ,", .{b});
            }
            else {
                print("{d}\n", .{b});
            }
        }
    }
}