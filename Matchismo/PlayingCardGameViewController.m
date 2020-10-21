//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Rotem Tal on 19/10/2020.
//

#import "PlayingCardGameViewController.h"

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardGameViewController


- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (void)setButtonBackground:(UIButton *)button forCard:(Card *) card {
    [button setTitle:[self titleForCard:card] forState:UIControlStateNormal];
    [button setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
}

- (UIImage *)backgroundImageForCard:(Card *) card {
    return [UIImage imageNamed:card.chosen ? @"cardfront" : @"cardback"];
}

- (NSString *)titleForCard:(Card *)card {
    return card.chosen ? card.contents : @"";
}

- (NSAttributedString *)cardsArrayToContentString: (NSArray<Card *> *) cardsArray {
    NSString *content = @"";
    for (Card *card in cardsArray)
    {
        content = [content stringByAppendingString:card.contents];
    }
    return [[NSAttributedString alloc] initWithString:content];
}

- (BOOL)isSetGame {
    return NO;
}
@end
