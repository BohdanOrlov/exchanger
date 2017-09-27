// Created by Bohdan Orlov on 27/09/2017.
// Copyright (c) 2017 Bohdan Orlov. All rights reserved.

#import <Foundation/Foundation.h>
#import "BORExchangeRateProvider.h"

@interface BORMockExchangeRateProvider : NSObject <BORExchangeRateProviding>
@property (nonatomic, strong) BORExchangeRate *stubbedExchangeRate;

@end



