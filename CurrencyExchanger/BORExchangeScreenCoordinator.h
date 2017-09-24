//
//  BORExchangeScreenCoordinator.h
//  CurrencyExchanger
//
//  Created by Bohdan Orlov on 23/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BORExchangeScreenData.h"
#import "BORCurrency.h"

NS_ASSUME_NONNULL_BEGIN

@class BORCurrencyViewData;
@protocol BORBalanceProviding;

@protocol BORExchangeScreenDataProviding <NSObject>

@property (copy, nonatomic, readonly) BORExchangeScreenData *data;
@property (copy, nonatomic, nullable) void (^screenDataDidChange)(BORExchangeScreenData *);

@end


@protocol BORExchangeScreenActionHandling <NSObject>

- (void)selectNextFromCurrency;
- (void)selectPrevFromCurrency;

- (void)selectNextToCurrency;
- (void)selectPrevToCurrency;

- (void)exchange;

@end

@interface BORExchangeScreenCoordinator : NSObject <BORExchangeScreenDataProviding, BORExchangeScreenActionHandling>


+ (instancetype)coordinatorWithBalanceProvider:(id<BORBalanceProviding>)balanceProvider;


@end

NS_ASSUME_NONNULL_END
