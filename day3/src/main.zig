const std = @import("std");
const print = std.debug.print;
const expectEqual = std.testing.expectEqual;

pub fn main() !void {
    const input = @embedFile("input.txt");
    const result1: u32 = try part1(input);
    print("Day 2 part 1 result: {}\n", .{result1});
    // const result2: u32 = try part2(input);
    // print("Day 2 part 2 result: {}\n", .{result2});
}

pub fn isSymbol(slice: []const u8) bool {
    if (slice.len == 0) return false;
    for (slice) |c| {
        switch (c) {
            '0'...'9', '.' => {},
            else => return true,
        }
    }
    return false;
}

pub fn part1(input: []const u8) !u32 {
    var lines_iter = std.mem.tokenizeScalar(u8, input, '\n');
    var sum: u32 = 0;
    var prev_line: ?[]const u8 = null;
    while (lines_iter.next()) |line| : (prev_line = line) {
        const next_line = lines_iter.peek();
        var parser = std.fmt.Parser{ .buf = line };
        while (std.mem.indexOfAnyPos(u8, parser.buf, parser.pos, "0123456789")) |pos| {
            parser.pos = pos;
            const number: u32 = @intCast(parser.number().?);
            const start = if (pos > 0) pos - 1 else 0;
            const end = @min(parser.buf.len, parser.pos + 1);
            //check for symbol on the left
            if (pos > 0 and isSymbol(line[start..pos])) {
                sum += number;
                continue;
            }
            //check for symbol on the right
            if (parser.pos < line.len and isSymbol(line[pos..end])) {
                sum += number;
                continue;
            }
            //check for symbol above
            if (prev_line) |l| {
                if (isSymbol(l[start..end])) {
                    sum += number;
                    continue;
                }
            }
            //check for symbol belov
            if (next_line) |l| {
                if (isSymbol(l[start..end])) {
                    sum += number;
                    continue;
                }
            }
        }
    }
    return sum;
}

// pub fn part2(input: []const u8) !u32 {
//     var lines_iter = std.mem.tokenizeScalar(u8, input, '\n');
//     var sum: u32 = 0;

//     while (lines_iter.next()) |line| {
//         _ = line;
//     }
//     return sum;
// }

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
    try expectEqual(@as(u32, 4361), try part1(input));
}

// test "part2 " {
//     const input =
//         \\467..114..
//         \\...*......
//         \\..35..633.
//         \\......#...
//         \\617*......
//         \\.....+.58.
//         \\..592.....
//         \\......755.
//         \\...$.*....
//         \\.664.598..
//     ;
//     try expectEqual(@as(u32, 2286), try part2(input));
// }
