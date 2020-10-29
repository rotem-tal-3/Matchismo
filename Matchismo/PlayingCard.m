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


- (NSInteger)match:(NSArray *)otherCards {
    NSInteger score = 0;
    for (PlayingCard* otherCard in otherCards) {
        if (self.rank == otherCard.rank) {
            score = 4;
        }
        if ([self.suit isEqualToString:otherCard.suit]) {
            score = 1;
        }
    }
    
    return score;
}


#pragma mark - Card constants

+ (NSArray<NSString *> *) validSuits {
    return @[@"♥️" ,@"♦️" ,@"♣️" ,@"♠️"];
}

+ (NSUInteger) maxRank {
    return [[PlayingCard rankStrings] count] - 1;
}

+ (NSArray<NSString *> *) rankStrings {
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}


#pragma mark - Properties

@synthesize suit = _suit;
- (void)setSuit:(NSString *)suit {
    if ([[PlayingCard validSuits] containsObject:suit])
    {
        _suit = suit;
    }
}

-(NSString *)suit {
    return _suit ? _suit : @"?";
}

- (void)setRank:(NSUInteger)rank {
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

-(NSString *)description {
  return [NSString stringWithFormat:@"%lu%@", self.rank,self.suit];
}

- (NSString *)contents {
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}
@end
