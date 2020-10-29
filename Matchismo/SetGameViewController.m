//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Rotem Tal on 20/10/2020.
//

#import "SetGameViewController.h"

#import "CardMatchingGame.h"
#import "SetCard.h"
#import "SetDeck.h"
#import "SetCardView.h"

@interface SetGameViewController()

@property (weak, nonatomic) IBOutlet UIView *cardLayoutView;

@end

@implementation SetGameViewController

@dynamic cardLayoutView;

- (Deck *)createDeck {
  return [[SetDeck alloc] init];
}

- (NSUInteger)defaultNumberOfRows {
  return 3;
}

- (NSUInteger)defaultNumberOfCardsInRow {
  return 4;
}

- (BOOL)isSetGame {
  return YES;
}

- (void)viewDidLoad {
  [super viewDidLoad];
}
- (SetCardView *)createViewForCardAtIndex:(NSUInteger)index withFrame:(CGRect)frame {
  SetCard *currentCard = (SetCard *)[self.game cardAtIndex:index];
  SetCardView *scv = [[SetCardView alloc] initWithFrame:frame
                                                atIndex:index
                                              withColor:currentCard.color
                                            withShading:currentCard.shading
                                              withShape:currentCard.shape
                         withNumberOfShapeAsDigitString:currentCard.numberOfShape];
  scv.delegate = self;
  UITapGestureRecognizer *uitgr = [[UITapGestureRecognizer alloc]
                                   initWithTarget:scv action:@selector((onCardTap:))];
  [scv addGestureRecognizer:uitgr];
  return scv;
}


#pragma mark -
#pragma mark - View touched handlers
#pragma mark -


- (BOOL)isViewShowingCard:(SetCard *)card forView:(SetCardView *)view {
  return [card.shape isEqualToString:view.shape] && [card.color isEqualToString:view.colorString]
  && [card.shading isEqualToString:view.shading] && [card.numberOfShape isEqualToString:view.numberOfShapeString];
}

- (void)handleChosen:(Card *)card withView:(UIView<CardViewProtocol> *)view {
  view.chosen = card.chosen;
}

@end
