//
//  SWApiProxy.h
//  Test
//
//  Created by 邱成西 on 2017/5/12.
//  Copyright © 2017年 邱大侠. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSUInteger, SWResponseStatusType){
    SWResponseStatusTypeSuccess,
    SWResponseStatusTypeFail
};

typedef void (^CallBlock)(id responseObject, NSInteger responseStatus);

@interface SWApiProxy : NSObject

+ (instancetype)sharedInstance;

- (NSInteger)callGETWithParams:(NSDictionary *)params
                    methodName:(NSString *)methodName
                       success:(CallBlock)success
                          fail:(CallBlock)fail;

- (NSInteger)callPOSTWithParams:(NSDictionary *)params
                     methodName:(NSString *)methodName
                        success:(CallBlock)success
                           fail:(CallBlock)fail;

- (NSInteger)callUPLOADWithFileData:(NSData *)filedata
                     fileType:(NSString *)fileType
                        success:(CallBlock)success
                           fail:(CallBlock)fail;

- (void)cancelRequestWithRequestID:(NSNumber *)requestID;

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;
@end
