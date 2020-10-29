//
//  Deck.m
//  Matchismo
//
//  Created by Rotem Tal on 12/10/2020.
//

#import "Deck.h"

@interface Deck()
@property (strong, nonatomic) NSMutableArray<Card *> *cards;
@end

@implementation Deck

- (instancetype)init {
  if (self = [super init]) {
    self.cards = [NSMutableArray array];
  }
  return self;
}

- (void)addCard: (Card *)card {
  [self.cards addObject:card];
}

- (Card *)drawRandomCard {
  Card *randomCard = nil;
  if ([self.cards count] == 0) {
    return randomCard;
  }
  int i = arc4random() % [self.cards count];
  randomCard = self.cards[i];
  [self.cards removeObjectAtIndex:i];
  return randomCard;
}

- (NSUInteger)count {
  return [self.cards count];
}
@end
