//
//  PlayingCardView.m
//  Matchismo
//
//  Created by Rotem Tal on 25/10/2020.
//

#import "PlayingCardView.h"

#import "CardViewDelegate.h"
#import "CardViewUtils.h"
#import "PlayingCard.h"

@interface PlayingCardView ()

@property (nonatomic) CGFloat faceCardScaleFactor;

@end

@implementation PlayingCardView

@synthesize delegate, cardIndex, chosen = _chosen;

static const CGFloat kDefaultFaceCardScaleFactor = 0.9;
static const CGFloat kCornerFontStandardHeight = 180.0;

static const CGFloat kPipHoffsetPercentage = 0.165;
static const CGFloat kPipVRow1OffsetPercentage = 0.09;
static const CGFloat kPipVRow2OffsetPercentage = 0.175;
static const CGFloat kPipVRow3OffsetPercentage = 0.27;
static const CGFloat kPipFontScaleFactor = 0.008;


- (NSString *)rankAsString {
  return [PlayingCard rankStrings][self.rank];
}

- (instancetype)initWithFrame:(CGRect)frame atIndex:(NSUInteger)index withRank:(NSInteger)rank
                     withSuit:(NSString *)suit{
  if (self = [super initWithFrame:frame]) {
    self.contentMode = UIViewContentModeRedraw;
    _rank = rank;
    _suit = suit;
    self.cardIndex = index;
    self.chosen = NO; // Default for playing card
  }
  return self;
}

- (IBAction)onCardTap:(UITapGestureRecognizer *)sender {
  if([self.delegate respondsToSelector:@selector(cardChosenAtIndex:)]) {
    [self.delegate cardChosenAtIndex:self.cardIndex];
  }
}


#pragma mark -
#pragma mark - Initialization
#pragma mark -

- (void)setup {
  self.faceCardScaleFactor = kDefaultFaceCardScaleFactor;
  self.backgroundColor = nil;
  self.opaque = NO;
  self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self setup];
}

#pragma mark -
#pragma mark - Properties
#pragma mark -

- (void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor {
  _faceCardScaleFactor = faceCardScaleFactor;
  [self setNeedsDisplay];
}

- (void)setChosen:(BOOL)faceUp {
  _chosen = faceUp;
  [self setNeedsDisplay];
}


#pragma mark -
#pragma mark - Draw
#pragma mark -

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  // Drawing code
  CGFloat cornerRadius = [CardViewUtils cornerOffsetForScaleFactor:[self cornerScaleFactor]];
  [CardViewUtils drawCardInBounds:self.bounds withCornerRadius:cornerRadius withBackgroundColor:[UIColor whiteColor]];
  if (self.chosen) {
    [self drawFaceUp];
  } else {
    [self drawFaceDown];
  }
}

- (void)drawFaceDown {
  [[UIImage imageNamed:@"cardback"] drawInRect:self.bounds];
}

- (void)drawFaceUp {
  NSString *f = [NSString stringWithFormat:@"%@%@",
                 [self rankAsString], self.suit];
  UIImage *faceImage = [UIImage imageNamed:f];
  if (faceImage) {
    [self drawFaceImage:faceImage];
  } else {
    [self drawPips];
  }
  [self drawCorners];
}

- (void)drawFaceImage:(UIImage *)faceImage {
  CGRect imageRect = CGRectInset(self.bounds, self.bounds.size.width *
                                 (self.faceCardScaleFactor), self.bounds.size.height *
                                 (self.faceCardScaleFactor));
  [faceImage drawInRect:imageRect];
}

#pragma mark -
#pragma mark - Corners
#pragma mark -

- (void)drawCorners {
  NSAttributedString *cornerText = [self getCardCornerAttributedString];
  CGRect textBounds = [self createTextBoundRectWithSize:[cornerText size]];
  [cornerText drawInRect:textBounds];
  [CardViewUtils rotateUpsideDown:self.bounds];
  [cornerText drawInRect:textBounds];
}

- (CGRect)createTextBoundRectWithSize:(CGSize)size {
  CGRect textBounds;
  CGFloat cornerOffset = [CardViewUtils cornerOffsetForScaleFactor:[self cornerScaleFactor]];
  textBounds.origin = CGPointMake(cornerOffset, cornerOffset);
  textBounds.size = size;
  return textBounds;
}

