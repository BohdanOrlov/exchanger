//
// Copyright (c) Badoo Trading Limited, 2010-present. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^BPFTimerCallback)(void);

@protocol BORTimerProtocol

- (void)startTimerWithTimeInterval:(NSTimeInterval)timeInterval andCallback:(nullable BPFTimerCallback)callback repetitive:(BOOL)repetitive;
- (void)invalidate;

@end


// The purpose of this timer is to non-retain target which NSTimer is not suitable for

@interface BORTimer : NSObject <BORTimerProtocol>

+ (BORTimer *)timer;

@end

NS_ASSUME_NONNULL_END
