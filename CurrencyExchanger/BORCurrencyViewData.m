//
//  BORCurrencyViewData.m
//  CurrencyExchanger
//
//  Created by Bohdan Orlov on 23/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.
//

#import "BORCurrencyViewData.h"

@interface BORCurrencyViewData ()

@property (copy, nonatomic, readwrite) NSString *currency;
@property (copy, nonatomic, readwrite) NSString *balance;
@property (assign, nonatomic, readwrite) NSInteger difference;

@end

@implementation BORCurrencyViewData

+ (instancetype)dataWithCurrency:(NSString *)currency balance:(NSString *)balance difference:(NSInteger)difference {
    BORCurrencyViewData *data = [[self alloc] init];
    data.currency = currency;
    data.balance = balance;
    data.difference = difference;
    return data;
}

- (instancetype)copyWithDifference:(NSInteger)difference {
    BORCurrencyViewData *data = [self copy];
    data.difference = difference;
    return data;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[BORCurrencyViewData class]]) {
        return NO;
    }
    BORCurrencyViewData *otherObject = object;
    return [otherObject.currency isEqualToString:self.currency];
}

- (NSUInteger)hash {
    return self.currency.hash;
}

@end
