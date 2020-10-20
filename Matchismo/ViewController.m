//
//  ViewController.m
//  Matchismo
//
//  Created by Rotem Tal on 12/10/2020.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) NSMutableArray<NSString *> *history;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *matchDescriptionLabel;
@property (strong, nonatomic) Deck* deck;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

- (void)setButtonBackground:(UIButton *)button forCard:(Card *) card;
- (NSString *)cardsArrayToContentString: (NSArray<Card *> *) cardsArray;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self startNewGame];
}

- (void)startNewGame
{
    self.deck = [self createDeck];
    self.game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:self.deck];
    [self.game setGameMode:NO];
    [self.matchDescriptionLabel setText:@""];
    [self updateUI];
    [self updateScore];
}

- (Deck *)createDeck
{
    return nil;
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    NSUInteger cardIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:cardIndex];
    [self updateUI];
    [self updateScore];
}

-  (void)updateUI
{
    NSMutableArray<Card *> *chosenCards = [[NSMutableArray alloc]init];
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        if ([self isCardEligable:card])
        {
            [chosenCards addObject:card];
        }
        [self setButtonBackground:cardButton forCard:card];
        cardButton.enabled = !card.matched;
    }
    [self updateDescription:chosenCards];
}

- (BOOL)isCardEligable:(Card *)card
{
    return card.chosen && !card.matched;
}

- (void)updateDescription: (NSMutableArray<Card *> *)chosenCards
{
    NSString *description = [self getMatchDescription:chosenCards];
    [self.history addObject:description];
    [self.matchDescriptionLabel setText:description];
}

- (NSString *)getMatchDescription: (NSArray<Card *> *)chosenCards
{
    NSString* description = @"";
    if ([chosenCards count])
    {
        description = [self cardsArrayToContentString:chosenCards];

    }
    if ([self.game.lastMatchedCards count])
    {
        description =  [NSString stringWithFormat:self.game.lastMatchScore > 0 ? @"Matched %@ for %d points.":@"%@ don't match! %d points penalty" , [self cardsArrayToContentString:self.game.lastMatchedCards], self.game.lastMatchScore];
        
    }
    return description;
}

- (NSString *)cardsArrayToContentString: (NSArray<Card *> *) cardsArray
{
    return nil;
}

- (void)setButtonBackground:(UIButton *)button forCard:(Card *) card
{
    
}

- (void)updateScore
{
    [self.scoreLabel setText:[NSString stringWithFormat:@"Score: %ld", self.game.score]];
}
- (IBAction)resetButtonPressed:(UIButton *)sender
{
    [self startNewGame];
}

@end
