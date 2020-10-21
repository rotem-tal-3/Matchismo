//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Rotem Tal on 13/10/2020.
//

#import "CardMatchingGame.h"
#include "Deck.h"
#include "Card.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (strong, nonatomic) NSMutableArray<Card *> *cards;
@property (nonatomic, readwrite) NSInteger lastMatchScore;
@property (nonatomic) NSInteger revealCost;
@property (nonatomic) NSInteger mismatchPenalty;
@property (nonatomic) NSInteger matchBonus;
@property (nonatomic, readwrite) NSInteger currentAllowedChosen;
@property (nonatomic, strong, readwrite) NSArray<Card *> *lastMatchedCards;
@end

static const NSInteger kSetAllowedChosen = 3;
static const NSInteger kMatchismoAllowedChosen = 2;
	
@implementation CardMatchingGame
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    if (count > [deck count]) { return nil; }
    if (self = [super init]) {
        [self setIsGameMode3Way:NO];
        self.cards = [NSMutableArray array];
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            }
            else {
                return nil;
            }
        }
    }
    return self;
}

- (instancetype)init {
    return nil;
}


#pragma mark - Public API

- (Card *)cardAtIndex:(NSUInteger)index {
    return index < [self.cards count] ? self.cards[index] : nil;
}

- (void)setIsGameMode3Way:(BOOL)gameModeIs3Way {
    if (gameModeIs3Way) {
        [self set3WayMatchScoring];
        self.currentAllowedChosen = kSetAllowedChosen;
    } else {
        [self set2WayMatchScoring];
        self.currentAllowedChosen = kMatchismoAllowedChosen;
    }
}

- (void)chooseCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    if (card.matched) {
        return;
    }
    self.lastMatchedCards = nil;
    if (card.chosen) {
        card.chosen = NO;
    } else {
        [self handleCardReveal:card];
    }
}


#pragma mark - Game logic functions

- (void)handleCardReveal:(Card *)card {
    self.score -= self.revealCost;
    NSMutableArray<Card *> *chosenCards = [self getCurrentlyChosenCards];
    if ([chosenCards count] + 1 == self.currentAllowedChosen) {
        [self handleMatch:card withCards:chosenCards];
    }
    card.chosen = YES;
}

- (NSMutableArray *)getCurrentlyChosenCards {
    NSMutableArray *chosenCards = [NSMutableArray array];
    for (Card *otherCard in self.cards) {
        if (!otherCard.matched && otherCard.chosen) {
            if ([chosenCards count] < self.currentAllowedChosen) {
                [chosenCards addObject:otherCard];
            } else { break; }
        }
    }
    return chosenCards;
}

- (void)handleMatch:(Card *)card withCards:(NSMutableArray *)possibleMatches {
    NSInteger roundScore = [card match:possibleMatches] * self.matchBonus;
    self.lastMatchScore = roundScore ? roundScore : -self.mismatchPenalty;
    self.score += self.lastMatchScore;
    [possibleMatches addObject:card];
    [self setMatchedCardsState:possibleMatches isMatched:roundScore != 0];
    self.lastMatchedCards = [[NSArray alloc] initWithArray:possibleMatches];
}

- (void)setMatchedCardsState:(NSMutableArray<Card *> *)matchedCard isMatched:(BOOL) isMatched {
    for (Card *card in matchedCard) {
        card.matched = isMatched;
        card.chosen = isMatched;
    }
}


#pragma mark - Scoring management

- (void)set2WayMatchScoring {
    self.revealCost = 1;
    self.mismatchPenalty = 2;
    self.matchBonus = 4;
}

- (void)set3WayMatchScoring {
    self.revealCost = 1;
    self.mismatchPenalty = 3;
    self.matchBonus = 4;
}

@end
