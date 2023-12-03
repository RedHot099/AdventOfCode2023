const std = @import("std");
const print = std.debug.print;
const expectEqual = std.testing.expectEqual;

pub fn main() !void {
    try part1();
}


pub fn part1() !void {
    var lines_iter = std.tokenizeScalar(u8, @embedFile("input.txt"), '\n');
    var sum: u32 = 0;
    while (lines_iter.next()) |line| {
        var first:u32 = 0;
        var last:u32 = 0;
        for (line) |c| {
            if (std.ascii.isDigit(c)) {
                if (first == 0){
                    first = c - '0';
                    last = c - '0';
                } else {
                    last = c - '0';
                }
            }
        }
        sum += first*10+last;
    }
    print("{}\n", .{sum});
}


pub fn part2() !void {
    const numbers = [_][]const u8{ "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"};

    var lines_iter = std.tokenizeScalar(u8, @embedFile("input.txt"), '\n');
    var sum:u32 = 0;

    while (lines_iter.next()) |line| {
        if (line.len == 0) continue;
        var first:u32 = null;
        var last:u32 = null;
        next_digit: for (0..line.len) |i| {
            if (std.ascii.isDigit(line[i])) {
                if (first == 0){
                    first = c - '0';
                    last = first;
                } else {
                    last = c - '0';
                }
                continue;
            }
            for(numbers, 1..) |number, digit| {
                if (i + number.len - 1 < line.len & std.mem.eql(u8, line[i..i+number.len], number)) {
                    if (first == 0){
                        first = @intCast(digit);
                        last = first;
                    } else {
                        last = @intCast(digit);
                    }
                    continue :next_digit;
                }
            }
        }
        std.debug.assert(first != null);
        sum += first*10+last;
    }
    print("{}\n", .{sum});
}


test "part 1" {
    const input =
        \\1abc2
        \\pqr3stu8vwx
        \\a1b2c3d4e5f
        \\treb7uchet
    ;
    try expectEqual(@as(u32, 142), part1(input));
}


test "part 2" {
    const input =
        \\two1nine
        \\eightwothree
        \\abcone2threexyz
        \\xtwone3four
        \\4nineeightseven2
        \\zoneight234
        \\7pqrstsixteen
    ;
    try expectEqual(@as(u32, 281), part2(input));
}