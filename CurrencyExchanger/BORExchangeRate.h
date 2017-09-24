//
//  BORExchangeRate.h
//  CurrencyExchanger
//
//  Created by Bohdan Orlov on 24/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BORCurrency;

@interface BORExchangeRate : NSObject

@property (strong, nonatomic, readonly) BORCurrency *fromCurrency;
@property (strong, nonatomic, readonly) BORCurrency *toCurrency;
@property (assign, nonatomic, readonly) double ratio;

+ (instancetype)rateFrom:(BORCurrency *)fromCurrency to:(BORCurrency *)toCurrency ratio:(double)ratio;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
