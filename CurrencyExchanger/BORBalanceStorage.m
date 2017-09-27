//
//  BORCurrencyStorage.m
//  CurrencyExchanger
//
//  Created by Bohdan Orlov on 24/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.
//

#import "BORBalanceStorage.h"
#import "BORCurrency.h"
#import "BORBalance.h"

@interface BORBalanceStorage ()

@property (strong, nonatomic) NSMutableArray<BORBalance *> *mutableBalances;

@end

@implementation BORBalanceStorage
@synthesize balancesDidChange = _balancesDidChange;

- (instancetype)init {
    BORCurrency *eurCurrency = [BORCurrency eur];
    BORCurrency *usdCurrency = [BORCurrency usd];
    BORCurrency *gbpCurrency = [BORCurrency gbp];
    const double initialAmount = 100;
    BORBalance *eurBalance = [BORBalance balanceWithCurrency:eurCurrency amount:initialAmount];
    BORBalance *usdBalance = [BORBalance balanceWithCurrency:usdCurrency amount:initialAmount];
    BORBalance *gbpBalance = [BORBalance balanceWithCurrency:gbpCurrency amount:initialAmount];
    self = [super init];
    self.mutableBalances = [@[ eurBalance, usdBalance, gbpBalance ] mutableCopy];
    return self;
}

- (NSArray<BORBalance *> *)balances {
    return [self.mutableBalances copy];
}

- (BOOL)canTransferFrom:(BORCurrency *)fromCurrency to:(BORCurrency *)toCurrency amount:(double)amount rate:(double)rate {
    BORBalance *fromBalance;
    for (BORBalance *balance in self.mutableBalances) {
        if ([balance.currency isEqual:fromCurrency]) {
            fromBalance = balance;
        }
    }
    NSParameterAssert(fromBalance);
    if (fromBalance.amount - amount < 0) {
        return NO;
    }
    return YES;
}

- (void)transferFrom:(BORCurrency *)fromCurrency to:(BORCurrency *)toCurrency amount:(double)amount rate:(double)rate {
    if (![self canTransferFrom:fromCurrency to:toCurrency amount:amount rate:rate]) {
        NSAssert(NO, @"Call canTransferFrom:to: prior trying to transfer");
        return;
    }
    BORBalance *fromBalance;
    BORBalance *toBalance;
    for (BORBalance *balance in self.mutableBalances) {
        if ([balance.currency isEqual:fromCurrency]) {
            fromBalance = balance;
        }
        if ([balance.currency isEqual:toCurrency]) {
            toBalance = balance;
        }
    }
    NSParameterAssert(fromBalance);
    NSParameterAssert(toBalance);
    BORBalance *updatedFromBalance = [BORBalance balanceWithCurrency:fromBalance.currency amount:fromBalance.amount - amount];
    BORBalance *updatedToBalance = [BORBalance balanceWithCurrency:toBalance.currency amount:toBalance.amount + amount * rate];
    NSUInteger fromIndex = [self.mutableBalances indexOfObject:fromBalance];
    NSUInteger toIndex = [self.mutableBalances indexOfObject:toBalance];
    self.mutableBalances[fromIndex] = updatedFromBalance;
    self.mutableBalances[toIndex] = updatedToBalance;
    if (self.balancesDidChange) {
        self.balancesDidChange();
    }
}
@end
