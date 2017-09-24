//
//  BORExchangeViewData.h
//  CurrencyExchanger
//
//  Created by Bohdan Orlov on 23/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BORExchangeRate.h"

@class BORCarouselViewData;

NS_ASSUME_NONNULL_BEGIN

@interface BORExchangeScreenData : NSObject

@property (strong, nonatomic, readonly) BORCarouselViewData *fromCurrencyData;
@property (strong, nonatomic, readonly) BORCarouselViewData *toCurrencyData;
@property (strong, nonatomic, readonly) NSString *exchangeRate;

+ (instancetype)dataWithFromCurrency:(BORCarouselViewData *)fromCurrencyData toCurrencyData:(BORCarouselViewData *)toCurrencyData exchangeRate:(NSString *)exchangeRate;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
