//  Created by Bohdan Orlov on 27/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.


#import <XCTest/XCTest.h>
#import "BORExchangeScreenCoordinator.h"
#import "BORMockBalanceStorage.h"
#import "BORMockExchangeRateProvider.h"
#import "BORBalance.h"
#import "BORCurrencyViewData.h"
#import "BORCarouselViewData.h"

@interface BORExchangeScreenCoordinatorTests : XCTestCase
@property (strong, nonatomic) BORMockBalanceStorage *mockBalanceStorage;
@property (strong, nonatomic) BORMockExchangeRateProvider *mockExchangeRateProvider;
@property (strong, nonatomic) BORExchangeScreenCoordinator *coordinator;
@end

@implementation BORExchangeScreenCoordinatorTests

- (void)setUp {
    [super setUp];
    self.mockBalanceStorage = [BORMockBalanceStorage new];
    self.mockExchangeRateProvider = [BORMockExchangeRateProvider new];
    self.coordinator = [BORExchangeScreenCoordinator coordinatorWithBalanceProvider:self.mockBalanceStorage exchangeRateProvider:self.mockExchangeRateProvider];
}

- (void)tearDown {
    self.coordinator = nil;  // XCTestCase is not deallocated after the test has finished
    self.mockExchangeRateProvider = nil;
    self.mockBalanceStorage = nil;
    [super tearDown];
}

- (void)testGivenAmountWasNotSet_WhenExchange_ThenScreenDataDidNotChange {
    // Given
    __block BOOL screenDataDidChangeCalled = NO;
    self.coordinator.screenDataDidChange = ^(BORExchangeScreenData *data) {
        screenDataDidChangeCalled = YES;
    };
    // When
    [self.coordinator exchange];
    // Then
    XCTAssertFalse(screenDataDidChangeCalled);
}

- (void)testGivenBalancesAndFromAmountWasSet_WhenExchange_ThenScreenDataDidChange {
    // Given
    [self mockBalancesWithInitialAmount:100];
    __block BOOL screenDataDidChangeCalled = NO;
    self.coordinator.screenDataDidChange = ^(BORExchangeScreenData *data) {
        screenDataDidChangeCalled = YES;
    };
    [self.coordinator setFromCurrencyAmount:5];
    // When
    [self.coordinator exchange];
    // Then
    XCTAssertTrue(screenDataDidChangeCalled);
}

- (void)test_WhenBalanceChanges_ThenScreenDataIsCorrect {
    // Given
    const double initialAmount = 100;
    [self mockBalancesWithInitialAmount:initialAmount];
    __block BORExchangeScreenData *resultData;
    self.coordinator.screenDataDidChange = ^(BORExchangeScreenData *data) {
        resultData = data;
    };
    // When
    self.mockBalanceStorage.interceptedBalancesDidChange();
    // Then
    NSString *fromBalance = resultData.fromCurrencyData.selectedViewData.balance;
    NSString *toBalance = resultData.toCurrencyData.selectedViewData.balance;
    NSString *expectedFromBalance = [NSString stringWithFormat:@"Balance: %0.2f", initialAmount];
    NSString *expectedToBalance = [NSString stringWithFormat:@"Balance: %0.2f", initialAmount];
    XCTAssertEqualObjects(fromBalance, expectedFromBalance);
    XCTAssertEqualObjects(toBalance, expectedToBalance);
}

- (void)testGivenBalancesAndRatesAndFromAmountWasSet_WhenExchange_ThenTransferIsInvoked {
    // Given
    const double initialAmount = 100;
    const double rate = 0.5;
    const double amountToExchange = 5;
    [self mockBalancesWithInitialAmount:initialAmount];
    [self mockExchangeRate:rate];

    [self.coordinator setFromCurrencyAmount:amountToExchange];
    // When
    [self.coordinator exchange];
    // Then
    XCTAssertEqual(self.mockBalanceStorage.transferInvokedCount, 1);
}

