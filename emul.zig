const std = @import("std");
const print = std.debug.print;


var regs: [32]u32 = @splat(0);

fn print_regs() void {
    for (regs, 0..regs.len) |reg, i| {
        print("R{d}: 0x{x:0>8}\n", .{i, reg});
    }
    print("\n", .{});
}

fn op_R(instr: u32, f: fn(u32, u32) u32) void {
    const reg_d = (instr >> 7) & 0b11111;
    const reg_src1 = (instr >> 15) & 0b11111;
    const reg_src2 = (instr >> 20) & 0b11111;
    regs[reg_d] = f(regs[reg_src1], regs[reg_src2]);
}

fn op_I(instr: u32, f: fn(u32, u32) u32) void {
    const reg_d = (instr >> 7) & 0b11111;
    const reg_src1 = (instr >> 15) & 0b11111;
    const imm12: u12 = @truncate(instr >> 20);
    const imm: u32 = @bitCast(@as(i32, @as(i12, @bitCast(imm12))));
    regs[reg_d] = f(regs[reg_src1], imm);
}

fn op_B(instr: u32, f: fn(u32, u32) u32) void {
    const reg_d = (instr >> 7) & 0b11111;
    const reg_src1 = (instr >> 15) & 0b11111;
    const imm12: u12 = @truncate(instr >> 20);
    const imm: u32 = @bitCast(@as(i32, @as(i12, @bitCast(imm12))));
    regs[reg_d] = f(regs[reg_src1], imm);
}

pub fn add(a: u32, b: u32) u32 {
    return a +% b;
}

pub fn sub(a: u32, b: u32) u32 {
    return a -% b;
}

pub fn xor(a: u32, b: u32) u32 {
    return a ^ b;
}

pub fn or_(a: u32, b: u32) u32 {
    return a | b;
}

pub fn and_(a: u32, b: u32) u32 {
    return a & b;
}

pub fn sll(a: u32, b: u32) u32 {
    const shift: u5 = @truncate(b);
    return a << shift;
}

pub fn srl(a: u32, b: u32) u32 {
    const shift: u5 = @truncate(b);
    return a >> shift;
}

pub fn slt(a: u32, b: u32) u32 {
    if (a < b)
    {
        return 1;
    }
    return 0;
}

pub fn sltu(a: u32, b: u32) u32 {
    if (a < b)
    {
        return 1;
    }
    return 0;
}

pub fn sra(a: u32, b: u32) u32 {
    const shift: u5 = @truncate(b);
    const res = a >> shift;
    if (a >> 31 == 1)
    {
        const mask = ~(@as(u32, 0xffffffff) >> shift);
        return res | mask;
    }
    return res;
}

pub fn not_(a: u32) u32 {
    return ~a;
}

const KIND = enum(u7) {
    R =         0x33,
    I =         0x13,
    B =         0x63,
    J =         0x6f,
    SYSCALL =   0x73,
    S =         0x23,
    LOAD =      0x03,
    U =         0x07
};

const DATATYPE = enum(u8) {
    INT     = 0,
    SHORT   = 1,
    CHAR    = 2,
    UINT    = 3,
    USHORT  = 4,
    UCHAR   = 5,
};

const OP_R_I = enum(u3) {
    ADD =   0,
    AND =   7,
    OR =    6,
    XOR =   4,
    SLL =   1,
    SLT =   2,
    SLTU =  3,
    // SRA =   5, // warning also has 0x40005030
    SRL =   5
};

const OP_B = enum(u3) {
    BEQ =   0,
    BGE =   5,
    BGEU =  7,
    BLT =   4,
    BLTU =  6,
    BNE =   1
};

const OP_LOAD = enum(u3) {
    LB =    0,
    LH =    1,
    LW =    2,
    LBU =   4,
    LHU =   5
};

const OP_STORE = enum(u3) {
    SB =    0,
    SH =    1,
    SW =    2
};

