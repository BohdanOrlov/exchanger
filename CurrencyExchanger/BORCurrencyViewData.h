//
//  BORCurrencyViewData.h
//  CurrencyExchanger
//
//  Created by Bohdan Orlov on 23/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BORCurrency.h"

NS_ASSUME_NONNULL_BEGIN

@interface BORCurrencyViewData : NSObject

@property (copy, nonatomic, readonly) NSString *currency;
@property (copy, nonatomic, readonly) NSString *balance;
@property (assign, nonatomic, readonly) NSInteger difference;

+ (instancetype)dataWithCurrency:(NSString *)currency balance:(NSString *)balance difference:(NSInteger) difference;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)copyWithDifference:(NSInteger)difference;

@end

NS_ASSUME_NONNULL_END
