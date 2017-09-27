//
// Copyright (c) Badoo Trading Limited, 2010-present. All rights reserved.
//

#import "BORTimer.h"

@interface BORTimer ()

@property (nonatomic) dispatch_source_t timer;
@property (nonatomic, copy) BPFTimerCallback callback;
@property (nonatomic) BOOL repetitive;

@end

@implementation BORTimer


+ (BORTimer *)timer {
    BORTimer *timer = [[BORTimer alloc] init];
    return timer;
}


- (void)invalidate {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
        dispatch_release(self.timer);
#endif
        self.timer = nil;
    }
    self.callback = nil;
}


- (void)startTimerWithTimeInterval:(NSTimeInterval)timeInterval andCallback:(nullable BPFTimerCallback)callback repetitive:(BOOL)repetitive {
    [self invalidate];

    self.callback = callback;
    self.repetitive = repetitive;

    self.timer = dispatch_source_create(
        DISPATCH_SOURCE_TYPE_TIMER, 0, 0, [NSThread isMainThread] ? dispatch_get_main_queue() : dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));

    dispatch_source_set_timer(self.timer,
                              dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)),
                              repetitive ? (uint64_t)(timeInterval * NSEC_PER_SEC) : DISPATCH_TIME_FOREVER,
                              0);

    if (repetitive) {
        dispatch_source_set_event_handler(self.timer, callback);
    } else {
        __weak typeof(self) wSelf = self;
        dispatch_source_set_event_handler(self.timer, ^{
            callback();
            [wSelf invalidate];
        });
    }

    dispatch_resume(self.timer);
}

- (void)dealloc {
    [self invalidate];
}

@end

