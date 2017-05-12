//
//  NSArray+validation.m
//  Test
//
//  Created by 邱成西 on 2017/5/12.
//  Copyright © 2017年 邱大侠. All rights reserved.
//

#import "NSArray+validation.h"

@implementation NSArray (validation)

- (BOOL)isValidation {
    
    if (self == nil) {
        return NO;
    }
    
    if ([self isKindOfClass:[NSNull class]]) {
        return NO;
    }
    
    if (self.count == 0) {
        return NO;
    }

    return YES;
}

@end
