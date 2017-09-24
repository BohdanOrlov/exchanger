//  Created by Bohdan Orlov on 23/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@class BORCarouselViewData;
@class BORCurrencyViewData;

@interface BORCarouselViewController : UIViewController

@property (strong, nonatomic) BORCarouselViewData *data;
@property (copy, nonatomic, nullable) void (^didSelectPrevView)();
@property (copy, nonatomic, nullable) void (^didSelectNextView)();

@end


NS_ASSUME_NONNULL_END

