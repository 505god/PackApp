//
//  SWApiProxy.m
//  Test
//
//  Created by 邱成西 on 2017/5/12.
//  Copyright © 2017年 邱大侠. All rights reserved.
//

#import "SWApiProxy.h"

#import <AFNetworking/AFNetworking.h>

@interface SWApiProxy ()

@property (nonatomic, strong) NSMutableDictionary *dispatchTable;

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation SWApiProxy

#pragma mark - life cycle

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static SWApiProxy *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SWApiProxy alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public methods

//根据tast的taskIdentifier
- (void)cancelRequestWithRequestID:(NSNumber *)requestID {
    NSURLSessionDataTask *requestOperation = self.dispatchTable[requestID];
    [requestOperation cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList {
    for (NSNumber *requestId in requestIDList) {
        [self cancelRequestWithRequestID:requestId];
    }
}

- (NSInteger)callGETWithParams:(NSDictionary *)params
                    methodName:(NSString *)methodName
                       success:(CallBlock)success
                          fail:(CallBlock)fail {
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.sessionManager GET:methodName parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *requestID = @([dataTask taskIdentifier]);
        [self.dispatchTable removeObjectForKey:requestID];
        
        [self processingResponseObject:responseObject success:success fail:fail];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSNumber *requestID = @([dataTask taskIdentifier]);
        [self.dispatchTable removeObjectForKey:requestID];
        
        [self processingError:error];
        
        fail(nil,1);
    }];
    
    NSNumber *requestId = @([dataTask taskIdentifier]);
    self.dispatchTable[requestId] = dataTask;
    [dataTask resume];
    
    return dataTask.taskIdentifier;
}

- (NSInteger)callPOSTWithParams:(NSDictionary *)params
                     methodName:(NSString *)methodName
                        success:(CallBlock)success
                           fail:(CallBlock)fail {
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.sessionManager POST:methodName parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *requestID = @([dataTask taskIdentifier]);
        [self.dispatchTable removeObjectForKey:requestID];
        
        [self processingResponseObject:responseObject success:success fail:fail];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSNumber *requestID = @([dataTask taskIdentifier]);
        [self.dispatchTable removeObjectForKey:requestID];
        
        [self processingError:error];
        fail(nil,1);
    }];
    
    NSNumber *requestId = @([dataTask taskIdentifier]);
    self.dispatchTable[requestId] = dataTask;
    [dataTask resume];
    
    return dataTask.taskIdentifier;
}

- (NSInteger)callUPLOADWithFileData:(NSData *)filedata
                           fileType:(NSString *)fileType
                            success:(CallBlock)success
                               fail:(CallBlock)fail {
    
    AFHTTPResponseSerializer *instance = [AFHTTPResponseSerializer serializer];
    instance.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"FILE_URL" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSString *fileName = [fileType isEqualToString:@"image"] ? @"a.png" : ([fileType isEqualToString:@"video"] ? @"a.mp4" : @"a.mp3");
        [formData appendPartWithFileData:filedata name:@"a" fileName:fileName mimeType:fileType];
    } error:nil];

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = instance;
    
    __block NSURLSessionUploadTask *uploadTask = nil;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          
                          NSLog(@"%f",uploadProgress.fractionCompleted);
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      NSNumber *requestID = @([uploadTask taskIdentifier]);
                      [self.dispatchTable removeObjectForKey:requestID];
                      
                      if (error) {
                          fail(nil,1);
                      } else {
                          NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                          success(json,0);
                      }
                  }];
    
    NSNumber *requestId = @([uploadTask taskIdentifier]);
    self.dispatchTable[requestId] = uploadTask;

    [uploadTask resume];
    
    return uploadTask.taskIdentifier;
}

//对API返回的数据进行初始判断
- (void)processingResponseObject:(id)responseObject
                         success:(CallBlock)success
                            fail:(CallBlock)fail {
    
    NSInteger code = [responseObject[@"code"] integerValue];
    if (code == 200) {
        success(responseObject[@"data"],0);
    }else {
        fail(nil,1);
        //提示
    }
}

//处理错误事件
- (void)processingError:(NSError *)error {
    
    if (error.code == NSURLErrorTimedOut) {
        //超时
    }else {
        // 无网络
        [self.sessionManager.operationQueue cancelAllOperations];
    }
}


#pragma mark - getter/setter

- (NSMutableDictionary *)dispatchTable {
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

- (AFHTTPSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://192.168.1.176:88"]];
        [_sessionManager.requestSerializer setTimeoutInterval:30];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
        _sessionManager.securityPolicy.validatesDomainName = NO;
    }
    return _sessionManager;
}

@end
