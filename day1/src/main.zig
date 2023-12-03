const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    try part1();
}


pub fn part1() !void {
    var file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();
    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var buf: [1024]u8 = undefined;
    var sum: u32 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
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
}