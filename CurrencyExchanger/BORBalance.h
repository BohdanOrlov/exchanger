//  Created by Bohdan Orlov on 24/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BORCurrency;

@interface BORBalance : NSObject

@property (strong, nonatomic) BORCurrency *currency;
@property (assign, nonatomic) double amount;

+ (instancetype)balanceWithCurrency:(BORCurrency *)currency amount:(double)amount;
- (instancetype)init NS_UNAVAILABLE;
- (BOOL)isEqual:(id)other;
- (BOOL)isEqualToBalance:(BORBalance *)balance;
- (NSUInteger)hash;

@end

NS_ASSUME_NONNULL_END