fn disassembly(command: u32, kind: KIND) void {
    const opcode: u3 = @truncate(command >> 12);
    const rd: u5 = @truncate(command >> 7);
    const rs1: u5 = @truncate(command >> 15);
    const op: OP_R_I = @enumFromInt(opcode);
    const instru = @tagName(op);
    if (kind == KIND.R){
        const rs2: u5 = @truncate(command >> 20);
        print("{s} r{d}, r{d}, r{d} ", .{instru, rd, rs1, rs2});
    }
    else if (kind == KIND.I){
        const imm12: u12 = @truncate(command >> 20);
        const imm: i12 = @bitCast(imm12);
        print("{s} r{d}, r{d}, #{d} ", .{instru, rd, rs1, imm});
    } 
}

fn decode(instr: []const u8, little_endian: bool) void {
    var command: u32 = 0;
    if (little_endian)
    {
        for (0..4) |i| {
            var b: u32 = instr[i];
            const shift: u5 = @truncate(i * 8);
            b <<= shift;
            command |= b;
        }
    }
    else {
        for (instr) |byte| {
            command <<= 8;
            command |= byte;
        }
    }

    const kind: u7 = @truncate(command & 0x7f);
    const opcode: u3 = @truncate(command >> 12);
    // std.process.exit(1);
    disassembly(command, @enumFromInt(kind));
    switch (@as(KIND, @enumFromInt(kind))) {
        KIND.R => 
        {
            switch (@as(OP_R_I, @enumFromInt(opcode)) )
            {
                OP_R_I.ADD => 
                {
                    op_R(command, add);
                },
                OP_R_I.AND =>
                {
                    op_R(command, and_);
                },
                OP_R_I.OR =>
                {
                    op_R(command, or_);
                },
                OP_R_I.XOR =>
                {
                    op_R(command, xor);
                },
                OP_R_I.SLL =>
                {
                    op_R(command, sll);
                },
                OP_R_I.SRL =>
                {
                    const x: u1 = @truncate(command >> 30);
                    if (x == 1)
                    {
                        op_R(command, sra);
                    }
                    else 
                    {
                        op_R(command, srl);
                    }
                },
                OP_R_I.SLT =>
                {
                    op_R(command, slt);
                },
                OP_R_I.SLTU =>
                {
                    op_R(command, sltu);
                },
            }
        },
        KIND.I => {

            switch (@as(OP_R_I, @enumFromInt(opcode)) )
            {
                OP_R_I.ADD => 
                {
                    op_I(command, add);
                },
                OP_R_I.AND =>
                {
                    op_I(command, and_);
                },
                OP_R_I.OR =>
                {
                    op_I(command, or_);
                },
                OP_R_I.XOR =>
                {
                    op_I(command, xor);
                },
                OP_R_I.SLL =>
                {
                    op_I(command, sll);
                },
                OP_R_I.SRL =>
                {
                    const x: u1 = @truncate(command >> 30);
                    if (x == 1)
                    {
                        op_I(command, sra);
                    }
                    else 
                    {
                        op_I(command, srl);
                    }
                },
                OP_R_I.SLT =>
                {
                    op_I(command, slt);
                },
                OP_R_I.SLTU =>
                {
                    op_I(command, sltu);
                },
            }

        },
        KIND.B => {
            if (kind & 0xf > 1){
                //kind.J
            }
        },
        KIND.SYSCALL => {

        },
        KIND.S => {

        },
        KIND.LOAD => {

        },
        KIND.U => {

        },
        else => 
        {
            print("shit", .{});
        }
    }
}

pub fn dump_hex(array: []const u8, range: usize) void {
    var pc: usize = 0;
    while (pc < array.len) : (pc += range) {
        print("{X:0>4}: ", .{pc});
        const end = @min(pc + range, array.len);
        const instr = array[pc..end];
        decode(instr, true);
        print("\n", .{});
    }
    print_regs();
}

fn fetch_mem(ram: []u8, buffer: []u8) void {
    dump_hex(buffer, 4);
    _ = ram[0];
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
