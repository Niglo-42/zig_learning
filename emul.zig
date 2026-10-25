const std = @import("std");
const print = std.debug.print;


var regs: [8]u32 = @splat(0);

fn print_regs() void {
    for (regs, 0..regs.len) |reg, i| {
        print("{d}: {x:0>4}\n", .{i, reg});
    }
    print("\n", .{});
}

fn add(instr: []const u8) void {
    const reg_d = instr[1] >> 5;
    const reg_src1 = instr[1] >> 2 & 7;
    const reg_src2 = instr[1] & 3 | instr[2] >> 7;
    if (instr[0] & 128 != 0){
        regs[reg_d] = regs[reg_src1] + instr[3];
    }
    else {
        regs[reg_d] = regs[reg_src1] + regs[reg_src2];
    }
    
}

fn decode(instr: []const u8) void {
    switch (instr[0] & 0xf) {
        1 => {
            print("add", .{});
            add(instr);
        },
        2 => {
            print("sub", .{});
        },
        3 => {
            print("mul", .{});
        },
        else => print("shit", .{}),
    }
}

pub fn dump_hex(array: []const u8, range: usize) void {
    var i: usize = 0;
    while (i < array.len) : (i += range) {
        print("{X:0>4}: ", .{i});
        const end = @min(i + range, array.len);
        const instr = array[i..end];
        decode(instr);
        // for (array[i..end]) |byte| {
        //     print("{X:0>2} ", .{byte});
        // }
        print("\n", .{});
    }
    print_regs();
}

fn fetch_mem(ram: []u8, buffer: []u8) void {
    dump_hex(buffer, 4);
    ram[0] = 'a';
}

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    const args = try init.minimal.args.toSlice(arena);
    const opener = std.Io.Dir.cwd();
    var ram: [0x1000]u8 = undefined;
    @memset(&ram, 0);
    const file = try opener.openFile(init.io, args[1], .{});
    defer file.close(init.io);
    const stat = try file.stat(init.io);
    const size: u64 = stat.size;
    const buffer = try arena.alloc(u8, size);
    defer arena.free(buffer);
    const n = try file.readPositionalAll(init.io, buffer, 0);
    if (n != size){
        print("hoho problemo", .{});
    }
    fetch_mem(&ram, buffer);
}
