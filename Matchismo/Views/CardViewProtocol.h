//
//  CardViewProtocol.h
//  Matchismo
//
//  Created by Rotem Tal on 27/10/2020.
//

#import <Foundation/Foundation.h>

@protocol CardViewDelegate;

@protocol CardViewProtocol <NSObject>

- (IBAction)onCardTap:(UITapGestureRecognizer *)sender;

@property (nonatomic) BOOL chosen;
@property (nonatomic) NSUInteger cardIndex;
@property (nonatomic, assign) id <CardViewDelegate> delegate;

@end

