//
//  AttributedStringFunctions.h
//  Matchismo
//
//  Created by Rotem Tal on 21/10/2020.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class Card;

@interface AttributedStringFunctions : NSObject
+ (NSAttributedString *)joinAttributedStringArrayByString:(NSString *)sep
                                                 forArray:(NSArray<NSAttributedString *> *)arr;
@end

NS_ASSUME_NONNULL_END
