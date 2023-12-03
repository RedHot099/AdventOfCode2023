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
    const max_red: u8 = 12;
    const max_green: u8 = 13;
    const max_blue: u8 = 14;
    
    new_game: while (lines_iter.next()) |line| {
        var game_no: u8 = 0;
        var splits = std.mem.split(u8, line, ": ");
        while (splits.next()) |part| {
            if(part[0] == 'G') {
                game_no = try std.fmt.parseInt(u8, part[5..], 10);
            } else {
                var sets = std.mem.split(u8, part, "; ");
                while(sets.next()) |set| {
                    var colors = std.mem.split(u8, set, ", ");
                    while(colors.next()) |color| {
                        var cubes = std.mem.split(u8, color, " ");
                        var count:u8 = 0;
                        while(cubes.next()) |cube| {
                            switch(cube[0]) {
                                'r' => {
                                    if (count > max_red) continue: new_game;
                                },
                                'g' => {
                                    if (count > max_green) continue: new_game;
                                },
                                'b' => {
                                    if (count > max_blue) continue: new_game;
                                },
                                else => {
                                    count = try std.fmt.parseInt(u8, cube, 10);
                                }
                            }

                        }
                    }
                }
                sum += @intCast(game_no);
            }
        }
    }
    return sum;
}

pub fn part2(input: []const u8) !u32 {
    var lines_iter = std.mem.tokenizeScalar(u8, input, '\n');
    var sum: u32 = 0;
    
    while (lines_iter.next()) |line| {
        var min_red:u32 = 0;
        var min_green:u32 = 0;
        var min_blue:u32 = 0;
        var splits = std.mem.split(u8, line, ": ");
        while (splits.next()) |part| {
            if(part[0] == 'G') {
            } else {
                var sets = std.mem.split(u8, part, "; ");
                while(sets.next()) |set| {
                    var colors = std.mem.split(u8, set, ", ");
                    while(colors.next()) |color| {
                        var cubes = std.mem.split(u8, color, " ");
                        var count:u8 = 0;
                        while(cubes.next()) |cube| {
                            switch(cube[0]) {
                                'r' => {
                                    if (count > min_red) min_red = @intCast(count);
                                },
                                'g' => {
                                    if (count > min_green) min_green = @intCast(count);
                                },
                                'b' => {
                                    if (count > min_blue) min_blue = @intCast(count);
                                },
                                else => {
                                    count = try std.fmt.parseInt(u8, cube, 10);
                                }
                            }
                        }
                    }
                }
                sum += min_red*min_green*min_blue;
            }
        }
    }
    return sum;
}

test "part1 " {
    const input =
        \\Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        \\Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        \\Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        \\Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        \\Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    ;
    try expectEqual(@as(u32, 8), try part1(input));
}


test "part2 " {
    const input =
        \\Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        \\Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        \\Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        \\Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        \\Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    ;
    try expectEqual(@as(u32, 2286), try part2(input));
}
