//
//  BORCurrencyViewController.m
//  CurrencyExchanger
//
//  Created by Bohdan Orlov on 23/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.
//

#import "BORCurrencyViewController.h"

@interface BORCurrencyViewController ()
@property (strong, nonatomic) IBOutlet UILabel *currencyLabel;
@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *exchangeAmountLabel;

@end

@implementation BORCurrencyViewController

@synthesize data = _data;

+ (instancetype)controller {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BORCurrencyViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"currencyViewController"];
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateWithData:self.data];
}

- (void)setData:(BORCurrencyViewData *)data {
    _data = data;
    [self updateWithData:data];
}

- (void)updateWithData:(BORCurrencyViewData *)data {
    if (!self.isViewLoaded) {
        return;
    }
    self.currencyLabel.text = data.currency;
    self.balanceLabel.text = data.balance;
    self.exchangeAmountLabel.text = data.exchangeAmount;
    self.balanceLabel.textColor = data.balanceHighlighted ? [UIColor redColor] : [UIColor blackColor];
}

@end
