const std = @import("std");
const print = std.debug.print;
const expectEqual = std.testing.expectEqual;

pub fn main() !void {
    const input = @embedFile("input.txt");
    const result1: u32 = try part1(input);
    print("Day5 part 1 result: {}\n", .{result1});
}

pub fn part1(input: []const u8) !u32 {
    const Category = struct { seed: u32, changed: bool };
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var seeds_ids = std.AutoHashMap(u32, Category).init(allocator);
    defer seeds_ids.deinit();

    var lines_iter = std.mem.split(u8, input, "\n");
    var seeds_it = std.mem.split(u8, lines_iter.next() orelse "", ": ");
    _ = seeds_it.next();
    var seeds_nums = std.mem.split(u8, seeds_it.next() orelse "", " ");
    while (seeds_nums.next()) |seed| {
        try seeds_ids.put(try std.fmt.parseInt(u32, seed, 10), .{ .seed = try std.fmt.parseInt(u32, seed, 10), .changed = false });
    }
    var map: bool = false;
    while (lines_iter.next()) |line| {
        if (line.len == 0) {
            map = false;
            var iterator = seeds_ids.iterator();
            while (iterator.next()) |e| {
                try seeds_ids.put(e.key_ptr.*, .{ .seed = e.value_ptr.seed, .changed = false });
            }
        }
        if (std.mem.indexOf(u8, line, ":") orelse 0 > 0) {
            map = true;
            continue;
        }
        // print("{} -> {s}\n", .{ map, line });
        if (map) {
            var iterator = seeds_ids.iterator();
            while (iterator.next()) |e| {
                if (e.value_ptr.changed) continue;
                var range_it = std.mem.split(u8, line, " ");
                const destination = try std.fmt.parseInt(u64, range_it.next() orelse "0", 10);
                const source = try std.fmt.parseInt(u64, range_it.next() orelse "0", 10);
                const length = try std.fmt.parseInt(u64, range_it.next() orelse "0", 10);
                if (e.value_ptr.seed >= source and e.value_ptr.seed <= source + length) {
                    var diff = e.value_ptr.seed - source;
                    try seeds_ids.put(e.key_ptr.*, .{ .seed = @intCast(destination + diff), .changed = true });
                }
                // for (destination..destination + length, source..source + length) |d, s| {
                //     if (e.value_ptr.seed == @as(u32, @intCast(s))) {
                //         print("seed {}: {} => {}\n", .{ e.key_ptr.*, s, d });
                //         try seeds_ids.put(@intCast(e.key_ptr.*), .{ .seed = @intCast(d), .changed = true });
                //         continue :new_seed;
                //     }
                // }
            }
        }
    }
    var location: u32 = undefined;

    var iterator = seeds_ids.valueIterator();
    if (iterator.next()) |v| location = v.seed;
    while (iterator.next()) |v| {
        // print("{}\n", .{v.seed});
        if (v.seed < location) {
            location = v.seed;
        }
    }

    return location;
}

test "part1" {
    const input =
        \\seeds: 79 14 55 13
        \\
        \\seed-to-soil map:
        \\50 98 2
        \\52 50 48
        \\
        \\soil-to-fertilizer map:
        \\0 15 37
        \\37 52 2
        \\39 0 15
        \\
        \\fertilizer-to-water map:
        \\49 53 8
        \\0 11 42
        \\42 0 7
        \\57 7 4
        \\
        \\water-to-light map:
        \\88 18 7
        \\18 25 70
        \\
        \\light-to-temperature map:
        \\45 77 23
        \\81 45 19
        \\68 64 13
        \\
        \\temperature-to-humidity map:
        \\0 69 1
        \\1 0 69
        \\
        \\humidity-to-location map:
        \\60 56 37
        \\56 93 4
        \\
    ;
    try expectEqual(@as(u32, 35), try part1(input));
}
