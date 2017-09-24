//
//  BORCurrencyStorage.h
//  CurrencyExchanger
//
//  Created by Bohdan Orlov on 24/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BORBalance;

@protocol BORBalanceProviding <NSObject>

@property (strong, nonatomic, readonly) NSOrderedSet<BORBalance *> *balances;

@end

@interface BORBalanceStorage : NSObject <BORBalanceProviding>

@end

NS_ASSUME_NONNULL_END
