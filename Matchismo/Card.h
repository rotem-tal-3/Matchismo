//
//  Card.h
//  Matchismo
//
//  Created by Rotem Tal on 12/10/2020.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Card : NSObject
@property (strong, nonatomic) NSString *contents;
@property (nonatomic) BOOL chosen;
@property (nonatomic) BOOL matched;

- (NSInteger)match: (NSArray<Card *> *)otherCards;
@end

NS_ASSUME_NONNULL_END
