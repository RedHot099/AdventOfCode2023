const std = @import("std");
const print = std.debug.print;
const expectEqual = std.testing.expectEqual;

pub fn main() !void {
    const input = @embedFile("input.txt");
    const result1: u32 = try part1(input);
    print("Day 2 part 1 result: {}\n", .{result1});
    const result2: u32 = try part2(input);
    print("Day 2 part 2 result: {}\n", .{result2});
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

pub fn findBefore(line: []const u8, star: usize) usize {
    var is_digit: bool = false;
    var start: usize = 0;
    for (line[0..star], 0..) |c, i| {
        switch (c) {
            '0'...'9' => {
                if (!is_digit) {
                    start = i;
                    is_digit = true;
                }
            },
            else => {
                is_digit = false;
            },
        }
    }
    return start;
}

pub fn findAfter(line: []const u8, star: usize) usize {
    var end: usize = 0;
    for (line[star..], star..) |c, i| {
        switch (c) {
            '0'...'9' => {
                end = i + 1;
            },
            else => {
                return end;
            },
        }
    }
    return line.len - 1;
}

pub fn numberInStr(line: []const u8, star: usize) !u32 {
    var start: usize = 0;
    var end: usize = 0;
    var left: bool = false;
    var right: bool = false;
    var center: bool = false;
    //check if number on the left side of gear
    if (star > 0) {
        if (std.ascii.isDigit(line[star - 1])) left = true;
    }
    //check if number on the right side of gear
    if (star < line.len) {
        if (std.ascii.isDigit(line[star + 1])) right = true;
    }
    //check if gear above/belov gear
    if (std.ascii.isDigit(line[star])) center = true;
    // print("{s} - l{} | c{} | r{}\n", .{ line, left, center, right });
    //if number above/below gear
    if (center) {
        //find begining before and end after
        if (left and right) {
            start = findBefore(line, star + 1);
            end = findAfter(line, star + 1);
            return try std.fmt.parseInt(u32, line[start..end], 10);
        } //find begining before and ends above/below
        else if (left) {
            start = findBefore(line, star + 1);
            return try std.fmt.parseInt(u32, line[start .. star + 1], 10);
        } //begins above/belov find end after
        else if (right) {
            end = findAfter(line, star + 1);
            return try std.fmt.parseInt(u32, line[star..end], 10);
        } //just one digit above/below
        else {
            // print("Return one char:{c}:\n", .{line[star]});
            return @as(u32, @intCast(line[star]));
        }
    }
    //if number on the left find its beginning
    if (left) {
        start = findBefore(line, star);
        return try std.fmt.parseInt(u32, line[start..star], 10);
    }
    //if number on the right find its end
    if (right) {
        end = findAfter(line, star + 1);
        return try std.fmt.parseInt(u32, line[star + 1 .. end], 10);
    }
    return 1;
}

pub fn part2(input: []const u8) !u32 {
    var lines_iter = std.mem.tokenizeScalar(u8, input, '\n');
    var sum: u32 = 0;
    var prev_line: ?[]const u8 = null;
    while (lines_iter.next()) |line| : (prev_line = line) {
        const next_line = lines_iter.peek();
        for (line, 0..) |c, i| {
            if (c != '*') continue;
            var parts: usize = 0;
            var ratio: u32 = 1;
            var tmp: u32 = 1;
            if (prev_line) |l| {
                tmp = try numberInStr(l, i);
                if (tmp > 1) {
                    // print("{}\n", .{tmp});
                    ratio *= tmp;
                    parts += 1;
                }
            }
            tmp = try numberInStr(line, i);
            if (tmp > 1) {
                // print("{}\n", .{tmp});
                ratio *= tmp;
                parts += 1;
            }
            if (next_line) |l| {
                tmp = try numberInStr(l, i);
                if (tmp > 1) {
                    // print("{}\n", .{tmp});
                    ratio *= tmp;
                    parts += 1;
                }
            }
            if (parts > 1) {
                // print("R{}\n", .{ratio});
                sum += ratio;
            }
        }
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
    try expectEqual(@as(u32, 4361), try part1(input));
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
    try expectEqual(@as(u32, 467835), try part2(input));
}
