const neg = @import("ex04/ft_is_negative.zig");
const num = @import("ex03/ft_print_numbers.zig");
const rev_alpha = @import("ex02/ft_print_reverse_alphabet.zig");
const alpha = @import("ex01/ft_print_alphabet.zig");
const pchar = @import("ex00/ft_putchar.zig");
const print = std.debug.print;
const std = @import("std");
const b_comb = @import("ex05/ft_print_comb.zig");
const comb2 = @import("ex06/ft_print_comb2.zig");
const putnbr = @import("ex07/ft_putnbr.zig");
const ncomb = @import("ex08/ft_printn_comb.zig");

pub fn main() void {
    print("{c}\n", .{neg.ft_is_negative(-42)});
    num.ft_print_numbers();
    rev_alpha.ft_print_alphabet();
    alpha.ft_print_alphabet();
    pchar.ft_putchar('w');
    pchar.ft_putchar('\n');
    // b_comb.ft_print_comb();
    // comb2.ft_print_comb2();
    putnbr.ft_putnbr(--1);
    ncomb.ft_print_ncomb(10);
}
