//  Created by Bohdan Orlov on 24/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BORBalance;
@class BORCurrency;

@protocol BORBalanceStoring <NSObject>

@property (strong, nonatomic, readonly) NSArray<BORBalance *> *balances;
@property (copy, nonatomic, nullable) void (^balancesDidChange)();

- (BOOL)canTransferFrom:(BORCurrency *)fromCurrency to:(BORCurrency *)toCurrency amount:(double)amount rate:(double)rate;
- (void)transferFrom:(BORCurrency *)fromCurrency to:(BORCurrency *)toCurrency amount:(double)amount rate:(double)rate;

@end

@interface BORBalanceStorage : NSObject <BORBalanceStoring>

@end

NS_ASSUME_NONNULL_END
