//  Created by Bohdan Orlov on 23/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.

#import "BORExchangeScreenCoordinator.h"
#import "BORBalanceStorage.h"
#import "BORExchangeRateProvider.h"
#import "BORCarouselViewData.h"
#import "BORCurrencyViewData.h"
#import "BORBalance.h"

@interface BORExchangeScreenCoordinator ()

@property (strong, nonatomic) id <BORBalanceStoring> balanceProvider;
@property (strong, nonatomic) id <BORExchangeRateProviding> exchangeRateProvider;
@property (assign, nonatomic) NSInteger selectedFromBalanceIndex;
@property (assign, nonatomic) NSInteger selectedToBalanceIndex;
@property (assign, nonatomic) double fromAmount;
@property (assign, nonatomic) double toAmount;

@end

@implementation BORExchangeScreenCoordinator
@synthesize data = _data;
@synthesize screenDataDidChange = _screenDataDidChange;

+ (instancetype)coordinatorWithBalanceProvider:(id <BORBalanceStoring>)balanceProvider exchangeRateProvider:(id <BORExchangeRateProviding>)exchangeRateProvider {
    BORExchangeScreenCoordinator *coordinator = [[self alloc] init];
    coordinator.balanceProvider = balanceProvider;
    coordinator.exchangeRateProvider = exchangeRateProvider;
    return coordinator;
}

- (void)setBalanceProvider:(id<BORBalanceStoring>)balanceProvider {
    _balanceProvider = balanceProvider;
    _selectedFromBalanceIndex = 0;
    _selectedToBalanceIndex = balanceProvider.balances.count > 1 ? 1 : 0;
    __weak typeof(self) wSelf = self;
    balanceProvider.balancesDidChange = ^{
        [wSelf invalidateData];
    };
}

- (void)setExchangeRateProvider:(id<BORExchangeRateProviding>)exchangeRateProvider {
    _exchangeRateProvider = exchangeRateProvider;
    [exchangeRateProvider startUpdatingExchangeRates];
    __weak typeof(self) wSelf = self;
    exchangeRateProvider.ratesDidChange = ^{
        [wSelf invalidateData];
    };
}

- (void)setSelectedFromBalanceIndex:(NSInteger)selectedFromBalanceIndex {
    _selectedFromBalanceIndex = selectedFromBalanceIndex;
    [self invalidateData];
    if (_selectedFromBalanceIndex == _selectedToBalanceIndex) {
        [self selectNextToCurrency];
    }
}

- (void)setSelectedToBalanceIndex:(NSInteger)selectedToBalanceIndex {
    _selectedToBalanceIndex = selectedToBalanceIndex;
    [self invalidateData];
    if (_selectedToBalanceIndex == _selectedFromBalanceIndex) {
        [self selectNextFromCurrency];
    }
}

- (void)setFromCurrencyAmount:(double)amount {
    self.fromAmount = amount;
    self.toAmount = [self currentExchangeRate].ratio * amount;
    [self invalidateData];
}

- (void)setToCurrencyAmount:(double)amount {
    self.toAmount = amount;
    self.fromAmount = amount * (1 / [self currentExchangeRate].ratio);
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
                                               exchangeRate:[self currentExchangeRateString]
                                      exchangeButtonEnabled:[self exchangeButtonEnabled]];
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
        BORCurrencyViewData *data = [BORCurrencyViewData dataWithCurrency:balance.currency.name balance:[self balanceString:balance] exchangeAmount:[self fromAmountString] balanceHighlighted:[self fromBalanceHighlighted]];
        if ([balance.currency isEqual:self.selectedFromBalance.currency]) {
            selected = data;
        }
        [set addObject:data];

    }
    return [BORCarouselViewData dataWithAllViewData:set selectedViewData:selected];
}

- (BOOL)fromBalanceHighlighted {
    return ![self canExchange];
}

- (NSString *)fromAmountString {
    NSString *numberAsString = [self formattedAmountString:self.fromAmount];
    NSString *prefix = self.fromAmount > 0 ? @"-" : @"";
    return [NSString stringWithFormat:@"%@%@", prefix, numberAsString];
}

- (NSString *)toAmountString {
    NSString *numberAsString = [self formattedAmountString:self.toAmount];
    return [NSString stringWithFormat:@"%@", numberAsString];
}

