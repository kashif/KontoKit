//
//  KKView.h
//  KontoKit Example
//
//  Created by Kashif Rasul on 6/13/13.
//  Copyright (c) 2013 Kashif Rasul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKCard.h"
#import "KKCardNumber.h"
#import "KKCardBLZ.h"

@class KKView, KKTextField;

@protocol KKViewDelegate <NSObject>
@optional
- (void) paymentView:(KKView*)paymentView withCard:(KKCard*)card isValid:(BOOL)valid;
@end

@interface KKView : UIView

- (BOOL)isValid;

@property (nonatomic, readonly) UIView *opaqueOverGradientView;
@property (nonatomic, readonly) KKCardNumber* cardNumber;
@property (nonatomic, readonly) KKCardBLZ* cardBLZ;

@property IBOutlet UIView* innerView;
@property IBOutlet UIView* clipView;
@property IBOutlet KKTextField* cardNumberField;
@property IBOutlet KKTextField* cardBLZField;
@property IBOutlet UIImageView* placeholderView;

@property id <KKViewDelegate> delegate;
@property (readonly) KKCard* card;

@end
