//
//  HistoryViewController.m
//  Matchismo
//
//  Created by Rotem Tal on 21/10/2020.
//

#import "HistoryViewController.h"
#import "AttributedStringFunctions.h"

@interface HistoryViewController()
@property (weak, nonatomic) IBOutlet UITextView *historyTextView;
@property (strong, nonatomic) NSAttributedString *noHistoryString;
@end

#define kNoHistoryMessage @"No history for this game yet!"

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateUI];
    self.noHistoryString = [[NSAttributedString alloc] initWithString:kNoHistoryMessage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)updateUI {
    if (self.history == nil | [self.history count] == 0) {
        self.historyTextView.attributedText = self.noHistoryString;
    } else {
        self.historyTextView.attributedText = [AttributedStringFunctions
                                               joinAttributedStringArrayByString:@"\n"
                                               forArray:self.history];
    }
}

@end
