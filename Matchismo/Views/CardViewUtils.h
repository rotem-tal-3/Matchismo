//
//  CardViewUtils.h
//  Matchismo
//
//  Created by Rotem Tal on 28/10/2020.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardViewUtils : NSObject
+ (void)drawCardInBounds:(CGRect)bounds withCornerRadius:(CGFloat)cornerRadius withBackgroundColor:(UIColor *)color;
+ (CGFloat)cornerOffsetForScaleFactor:(CGFloat)scaleFactor;
+ (void)rotateUpsideDown:(CGRect)bounds;
+ (void)pushContext;
+ (void)popContext;
@end

NS_ASSUME_NONNULL_END
