//  Created by Bohdan Orlov on 23/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.

#import "BORExchangeViewController.h"
#import "BORCarouselViewController.h"
#import "BORExchangeScreenCoordinator.h"

@interface BORExchangeViewController ()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *keyboardSpacingConstraint;
@property (strong, nonatomic) IBOutlet UIView *exchangeRateContainerView;
@property (strong, nonatomic) IBOutlet UILabel *exchangeRateLabel;
@property (strong, nonatomic) BORCarouselViewController *topCurrencyViewController;
@property (strong, nonatomic) BORCarouselViewController *bottomCurrencyViewController;
@property (strong, nonatomic) IBOutlet UIButton *exchangeButton;
@end

@implementation BORExchangeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) wSelf = self;
    self.topCurrencyViewController.didSelectPrevView = ^() {
        [wSelf.actionsHandler selectPrevFromCurrency];
    };
    self.topCurrencyViewController.didSelectNextView = ^() {
        [wSelf.actionsHandler selectNextFromCurrency];
    };
    self.bottomCurrencyViewController.didSelectPrevView = ^() {
        [wSelf.actionsHandler selectPrevToCurrency];
    };
    self.bottomCurrencyViewController.didSelectNextView = ^() {
        [wSelf.actionsHandler selectNextToCurrency];
    };
    [self updateWithData:self.dataProvider.data];
    self.topCurrencyViewController.view.backgroundColor = [UIColor whiteColor];
    self.bottomCurrencyViewController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.05];
    self.exchangeRateContainerView.layer.borderColor = self.bottomCurrencyViewController.view.backgroundColor.CGColor;
    self.exchangeRateContainerView.layer.cornerRadius = self.exchangeRateContainerView.frame.size.height / 2;
    self.exchangeRateContainerView.layer.borderWidth = 2;
    self.exchangeRateLabel.textColor = self.view.tintColor;
    self.exchangeButton.layer.cornerRadius = self.exchangeButton.frame.size.height / 2;
    self.exchangeButton.layer.borderWidth = self.exchangeRateContainerView.layer.borderWidth;
    self.exchangeButton.layer.borderColor = self.exchangeButton.tintColor.CGColor;
}

- (void)updateWithData:(BORExchangeScreenData *)data {
    if (!self.isViewLoaded) {
        return;
    }
    self.topCurrencyViewController.data = data.fromCurrencyData;
    self.bottomCurrencyViewController.data = data.toCurrencyData;
    self.exchangeRateLabel.text = data.exchangeRate;
}

- (void)setDataProvider:(id<BORExchangeScreenDataProviding>)dataProvider {
    _dataProvider = dataProvider;
    [self updateWithData: dataProvider.data];
    __weak typeof(self) wSelf = self;
    _dataProvider.screenDataDidChange = ^(BORExchangeScreenData * _Nonnull data) {
        [wSelf updateWithData: data];
    };
}

- (IBAction)didTapExchangeButton:(id)sender {
    [self.actionsHandler exchange];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Note: usage of segues/storyboards is discouraged in big projects due to stringly typed API and deffered initialization.
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


@end
