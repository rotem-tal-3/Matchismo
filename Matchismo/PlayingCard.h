//
//  PlayingCard.h
//  Matchismo
//
//  Created by Rotem Tal on 12/10/2020.
//

#import <Foundation/Foundation.h>
#import "Card.h"
NS_ASSUME_NONNULL_BEGIN

@interface PlayingCard : Card
@property (strong, nonatomic) NSString	*suit;
@property (nonatomic) NSUInteger rank;
+ (NSArray *) validSuits;
+ (NSUInteger) maxRank;
@end

NS_ASSUME_NONNULL_END
