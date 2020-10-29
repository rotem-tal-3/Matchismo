//
//  CardViewUtils.m
//  Matchismo
//
//  Created by Rotem Tal on 28/10/2020.
//

#import "CardViewUtils.h"

@implementation CardViewUtils

static const CGFloat kCornerRadius = 12.0;

+ (void)drawCardInBounds:(CGRect)bounds withCornerRadius:(CGFloat)cornerRadius withBackgroundColor:(UIColor *)color {
  UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                         cornerRadius:cornerRadius];
  [roundedRect addClip];
  
  [color setFill];
  UIRectFill(bounds);
  
  [[UIColor blueColor] setStroke];
  [roundedRect stroke];
}

#pragma mark -
#pragma mark - Corner Radius
#pragma mark -


+ (CGFloat)cornerRadiusForScaleFactor:(CGFloat)scaleFactor {
  return kCornerRadius * scaleFactor;
}

+ (CGFloat)cornerOffsetForScaleFactor:(CGFloat)scaleFactor {
  return  [CardViewUtils cornerRadiusForScaleFactor:scaleFactor] / 3.0;
}

#pragma mark -
#pragma mark - Context handlers
#pragma mark -

+ (void)rotateUpsideDown:(CGRect)bounds {
  [CardViewUtils pushContext];
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextTranslateCTM(context, bounds.size.width, bounds.size.height);
  CGContextRotateCTM(context, M_PI);
}

+ (void)pushContext {
  CGContextSaveGState(UIGraphicsGetCurrentContext());
}

+ (void)popContext {
  CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

@end
