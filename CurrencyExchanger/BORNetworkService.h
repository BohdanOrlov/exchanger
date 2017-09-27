//  Created by Bohdan Orlov on 27/09/2017.
//  Copyright © 2017 Bohdan Orlov. All rights reserved.

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@protocol BORDataLoading <NSObject> // Note: not a production grade API =)

- (void)loadDataWithUrl:(NSURL *)url completion:(void (^)(NSData * _Nullable data))completion;

@end

@interface BORNetworkService : NSObject <BORDataLoading>

@end

NS_ASSUME_NONNULL_END
