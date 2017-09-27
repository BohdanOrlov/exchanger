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

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;
    return [self isEqualToBalance:other];
}

- (BOOL)isEqualToBalance:(BORBalance *)balance {
    if (self == balance)
        return YES;
    if (balance == nil)
        return NO;
    if (self.currency != balance.currency && ![self.currency isEqual:balance.currency])
        return NO;
    if (self.amount != balance.amount)
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [self.currency hash];
    hash = hash * 31u + [[NSNumber numberWithDouble:self.amount] hash];
    return hash;
}

@end
