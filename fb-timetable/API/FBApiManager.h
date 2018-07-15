//
//  FBApiManager.h
//  fb-timetable
//
//  Created by Arpit Agarwal on 15/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FBApiManagerDelegate <NSObject>

@required
- (void)didFetchObjects:(id)objects ForClass:(Class)klass withInitialParams:(NSDictionary *)params;

@required
- (void) didFailForClass:(Class) klass withError:(NSError *) error andInitialParams:(NSDictionary *)dictionary;

@end

@interface FBApiManager : NSObject

+ (FBApiManager *)sharedInstance;

+ (void)setApiKey:(NSString *)apiKey;
+ (void)setApiPath:(NSURL *)apiPath;

- (void)initialize;

- (void)getRequestForClass:(Class)Klass WithParameters:(NSDictionary *)params andRetryCount:(NSInteger)retryCount withDelegate:(id)callbackDelegate;

@end
