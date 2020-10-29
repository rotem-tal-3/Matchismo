//
//  CardViewDelegate.h
//  Matchismo
//
//  Created by Rotem Tal on 26/10/2020.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CardViewDelegate <NSObject>

- (void)cardChosenAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
