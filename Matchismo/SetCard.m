//
//  SetCard.m
//  Matchismo
//
//  Created by Rotem Tal on 19/10/2020.
//

#import "SetCard.h"

@implementation SetCard

static const int kNumberOfCardsToMatch = 3;



// Iterates
- (NSInteger)match:(NSArray<SetCard *> *)otherCards {
    int score = 0;
    if ([self notAmountOfCardsToMatchToThisCard:otherCards]) {
        return score;
    }
    if ([self isSetWith:otherCards]) {
        score = 1;
    }
    return score;
}

+ (NSArray<NSString *> *)propertyNames {
    return @[@"numberOfShape", @"shape", @"color", @"shading"];
}


#pragma mark - Set validations

// A card is a set with 2 other cards if each of their property is a set.
- (BOOL)isSetWith:(NSArray <SetCard *> *)otherCards
{
    bool isSet = YES;
    for (NSString *property in [SetCard propertyNames]) {
        NSArray<NSString *> *propertiesFromAllCards = @[
            [self valueForKey:property],
            [otherCards[0] valueForKey:property],
            [otherCards[1] valueForKey:property]];;
        isSet &= [self isPropertySet:propertiesFromAllCards];
    }
    return isSet;
}

- (BOOL)notAmountOfCardsToMatchToThisCard:(NSArray<SetCard *> *)cards {
    return [cards count] + 1 != kNumberOfCardsToMatch; // +1 for this card
}


// A property may be part of a set if all 3 cards match it or all differ it.
- (BOOL)isPropertySet:(NSArray <NSString *> *)propertyValues {
    BOOL firstEqualSecond = [propertyValues[0] isEqualToString:propertyValues[1]];
    BOOL firstEqualThird = [propertyValues[0] isEqualToString:propertyValues[2]];
    BOOL secondEqualThird = [propertyValues[2] isEqualToString:propertyValues[1]];
    BOOL allTrue = firstEqualThird & firstEqualSecond & secondEqualThird;
    BOOL allFalse = !firstEqualSecond & !firstEqualThird & !secondEqualThird;
    return allTrue | allFalse;
}

#pragma mark Property setters and getters

@synthesize shape = _shape;
- (void)setShape:(NSString *)shape {
    if ([[SetCard validShapes] containsObject:shape]) {
        _shape = shape;
    }
}
-(NSString *)shape {
    return _shape ? _shape : @"?";
}

@synthesize color = _color;
- (void)setColor:(NSString *)color {
    if ([[SetCard validColor] containsObject:color]) {
        _color = color;
    }
}
-(NSString *)color {
    return _color ? _color : @"?";
}

@synthesize shading = _shading;
- (void)setShading:(NSString *)shading {
    if ([[SetCard validShading] containsObject:shading]) {
        _shading = shading;
    }
}
-(NSString *)shading {
    return _shading ? _shading : @"?";
}

@synthesize numberOfShape = _numberOfShape;

- (void)setNumberOfShape:(NSString *)numberOfShape {
    if ([[SetCard validNumberOfShape] containsObject:numberOfShape]) {
        _numberOfShape = numberOfShape;
    }
}
-(NSString *)numberOfShape {
    return _numberOfShape ? _numberOfShape : @"?";
}

- (NSString *)contents {
    return nil;
}


#pragma mark - Set Card valid properties

+ (NSArray<NSString *> *)validShapes {
    return @[@"Diamond", @"Squiggle", @"Oval"];
}
+ (NSArray<NSString *> *)validColor {
    return @[@"Red", @"Green", @"Purple"];
}
+ (NSArray<NSString *> *)validShading {
    return @[@"Solid", @"Striped", @"Open"];
}

+ (NSArray <NSString *> *)validNumberOfShape {
    return @[@"1",@"2",@"3"];
}

+ (NSInteger)maxNumberOfShape {
  NSInteger max = 0;
  for (NSString *num in [SetCard validNumberOfShape]) {
    NSInteger cur = [num intValue];
    max = max > cur ? max : cur;
  }
  return max;
}

@end
