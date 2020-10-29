//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Rotem Tal on 19/10/2020.
//

#import "PlayingCardGameViewController.h"

#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardView.h"
#import "CardMatchingGame.h"

@interface PlayingCardGameViewController ()

@property (weak, nonatomic) IBOutlet UIView *cardLayoutView;

@end

@implementation PlayingCardGameViewController

@dynamic cardLayoutView;

- (Deck *)createDeck {
  return [[PlayingCardDeck alloc] init];
}

- (BOOL)isSetGame {
  return NO;
}

- (NSUInteger)defaultNumberOfRows {
  return 5;
}

- (NSUInteger)defaultNumberOfCardsInRow {
  return 4;
}

#pragma mark -
#pragma mark - CardView creation
#pragma mark -


- (PlayingCardView *)createViewForCardAtIndex:(NSUInteger)index withFrame:(CGRect)frame {
  PlayingCard *currentCard = (PlayingCard *) [self.game cardAtIndex:index];
  PlayingCardView *pcv = [[PlayingCardView alloc] initWithFrame:frame atIndex:index withRank:currentCard.rank withSuit:currentCard.suit];
  pcv.delegate = self;
  UITapGestureRecognizer *uitgr = [[UITapGestureRecognizer alloc] initWithTarget:pcv action:@selector(onCardTap:)];
  [pcv addGestureRecognizer:uitgr];
  return pcv;
}


#pragma mark -
#pragma mark - View touched handlers
#pragma mark -

- (BOOL)isViewShowingCard:(PlayingCard *)card forView:(PlayingCardView *)view {
  return (card.rank == view.rank) && ([card.suit isEqualToString:view.suit]);
}

- (void)handleChosen:(Card *)card withView:(UIView<CardViewProtocol> *)view {
  if (view.chosen == card.chosen) {
    return;
  }
  [UIView transitionWithView:view duration:0.3 options:UIViewAnimationOptionTransitionFlipFromLeft
                  animations: ^{
    view.chosen = card.chosen;
  } completion:^(BOOL finished) {}];
}


@end
