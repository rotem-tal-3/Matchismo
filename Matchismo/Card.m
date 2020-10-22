//
//  Card.m
//  Matchismo
//
//  Created by Rotem Tal on 12/10/2020.
//

#import "Card.h"

@interface Card()

@end

@implementation Card

- (NSInteger)match:(NSArray<Card *> *)otherCards {
    NSInteger score = 0;
    for (Card *card in otherCards) {
        if([card.contents isEqualToString:self.contents]) {
            score++;
        }
    }
    return score;
}

- (NSString *)description {
    return self.contents;
}
@end
