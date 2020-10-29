//
//  ViewController.h
//  Matchismo
//
//  Created by Rotem Tal on 12/10/2020.
//

#import <UIKit/UIKit.h>

#import "CardViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@class Deck, CardMatchingGame;

@interface ViewController : UIViewController <CardViewDelegate>

- (Deck *)createDeck;

@property (nonatomic, readonly) CardMatchingGame *game;
@end
NS_ASSUME_NONNULL_END;
