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
@property (copy, nonatomic, readwrite) NSString *exchangeAmount;
@property (assign, nonatomic, readwrite) BOOL balanceHighlighted;

@end

@implementation BORCurrencyViewData
+ (instancetype)dataWithCurrency:(NSString *)currency balance:(NSString *)balance exchangeAmount:(NSString *)exchangeAmount balanceHighlighted:(BOOL)balanceHighlighted {
    BORCurrencyViewData *data = [[self alloc] init];
    data.currency = currency;
    data.balance = balance;
    data.exchangeAmount = exchangeAmount;
    data.balanceHighlighted = balanceHighlighted;
    return data;
}

@end
