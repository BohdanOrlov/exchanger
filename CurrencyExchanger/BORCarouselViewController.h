//  Created by Bohdan Orlov on 23/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.


@import UIKit;
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BORCarouselViewData;
@class BORCurrencyViewData;

@interface BORCarouselViewController : UIViewController

@property (strong, nonatomic) BORCarouselViewData *data;
@property (copy, nonatomic, nullable) void (^didSelectPrevView)();
@property (copy, nonatomic, nullable) void (^didSelectNextView)();
@property (copy, nonatomic, nullable) void (^didChangeAmount)(double);

- (void)makeActive;

@end


NS_ASSUME_NONNULL_END

