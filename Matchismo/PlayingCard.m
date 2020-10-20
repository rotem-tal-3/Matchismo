//
//  PlayingCard.m
//  Matchismo
//
//  Created by Rotem Tal on 12/10/2020.
//

#import "PlayingCard.h"
@interface PlayingCard()
@end
@implementation PlayingCard

@synthesize suit = _suit;
- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit])
    {
        _suit = suit;
    }
}
-(NSString *)suit
{
    return _suit ? _suit : @"?";
}
- (NSString *)contents
{
    return [[PlayingCard rankStrings][self.rank + 1] stringByAppendingString:self.suit];
}
+ (NSArray<NSString *> *) rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}
+ (NSUInteger) maxRank
{
    return [[PlayingCard rankStrings] count] - 1;
}
- (void)setRank:(NSUInteger)rank
{
    if (rank < [PlayingCard maxRank])
    {
        _rank = rank;
    }
}
- (int)match:(NSArray *)otherCards
{
    int score = 0;
    for (PlayingCard* otherCard in otherCards) {
        if (self.rank == otherCard.rank) {
            score = 4;
        }
        if ([self.suit isEqualToString:otherCard.suit])
        {
            score = 1;
        }
        if (score)
        {
            break;
        }
    }
    return score;
}
+ (NSArray<NSString *> *) validSuits
{
    return @[@"♥️"
             ,@"♦️"
             ,@"♣️"
             ,@"♠️"];
}
@end
