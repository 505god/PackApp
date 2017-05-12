//
//  SWAPIManager.h
//  Test
//
//  Created by 邱成西 on 2017/5/12.
//  Copyright © 2017年 邱大侠. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^successBlock)(id responseObject);
typedef void (^failureBlock)(NSString *errorInfo);

typedef NS_ENUM (NSUInteger, SWAPIManagerRequestType){
    SWAPIManagerRequestTypeGet,
    SWAPIManagerRequestTypePost,
    SWAPIManagerRequestTypePut,
    SWAPIManagerRequestTypeDelete
};

@interface SWAPIManager : NSObject

@property (nonatomic, assign) BOOL isReachable;

+ (instancetype)sharedInstance;

- (NSInteger)loginWithParameters:(NSDictionary *)parameters
                 methodType:(NSInteger)methodType
                    success:(successBlock)success
                    failure:(failureBlock)failure;

- (NSInteger)loadDataWithParameters:(NSDictionary *)parameters
                               path:(NSString *)path
                         methodType:(NSInteger)methodType
                            success:(successBlock)success
                            failure:(failureBlock)failure;

- (void)cancelAllRequests;
- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;
- (void)cancelRequestWithRequestId:(NSInteger)requestID;
@end
