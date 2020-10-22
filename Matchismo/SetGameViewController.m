//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Rotem Tal on 20/10/2020.
//

#import "SetGameViewController.h"

#import "SetDeck.h"
#import "SetCard.h"
#import "CardMatchingGame.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
                 blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
                alpha:1.0]

@interface SetGameViewController()
@end

@implementation SetGameViewController

- (Deck *)createDeck {
    return [[SetDeck alloc] init];
}

- (NSAttributedString *)cardsArrayToContentString: (NSArray<SetCard *> *) cardsArray {
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] init];
    NSAttributedString *space = [[NSAttributedString alloc] initWithString:@" "];
    for (SetCard *card in cardsArray) {
        [content appendAttributedString:[self titleForCard:card]];
        [content appendAttributedString:space];
    }
    return content;
}

- (BOOL)isSetGame {
    return YES;
}


#pragma mark UI modifiers

- (void)setButtonBackground:(UIButton *)button forCard:(SetCard *) card {
    [button setBackgroundColor:[self backgroundColorForCard:card]];
    [button setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
    
}


#pragma mark - Visual attributes from card

- (UIColor *)backgroundColorForCard:(SetCard *) card {
    return card.chosen ? UIColorFromRGB(0xFFFF99) : UIColorFromRGB(0xFFFFFF);
}

- (NSAttributedString *)titleForCard:(SetCard *)card {
    NSString *shape = [@"" stringByPaddingToLength:[card.numberOfShape intValue]
                                        withString:card.shape startingAtIndex:0];
    NSMutableAttributedString *cardContent =
        [[NSMutableAttributedString alloc] initWithString:shape];
    [cardContent setAttributes:[self attributeDictionaryForCard:card]
                         range:NSMakeRange(0, [shape length])];
    return cardContent;
}

- (NSDictionary<NSAttributedStringKey, id> *)attributeDictionaryForCard:(SetCard *)card {
    NSUInteger shade = [[SetCard validShading] indexOfObject:card.shading];
    UIColor *shapeColor;
    UIColor *strokeColor;
    NSNumber *strokeWidth = @0;
    if (shade == 2) {
        shapeColor = UIColorFromRGB(0xFFFFFF);
        strokeColor = [self colorFromHexString:card.color];
        strokeWidth = @-3;
    } else {
        shapeColor = strokeColor = [self colorFromHexString:card.color];
        if (shade == 1) {
            shapeColor = [shapeColor colorWithAlphaComponent:0.4];
        }
    }
    return @{ NSForegroundColorAttributeName: shapeColor,
             NSStrokeColorAttributeName: strokeColor,
             NSStrokeWidthAttributeName: strokeWidth };
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return UIColorFromRGB(rgbValue);
}

@end
