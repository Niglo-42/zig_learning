const std = @import("std");

const Packed = packed struct {a: u24, b: u8};

fn add(a: i32, b: i32) i32 
{
    return a + b;
}

pub fn main() void {
    var x: i32 = add(10, 42);
    x += 1;
    std.debug.print("hello i'm {x} years old\n", .{x});
    // const s = @sizeOf(Packed);
    std.debug.print("size = {d}\n", .{@sizeOf(Packed)});
    const items = [_]i32{1, 2, 3};
    for (items, 0..) |item, i|
    {
        std.debug.print("{d} at index {d}\n", .{item, i});
    }
    var i: i32 = 0;
    while (i < 10) 
    {
        defer i += 1;
        std.debug.print("i = {d}\n", .{i});
    }
    while (i < 20) : (i += 1)
    {
        std.debug.print("i = {d}\n", .{i});
    }
    for (0..5) |stuff| {
        std.debug.print("{d}", .{stuff});
    }
    const res = for (items) |item| {
        if (item == 3) break item;
    } else -1;
    std.debug.print("res= {d}", .{res});
    // zip python:
    // for (a, b) |x, y| {
    // code
    //}
    const val: ?i32 = null;
    std.debug.print("{?d}", .{val});
}
