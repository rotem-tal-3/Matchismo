//
//  SetCard.m
//  Matchismo
//
//  Created by Rotem Tal on 19/10/2020.
//

#import "SetCard.h"
@implementation SetCard

static const int kNumberOfCardsToMatch = 3;


@synthesize shape = _shape;
- (void)setShape:(NSString *)shape
{
    if ([[SetCard validShapes] containsObject:shape])
    {
        _shape = shape;
    }
}
-(NSString *)shape
{
    return _shape ? _shape : @"?";
}


-(int)match:(NSArray<Card *> *)otherCards
{
    int score = 0;
    BOOL isSet = YES;
    if ([self notAmountOfCardsToMatchToThisCard:otherCards])
    {
        return score;
    }
    for (NSString *property in [SetCard properties]) {
        NSArray* propertiesFromAllCards = @[
            [self valueForKey:property],
            [otherCards[0] valueForKey:property],
            [otherCards[1] valueForKey:property]];;
        isSet &= [self isSet:propertiesFromAllCards];
    }
    if (isSet) {
        score = 1;
    }
    return score;
}

- (BOOL)notAmountOfCardsToMatchToThisCard:(NSArray<Card *> *)cards
{
    return [cards count] + 1 != kNumberOfCardsToMatch; // +1 for this card
}

-(BOOL)isSet:(NSArray <NSString *> *)propertyValues
{
    BOOL firstEqualSecond = [propertyValues[0] isEqualToString:propertyValues[1]];
    BOOL firstEqualThird = [propertyValues[0] isEqualToString:propertyValues[2]];
    BOOL secondEqualThird = [propertyValues[2] isEqualToString:propertyValues[1]];
    return (firstEqualSecond != firstEqualThird) != secondEqualThird;
}



+ (NSArray<NSString *> *)properties
{
    return @[@"numberOfShape", @"shape", @"color", @"shading"];
}
+ (NSArray<NSString *> *)validShapes
{
    return @[@"▲", @"●", @"■"];
}
+ (NSArray<NSString *> *)validColor
{
    return @[@"Red", @"Green", @"Purple"];
}
+ (NSArray<NSString *> *)validShading
{
    return @[@"Solid", @"Stripped", @"Open"];
}
- (NSString *)contents
{
    return nil;
}
+ (NSArray <NSString *> *)validNumberOfShape
{
    return @[@"1",@"2",@"3"];
}
@end
