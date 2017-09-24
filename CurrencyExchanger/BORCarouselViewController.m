//  Created by Bohdan Orlov on 23/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.

#import "BORCarouselViewController.h"
#import "BORCurrencyViewController.h"
#import "BORCarouselViewData.h"
#import "BORCurrencyViewData.h"

@interface BORCarouselViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@end

@implementation BORCarouselViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
}

- (void)setData:(BORCarouselViewData *)data {
    _data = data;
    if (self.pageViewController.viewControllers.count) {
        BORCurrencyViewController *currencyController = (BORCurrencyViewController *)self.pageViewController.viewControllers.firstObject;
        currencyController.data = data.selectedViewData;
    } else {
        BORCurrencyViewController *currencyController = [BORCurrencyViewController controller];
        currencyController.data = self.data.selectedViewData;
          [self.pageViewController setViewControllers:@[currencyController] direction:UIPageViewControllerNavigationDirectionForward animated:false completion:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (![segue.destinationViewController isKindOfClass:[UIPageViewController class]]) {
        NSAssert(NO, @"Unexpected view controller: %@", segue.destinationViewController);
        return;
    }
    if ([segue.identifier isEqualToString:@"pageViewController"]) {
        self.pageViewController = segue.destinationViewController;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    BORCurrencyViewController *currentCurrencyController = (BORCurrencyViewController *)viewController;
    NSUInteger index = [self.data.allViewData indexOfObject:currentCurrencyController.data];
    NSUInteger nextIndex = index + 1;
    if (nextIndex >= self.data.allViewData.count) {
        return nil;
    }

    BORCurrencyViewController *currencyController = [BORCurrencyViewController controller];
    currencyController.data = self.data.allViewData[nextIndex];
    return currencyController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    BORCurrencyViewController *currentCurrencyController = (BORCurrencyViewController *)viewController;
    NSInteger index = [self.data.allViewData indexOfObject:currentCurrencyController.data];
    NSInteger prevIndex = index - 1;
    if (prevIndex < 0) {
        return nil;
    }

    BORCurrencyViewController *currencyController = [BORCurrencyViewController controller];
    currencyController.data = self.data.allViewData[prevIndex];
    return currencyController;
}


- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (!completed) {
        return;
    }
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

//    dispatch_async(dispatch_get_main_queue(), ^{  // calling setVCs in this callback crashes the app, even though UIPageViewController is "completed", so dispatch_async makes sure it is actually finished
        BORCurrencyViewController *currentController = (BORCurrencyViewController *)pageViewController.viewControllers.firstObject;
        BORCurrencyViewController *previousController = (BORCurrencyViewController *) previousViewControllers.firstObject;
        NSInteger oldIndex = [self.data.allViewData indexOfObject:previousController.data];
        NSInteger currentIndex = [self.data.allViewData indexOfObject:currentController.data];
        BOOL forward = currentIndex > oldIndex;
        NSLog(@"Direction: %d", forward);
        if (forward) {
            if (self.didSelectNextView) {
                self.didSelectNextView();
            }

        } else {
            if (self.didSelectPrevView) {
                self.didSelectPrevView();
            }
        }
//    });
//    });
}

@end
