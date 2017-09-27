//  Created by Bohdan Orlov on 24/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.

#import "BORBalance.h"
#import "BORCurrency.h"

@implementation BORBalance

+ (instancetype)balanceWithCurrency:(BORCurrency *)currency amount:(double)amount {
    BORBalance *balance = [[self alloc] init];
    balance.currency = currency;
    balance.amount = amount;
    return balance;
}

@end
