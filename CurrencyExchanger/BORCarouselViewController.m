//  Created by Bohdan Orlov on 23/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.

#import "BORCarouselViewController.h"
#import "BORCurrencyViewController.h"
#import "BORCarouselViewData.h"

@interface BORCarouselViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *amountTextField;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) IBOutlet UIView *activeIndicator;

@end

@implementation BORCarouselViewController

- (IBAction)didTap:(id)sender {
    [self makeActive];
}


- (IBAction)amountDidChange:(id)sender {
    if (self.didChangeAmount) {
        self.didChangeAmount(ABS(self.amountTextField.text.doubleValue));
    }
}
- (IBAction)didEndEditingAmount:(id)sender {
    self.activeIndicator.hidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    self.activeIndicator.layer.cornerRadius = self.activeIndicator.bounds.size.width;
    self.activeIndicator.layer.borderWidth = 2;
    self.activeIndicator.layer.borderColor = self.view.tintColor.CGColor;
}

- (void)setData:(BORCarouselViewData *)data {
    _data = data;
    self.amountTextField.text = data.selectedViewData.exchangeAmount;
    if (self.pageViewController.viewControllers.count) {
        BORCurrencyViewController *currencyController = self.pageViewController.viewControllers.firstObject;
        currencyController.data = data.selectedViewData;
    } else {
        BORCurrencyViewController *currencyController = [BORCurrencyViewController controller];
        currencyController.data = self.data.selectedViewData;
          [self.pageViewController setViewControllers:@[currencyController] direction:UIPageViewControllerNavigationDirectionForward animated:false completion:nil];
//        currencyController.active = self.active;
    }
}

- (void)makeActive {
    [self.amountTextField becomeFirstResponder];
    self.activeIndicator.hidden = NO;
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
    NSUInteger index = [self.data.allViewData indexOfObjectPassingTest:^BOOL(BORCurrencyViewData *obj, NSUInteger idx, BOOL *stop) {
        return [obj.currency isEqualToString:currentCurrencyController.data.currency];
    }];
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
    NSUInteger index = [self.data.allViewData indexOfObjectPassingTest:^BOOL(BORCurrencyViewData *obj, NSUInteger idx, BOOL *stop) {
        return [obj.currency isEqualToString:currentCurrencyController.data.currency];
    }];
    NSInteger prevIndex = index - 1;
    if (prevIndex < 0) {
        return nil;
    }

    BORCurrencyViewController *currencyController = [BORCurrencyViewController controller];
    currencyController.data = self.data.allViewData[(NSUInteger)prevIndex];
    return currencyController;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (!completed) {
        return;
    }

    BORCurrencyViewController *currentController = pageViewController.viewControllers.firstObject;
    BORCurrencyViewController *previousController = (BORCurrencyViewController *)previousViewControllers.firstObject;
    NSUInteger oldIndex = [self.data.allViewData indexOfObjectPassingTest:^BOOL(BORCurrencyViewData *obj, NSUInteger idx, BOOL *stop) {
        return [obj.currency isEqualToString:previousController.data.currency];
    }];
    NSUInteger currentIndex = [self.data.allViewData indexOfObjectPassingTest:^BOOL(BORCurrencyViewData *obj, NSUInteger idx, BOOL *stop) {
        return [obj.currency isEqualToString:currentController.data.currency];
    }];
    BOOL forward = currentIndex > oldIndex;
    if (forward) {
        if (self.didSelectNextView) {
            self.didSelectNextView();
        }
    } else {
        if (self.didSelectPrevView) {
            self.didSelectPrevView();
        }
    }
}

@end
