//
//  SetDeck.m
//  Matchismo
//
//  Created by Rotem Tal on 19/10/2020.
//

#import "SetDeck.h"

#import "SetCard.h"

@implementation SetDeck
- (instancetype)init {
    if (self = [super init]) {
        for (NSString *shape in [SetCard validShapes]) {
            for (NSString *shade in [SetCard validShading]) {
                for (NSString *color in [SetCard validColor]) {
                    for (NSString *numberOfShape in [SetCard validNumberOfShape]) {
                        SetCard *card = [[SetCard alloc] init];
                        card.shape = shape;
                        card.color = color;
                        card.numberOfShape = numberOfShape;
                        card.shading = shade;
                        [self addCard:card];
                    }
                }
            }
        }
    }
    return self;
}
@end
