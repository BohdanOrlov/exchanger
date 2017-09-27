//
//  BORCurrency.m
//  CurrencyExchanger
//
//  Created by Bohdan Orlov on 23/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.
//

#import "BORCurrency.h"

@interface BORCurrency ()

@property (copy, nonatomic, readwrite) NSString *name;

@end


@implementation BORCurrency

+ (instancetype)currencyWithName:(NSString *)name {
    BORCurrency *currency = [[self alloc] init];
    currency.name = name;
    return currency;
}

+ (instancetype)eur {
    return [self currencyWithName:@"EUR"];
}

+ (instancetype)usd {
    return [self currencyWithName:@"USD"];
}

+ (instancetype)gbp {
    return [self currencyWithName:@"GBP"];
}

- (NSString *)symbol {
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:self.name];
    NSString *currencySymbol = [NSString stringWithFormat:@"%@", [locale displayNameForKey:NSLocaleCurrencySymbol value:self.name]];
    return currencySymbol;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[BORCurrency class]]) {
        return NO;
    }
    BORCurrency *otherObject = object;
    return [otherObject.name isEqualToString:self.name];
}

- (NSUInteger)hash {
    return self.name.hash;
}

@end
