//
//  ViewController.m
//  Matchismo
//
//  Created by Rotem Tal on 12/10/2020.
//

#import "ViewController.h"

#import "Card.h"
#import "CardViewProtocol.h"
#import "CardMatchingGame.h"
#import "Deck.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *cardLayoutView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic, readwrite) CardMatchingGame *game;
@property (strong, nonatomic) Deck* deck;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (nonatomic) NSUInteger numberOfCardsPlayed;

@end


@implementation ViewController

static const CGFloat kCardWidthToHeightProportion = 0.88;
static const NSInteger kNumberOfCardsToRedealOnRequest = 3;
static const CGFloat kCardToGapProportion = 0.9;

- (void)viewDidLoad {
  [super viewDidLoad];
  self.cardLayoutView.backgroundColor = nil;
  self.cardLayoutView.opaque = NO;
}

- (void)viewDidAppear:(BOOL)animated {
  if (self.deck == nil) {
    [self startNewGame];
  }
}

- (void)startNewGame {
  self.deck = [self createDeck];
  self.game = [[CardMatchingGame alloc] initWithCardCount:[self numberOfCards] usingDeck:self.deck];
  [self.game setIsGameMode3Way:[self isSetGame]];
  self.numberOfCardsPlayed = 0;
  [self createCardViews:[self numberOfCards]];
  [self animateCardViewsToTheirPosition];
  [self updateScore];
}

- (NSUInteger)numberOfCards {
  NSUInteger viewCount = [[self.cardLayoutView subviews] count];
  return viewCount ? viewCount : [self defaultNumberOfCards];
}

- (NSMutableArray *)getChosenCards {
  NSMutableArray<Card *> *chosenCards = [NSMutableArray array];
  for (NSUInteger i = 0; i < [[self.cardLayoutView subviews] count]; i++) {
    Card *card = [self.game cardAtIndex:i];
    if (card.chosen && !card.matched) {
      [chosenCards addObject:card];
    }
  }
  return chosenCards;
}


#pragma mark -
#pragma mark - Grid
#pragma mark -


#pragma mark -
#pragma mark - UI responders
#pragma mark -

- (IBAction)resetButtonPressed:(UIButton *)sender {
  [self clearAllCardViews];
  [self startNewGame];
}

- (void)cardChosenAtIndex:(NSUInteger)index {
  [self.game chooseCardAtIndex:index];
  [self updateUI];
}

- (IBAction)addCardsButtonPressed:(UIButton *)sender {
  [self.game addCardsToGame:kNumberOfCardsToRedealOnRequest];
  [self createCardViews:kNumberOfCardsToRedealOnRequest];
  [self animateCardViewsToTheirPosition];
}


#pragma mark -
#pragma mark - UI modifiers
#pragma mark -

- (void)clearAllCardViews {
  [self clearCardViews:[self.cardLayoutView subviews]];
  
}

- (void)clearCardViews:(NSArray <UIView *> *)views {
  [views makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)updateUI {
  [self updateScore];
  [self updateViews];
}

- (void)updateScore {
  [self.scoreLabel setText:[NSString stringWithFormat:@"Score: %ld", self.game.score]];
}

- (void)updateViews {
  NSMutableArray *viewsToBeRemoved = [NSMutableArray array];
  for (UIView <CardViewProtocol> *view in [self.cardLayoutView subviews]) {
    Card *card = [self.game cardAtIndex:view.cardIndex];
    [self handleChosen:card withView:view];
    view.chosen = card.chosen;
    if (card.matched) {
      [viewsToBeRemoved addObject:view];
    }
  }
  if ([viewsToBeRemoved count]){
    [self animteRemovalOfViews:viewsToBeRemoved];
  }
}

#pragma mark -
#pragma mark - Animations
#pragma mark -


- (void)animteRemovalOfViews:(NSArray <UIView<CardViewProtocol> *> *)views {
  for (UIView<CardViewProtocol> *view in views) {
    [self removeViewFromGame:view];
  }
}

- (void)removeViewFromGame:(UIView <CardViewProtocol> *)view {
  [UIView animateWithDuration:1.0 animations:^{
    view.center = CGPointMake(-100, -100); // Slightly off screen
    view.alpha = 0.3;
  } completion:^(BOOL finished) {
    if (finished) {
      view.hidden = YES;
      [view removeFromSuperview];
      [self animateCardViewsToTheirPosition];
    }
  }];
}

- (void)animateCardViewsToTheirPosition {
  CGSize cardSize = [self createCardSize];
  CGPoint position = CGPointZero;
  CGRect frame;
  frame.origin = position;
  frame.size = cardSize;
  for (NSUInteger i = 0; i < [[self.cardLayoutView subviews] count]; i++) {
    UIView *view = [self.cardLayoutView subviews][i];
    [UIView animateWithDuration:1.0 animations:^{
      view.frame = frame;
    }];
    frame = [self updateCardPosition:frame];
  }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context){}
                               completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    [self animateCardViewsToTheirPosition];
  }];
  
}


