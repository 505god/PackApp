//
//  SWAPIManager.m
//  Test
//
//  Created by 邱成西 on 2017/5/12.
//  Copyright © 2017年 邱大侠. All rights reserved.
//

#import "SWAPIManager.h"
#import "SWApiProxy.h"

#define SWCallAPI(REQUEST_METHOD, REQUEST_ID)                                                   \
{                                                                                               \
REQUEST_ID = [[SWApiProxy sharedInstance] call##REQUEST_METHOD##WithParams:parameters methodName:path success:^(id responseObject, NSInteger responseStatus) {                                                          \
    success(responseObject);\
} fail:^(id responseObject, NSInteger responseStatus) {                                                                                 \
    failure(@"");\
}];                                                                                         \
[self.requestIdList addObject:@(REQUEST_ID)];                                               \
}

@interface SWAPIManager ()

@property (nonatomic, strong) NSMutableArray *requestIdList;

@end

@implementation SWAPIManager

#pragma mark - life cycle

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static SWAPIManager *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SWAPIManager alloc] init];
    });
    return sharedInstance;
}

- (NSInteger)loginWithParameters:(NSDictionary *)parameters
                 methodType:(NSInteger)methodType
                    success:(successBlock)success
                    failure:(failureBlock)failure {
   return [self loadDataWithParameters:parameters path:@"/api/v1/member" methodType:methodType success:success failure:failure];
}

#pragma mark - public methods

- (void)cancelAllRequests {
    [[SWApiProxy sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestID {
    [self removeRequestIdWithRequestID:requestID];
    [[SWApiProxy sharedInstance] cancelRequestWithRequestID:@(requestID)];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList {
    [self.requestIdList removeObjectsInArray:requestIDList];
    [[SWApiProxy sharedInstance] cancelRequestWithRequestIDList:requestIDList];
}

- (void)removeRequestIdWithRequestID:(NSInteger)requestId {
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}

- (NSInteger)loadDataWithParameters:(NSDictionary *)parameters
                               path:(NSString *)path
                         methodType:(NSInteger)methodType
                            success:(successBlock)success
                            failure:(failureBlock)failure {
    NSInteger requestId = 0;
    
    if ([self isReachable]) { //网络状态
        
        switch (methodType) {
            case SWAPIManagerRequestTypeGet:
                SWCallAPI(GET,requestId);
                break;
                
            case SWAPIManagerRequestTypePost:
                SWCallAPI(POST,requestId);
                break;
                
            default:
                break;
        }
    }
    
    NSLog(@"%@",self.requestIdList);
    
    return requestId;
}

#pragma mark - getter/setter

- (NSMutableArray *)requestIdList {
    if (_requestIdList == nil) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}

- (BOOL)isReachable {
    return YES;
}
@end
