//
//  KKCardBLZ.h
//  KontoKit Example
//
//  Created by Kashif Rasul on 6/13/13.
//  Copyright (c) 2013 Kashif Rasul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKCardBLZ : NSObject

@property (nonatomic, readonly) NSString* string;

+ (id)cardBLZWithString:(NSString *)string;
- (id)initWithString:(NSString *)string;
@end
