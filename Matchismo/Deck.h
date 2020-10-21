//
//  Deck.h
//  Matchismo
//
//  Created by Rotem Tal on 12/10/2020.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Card;

@interface Deck : NSObject
- (void)addCard:(Card *)card;
- (NSUInteger)count;
- (Card *)drawRandomCard;
@end

NS_ASSUME_NONNULL_END
