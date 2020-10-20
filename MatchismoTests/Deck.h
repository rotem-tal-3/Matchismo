//
//  Deck.h
//  Matchismo
//
//  Created by Rotem Tal on 12/10/2020.
//

#import <Foundation/Foundation.h>
#import "Card.h"
NS_ASSUME_NONNULL_BEGIN

@interface Deck : NSObject
-(void)addCard:(Card *)card;
-(Card *)drawRandomCard;

@end

NS_ASSUME_NONNULL_END
