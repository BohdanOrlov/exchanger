//
//  BORExchangeRate.m
//  CurrencyExchanger
//
//  Created by Bohdan Orlov on 24/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.
//

#import "BORExchangeRate.h"

@interface BORExchangeRate ()

@property (strong, nonatomic, readwrite) BORCurrency *fromCurrency;
@property (strong, nonatomic, readwrite) BORCurrency *toCurrency;
@property (assign, nonatomic, readwrite) double ratio;

@end

@implementation BORExchangeRate

+ (instancetype)rateFrom:(BORCurrency *)fromCurrency to:(BORCurrency *)toCurrency ratio:(double)ratio {
    BORExchangeRate *rate = [[self alloc] init];
    rate.fromCurrency = fromCurrency;
    rate.toCurrency = toCurrency;
    rate.ratio = ratio;
    return rate;
}

@end

