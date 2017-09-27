//  Created by Bohdan Orlov on 24/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BORExchangeRate;
@class BORCurrency;
@class BORNetworkService;

@protocol BORExchangeRateProviding <NSObject>

@property (copy, nonatomic) void (^ratesDidChange)();
- (void)updateExchangeRates;
- (BORExchangeRate * _Nullable)exchangeRateFrom:(BORCurrency *)fromCurrency to:(BORCurrency *)toCurrency;

@end

@interface BORExchangeRateProvider : NSObject <BORExchangeRateProviding>
+ (instancetype)providerWithRatesURL:(NSURL *)ratesURL networkService:(BORNetworkService *)networkService;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
