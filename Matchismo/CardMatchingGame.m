//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Rotem Tal on 13/10/2020.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (strong, nonatomic) NSMutableArray<Card *> *cards;
@property (nonatomic, readwrite) int lastMatchScore;
@property (nonatomic) int revealCost;
@property (nonatomic) int mismatchPenalty;
@property (nonatomic) int matchBonus;
@property (nonatomic, readwrite) int currentAllowedChosen;
@property (nonatomic, strong, readwrite) NSArray<Card *> *lastMatchedCards;
@end

static const int ALLOWED_CHOSEN_3WAY = 3;
static const int ALLOWED_CHOSEN_2WAY = 2;
	
@implementation CardMatchingGame
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    if (count > [deck count]){ return nil; }
    if (self = [super init])
    {
        [self setGameMode:NO];
        self.cards = [[NSMutableArray alloc] init];
        for (int i = 0; i < count; i++)
        {
            Card *card = [deck drawRandomCard];
            if (card){
                [self.cards addObject:card];
            }
        }
    }
    return self;
}

- (instancetype)init{
    return nil;
}


-(void)setGameMode:(BOOL)gameModeIs3Way
{
    if (gameModeIs3Way)
    {
        [self set3WayMatchScoring];
        self.currentAllowedChosen = ALLOWED_CHOSEN_3WAY;
    } else {
        [self set2WayMatchScoring];
        self.currentAllowedChosen = ALLOWED_CHOSEN_2WAY;
    }
}

- (void)set2WayMatchScoring
{
    self.revealCost = 1;
    self.mismatchPenalty = 2;
    self.matchBonus = 4;
}
- (void)set3WayMatchScoring
{
    self.revealCost = 1;
    self.mismatchPenalty = 3;
    self.matchBonus = 4;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return index < [self.cards count] ? self.cards[index] : nil;
}

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    if (card.matched)
    {
        return;
    }
    self.lastMatchedCards = nil;
    if (card.chosen)
    {
        card.chosen = NO;
    }
    else
    {
        [self handleCardReveal:card];
    }
}
- (void)handleCardReveal:(Card *)card
{
    NSMutableArray<Card *> *chosenCards = [self getChosenCards];
    [chosenCards addObject:card];
    if ([chosenCards count] == self.currentAllowedChosen)
    {
        [self handleMatch:chosenCards];
    }
    self.score -= self.revealCost;
    card.chosen = YES;
}

- (NSMutableArray *)getChosenCards
{
    NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
    for (Card *otherCard in self.cards) {
        if (!otherCard.matched && otherCard.chosen)
        {
            if ([chosenCards count] < self.currentAllowedChosen)
            {
                [chosenCards addObject:otherCard];
            }
            else {break;}
            
        }
    }
    return chosenCards;
}

-(void)handleMatch:(NSMutableArray *)possibleMatches
{
    self.lastMatchedCards = [[NSArray alloc] initWithArray:possibleMatches];
    int roundScore = [self determineScoreFromMatches:possibleMatches];
    if (roundScore)
    {
        self.score += roundScore;
        self.lastMatchScore = roundScore;
    }
    else
    {
        self.score -= self.mismatchPenalty;
        self.lastMatchScore = -self.mismatchPenalty;
    }
    [self setMatchedCardsState:possibleMatches isMatched:roundScore != 0];
}

- (int)determineScoreFromMatches:(NSMutableArray<Card *> *)possibleMatches
{
    int score = 0;
    for (NSUInteger i = 0; i < [possibleMatches count]; i++) {
        Card *card = possibleMatches[i];
        for (NSUInteger j = i +1; j < [possibleMatches count]; j++) {
            Card *otherCard = possibleMatches[j];
            int matchScore = [otherCard match:@[card]] * self.matchBonus;
            if (matchScore > score)
            {
                score = matchScore;
            }
        }
    }
    return score;
}

- (void)setMatchedCardsState:(NSMutableArray<Card *> *)matchedCard isMatched:(BOOL) isMatched
{
    for (Card *card in matchedCard)
    {
        card.matched = isMatched;
        card.chosen = isMatched;
    }
}


@end
