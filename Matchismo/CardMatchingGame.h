//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Rotem Tal on 13/10/2020.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
NS_ASSUME_NONNULL_BEGIN

@interface CardMatchingGame : NSObject
@property (nonatomic, strong, readonly) NSArray<Card *> *lastMatchedCards;
@property (nonatomic, readonly) int currentAllowedChosen;
@property (nonatomic, readonly) int lastMatchScore;
@property (nonatomic, readonly) NSInteger score;
- (void) setGameMode:(BOOL)gameModeIs3Way;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck: (Deck *)deck NS_DESIGNATED_INITIALIZER;
- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
@end

NS_ASSUME_NONNULL_END
