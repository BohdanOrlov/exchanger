//
//  BORCarouselViewData.h
//  CurrencyExchanger
//
//  Created by Bohdan Orlov on 23/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BORCurrencyViewData;

NS_ASSUME_NONNULL_BEGIN

@interface BORCarouselViewData : NSObject

@property (copy, nonatomic, readonly) NSOrderedSet<BORCurrencyViewData *> *allViewData;
@property (strong, nonatomic, readonly) BORCurrencyViewData *selectedViewData;

+ (instancetype)dataWithAllViewData:(NSOrderedSet<BORCurrencyViewData *> *) allViewData
        selectedViewData:(BORCurrencyViewData *)selectedViewData;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
