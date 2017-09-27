//  Created by Bohdan Orlov on 23/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.

@import UIKit;
#import <Foundation/Foundation.h>
#import "BORExchangeScreenData.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BORExchangeScreenDataProviding;
@protocol BORExchangeScreenActionHandling;

@interface BORExchangeViewController : UIViewController

@property (strong, nonatomic) id <BORExchangeScreenDataProviding> dataProvider;
@property (strong, nonatomic) id <BORExchangeScreenActionHandling> actionsHandler;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

