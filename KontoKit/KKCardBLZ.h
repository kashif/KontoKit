//
//  KKCardBLZ.h
//  KontoKit Example
//
//  Created by Kashif Rasul on 6/13/13.
//  Copyright (c) 2013 Kashif Rasul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKCardType.h"

@interface KKCardBLZ : NSObject

@property (nonatomic, readonly) NSString* string;
@property (nonatomic, readonly) KKCardType cardType;

+ (id)cardBLZWithString:(NSString *)string;
- (id)initWithString:(NSString *)string;
- (NSString*)string;
- (KKCardType)cardType;

- (BOOL)isValid;

@end
