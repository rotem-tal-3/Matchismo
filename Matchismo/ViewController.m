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
@property (nonatomic) NSUInteger numberOfCardsInRow;
@property (nonatomic) NSUInteger numberOfRows;
@property (nonatomic) NSUInteger numberOfCardsPlayed;

@end


@implementation ViewController

static const NSInteger kNumberOfCardsToRedealOnRequest = 3;
static const CGFloat kPrefferedRowColRatio = 0.75;

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

- (void)switchNumberOfCardsAndNumberOfRows {
  NSUInteger temp = self.numberOfRows;
  self.numberOfRows = self.numberOfCardsInRow;
  self.numberOfCardsInRow = temp;
}


- (void)startNewGame {
  self.deck = [self createDeck];
  self.numberOfRows = [self defaultNumberOfRows];
  self.numberOfCardsInRow = [self defaultNumberOfCardsInRow];
  self.game = [[CardMatchingGame alloc] initWithCardCount:[self numberOfCards] usingDeck:self.deck];
  [self.game setIsGameMode3Way:[self isSetGame]];
  self.numberOfCardsPlayed = 0;
  [self createCardViews:[self numberOfCards]];
  [self animateCardViewsToTheirPosition];
  [self updateScore];
}

- (NSUInteger)numberOfCards {
  NSUInteger viewCount = [[self.cardLayoutView subviews] count];
  NSUInteger defaultNumber = self.numberOfCardsInRow * self.numberOfRows;
  return viewCount ? viewCount : defaultNumber;
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

- (void)fitCardGridSize:(NSInteger)numberOfViewsToBeAdded {
  NSUInteger newCardCount = [[self.cardLayoutView subviews] count] + numberOfViewsToBeAdded;
  NSUInteger numberOfRows = ceil((CGFloat)newCardCount / self.numberOfCardsInRow);
  self.numberOfRows = MAX(numberOfRows, [self defaultNumberOfRows]);
  if ([self needToAdjustGrid]) {
    self.numberOfRows--;
    self.numberOfCardsInRow++;
  }
  
}

- (BOOL)needToAdjustGrid {
  CGFloat curRatio = self.numberOfCardsInRow / ((CGFloat)self.numberOfRows);
  CGFloat proposedRatio = (self.numberOfCardsInRow + 1) / ((CGFloat)self.numberOfRows - 1);
  return fabs(curRatio - kPrefferedRowColRatio) > fabs(proposedRatio - kPrefferedRowColRatio);
}

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
  [self fitCardGridSize:kNumberOfCardsToRedealOnRequest];
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
      [self fitCardGridSize:0];
      [self animateCardViewsToTheirPosition];
    }
  }];
}

- (void)animateCardViewsToTheirPosition {
  __weak ViewController *weakSelf = self;
  for (NSUInteger i = 0; i < [[self.cardLayoutView subviews] count]; i++) {
    CGRect frame;
    frame.origin = [self createCardPosition:i];
    frame.size = [self createCardSize];
    [UIView animateWithDuration:1.0 animations:^{
      UIView *view = [weakSelf.cardLayoutView subviews][i];
      view.frame = frame;
    }];
  }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  [self switchNumberOfCardsAndNumberOfRows];
  [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context){}
                               completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    [self animateCardViewsToTheirPosition];
  }];
  
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
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
  CGSize frameSize = {
    [self cardWidthInsideLayout:self.cardLayoutView.frame.size.width],
    [self cardHeightInsideLayout:self.cardLayoutView.frame.size.height]
  };
  return frameSize;
}

#pragma mark -
#pragma mark - Create card position
#pragma mark -

- (CGPoint)createCardPosition:(NSUInteger)cardIndex {
  CGFloat widthOfCardLayout = self.cardLayoutView.frame.size.width;
  CGFloat heightOfCardLayout = self.cardLayoutView.frame.size.height;
  NSUInteger row = cardIndex / self.numberOfCardsInRow;
  NSUInteger col = cardIndex % self.numberOfCardsInRow;
  CGFloat cardWidth = [self cardWidthInsideLayout:widthOfCardLayout];
  CGFloat cardHeight = [self cardHeightInsideLayout:heightOfCardLayout];
  CGFloat posX = col * (cardWidth + [self gapSizeWithinBound:widthOfCardLayout
                                            forNumberOfCards:self.numberOfCardsInRow]);
  CGFloat posY = row * (cardHeight + [self gapSizeWithinBound:heightOfCardLayout
                                             forNumberOfCards:self.numberOfRows]);
  return CGPointMake(posX, posY);
}

- (CGFloat)cardWidthInsideLayout:(CGFloat)layoutWidth {
  return layoutWidth / (self.numberOfCardsInRow + 1);
}

- (CGFloat)cardHeightInsideLayout:(CGFloat)layoutHeight {
  return layoutHeight / (self.numberOfRows + 1);
}

- (CGFloat)gapSizeWithinBound:(CGFloat)bound forNumberOfCards:(NSInteger)numberOfCards {
  NSInteger numberOfGaps = [self numberOfGapsFor:numberOfCards];
  return bound / ((numberOfCards + 1) * numberOfGaps) ;
}

- (NSInteger)numberOfGapsFor:(NSInteger)numberOfCards {
  return numberOfCards - 1;
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

- (NSUInteger)defaultNumberOfRows {
  return 0;
}

- (NSUInteger)defaultNumberOfCardsInRow {
  return 0;
}

- (void)handleChosen:(Card *)card withView:(UIView<CardViewProtocol> *)view {
}

@end
