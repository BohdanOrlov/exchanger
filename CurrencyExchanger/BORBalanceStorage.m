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

@property (strong, nonatomic) NSMutableOrderedSet<BORBalance *> *mutableBalances;

@end

@implementation BORBalanceStorage

- (instancetype)init {
    BORCurrency *eurCurrency = [BORCurrency currencyWithName:@"EUR"];
    BORCurrency *usdCurrency = [BORCurrency currencyWithName:@"USD"];
    BORCurrency *gbpCurrency = [BORCurrency currencyWithName:@"GBP"];
    const double initialAmmount = 100;
    BORBalance *eurBalance = [BORBalance balanceWithCurrency:eurCurrency amount:initialAmmount];
    BORBalance *usdBalance = [BORBalance balanceWithCurrency:usdCurrency amount:initialAmmount];
    BORBalance *gbpBalance = [BORBalance balanceWithCurrency:gbpCurrency amount:initialAmmount];
    self = [super init];
    self.mutableBalances = [NSMutableOrderedSet orderedSetWithObjects:eurBalance, usdBalance, gbpBalance, nil];
    return self;
}

- (NSOrderedSet<BORBalance *> *)balances {
    return [self.mutableBalances copy];
}
@end
