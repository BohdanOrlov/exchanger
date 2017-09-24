//
//  BORCarouselViewData.m
//  CurrencyExchanger
//
//  Created by Bohdan Orlov on 23/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.
//

#import "BORCarouselViewData.h"
#import "BORCurrencyViewData.h"

@interface BORCarouselViewData ()

@property (copy, nonatomic, readwrite) NSOrderedSet<BORCurrencyViewData *> *allViewData;
@property (strong, nonatomic, readwrite) BORCurrencyViewData *selectedViewData;

@end

@implementation BORCarouselViewData

+ (instancetype)dataWithAllViewData:(NSOrderedSet<BORCurrencyViewData *> *)allViewData
        selectedViewData:(nonnull BORCurrencyViewData *)selectedViewData {
    BORCarouselViewData *data = [[self alloc] init];
    data.allViewData = [allViewData copy];
    data.selectedViewData = selectedViewData;
    return data;
}

@end
