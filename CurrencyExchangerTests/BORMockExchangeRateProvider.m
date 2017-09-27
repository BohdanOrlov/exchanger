// Created by Bohdan Orlov on 27/09/2017.
// Copyright (c) 2017 Bohdan Orlov. All rights reserved.

#import "BORMockBalanceStorage.h"
#include "BORMockExchangeRateProvider.h"

@implementation BORMockExchangeRateProvider

- (void (^)())ratesDidChange {
    return ^{
    };
}

- (void)setRatesDidChange:(void (^)())ratesDidChange {
}

- (void)startUpdatingExchangeRates {
}

- (BORExchangeRate *_Nullable)exchangeRateFrom:(BORCurrency *)fromCurrency to:(BORCurrency *)toCurrency {
    return self.stubbedExchangeRate;
}

@end