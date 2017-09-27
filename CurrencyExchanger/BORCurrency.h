//  Created by Bohdan Orlov on 23/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BORCurrency : NSObject

@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSString *symbol;

+ (instancetype)currencyWithName:(NSString *)name;
+ (instancetype)eur;
+ (instancetype)usd;
+ (instancetype)gbp;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
