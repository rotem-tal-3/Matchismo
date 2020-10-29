//
//  PlayingCardView.h
//  Matchismo
//
//  Created by Rotem Tal on 25/10/2020.
//

#import <UIKit/UIKit.h>

#import "CardViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@protocol CardViewDelegate;

@interface PlayingCardView : UIView <CardViewProtocol>

- (instancetype)initWithFrame:(CGRect)frame atIndex:(NSUInteger)index withRank:(NSInteger)rank withSuit:(NSString *)suit;

@property (readonly, nonatomic) NSUInteger rank;
@property (readonly, nonatomic) NSString *suit;
@end

NS_ASSUME_NONNULL_END
