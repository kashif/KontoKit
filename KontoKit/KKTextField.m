//
//  KKTextField.m
//  KontoKit Example
//
//  Created by Kashif Rasul on 6/13/13.
//  Copyright (c) 2013 Kashif Rasul. All rights reserved.
//

#import "KKTextField.h"

#define kKKTextFieldSpaceChar @"\u200B"

@implementation KKTextField

+ (NSString*)textByRemovingUselessSpacesFromString:(NSString*)string {
    return [string stringByReplacingOccurrencesOfString:kKKTextFieldSpaceChar withString:@""];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.text = kKKTextFieldSpaceChar;
        [self addObserver:self forKeyPath:@"text" options:0 context:NULL];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"text"];
}

- (void)drawRect:(CGRect)rect
{
    if(self.text.length == 0 || [self.text isEqualToString:kKKTextFieldSpaceChar]) {
        CGRect placeholderRect = self.bounds;
        placeholderRect.origin.y += 0.5;
        [super drawPlaceholderInRect:placeholderRect];
    }
    else
        [super drawRect:rect];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"text"] && object == self) {
        if(self.text.length == 0) {
            if([self.delegate respondsToSelector:@selector(kkTextFieldDidBackSpaceWhileTextIsEmpty:)])
                [self.delegate performSelector:@selector(kkTextFieldDidBackSpaceWhileTextIsEmpty:)
                                    withObject:self];
            self.text = kKKTextFieldSpaceChar;
        }
        [self setNeedsDisplay];
    }
}

@end
