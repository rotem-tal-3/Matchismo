//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Rotem Tal on 13/10/2020.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Deck, Card;

@interface CardMatchingGame : NSObject
@property (nonatomic, strong, readonly) NSArray<Card *> *lastMatchedCards;
@property (nonatomic, readonly) NSInteger currentAllowedChosen;
@property (nonatomic, readonly) NSInteger lastMatchScore;
@property (nonatomic, readonly) NSInteger score;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck: (Deck *)deck NS_DESIGNATED_INITIALIZER;
- (void)chooseCardAtIndex:(NSUInteger)index;
- (void) setIsGameMode3Way:(BOOL)gameModeIs3Way;
- (Card *)cardAtIndex:(NSUInteger)index;
- (BOOL)addCardsToGame:(NSUInteger)numberOfCardsToAdd;
@end

NS_ASSUME_NONNULL_END
