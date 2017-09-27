// Created by Bohdan Orlov on 27/09/2017.
// Copyright (c) 2017 Bohdan Orlov. All rights reserved.

#import <Foundation/Foundation.h>
#import "BORBalanceStorage.h"

@interface BORMockBalanceStorage : NSObject <BORBalanceStoring>
@property (assign, nonatomic) NSUInteger transferInvokedCount;
@property (copy, nonatomic) NSArray *transferParameters;
@property (strong, nonatomic) NSMutableArray<BORBalance *> *stubBalances;
@property (nonatomic, copy) void (^interceptedBalancesDidChange)();
@end

