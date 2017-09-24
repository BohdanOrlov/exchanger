//
//  AppDelegate.m
//  CurrencyExchanger
//
//  Created by Bohdan Orlov on 23/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.
//

#import "BORAppDelegate.h"
#import "BORExchangeViewController.h"
#import "BORExchangeScreenCoordinator.h"
#import "BORBalanceStorage.h"

@interface BORAppDelegate ()

@end

@implementation BORAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if ([self.window.rootViewController isKindOfClass:[BORExchangeViewController class]]) {
        BORExchangeViewController *controller = (BORExchangeViewController *) self.window.rootViewController;
        BORExchangeScreenCoordinator *coordinator = [BORExchangeScreenCoordinator coordinatorWithBalanceProvider:[BORBalanceStorage new]];
        controller.dataProvider = coordinator;
        controller.actionsHandler = coordinator;
    } else {
        NSAssert(NO, @"Unexpected root view controller: %@", self.window.rootViewController);
    }
    return YES;
}

@end
