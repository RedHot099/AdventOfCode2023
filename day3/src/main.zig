const std = @import("std");
const print = std.debug.print;
const expectEqual = std.testing.expectEqual;

pub fn main() !void {
    const input = @embedFile("input.txt");
    const result1:u32 = try part1(input);
    print("Day 2 part 1 result: {}\n", .{result1});
    const result2:u32 = try part2(input);
    print("Day 2 part 2 result: {}\n", .{result2});
}

pub fn part1(input: []const u8) !u32 {
    var lines_iter = std.mem.tokenizeScalar(u8, input, '\n');
    var sum: u32 = 0;
    
    while (lines_iter.next()) |line| {
    }
    return sum;
}

pub fn part2(input: []const u8) !u32 {
    var lines_iter = std.mem.tokenizeScalar(u8, input, '\n');
    var sum: u32 = 0;
    
    while (lines_iter.next()) |line| {
    }
    return sum;
}

test "part1 " {
    const input =
        \\467..114..
        \\...*......
        \\..35..633.
        \\......#...
        \\617*......
        \\.....+.58.
        \\..592.....
        \\......755.
        \\...$.*....
        \\.664.598..
    ;
    try expectEqual(@as(u32, 8), try part1(input));
}


test "part2 " {
    const input =
        \\467..114..
        \\...*......
        \\..35..633.
        \\......#...
        \\617*......
        \\.....+.58.
        \\..592.....
        \\......755.
        \\...$.*....
        \\.664.598..
    ;
    try expectEqual(@as(u32, 2286), try part2(input));
}
