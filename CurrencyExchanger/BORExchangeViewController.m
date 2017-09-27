//  Created by Bohdan Orlov on 23/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.

#import "BORExchangeViewController.h"
#import "BORCarouselViewController.h"
#import "BORExchangeScreenCoordinator.h"

@interface BORExchangeViewController ()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *keyboardSpacingConstraint;
@property (strong, nonatomic) IBOutlet UIView *exchangeRateContainerView;
@property (strong, nonatomic) IBOutlet UILabel *exchangeRateLabel;
@property (strong, nonatomic) IBOutlet UIButton *exchangeButton;
@property (strong, nonatomic) BORCarouselViewController *topCurrencyViewController;
@property (strong, nonatomic) BORCarouselViewController *bottomCurrencyViewController;
@property (strong, nonatomic) id <NSObject> keyboardSizeObserver;
@end

@implementation BORExchangeViewController

#pragma mark - VLC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureAppearance];
    [self configureActionsHandling];
    [self observeKeyboardSizeChanges];
    [self updateWithData:self.dataProvider.data];
    [self.topCurrencyViewController makeActive];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Note: usage of segues/storyboards is discouraged in big projects due to stringly typed API and deferred initialization.
    if (![segue.destinationViewController isKindOfClass:[BORCarouselViewController class]]) {
        NSAssert(NO, @"Unexpected view controller: %@", segue.destinationViewController);
        return;
    }
    // Note: Identifiers can be generated to make code safer
    if ([segue.identifier isEqualToString:@"topViewController"]) {
        self.topCurrencyViewController = segue.destinationViewController;
        return;
    }
    if ([segue.identifier isEqualToString:@"bottomViewController"]) {
        self.bottomCurrencyViewController = segue.destinationViewController;
        return;
    }
}

#pragma mark - Data updates

- (void)setDataProvider:(id<BORExchangeScreenDataProviding>)dataProvider {
    _dataProvider = dataProvider;
    [self updateWithData: dataProvider.data];
    __weak typeof(self) wSelf = self;
    _dataProvider.screenDataDidChange = ^(BORExchangeScreenData * _Nonnull data) {
        [wSelf updateWithData: data];
    };
}

- (void)updateWithData:(BORExchangeScreenData *)data {
    if (!self.isViewLoaded) {
        return;
    }
    self.topCurrencyViewController.data = data.fromCurrencyData;
    self.bottomCurrencyViewController.data = data.toCurrencyData;
    self.exchangeRateLabel.text = data.exchangeRate;
    self.exchangeButton.enabled = data.exchangeButtonEnabled;
    self.exchangeButton.layer.borderColor = data.exchangeButtonEnabled ? self.exchangeButton.tintColor.CGColor : [UIColor lightGrayColor].CGColor;
}

- (void)observeKeyboardSizeChanges {
    __weak typeof(self) wSelf = self;
    self.keyboardSizeObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull notification) {
        CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        const int extraSpacing = 10;
        wSelf.keyboardSpacingConstraint.constant = keyboardRect.size.height + extraSpacing;
    }];
}


#pragma mark - Actions handling

- (void)configureActionsHandling {
    __weak typeof(self) wSelf = self;
    self.topCurrencyViewController.didSelectPrevView = ^() {
        [wSelf.actionsHandler selectPrevFromCurrency];
    };
    self.topCurrencyViewController.didSelectNextView = ^() {
        [wSelf.actionsHandler selectNextFromCurrency];
    };
    self.topCurrencyViewController.didChangeAmount = ^(double amount) {
        [wSelf.actionsHandler setFromCurrencyAmount:amount];
    };
    self.bottomCurrencyViewController.didSelectPrevView = ^() {
        [wSelf.actionsHandler selectPrevToCurrency];
    };
    self.bottomCurrencyViewController.didSelectNextView = ^() {
        [wSelf.actionsHandler selectNextToCurrency];
    };
    self.bottomCurrencyViewController.didChangeAmount = ^(double amount) {
        [wSelf.actionsHandler setToCurrencyAmount:amount];
    };
}

- (IBAction)didTapExchangeButton:(id)sender {
    [self.actionsHandler exchange];
}

#pragma mark - Appearance configuration

- (void)configureAppearance {
    self.topCurrencyViewController.view.backgroundColor = [UIColor whiteColor];
    self.bottomCurrencyViewController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.05];
    [self configureExchangeRateLabel];
    [self configureExchangeButton];
}

- (void)configureExchangeRateLabel {
    self.exchangeRateContainerView.layer.borderColor = self.bottomCurrencyViewController.view.backgroundColor.CGColor;
    self.exchangeRateContainerView.layer.cornerRadius = self.exchangeRateContainerView.frame.size.height / 2;
    self.exchangeRateContainerView.layer.borderWidth = 2;
    self.exchangeRateLabel.textColor = self.view.tintColor;
}

- (void)configureExchangeButton {
    self.exchangeButton.layer.cornerRadius = self.exchangeButton.frame.size.height / 2;
    self.exchangeButton.layer.borderWidth = self.exchangeRateContainerView.layer.borderWidth;
}


@end
