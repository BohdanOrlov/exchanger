//
//  BORExchangeViewData.m
//  CurrencyExchanger
//
//  Created by Bohdan Orlov on 23/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.
//

#import "BORExchangeScreenData.h"

@interface BORExchangeScreenData ()

@property (strong, nonatomic, readwrite) BORCarouselViewData *fromCurrencyData;
@property (strong, nonatomic, readwrite) BORCarouselViewData *toCurrencyData;
@property (strong, nonatomic, readwrite) NSString *exchangeRate;
@property (assign, nonatomic, readwrite) BOOL exchangeButtonEnabled;

@end

@implementation BORExchangeScreenData
+ (instancetype)dataWithFromCurrency:(BORCarouselViewData *)fromCurrencyData
                      toCurrencyData:(BORCarouselViewData *)toCurrencyData
                        exchangeRate:(NSString *)exchangeRate
               exchangeButtonEnabled:(BOOL)exchangeButtonEnabled {
    BORExchangeScreenData *data = [[self alloc] init];
    data.fromCurrencyData = fromCurrencyData;
    data.toCurrencyData = toCurrencyData;
    data.exchangeRate = exchangeRate;
    data.exchangeButtonEnabled = exchangeButtonEnabled;
    return data;
}
@end


