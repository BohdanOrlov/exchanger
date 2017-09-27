//
//  BORExchangeRate.m
//  CurrencyExchanger
//
//  Created by Bohdan Orlov on 24/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.
//

#import "BORExchangeRate.h"
#import "BORCurrency.h"

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

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;
    return [self isEqualToRate:other];
}

- (BOOL)isEqualToRate:(BORExchangeRate *)rate {
    if (self == rate)
        return YES;
    if (rate == nil)
        return NO;
    if (self.fromCurrency != rate.fromCurrency && ![self.fromCurrency isEqual:rate.fromCurrency])
        return NO;
    if (self.toCurrency != rate.toCurrency && ![self.toCurrency isEqual:rate.toCurrency])
        return NO;
    if (self.ratio != rate.ratio)
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [self.fromCurrency hash];
    hash = hash * 31u + [self.toCurrency hash];
    hash = hash * 31u + [[NSNumber numberWithDouble:self.ratio] hash];
    return hash;
}


@end

