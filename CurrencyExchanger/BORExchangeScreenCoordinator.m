//
//  BORExchangeScreenCoordinator.m
//  CurrencyExchanger
//
//  Created by Bohdan Orlov on 23/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.
//

#import "BORExchangeScreenCoordinator.h"
#import "BORBalanceStorage.h"
#import "BORExchangeRateProvider.h"
#import "BORCarouselViewData.h"
#import "BORCurrencyViewData.h"
#import "BORBalance.h"
#import "BORCurrency.h"

@interface BORExchangeScreenCoordinator ()

@property (strong, nonatomic) id <BORBalanceProviding> balanceProvider;
@property (strong, nonatomic) id <BORExchangeRateProviding> exchangeRateProvider;
@property (strong, nonatomic) BORBalance *selectedFromBalance;
@property (strong, nonatomic) BORBalance *selectedToBalance;

@end

@implementation BORExchangeScreenCoordinator
@synthesize data = _data;
@synthesize screenDataDidChange = _screenDataDidChange;


+ (instancetype)coordinatorWithBalanceProvider:(id <BORBalanceProviding>)balanceProvider {
    BORExchangeScreenCoordinator *coordinator = [[self alloc] init];
    coordinator.balanceProvider = balanceProvider;
    coordinator.selectedFromBalance = balanceProvider.balances.firstObject;
    if (balanceProvider.balances.count > 1) {
        coordinator.selectedToBalance = balanceProvider.balances[1];
    } else {
        coordinator.selectedToBalance = coordinator.selectedFromBalance;
    }
    coordinator.exchangeRateProvider = [BORExchangeRateProvider new];  // TODO
    __weak typeof(coordinator) weakCoordinator = coordinator;
    [coordinator.exchangeRateProvider exchangeRatesWithCompletion:^() {
        [weakCoordinator invalidateData];
    }];
    return coordinator;
}

- (void)setSelectedFromBalance:(BORBalance *)selectedFromBalance {
    _selectedFromBalance = selectedFromBalance;
    [self invalidateData];
}

- (void)setSelectedToBalance:(BORBalance *)selectedToBalance {
    _selectedToBalance = selectedToBalance;
    [self invalidateData];
}

- (void)invalidateData {
    _data = nil;
    if (self.screenDataDidChange) {
        self.screenDataDidChange([self data]);
    }
}

- (BORExchangeScreenData *)data {
    if (!_data) {
        _data = [BORExchangeScreenData dataWithFromCurrency:[self fromCurrencyCarouselData]
                                             toCurrencyData:[self toCurrencyCarouselData]
                                               exchangeRate:[self currentExchangeRate]];
    }
    return _data;
}

- (BORCarouselViewData *)fromCurrencyCarouselData {
    NSArray *currentBalances = @[
                                 [self balanceBeforeBalance:self.selectedFromBalance],
                                 self.selectedFromBalance,
                                 [self balanceAfterBalance:self.selectedFromBalance]
                                 ];
    NSMutableOrderedSet *set = [NSMutableOrderedSet orderedSet];
    BORCurrencyViewData *selected = nil;
    for (BORBalance *balance in currentBalances) {
        BORCurrencyViewData *data = [BORCurrencyViewData dataWithCurrency:balance.currency.name balance:[NSString stringWithFormat:@"%0.2f", balance.amount] difference:0];
        if ([balance.currency isEqual:self.selectedFromBalance.currency]) {
            selected = data;
        }
        [set addObject:data];

    }
    return [BORCarouselViewData dataWithAllViewData:set selectedViewData:selected];
}

- (BORCarouselViewData *)toCurrencyCarouselData {
    NSArray *currentBalances = @[
                                 [self balanceBeforeBalance:self.selectedToBalance],
                                 self.selectedToBalance,
                                 [self balanceAfterBalance:self.selectedToBalance]
                                 ];
    NSMutableOrderedSet *set = [NSMutableOrderedSet orderedSet];
    BORCurrencyViewData *selected = nil;
    for (BORBalance *balance in currentBalances) {
        BORCurrencyViewData *data = [BORCurrencyViewData dataWithCurrency:balance.currency.name balance:[NSString stringWithFormat:@"%0.2f", balance.amount] difference:0];
        if ([balance.currency isEqual:self.selectedToBalance.currency]) {
            selected = data;
        }
        [set addObject:data];
    }
    return [BORCarouselViewData dataWithAllViewData:set selectedViewData:selected];
}

- (NSString *)currentExchangeRate {
    BORCurrency *fromCurrency = self.selectedFromBalance.currency;
    BORCurrency *toCurrency = self.selectedToBalance.currency;
    BORExchangeRate *rate = [self.exchangeRateProvider exchangeRateFrom:fromCurrency to:toCurrency];
    if (!rate) {
        return @"--";
    }
    return [NSString stringWithFormat:@"%@ 1 = %@ %0.2f", fromCurrency.symbol, toCurrency.symbol, rate.ratio];
//    return [BORExchangeRate rateFrom:[self fromCurrencyCarouselData].selectedViewData.currency
//                                  to:[self toCurrencyCarouselData].selectedViewData.currency ratio:1.0];
//    return [BORExchangeRate new];
}

- (void)selectNextFromCurrency {
    self.selectedFromBalance = [self balanceAfterBalance:self.selectedFromBalance];
}

- (void)selectPrevFromCurrency {
    self.selectedFromBalance = [self balanceBeforeBalance:self.selectedFromBalance];
}

- (void)selectNextToCurrency {
    self.selectedToBalance = [self balanceAfterBalance:self.selectedToBalance];
}

- (void)selectPrevToCurrency {
    self.selectedToBalance = [self balanceBeforeBalance:self.selectedToBalance];
}

- (BORBalance *)balanceAfterBalance:(BORBalance *)balance {
    NSInteger index = [self.balanceProvider.balances indexOfObject:balance] + 1;
    index %= self.balanceProvider.balances.count;
    return self.balanceProvider.balances[index];
}

- (BORBalance *)balanceBeforeBalance:(BORBalance *)balance {
    NSInteger index = [self.balanceProvider.balances indexOfObject:balance] - 1;
    index = index < 0 ? self.balanceProvider.balances.count - 1 : index;
    return self.balanceProvider.balances[index];
}




- (void)exchange {
    
}

@end
