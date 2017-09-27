//
// Copyright (c) Badoo Trading Limited, 2010-present. All rights reserved.
//

#import "BORMockTimer.h"

@implementation BORMockTimer

- (void)startTimerWithTimeInterval:(NSTimeInterval)timeInterval andCallback:(nullable BPFTimerCallback)callback repetitive:(BOOL)repetitive {
    self.invokedTimeInterval = timeInterval;
}

- (void)invalidate {
}


@end
