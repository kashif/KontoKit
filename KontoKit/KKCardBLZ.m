//
//  KKCardBLZ.m
//  KontoKit Example
//
//  Created by Kashif Rasul on 6/13/13.
//  Copyright (c) 2013 Kashif Rasul. All rights reserved.
//

#import "KKCardBLZ.h"

@interface KKCardBLZ () {
@private
    NSString* blz;
}
@end

@implementation KKCardBLZ

+ (id)cardBLZWithString:(NSString *)string;
{
    return [[self alloc] initWithString:string];
}

- (id)initWithString:(NSString *)string
{
    self = [super init];
    if (self) {
        if (string) {
            blz = [string stringByReplacingOccurrencesOfString:@"\\D"
                                                    withString:@""
                                                       options:NSRegularExpressionSearch
                                                         range:NSMakeRange(0, string.length)];
        } else {
            blz = [NSString string];
        }
    }
    return self;
}

- (NSString*)string
{
    return blz;
}

- (KKCardType)cardType
{
    if (blz.length < 7) return KKCardTypeUnknown;
    
    NSString* fourthChar = [blz substringWithRange:NSMakeRange(3, 1)];
    int type = [fourthChar integerValue];
    
    if (type == 0) {
        return KKCardTypeDeutscheBundesbank;
    } else if (type == 1) {
        return KKCardTypePostbank;
    } else if (type == 2 || type == 3) {
        return KKCardTypeHypovereinsbank;
    } else if (type == 4 || type == 8) {
        return KKCardTypeCommerzbank;
    } else if (type == 5) {
        return KKCardTypeSparkasse;
    } else if (type == 6) {
        return KKCardTypeRaiffeisenbanken;
    } else if (type == 7) {
        return KKCardTypeDeutscheBank;
    } else if (type == 9) {
        return KKCardTypeVolksbank;
    } else {
     return KKCardTypeUnknown;
    }
}

@end
