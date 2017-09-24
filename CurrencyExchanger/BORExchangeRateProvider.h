//
//  BORExchangeRateProvider.h
//  CurrencyExchanger
//
//  Created by Bohdan Orlov on 24/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BORExchangeRate;
@class BORCurrency;

@protocol BORExchangeRateProviding <NSObject>

- (void)exchangeRatesWithCompletion:(void (^)())completion;
- (BORExchangeRate * _Nullable)exchangeRateFrom:(BORCurrency *)fromCurrency to:(BORCurrency *)toCurrency;

@end

@interface BORExchangeRateProvider : NSObject <BORExchangeRateProviding>

@end

NS_ASSUME_NONNULL_END
