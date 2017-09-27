//  Created by Bohdan Orlov on 23/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.

#import "BORAppDelegate.h"
#import "BORExchangeViewController.h"
#import "BORExchangeScreenCoordinator.h"
#import "BORBalanceStorage.h"
#import "BORExchangeRateProvider.h"
#import "BORNetworkService.h"
#import "BORTimer.h"

@interface BORAppDelegate ()

@end

@implementation BORAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if ([self.window.rootViewController isKindOfClass:[BORExchangeViewController class]]) {
        BORExchangeRateProvider *exchangeRateProvider = [BORExchangeRateProvider providerWithRatesURL:[NSURL URLWithString:@"http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml"]
                                                                                       networkService:[BORNetworkService new]];
        BORExchangeScreenCoordinator *coordinator = [BORExchangeScreenCoordinator coordinatorWithBalanceProvider:[BORBalanceStorage new]
                                                                                            exchangeRateProvider:exchangeRateProvider
                                                                                                           timer:[BORTimer timer]
                                                                                         updateRatesTimeInterval:30.0];
        BORExchangeViewController *controller = (BORExchangeViewController *) self.window.rootViewController;
        controller.dataProvider = coordinator;
        controller.actionsHandler = coordinator;
    } else {
        NSAssert(NO, @"Unexpected root view controller: %@", self.window.rootViewController);
    }
    return YES;
}

@end
