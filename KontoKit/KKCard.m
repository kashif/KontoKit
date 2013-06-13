//
//  KKCard.m
//  KontoKit Example
//
//  Created by Kashif Rasul on 6/13/13.
//  Copyright (c) 2013 Kashif Rasul. All rights reserved.
//

#import "KKCard.h"

@implementation KKCard

@synthesize number, blz;

- (NSString*)last4
{
    if (number.length >= 4) {
        return [number substringFromIndex:([number length] - 4)];
    } else {
        return nil;
    }
}

@end
