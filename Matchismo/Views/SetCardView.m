//
//  SetCardView.m
//  Matchismo
//
//  Created by Rotem Tal on 28/10/2020.
//

#import "SetCardView.h"

#import "CardViewDelegate.h"
#import "CardViewUtils.h"
#import "SetCard.h"

@interface SetCardView ()

@property (strong, nonatomic)  UIColor * __nullable color;
@property (nonatomic) NSUInteger numberOfShapes;

@end

@implementation SetCardView

static const CGFloat kHorizontalGap = 0.0695;
static const CGFloat kVerticalGap = 0.05;
static const CGFloat kShapeSizeScaleFactor = 0.9;
static const CGFloat kOvalCornerScaleFactor = 4.2;
static const CGFloat kOffsetFor2Shapes = 0.166;

@synthesize delegate = _delegate;
@synthesize cardIndex = _cardIndex;
@synthesize chosen = _chosen;

#pragma mark -
#pragma mark - Initilize
#pragma mark -

- (instancetype)initWithFrame:(CGRect)frame atIndex:(NSUInteger)index withColor:(NSString *)color
                  withShading:(NSString *)shading withShape:(NSString *)shape
            withNumberOfShapeAsDigitString:(NSString *)numberOfShapes {
  UIColor *inputColor = [self UIColorFromString:color];
  NSUInteger inputNumber = [numberOfShapes intValue];
  if (inputColor == nil || inputNumber == 0) {
    return nil;
  }
  if (self = [super initWithFrame:frame]) {
    _numberOfShapeString = numberOfShapes;
    _colorString = color;
    self.cardIndex = index;
    self.color = inputColor;
    _shading = shading;
    _shape = shape;
    self.numberOfShapes = inputNumber;
  }
  return self;
}

- (void)setChosen:(BOOL)chosen {
  _chosen = chosen;
  [self setNeedsDisplay];
}

- (UIColor *)UIColorFromString:(NSString *)color {
  if ([color isEqualToString:@"Red"]) {
    return [UIColor redColor];
  }
  if ([color isEqualToString:@"Purple"]) {
    return [UIColor purpleColor];
  }
  if ([color isEqualToString:@"Green"]) {
    return [UIColor greenColor];
  }
  return nil;
}
 
- (UIColor *)cardBackgroundColor {
  return self.chosen ? [UIColor yellowColor] : [UIColor whiteColor];;
}

#pragma mark -
#pragma mark - UI response
#pragma mark -

- (IBAction)onCardTap:(UITapGestureRecognizer *)sender {
  if ([self.delegate respondsToSelector:@selector(cardChosenAtIndex:)]) {
    [self.delegate cardChosenAtIndex:self.cardIndex];
  }
}


#pragma mark -
#pragma mark - Draw
#pragma mark -

- (void)drawRect:(CGRect)rect {
  [CardViewUtils drawCardInBounds:self.bounds withCornerRadius:[self cornerScaleFactor] withBackgroundColor:[self cardBackgroundColor]];
  if ([self hasMiddleShape]) {
    [self drawMiddleShape];
  }
  if ([self hasLowerAndUpperShapes]) {
    [self drawLowerAndUpperShapes];
  }
  
}

- (BOOL)hasMiddleShape {
  return self.numberOfShapes == 1 || self.numberOfShapes == 3;
}

- (BOOL)hasLowerAndUpperShapes {
  return self.numberOfShapes == 3 || self.numberOfShapes == 2;
}


- (void)drawMiddleShape {
  CGRect shapeFrame = [self createShapeFrame];
  shapeFrame.origin = CGPointMake(kHorizontalGap * self.bounds.size.width ,
                                  0.5 * (self.bounds.size.height - shapeFrame.size.height));
  [self drawShapeInBounds:shapeFrame];
}

- (void)drawLowerAndUpperShapes {
  CGFloat offset = self.numberOfShapes == 2 ? kOffsetFor2Shapes :kVerticalGap;
  CGRect shapeFrame = [self createShapeFrame];
  shapeFrame.origin = CGPointMake(kHorizontalGap * self.bounds.size.width,
                                  offset * self.bounds.size.height);
  [self drawShapeInBounds:shapeFrame];
  shapeFrame.origin.y += shapeFrame.size.height * (self.numberOfShapes - 1);
  [self drawShapeInBounds:shapeFrame];
  
}

- (CGRect)createShapeFrame {
  CGRect shapeFrame;
  shapeFrame.size = [self createShapeSize];
  return shapeFrame;
}
- (CGSize)createShapeSize {
  return CGSizeMake(kShapeSizeScaleFactor * self.frame.size.width,
                    kShapeSizeScaleFactor * self.frame.size.height / [SetCard maxNumberOfShape]);
}

- (void)drawShapeInBounds:(CGRect)bounds {
  if ([self.shape isEqualToString:@"Squiggle"]) {
    [self drawSquiggleInBounds:bounds];
  }
  if ([self.shape isEqualToString:@"Diamond"]) {
    [self drawDiamondInBounds:bounds];
  }
  if ([self.shape isEqualToString:@"Oval"]) {
    [self drawOvalInBounds:bounds];
  }
}

  
#pragma mark -
#pragma mark - Shapes
#pragma mark -

