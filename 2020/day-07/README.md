# Day 7: Handy Haversacks
You land at the regional airport in time for your next flight. In fact, it looks like you'll even have time to grab some food: all flights are currently delayed due to issues in luggage processing.

Due to recent aviation regulations, many rules (your puzzle input) are being enforced about bags and their contents; bags must be color-coded and must contain specific quantities of other color-coded bags. Apparently, nobody responsible for these regulations considered how long they would take to enforce!

For example, consider the following rules:

```
light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.
```

These rules specify the required contents for 9 bag types. In this example, every faded blue bag is empty, every vibrant plum bag contains 11 bags (5 faded blue and 6 dotted black), and so on.

You have a shiny gold bag. If you wanted to carry it in at least one other bag, how many different bag colors would be valid for the outermost bag? (In other words: how many colors can, eventually, contain at least one shiny gold bag?)

In the above rules, the following options would be available to you:

```
A bright white bag, which can hold your shiny gold bag directly.
A muted yellow bag, which can hold your shiny gold bag directly, plus some other bags.
A dark orange bag, which can hold bright white and muted yellow bags, either of which could then hold your shiny gold bag.
A light red bag, which can hold bright white and muted yellow bags, either of which could then hold your shiny gold bag.
So, in this example, the number of bag colors that can eventually contain at least one shiny gold bag is 4.
```

## Problem 1

How many bag colors can eventually contain at least one shiny gold bag? (The list of rules is quite long; make sure you get all of it.)

Your puzzle answer was 348.

## Part Two

It's getting pretty expensive to fly these days - not because of ticket prices, but because of the ridiculous number of bags you need to buy!

Consider again your shiny gold bag and the rules from the above example:

```
faded blue bags contain 0 other bags.
dotted black bags contain 0 other bags.
vibrant plum bags contain 11 other bags: 5 faded blue bags and 6 dotted black bags.
dark olive bags contain 7 other bags: 3 faded blue bags and 4 dotted black bags.
```

So, a single shiny gold bag must contain 1 dark olive bag (and the 7 bags within it) plus 2 vibrant plum bags (and the 11 bags within each of those): 1 + 1*7 + 2 + 2*11 = 32 bags!

Of course, the actual rules have a small chance of going several levels deeper than this example; be sure to count all of the bags, even if the nesting becomes topologically impractical!

Here's another example:

```
shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags.
```

In this example, a single shiny gold bag must contain 126 other bags.

## Problem 2 
How many individual bags are required inside your single shiny gold bag?

Your puzzle answer was 18885.

# Perl solution

## Problem 1

There are two parts to this solution: part 1 parse the rules file, part apply the rules to work out the solution.

Regex's easily parse the lines of text - we need (this time) to create a 2-layer hash - with the first key being the colour of the bag contained in the bag with the second key

We then just start with the `shiny gold` bag and work our way through the hash to find out which bags it can be contained in - naively we could attack this as a recursive problem,
but we can also look at this as a "queue" to avoid confusion.

We keep a list of the colour of bags which contain `shiny gold` or which contain bags that can contain `shiny gold`. If we find a new colour we push it onto the queue of bags to check, and repeat for every bag in the queue until we empty the queue.

We can encapsulate this in a single line of perl - which I will have to apologies is one of the worst abuses of syntactic sugar I have made for some time!

```perl
    map { $bag_colours{$_} ++ || push @queue,$_ } keys %{$rev_map->{$_}||{}} while $_ = shift @queue;
```

 * `map` should return an array - but we are making it run a loop within the while loop.
 * We are using `++` && `||` to perform an `if( $bag_colour{$_} ) { $bag_colours{$_}=1; push @queue, $_ }`

So normally you would need to wrap these in `{ }` loops. But by using `map` to replace `foreach` && `$a || b()` to run `if(!$a) { b() }` we can avoid this.

## Problem 2

In someways is a slightly easier problem - probably because we are pushed down the recursive route.

The only "cool" perlism is in:

```perl
    my %colours = reverse $pt2 =~ m{(\d+) (.*?) bags?}g ;
```

This parses out the colours and the quantities in pairs - so we get an array like `[1, 'red', 2, 'blue', 3, 'green']` but we want keys and values interchanged - we can do this by just reversing the array to get `['green', 3, 'blue', 2, 'red', 1]` and then allocating this to a hash.