- (void)testGivenBalancesAndRatesAndFromAmountWasSet_WhenExchange_ThenTransferIsCorrect {
    // Given
    const double initialAmount = 100;
    const double rate = 0.5;
    const double amountToExchange = 5;
    [self mockBalancesWithInitialAmount:initialAmount];
    [self mockExchangeRate:rate];

    [self.coordinator setFromCurrencyAmount:amountToExchange];
    // When
    [self.coordinator exchange];
    // Then
    XCTAssertEqualObjects(self.mockBalanceStorage.transferParameters[0],  [BORCurrency eur]);
    XCTAssertEqualObjects(self.mockBalanceStorage.transferParameters[1],  [BORCurrency usd]);
    XCTAssertEqualObjects(self.mockBalanceStorage.transferParameters[2],  @(amountToExchange));
    XCTAssertEqualObjects(self.mockBalanceStorage.transferParameters[3],  @(rate));
}

- (void)testGivenBalances_WhenSelectNextFromCurrency_ThenSelectedCurrencyCorrect {
    // Given
    [self mockBalancesWithInitialAmount:100];
    __block BORExchangeScreenData *resultData;
    self.coordinator.screenDataDidChange = ^(BORExchangeScreenData *data) {
        resultData = data;
    };
    // When
    [self.coordinator selectNextFromCurrency];
    // Then
    XCTAssertEqualObjects([BORCurrency usd].name, resultData.fromCurrencyData.selectedViewData.currency);
}

- (void)testGivenBalances_WhenSelectPrevFromCurrency_ThenSelectedCurrencyCorrect {
    // Given
    [self mockBalancesWithInitialAmount:100];
    __block BORExchangeScreenData *resultData;
    self.coordinator.screenDataDidChange = ^(BORExchangeScreenData *data) {
        resultData = data;
    };
    // When
    [self.coordinator selectPrevFromCurrency];
    // Then
    XCTAssertEqualObjects([BORCurrency usd].name, resultData.fromCurrencyData.selectedViewData.currency);
}

- (void)testGivenBalances_WhenSelectNextToCurrency_ThenSelectedCurrencyCorrect {
    // Given
    [self mockBalancesWithInitialAmount:100];
    __block BORExchangeScreenData *resultData;
    self.coordinator.screenDataDidChange = ^(BORExchangeScreenData *data) {
        resultData = data;
    };
    // When
    [self.coordinator selectNextToCurrency];
    // Then
    XCTAssertEqualObjects([BORCurrency eur].name, resultData.fromCurrencyData.selectedViewData.currency);
}

- (void)testGivenBalances_WhenSelectPrevToCurrency_ThenSelectedCurrencyCorrect {
    // Given
    [self mockBalancesWithInitialAmount:100];
    __block BORExchangeScreenData *resultData;
    self.coordinator.screenDataDidChange = ^(BORExchangeScreenData *data) {
        resultData = data;
    };
    // When
    [self.coordinator selectPrevToCurrency];
    // Then
    XCTAssertEqualObjects([BORCurrency eur].name, resultData.fromCurrencyData.selectedViewData.currency);
}


- (void)mockExchangeRate:(double)rate {
    self.mockExchangeRateProvider.stubbedExchangeRate = [BORExchangeRate rateFrom:[BORCurrency eur] to:[BORCurrency usd] ratio:rate];
}

#pragma mark - Test utilities

- (void)mockBalancesWithInitialAmount:(double)initialAmount {
    BORCurrency *eurCurrency = [BORCurrency eur];
    BORCurrency *usdCurrency = [BORCurrency usd];
    BORBalance *eurBalance = [BORBalance balanceWithCurrency:eurCurrency amount:initialAmount];
    BORBalance *usdBalance = [BORBalance balanceWithCurrency:usdCurrency amount:initialAmount];
    self.mockBalanceStorage.stubBalances = [@[ eurBalance, usdBalance ] mutableCopy];
}


@end
