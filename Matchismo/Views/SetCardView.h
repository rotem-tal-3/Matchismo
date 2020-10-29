//
//  SetCardView.h
//  Matchismo
//
//  Created by Rotem Tal on 28/10/2020.
//

#import <UIKit/UIKit.h>

#import "CardViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetCardView : UIView <CardViewProtocol>

- (instancetype)initWithFrame:(CGRect)frame atIndex:(NSUInteger)index withColor:(NSString *)color
                  withShading:(NSString *)shading
                    withShape:(NSString *)shape withNumberOfShapeAsDigitString:(NSString *)numberOfShape;

@property (readonly, nonatomic) NSString *shading;
@property (readonly, nonatomic) NSString *shape;
@property (readonly, nonatomic) NSString *colorString;
@property (readonly, nonatomic) NSString *numberOfShapeString;
@end

NS_ASSUME_NONNULL_END
