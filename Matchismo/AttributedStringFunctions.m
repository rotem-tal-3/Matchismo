//
//  AttributedStringFunctions.m
//  Matchismo
//
//  Created by Rotem Tal on 21/10/2020.
//

#import "AttributedStringFunctions.h"
#include "Card.h"

@implementation AttributedStringFunctions
+ (NSAttributedString *)joinAttributedStringArrayByString:(NSString *)sep
                                                 forArray:(NSArray<NSAttributedString *> *)arr
{
    NSMutableAttributedString *joinedString = [[NSMutableAttributedString alloc] init];
    NSAttributedString *sepAttributed = [[NSAttributedString alloc] initWithString:sep];
    for (NSAttributedString *entry in arr) {
        [joinedString appendAttributedString:entry];
        [joinedString appendAttributedString:sepAttributed];
    }
    return joinedString;
}

@end