#pragma mark -
#pragma mark - Create card views
#pragma mark -

- (void)createCardViews:(NSUInteger)numberOfCards {
  CGRect initFrame = [self createInitFrame];
  for (NSUInteger i = self.numberOfCardsPlayed; i < self.numberOfCardsPlayed + numberOfCards; i++) {
    UIView <CardViewProtocol> *pcv = [self createViewForCardAtIndex:i withFrame:initFrame];
    [self.cardLayoutView addSubview:pcv];
  }
  self.numberOfCardsPlayed += numberOfCards;
}

- (CGRect)createInitFrame {
  CGSize frameSize = [self createCardSize];
  CGRect initFrame;
  initFrame.origin = CGPointZero;
  initFrame.size = frameSize;
  return initFrame;
}

- (CGSize)createCardSize {
  CGFloat width = [self cardWidthInsideLayout];
  CGSize frameSize = {width, [self cardHeightGivenCardWidth:width]};
  return frameSize;
}

#pragma mark -
#pragma mark - Card position
#pragma mark -

- (CGRect)updateCardPosition:(CGRect)previousPositionFrame {
  CGFloat cardWidth = previousPositionFrame.size.width;
  CGFloat gapWidth = [self gapGivenCardSize:cardWidth];
  previousPositionFrame.origin.x += cardWidth + gapWidth;
  if (previousPositionFrame.origin.x + cardWidth > self.cardLayoutView.frame.size.width) {
    previousPositionFrame.origin.x = 0;
    previousPositionFrame.origin.y += previousPositionFrame.size.height + [self gapGivenCardSize:previousPositionFrame.size.height];
  }
  return previousPositionFrame;
}

- (NSUInteger)cardCountWithGaps {
  return [[self.cardLayoutView subviews] count] + 1;
}

- (CGFloat)cardWidthInsideLayout {
  return kCardToGapProportion * [self cardAndGapWidthInsideLayout];
}

- (CGFloat)gapGivenCardSize:(CGFloat)size {
  return (size / kCardToGapProportion) - size;
}

-(CGFloat)cardAndGapWidthInsideLayout {
  CGFloat layoutArea = self.cardLayoutView.frame.size.width * self.cardLayoutView.frame.size.height;
  return sqrtl(kCardWidthToHeightProportion * layoutArea / [self cardCountWithGaps]);
}

- (CGFloat)cardHeightGivenCardWidth:(CGFloat)width {
  return width * kCardWidthToHeightProportion;
}

- (NSUInteger)numberOfCardsInRow:(CGFloat)cardWidth {
  return ceil(kCardToGapProportion * self.cardLayoutView.frame.size.width / cardWidth);
}

- (NSUInteger)numberOfRows:(CGFloat)cardHeight {
  return ceil(kCardToGapProportion * self.cardLayoutView.frame.size.height / cardHeight);
}

#pragma mark - Functions to be overriden by subclass

- (BOOL)isSetGame {
  return NO;
}

- (Deck *)createDeck {
  return nil;
}

- (UIView <CardViewProtocol> *)createViewForCardAtIndex:(NSUInteger)index withFrame:(CGRect)frame {
  return nil;
}


- (void)handleMatchForCards:(NSArray *)cards {
  
}

- (BOOL)isViewShowingCard:(Card *)card forView:(UIView *)view {
  return NO;
}

- (void)handleChosen:(Card *)card withView:(UIView<CardViewProtocol> *)view {
}

- (NSUInteger)defaultNumberOfCards {
  return 0;
}

@end
