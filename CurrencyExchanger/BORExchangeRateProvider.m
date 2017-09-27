//  Created by Bohdan Orlov on 24/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.

#import "BORExchangeRateProvider.h"
#import "BORExchangeRate.h"
#import "BORCurrency.h"

@interface BORExchangeRateProvider () <NSXMLParserDelegate>

@property (strong, nonatomic, readwrite) NSMutableArray<BORExchangeRate *> *exchangeRates;
@property (nonatomic) NSTimeInterval updateInterval;

@end

@implementation BORExchangeRateProvider
@synthesize ratesDidChange = _ratesDidChange;

+ (instancetype)providerWithUpdateInterval:(NSTimeInterval)updateInterval {
    BORExchangeRateProvider *provider = [[self alloc] init];
    provider.updateInterval = updateInterval;
    provider.exchangeRates = [NSMutableArray array];
    return provider;
}

- (BORExchangeRate *)exchangeRateFrom:(BORCurrency *)fromCurrency to:(BORCurrency *)toCurrency {
    if ([fromCurrency isEqual:toCurrency]) {
        return nil;
    }
    for (BORExchangeRate *rate in self.exchangeRates) {
        if ([rate.fromCurrency isEqual:fromCurrency] && [rate.toCurrency isEqual:toCurrency]){
            return rate;
        }
    }
    // I could use DFS at least to handle N-hop exchanges if EUR rate is not available...
    // ... but I'm too lazy ¯\_(ツ)_/¯
    BORCurrency *eurCurrency = [BORCurrency eur];
    BORExchangeRate *rateToEUR = [self exchangeRateFrom:fromCurrency to:eurCurrency];
    if (rateToEUR) {
        double ratio = rateToEUR.ratio * [self exchangeRateFrom:eurCurrency to:toCurrency].ratio;
        return [BORExchangeRate rateFrom:fromCurrency to:toCurrency ratio:ratio];
    }
    return nil;
}


- (void)startUpdatingExchangeRates {
    [self updateExchangeRates];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.updateInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startUpdatingExchangeRates];
    });

}

- (void)updateExchangeRates {
    __weak typeof(self) wSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        @synchronized (self) {
            // Note: In real project we'd have a network service for this purposes
            NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml"]];
            [wSelf.exchangeRates removeAllObjects];
            [xmlParser setDelegate:wSelf];
            [xmlParser parse];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (wSelf.ratesDidChange) {
                    self.ratesDidChange();
                }
            });
        }
    });
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    if (![elementName isEqualToString:@"Cube"]) {
        return;
    }
    NSString *currency = attributeDict[@"currency"];
    NSString *rate = attributeDict[@"rate"];
    if (!currency || !rate) {
        return;
    }
    BORCurrency *fromCurrency = [BORCurrency eur];
    BORCurrency *toCurrency = [BORCurrency currencyWithName:currency];
    BORExchangeRate *directRate = [BORExchangeRate rateFrom:fromCurrency to:toCurrency ratio:rate.doubleValue];
    [self.exchangeRates addObject:directRate];
    BORExchangeRate *reverseRate = [BORExchangeRate rateFrom:toCurrency to:fromCurrency ratio: 1.0 / directRate.ratio];
    [self.exchangeRates addObject:reverseRate];
}

@end
