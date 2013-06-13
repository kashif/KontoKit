//
//  KKCardNumber.h
//  KontoKit Example
//
//  Created by Kashif Rasul on 6/13/13.
//  Copyright (c) 2013 Kashif Rasul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKCardType.h"

@interface KKCardNumber : NSObject

@property (nonatomic, readonly) KKCardType cardType;
@property (nonatomic, readonly) NSString * last4;

+ (id) cardNumberWithString:(NSString *)string;
- (id) initWithString:(NSString *)string;
- (KKCardType)cardType;

@end
