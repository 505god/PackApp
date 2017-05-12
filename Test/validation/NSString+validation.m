//
//  NSString+validation.m
//  Test
//
//  Created by 邱成西 on 2017/5/12.
//  Copyright © 2017年 邱大侠. All rights reserved.
//

#import "NSString+validation.h"

@implementation NSString (validation)

- (BOOL)isValidation {
    if ( self == nil || self == NULL ) {
        return NO;
    }
    if (self.length==0) {
        return NO;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return NO;
    }
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return NO;
    }
    return YES;
}

@end
