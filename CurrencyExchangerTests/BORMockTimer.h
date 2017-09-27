//
// Copyright (c) Badoo Trading Limited, 2010-present. All rights reserved.
//

@import Foundation;
#import "BORTimer.h"

@interface BORMockTimer : NSObject <BORTimerProtocol>
@property (assign, nonatomic) NSTimeInterval invokedTimeInterval;
@end