- (NSAttributedString *)getCardCornerAttributedString {
  NSParagraphStyle *paragraphStyle = [self getCornerParagraphStyle];
  UIFont *cornerFont = [self getCornerFont];
  return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",
                                                     [self rankAsString], self.suit]
                                         attributes:@{ NSFontAttributeName: cornerFont,
                                                       NSParagraphStyleAttributeName:
                                                         paragraphStyle}];
}

-(NSParagraphStyle *)getCornerParagraphStyle {
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.alignment = NSTextAlignmentCenter;
  return paragraphStyle;
}

- (UIFont *)getCornerFont {
  UIFont *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * [self cornerScaleFactor]];
  return cornerFont;
}


#pragma mark -
#pragma mark - Pips
#pragma mark -

- (void)drawPips {
  if ([self hasMiddlePip]) {
    [self drawPipsWithHorizontalOffset:0 verticalOffset:0 mirroredVertically:NO];
  }
  if ([self hasMiddlePipAtSides]) {
    [self drawPipsWithHorizontalOffset:kPipHoffsetPercentage verticalOffset:0
                    mirroredVertically:NO];
  }
  if ([self hasUpperMiddlePip]) {
    [self drawPipsWithHorizontalOffset:0 verticalOffset:kPipVRow2OffsetPercentage
                    mirroredVertically:[self hasLowerMiddlePip]];
  }
  if ([self hasCornerPip]) {
    [self drawPipsWithHorizontalOffset:kPipHoffsetPercentage
                        verticalOffset:kPipVRow3OffsetPercentage mirroredVertically:YES];
  }
  if ([self hasDoubleMiddlePipAtSides]) {
    [self drawPipsWithHorizontalOffset:kPipHoffsetPercentage
                        verticalOffset:kPipVRow1OffsetPercentage mirroredVertically:YES];
  }
}

- (BOOL)hasMiddlePip {
  return (self.rank == 1) || (self.rank == 3) || (self.rank == 5) || (self.rank == 9);
}

- (BOOL)hasMiddlePipAtSides {
  return (self.rank == 6) || (self.rank == 7) || (self.rank == 8);
}

- (BOOL)hasUpperMiddlePip {
  return (self.rank == 2) || (self.rank == 3) || (self.rank == 7) || (self.rank == 8) ||
    (self.rank == 10);
}

- (BOOL)hasLowerMiddlePip {
  return self.rank != 7;
}

- (BOOL)hasCornerPip {
  return (self.rank == 4) || (self.rank == 5) || (self.rank == 6) || (self.rank == 7) ||
  (self.rank == 8) || (self.rank == 9) || (self.rank == 10);
}

- (BOOL)hasDoubleMiddlePipAtSides {
  return (self.rank == 9) || (self.rank == 10);
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset verticalOffset:(CGFloat)voffset
                  mirroredVertically:(BOOL)mirroredVertically {
  [self drawPipsWithHorizontalOffset:hoffset verticalOffset:voffset upsideDown:NO];
  if (mirroredVertically) {
    [self drawPipsWithHorizontalOffset:hoffset verticalOffset:voffset upsideDown:YES];
  }
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset verticalOffset:(CGFloat)voffset
                          upsideDown:(BOOL)upsideDown {
  if (upsideDown) {
    [CardViewUtils rotateUpsideDown:self.bounds];
  }
  CGPoint middle = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
  UIFont *pipFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  pipFont = [pipFont fontWithSize:[pipFont pointSize] *
             self.bounds.size.width * kPipFontScaleFactor];
  NSAttributedString *attributedSuit = [[NSAttributedString alloc]
                                        initWithString:self.suit
                                        attributes:@{ NSFontAttributeName: pipFont}];
  CGSize pipSize = [attributedSuit size];
  CGPoint pipOrigin = CGPointMake(middle.x - pipSize.width/2 - hoffset*self.bounds.size.width,
                                  middle.y - pipSize.height/2 - voffset*self.bounds.size.height);
  [attributedSuit drawAtPoint:pipOrigin];
  if (hoffset) {
    pipOrigin.x += hoffset * 2.0 * self.bounds.size.width;
    [attributedSuit drawAtPoint:pipOrigin];
  }
  if (upsideDown) {
    [CardViewUtils popContext];
  }
}


#pragma mark -
#pragma mark - Corner Radius
#pragma mark -

- (CGFloat)cornerScaleFactor {
  return self.bounds.size.height / kCornerFontStandardHeight;
}

@end