- (NSString *)formattedAmountString:(double)amount {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    NSString *numberAsString = [numberFormatter stringFromNumber:@(amount)];
    return numberAsString;
}

- (NSString *)balanceString:(BORBalance *)balance {
    return [NSString stringWithFormat:@"Balance: %0.2f", balance.amount];
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
        BORCurrencyViewData *data = [BORCurrencyViewData dataWithCurrency:balance.currency.name balance:[self balanceString:balance] exchangeAmount:[self toAmountString] balanceHighlighted:NO];
        if ([balance.currency isEqual:self.selectedToBalance.currency]) {
            selected = data;
        }
        [set addObject:data];
    }
    return [BORCarouselViewData dataWithAllViewData:set selectedViewData:selected];
}

- (BORExchangeRate *)currentExchangeRate {
    BORCurrency *fromCurrency = self.selectedFromBalance.currency;
    BORCurrency *toCurrency = self.selectedToBalance.currency;
    BORExchangeRate *rate = [self.exchangeRateProvider exchangeRateFrom:fromCurrency to:toCurrency];
    return rate;
}

- (NSString *)currentExchangeRateString {
    BORExchangeRate *rate = [self currentExchangeRate];
    if (!rate) {
        return @"--";
    }
    BORCurrency *fromCurrency = self.selectedFromBalance.currency;
    BORCurrency *toCurrency = self.selectedToBalance.currency;
    return [NSString stringWithFormat:@"%@1 = %@%0.2f", fromCurrency.symbol, toCurrency.symbol, rate.ratio];
}

- (BOOL)exchangeButtonEnabled {
    return [self currentExchangeRate] != nil && self.selectedFromBalance.amount - self.fromAmount >= 0.0 ;
}

- (void)selectNextFromCurrency {
    self.selectedFromBalanceIndex = [self balanceIndexAfterBalance:self.selectedFromBalance];
}

- (void)selectPrevFromCurrency {
    self.selectedFromBalanceIndex = [self balanceIndexBeforeBalance:self.selectedFromBalance];
}

- (void)selectNextToCurrency {
    self.selectedToBalanceIndex = [self balanceIndexAfterBalance:self.selectedToBalance];
}

- (void)selectPrevToCurrency {
    self.selectedToBalanceIndex = [self balanceIndexBeforeBalance:self.selectedToBalance];
}

- (BORBalance *)selectedFromBalance {
    return self.balanceProvider.balances[(NSUInteger)self.selectedFromBalanceIndex];
}


- (BORBalance *)selectedToBalance {
    return self.balanceProvider.balances[(NSUInteger)self.selectedToBalanceIndex];
}

- (NSInteger)balanceIndexBeforeBalance:(BORBalance *)balance {
    NSInteger index = [self.balanceProvider.balances indexOfObject:balance] - 1;
    index = index < 0 ? self.balanceProvider.balances.count - 1 : (NSUInteger)index;
    return index;
}

- (NSInteger)balanceIndexAfterBalance:(BORBalance *)balance {
    NSInteger index = [self.balanceProvider.balances indexOfObject:balance] + 1;
    index %= self.balanceProvider.balances.count;
    return index;
}

- (BORBalance *)balanceBeforeBalance:(BORBalance *)balance {
    NSInteger index = [self balanceIndexBeforeBalance:balance];
    return self.balanceProvider.balances[(NSUInteger)index];
}
- (BORBalance *)balanceAfterBalance:(BORBalance *)balance {
    NSInteger index = [self balanceIndexAfterBalance:balance];
    return self.balanceProvider.balances[(NSUInteger)index];
}

- (BOOL)canExchange {
    BORExchangeRate *rate = [self currentExchangeRate];
    return rate && [self.balanceProvider canTransferFrom:rate.fromCurrency to:rate.toCurrency amount:self.fromAmount rate:rate.ratio];
}

- (void)exchange {
    if (![self canExchange]) {
        return;
    }
    const double transferAmount = self.fromAmount;
    BORExchangeRate *rate = [self currentExchangeRate];
    self.fromAmount = 0;
    self.toAmount = 0;
    [self.balanceProvider transferFrom:rate.fromCurrency to:rate.toCurrency amount:transferAmount rate:rate.ratio];
}

@end
