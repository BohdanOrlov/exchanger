// Created by Bohdan Orlov on 27/09/2017.
// Copyright (c) 2017 Bohdan Orlov. All rights reserved.

#import "BORMockBalanceStorage.h"

@implementation BORMockBalanceStorage

- (NSArray<BORBalance *> *)balances {
    return [self.stubBalances copy];
}

- (void (^)())balancesDidChange {
    return ^{
    };
}

- (void)setBalancesDidChange:(void (^)())balancesDidChange {
    self.interceptedBalancesDidChange = balancesDidChange;
}

- (BOOL)canTransferFrom:(BORCurrency *)fromCurrency to:(BORCurrency *)toCurrency amount:(double)amount rate:(double)rate {
    return YES;
}

- (void)transferFrom:(BORCurrency *)fromCurrency to:(BORCurrency *)toCurrency amount:(double)amount rate:(double)rate {
    self.transferInvokedCount++;
    self.transferParameters = @[fromCurrency, toCurrency, @(amount), @(rate)];
}


@end

