//
//  FBApiManager.m
//  fb-timetable
//
//  Created by Arpit Agarwal on 15/07/18.
//  Copyright © 2018 acyooman. All rights reserved.
//

#import "FBApiManager.h"
#import "AFNetworking.h"
#import "FBApiSettings.h"
#import "FBModelObject.h"

typedef void (^successBlock)(NSURLSessionDataTask *dataTask, id responseObject);
typedef void (^failureBlock)(NSURLSessionDataTask *dataTask, NSError *error);

@interface FBApiManager()
@property (strong, nonatomic) AFHTTPSessionManager *apiManager;
@end

@implementation FBApiManager

+ (FBApiManager *)sharedInstance {
    static FBApiManager *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[FBApiManager alloc] init];
    });
    
    return _sharedInstance;
}

- (void)initialize {
    self.apiManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[self getBaseUrl]];
    [self addTokensToHeader];
}

- (NSURL *)getBaseUrl {
    return [FBApiSettings getApiPath];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.apiManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

#pragma mark - Request Handlers
- (void)getRequestForClass:(Class)Klass WithParameters:(NSDictionary *)params andRetryCount:(NSInteger)retryCount withDelegate:(id)callbackDelegate {
    
    NSMutableDictionary *requestParams = [[NSMutableDictionary alloc] init];
    
    //avoiding request params to keep a strong reference of the objects of the params dictionary
    [requestParams addEntriesFromDictionary:[self copyParamsFromDictionary:params]];

    successBlock requestSuccess = ^(NSURLSessionDataTask *dataTask, id responseObject) {
        
        if ([callbackDelegate respondsToSelector:@selector(didFetchObjects:ForClass:withInitialParams:)]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                if ([[callbackDelegate class] isSubclassOfClass:[FBModelObject class]]) {
                    [callbackDelegate parseObject:responseObject withInitialParams:requestParams];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [callbackDelegate didFetchObjects:responseObject ForClass:Klass withInitialParams:requestParams];
                });
            });
        }
    };
    
    failureBlock requestFailure = ^(NSURLSessionDataTask *dataTask, NSError *error) {
        if (retryCount > 0 && error.code != NSURLErrorCancelled) {
            [self getRequestForClass:Klass WithParameters:params andRetryCount:retryCount - 1 withDelegate:callbackDelegate];
        }
        else {
            if ([callbackDelegate respondsToSelector:@selector(didFailForClass:withError:andInitialParams:)]) {
                [callbackDelegate didFailForClass:Klass withError:error andInitialParams:params];
            }
        }
    };
    
    //modifying url path
    NSString *apiPath = [Klass getAPIPathWithParams:requestParams];    
    [self addTokensToHeader];
    
    NSURLSessionDataTask *dataTask = [self.apiManager GET:apiPath parameters:nil progress:nil success:requestSuccess failure:requestFailure];
    
    //log request in Debug
#if DEBUG
        NSLog(@"Api path = %@", dataTask.originalRequest.URL.absoluteString);
        [requestParams addEntriesFromDictionary:self.apiManager.requestSerializer.HTTPRequestHeaders];
        NSLog(@"Request GET params: %@", requestParams);
#endif
}

#pragma mark - Setters
+ (void)setApiKey:(NSString *)apiKey {
    [FBApiSettings setApiKey:apiKey];
}

+ (void)setApiPath:(NSURL *)apiPath {
    [FBApiSettings setApiPath:apiPath];
}

#pragma mark - Configuration
- (void) addTokensToHeader {
    NSDictionary *headersDictionary = [self defaultHeaders];
    for (id key in [headersDictionary allKeys]) {
        [self.apiManager.requestSerializer setValue:[headersDictionary objectForKey:key] forHTTPHeaderField:key];
    }
}

- (NSDictionary *)defaultHeaders {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[FBApiSettings getApiKey] forKey:@"X-Api-Authentication"];
    return dict;
}

#pragma mark - Helpers
- (NSDictionary *)copyParamsFromDictionary:(NSDictionary *)params{
    NSMutableDictionary *deepCopy = [[NSMutableDictionary alloc] init];
    for (NSString *key in [params allKeys]) {
        [deepCopy setObject:[params objectForKey:key] forKey:key];
    }
    return deepCopy;
}

@end
