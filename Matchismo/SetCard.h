//
//  SetCard.h
//  Matchismo
//
//  Created by Rotem Tal on 19/10/2020.
//

#import <Foundation/Foundation.h>

#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetCard : Card
@property (strong, nonatomic) NSString *numberOfShape;
@property (strong, nonatomic) NSString *shape;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *shading;

+ (NSArray<NSString *> *) validShapes;
+ (NSArray<NSString *> *) validColor;
+ (NSArray<NSString *> *) validShading;
+ (NSArray<NSString *> *) validNumberOfShape;
@end

NS_ASSUME_NONNULL_END
