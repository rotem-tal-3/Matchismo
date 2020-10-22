//
//  ViewController.m
//  Matchismo
//
//  Created by Rotem Tal on 12/10/2020.
//

#import "ViewController.h"

#import "CardMatchingGame.h"
#import "Deck.h"
#import "Card.h"
#import "HistoryViewController.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) NSMutableArray<NSAttributedString *> *history;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *matchDescriptionLabel;
@property (strong, nonatomic) Deck* deck;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

- (BOOL)isSetGame;
- (void)setButtonBackground:(UIButton *)button forCard:(Card *) card;
- (NSAttributedString *)cardsArrayToContentString: (NSArray<Card *> *) cardsArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startNewGame];
}

- (void)startNewGame {
    self.deck = [self createDeck];
    self.game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:self.deck];
    self.history = [NSMutableArray array];
    [self.game setIsGameMode3Way:[self isSetGame]];
    [self updateUI];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender {
    if (![segue.identifier isEqualToString:@"historySegue"] | ![segue.destinationViewController isKindOfClass:[HistoryViewController class]]) {
        return;
    }
    HistoryViewController *hvc = (HistoryViewController *)segue.destinationViewController;
    hvc.history = self.history;
}

- (NSMutableArray *)getChosenCards {
    NSMutableArray<Card *> *chosenCards = [NSMutableArray array];
    for (NSUInteger i = 0; i < [self.cardButtons count]; i++) {
        Card *card = [self.game cardAtIndex:i];
        if (card.chosen && !card.matched) {
            [chosenCards addObject:card];
        }
    }
    return chosenCards;
}

#pragma mark - UI responders

- (IBAction)resetButtonPressed:(UIButton *)sender {
    [self startNewGame];
}

- (IBAction)touchCardButton:(UIButton *)sender {
    NSUInteger cardIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:cardIndex];
    [self updateUI];
}


#pragma mark - UI modifiers

- (void)updateUI {
    [self setButtons];
    [self updateDescription];
    [self updateScore];
}

- (void)setButtons {
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        [self setButtonBackground:cardButton forCard:card];
        cardButton.enabled = !card.matched;
    }
}

- (void)updateScore {
    [self.scoreLabel setText:[NSString stringWithFormat:@"Score: %ld", self.game.score]];
}

- (void)updateDescription {
    NSAttributedString *description = [self getRoundDescription];
    [self.matchDescriptionLabel setAttributedText:description];
}


#pragma mark - Game description handlers
 
- (NSAttributedString *)getRoundDescription {
    NSAttributedString *description = [[NSAttributedString alloc] initWithString: @""];
    NSMutableArray *chosenCards = [self getChosenCards];
    if ([chosenCards count]) {
        description = [self cardsArrayToContentString:chosenCards];
    }
    if ([self.game.lastMatchedCards count]) {
        description = [self getMatchDescription:self.game.lastMatchedCards];
        [self.history addObject:description];
    }
    return description;
}

- (NSAttributedString *)getMatchDescription:(NSArray<Card *> *)chosenCards {
    BOOL isWinningMessage = self.game.lastMatchScore > 0;
    NSString *textBeforeCardString = isWinningMessage ? @"Matched " : @"";
    NSString *textAfterCardString = [NSString stringWithFormat:isWinningMessage ?
                                     @" for %ld points." :
                                     @" don't match! %ld points penalty", self.game.lastMatchScore];
    NSMutableAttributedString *description = [[NSMutableAttributedString alloc]
                                      initWithString:textBeforeCardString];
    [description appendAttributedString:[self cardsArrayToContentString:chosenCards]];
    [description appendAttributedString:[[NSAttributedString alloc]
                                         initWithString:textAfterCardString]];
    return description;
}


#pragma mark - Functions to be overriden by subclass

- (NSAttributedString *)cardsArrayToContentString: (NSArray<Card *> *) cardsArray {
    return nil;
}

- (void)setButtonBackground:(UIButton *)button forCard:(Card *) card {
    
}

- (BOOL)isSetGame {
    return NO;
}

- (Deck *)createDeck {
    return nil;
}

@end
