//
//  KKCardNumber.m
//  KontoKit Example
//
//  Created by Kashif Rasul on 6/13/13.
//  Copyright (c) 2013 Kashif Rasul. All rights reserved.
//

#import "KKCardNumber.h"

@interface KKCardNumber() {
@private
    NSString* number;
}
@end

@implementation KKCardNumber

+ (id)cardNumberWithString:(NSString *)string
{
    return [[self alloc] initWithString:string];
}

- (id)initWithString:(NSString *)string
{
    self = [super init];
    if (self) {
        // Strip non-digits
        number = [string stringByReplacingOccurrencesOfString:@"\\D"
                                                   withString:@""
                                                      options:NSRegularExpressionSearch
                                                        range:NSMakeRange(0, string.length)];
    }
    return self;
}

- (NSString *)string
{
    return number;
}

@end
