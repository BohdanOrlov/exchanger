//
// Copyright (c) Badoo Trading Limited, 2010-present. All rights reserved.
//

#import "BORNetworkService.h"

@implementation BORNetworkService

- (void)loadDataWithUrl:(NSURL *)url completion:(void (^)(NSData * _Nullable data))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:url]; // !!! synchronous network call, this is why it is done on a global thread
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(data);
        });
    });
}

@end
