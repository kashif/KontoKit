//
//  KKCardNumber.h
//  KontoKit Example
//
//  Created by Kashif Rasul on 6/13/13.
//  Copyright (c) 2013 Kashif Rasul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKCardNumber : NSObject

@property (nonatomic, readonly) NSString * last4;

+ (id) cardNumberWithString:(NSString *)string;
- (id) initWithString:(NSString *)string;
- (NSString *)string;

@end
