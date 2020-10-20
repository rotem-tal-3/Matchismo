//
//  PlayingCardDeck.m
//  Matchismo
//
//  Created by Rotem Tal on 12/10/2020.
//

#import "PlayingCardDeck.h"

@implementation PlayingCardDeck
- (instancetype)init
{
    if (self = [super init])
    {
        for (NSString *suit in [PlayingCard validSuits])
        {
            for (NSUInteger rank = 1;rank <= [PlayingCard maxRank];rank++) {
                PlayingCard *card= [[PlayingCard alloc] init];
                card.rank = rank;
                card.suit = suit;
                [self addCard:card];
            }
        }
    }
    return self;
}
@end
