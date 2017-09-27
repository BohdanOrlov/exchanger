//  Created by Bohdan Orlov on 23/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.

#import <UIKit/UIKit.h>
#import "BORCurrencyViewData.h"

NS_ASSUME_NONNULL_BEGIN


@protocol BORCurrencyView <NSObject>

@end

@interface BORCurrencyViewController : UIViewController <BORCurrencyView>

@property (strong, nonatomic) BORCurrencyViewData *data;

+ (instancetype)controller;


@end

NS_ASSUME_NONNULL_END