- (void)drawSquiggleInBounds:(CGRect)bounds {
  UIBezierPath *path = [self setPath];
  [path moveToPoint:CGPointMake(bounds.origin.x + bounds.size.width*0.05,
                                bounds.origin.y + bounds.size.height*0.40)];
  [path addCurveToPoint:CGPointMake(bounds.origin.x + bounds.size.width*0.35,
                                    bounds.origin.y + bounds.size.height*0.25)
          controlPoint1:CGPointMake(bounds.origin.x + bounds.size.width*0.09,
                                    bounds.origin.y + bounds.size.height*0.15)
          controlPoint2:CGPointMake(bounds.origin.x + bounds.size.width*0.18,
                                    bounds.origin.y + bounds.size.height*0.10)];
  [path addCurveToPoint:CGPointMake(bounds.origin.x + bounds.size.width*0.75,
                                    bounds.origin.y + bounds.size.height*0.30)
          controlPoint1:CGPointMake(bounds.origin.x + bounds.size.width*0.40,
                                    bounds.origin.y + bounds.size.height*0.30)
          controlPoint2:CGPointMake(bounds.origin.x + bounds.size.width*0.60,
                                    bounds.origin.y + bounds.size.height*0.45)];
  
  [path addCurveToPoint:CGPointMake(bounds.origin.x + bounds.size.width*0.97,
                                    bounds.origin.y + bounds.size.height*0.35)
          controlPoint1:CGPointMake(bounds.origin.x + bounds.size.width*0.87,
                                    bounds.origin.y + bounds.size.height*0.15)
          controlPoint2:CGPointMake(bounds.origin.x + bounds.size.width*0.98,
                                    bounds.origin.y)];
  
  [path addCurveToPoint:CGPointMake(bounds.origin.x + bounds.size.width*0.45,
                                    bounds.origin.y + bounds.size.height*0.85)
          controlPoint1:CGPointMake(bounds.origin.x + bounds.size.width*0.95,
                                    bounds.origin.y + bounds.size.height*1.10)
          controlPoint2:CGPointMake(bounds.origin.x + bounds.size.width*0.50,
                                    bounds.origin.y + bounds.size.height*0.95)];
  
  [path addCurveToPoint:CGPointMake(bounds.origin.x + bounds.size.width*0.25,
                                    bounds.origin.y + bounds.size.height*0.85)
          controlPoint1:CGPointMake(bounds.origin.x + bounds.size.width*0.40,
                                    bounds.origin.y + bounds.size.height*0.80)
          controlPoint2:CGPointMake(bounds.origin.x + bounds.size.width*0.35,
                                    bounds.origin.y + bounds.size.height*0.75)];
  
  [path addCurveToPoint:CGPointMake(bounds.origin.x + bounds.size.width*0.05,
                                    bounds.origin.y + bounds.size.height*0.40)
          controlPoint1:CGPointMake(bounds.origin.x ,bounds.origin.y + bounds.size.height*1.10)
          controlPoint2:CGPointMake(bounds.origin.x + bounds.size.width*0.005,
                                    bounds.origin.y + bounds.size.height*0.60)];
  [path closePath];
  [self endPath:path];
}

- (void)drawDiamondInBounds:(CGRect)bounds {
  UIBezierPath *path = [self setPath];
  CGFloat middle = 0.5;
  CGFloat gap = 0.05;
  [path moveToPoint:CGPointMake(bounds.origin.x +bounds.size.width * middle,
                                bounds.origin.y + (bounds.size.width * gap))];
  [path addLineToPoint:CGPointMake(bounds.origin.x + (bounds.size.width * gap)
                                   ,bounds.origin.y + bounds.size.height * middle)];
  [path addLineToPoint:CGPointMake(bounds.origin.x +bounds.size.width * middle,
                                bounds.origin.y + (bounds.size.height * (1.0 - gap)))];
  [path addLineToPoint:CGPointMake(bounds.origin.x + (bounds.size.width * (1 - gap)),
                                bounds.origin.y + bounds.size.height * middle)];
  [path closePath];
  [self endPath:path];
}

- (UIBezierPath *)setPath {
  UIBezierPath *path = [UIBezierPath bezierPath];
  [self.color setStroke];
  path.lineWidth = 2;
  return path;
}

- (void)drawOvalInBounds:(CGRect)bounds {
  bounds.size.width *= kShapeSizeScaleFactor;
  bounds.size.height *= kShapeSizeScaleFactor;
  [self.color setStroke];
  UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                  cornerRadius:
                        [CardViewUtils cornerOffsetForScaleFactor:kOvalCornerScaleFactor]];
  //[path addClip];
  [self endPath:path];
}

- (void)endPath:(UIBezierPath *)path {
  [self drawShadingInPath:path];
  [path stroke];
}

#pragma mark -
#pragma mark - Shading
#pragma mark -

- (void)drawShadingInPath:(UIBezierPath *)bezierPath
{
  if ([self.shading isEqualToString:@"Solid"]) {
    [self.color setFill];
    [bezierPath fill];
  }
  if ([self.shading isEqualToString:@"Striped"]){
    [self drawStripedShadingForPath:bezierPath];
  }
}

- (void)drawStripedShadingForPath:(UIBezierPath *)pathOfSymbol
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  
  CGRect bounds = [pathOfSymbol bounds];
  UIBezierPath *path = [[UIBezierPath alloc] init];
  
  for (int i = 0; i < bounds.size.width; i += 2) {
    [path moveToPoint:CGPointMake(bounds.origin.x + i, bounds.origin.y)];
    [path addLineToPoint:CGPointMake(bounds.origin.x + i, bounds.origin.y + bounds.size.height)];
  }
  
  [pathOfSymbol addClip];
  
  [path stroke];
  
  CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

#pragma mark -
#pragma mark - Corner Radius
#pragma mark -

- (CGFloat)cornerScaleFactor {
  return self.bounds.size.height / 180.0;
}

@end
