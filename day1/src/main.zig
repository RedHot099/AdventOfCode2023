const std = @import("std");
const print = std.debug.print;
const expectEqual = std.testing.expectEqual;

pub fn main() !void {
    const input = @embedFile("input.txt");
    const result1:u32 = part1(input);
    print("Day 1 part 1 result: {}\n", .{result1});
    const result2:u32 = part2(input);
    print("Day 1 part 2 result: {}\n", .{result2});
}


pub fn part1(input: []const u8) u32  {
    var lines_iter = std.mem.tokenizeScalar(u8, input, '\n');
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
    return sum;
}


pub fn part2(input: []const u8) u32 {
    const numbers = [_][]const u8{ "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"};

    var lines_iter = std.mem.tokenizeScalar(u8, input, '\n');
    var sum:u32 = 0;

    while (lines_iter.next()) |line| {
        if (line.len == 0) continue;
        var first:u32 = 10;
        var last:u32 = 10;
        next_digit: for (0..line.len) |i| {
            if (std.ascii.isDigit(line[i])) {
                if (first == 10){
                    first = line[i] - '0';
                    last = first;
                } else {
                    last = line[i] - '0';
                }
                continue;
            }
            for(numbers, 0..) |number, digit| {
                if ((i + number.len - 1 < line.len) and std.mem.eql(u8, line[i..i+number.len], number)) {
                    if (first == 10){
                        first = @intCast(digit);
                        last = first;
                    } else {
                        last = @intCast(digit);
                    }
                    continue :next_digit;
                }
            }
        }
        sum += first*10+last;
    }
    return sum;
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