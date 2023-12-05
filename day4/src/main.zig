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

pub fn part1(input: []const u8) !u32 {
    var lines_iter = std.mem.tokenizeScalar(u8, input, '\n');
    var sum: u32 = 0;
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    while (lines_iter.next()) |line| {
        //split game id with numbers
        var card_it = std.mem.splitSequence(u8, line, ": ");
        _ = card_it.next();
        //split winning numbers from elf numbers
        var numbers_it = std.mem.splitSequence(u8, card_it.next() orelse continue, " | ");
        var winning_numbers_it = std.mem.splitSequence(u8, numbers_it.next() orelse continue, " ");
        var elf_numbers_it = std.mem.splitSequence(u8, numbers_it.next() orelse continue, " ");
        //put elf numbers into hashmap
        var elf_numbers = std.StringHashMap(void).init(allocator);
        defer elf_numbers.deinit();
        while (elf_numbers_it.next()) |num| if (num.len > 0) try elf_numbers.put(num, {});
        //count how many winning numbers are in elfs numbers
        var points: u32 = 0;
        while (winning_numbers_it.next()) |num| {
            if (elf_numbers.contains(num)) points = if (points == 0) 1 else points * 2;
        }
        sum += points;
    }
    return sum;
}

pub fn part2(input: []const u8) !u32 {
    var lines_iter = std.mem.tokenizeScalar(u8, input, '\n');
    var sum: u32 = 0;
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    //put elf numbers into hashmap
    var elf_numbers = std.StringHashMap(void).init(allocator);
    defer elf_numbers.deinit();
    //put all cards into hashmap
    var card_counts = std.AutoHashMap(usize, u32).init(allocator);
    defer card_counts.deinit();
    var card_num: usize = 1;
    while (lines_iter.next()) |line| : (card_num += 1) {
        //clear elf numbers table
        elf_numbers.clearRetainingCapacity();
        //split game id with numbers
        var card_it = std.mem.splitSequence(u8, line, ": ");
        _ = card_it.next();
        //split winning numbers from elf numbers
        var numbers_it = std.mem.splitSequence(u8, card_it.next() orelse continue, " | ");
        var winning_numbers_it = std.mem.splitSequence(u8, numbers_it.next() orelse continue, " ");
        var elf_numbers_it = std.mem.splitSequence(u8, numbers_it.next() orelse continue, " ");
        while (elf_numbers_it.next()) |num| if (num.len > 0) try elf_numbers.put(num, {});
        //count how many winning numbers are in elfs numbers
        var points: u32 = 0;
        while (winning_numbers_it.next()) |num| {
            if (elf_numbers.contains(num)) points += 1;
        }

        const card_count: u32 = card_counts.get(card_num) orelse 1;
        for (0..points) |i| {
            const count: u32 = card_counts.get(card_num + 1 + i) orelse 1;
            try card_counts.put(card_num + 1 + i, card_count + count);
        }
        sum += card_count;
    }
    return sum;
}

test "part1 " {
    const input =
        \\Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
        \\Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
        \\Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
        \\Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
        \\Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
        \\Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    ;
    try expectEqual(@as(u32, 13), try part1(input));
}

test "part2 " {
    const input =
        \\Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
        \\Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
        \\Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
        \\Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
        \\Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
        \\Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    ;
    try expectEqual(@as(u32, 30), try part2(input));
}
