//
//  KKView.m
//  KontoKit Example
//
//  Created by Kashif Rasul on 6/13/13.
//  Copyright (c) 2013 Kashif Rasul. All rights reserved.
//

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#define DarkGreyColor RGB(0,0,0)
#define RedColor RGB(253,0,17)
#define DefaultBoldFont [UIFont boldSystemFontOfSize:17]

#define kKKViewCardBLZFieldStartX 84 + 200

#define kKKViewPlaceholderViewAnimationDuration 0.25

#import "KKView.h"
#import "KKTextField.h"

@interface KKView () <UITextFieldDelegate> {
@private
    BOOL isInitialState;
    BOOL isValidState;
}
@end

@implementation KKView

@synthesize innerView, opaqueOverGradientView, cardNumberField,
    cardBLZField, placeholderView, delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    isInitialState = YES;
    isValidState   = NO;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 290, 46);
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    backgroundImageView.image = [[UIImage imageNamed:@"textfield"]
                                 resizableImageWithCapInsets:UIEdgeInsetsMake(0, 8, 0, 8)];
    [self addSubview:backgroundImageView];
    
    self.innerView = [[UIView alloc] initWithFrame:CGRectMake(40, 12, self.frame.size.width - 40, 20)];
    self.innerView.clipsToBounds = YES;
    
    [self setupPlaceholderView];
    [self setupCardBLZField];
    [self setupCardNumberField];
    
    [self.innerView addSubview:cardNumberField];
    
    UIImageView *gradientImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 34)];
    gradientImageView.image = [UIImage imageNamed:@"gradient"];
    [self.innerView addSubview:gradientImageView];
    
    opaqueOverGradientView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 9, 34)];
    opaqueOverGradientView.backgroundColor = [UIColor colorWithRed:0.9686 green:0.9686
                                                              blue:0.9686 alpha:1.0000];
    opaqueOverGradientView.alpha = 0.0;
    [self.innerView addSubview:opaqueOverGradientView];
    
    [self addSubview:self.innerView];
    [self addSubview:placeholderView];
    
    [self stateCardBLZ];
}

- (void)setupPlaceholderView
{
    placeholderView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 13, 32, 20)];
    placeholderView.backgroundColor = [UIColor clearColor];
    placeholderView.image = [UIImage imageNamed:@"placeholder"];
    
    CALayer *clip = [CALayer layer];
    clip.frame = CGRectMake(32, 0, 4, 20);
    clip.backgroundColor = [UIColor clearColor].CGColor;
    [placeholderView.layer addSublayer:clip];
}

- (void)setupCardNumberField
{
    cardNumberField = [[KKTextField alloc] initWithFrame:CGRectMake(12,0,170,20)];
    
    cardNumberField.delegate = self;
    
    cardNumberField.placeholder = @"0123456789";
    cardNumberField.keyboardType = UIKeyboardTypeNumberPad;
    cardNumberField.textColor = DarkGreyColor;
    cardNumberField.font = DefaultBoldFont;
    
    [cardNumberField.layer setMasksToBounds:YES];
}

- (void)setupCardBLZField
{
    cardBLZField = [[KKTextField alloc] initWithFrame:CGRectMake(kKKViewCardBLZFieldStartX,0,
                                                                    60,20)];
    
    cardBLZField.delegate = self;
    
    cardBLZField.placeholder = @"12345678";
    cardBLZField.keyboardType = UIKeyboardTypeNumberPad;
    cardBLZField.textColor = DarkGreyColor;
    cardBLZField.font = DefaultBoldFont;
    
    [cardBLZField.layer setMasksToBounds:YES];
}

- (void)stateCardBLZ
{
    if (!isInitialState) {
        isInitialState = YES;
    }
    
    [self.cardBLZField becomeFirstResponder];
}

- (void)stateCardNumber
{
    [cardNumberField becomeFirstResponder];
}

- (void)stateMeta
{
    isInitialState = NO;
    
    [self addSubview:placeholderView];
    [self.innerView addSubview:cardNumberField];
    [cardNumberField becomeFirstResponder];
}

- (void)setPlaceholderViewImage:(UIImage *)image
{
    if(![placeholderView.image isEqual:image]) {
        __block __weak UIView *previousPlaceholderView = placeholderView;
        [UIView animateWithDuration:kKKViewPlaceholderViewAnimationDuration delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^
         {
             placeholderView.layer.opacity = 0.0;
             placeholderView.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1.2);
         } completion:^(BOOL finished) {
             [previousPlaceholderView removeFromSuperview];
         }];
        placeholderView = nil;
        
        [self setupPlaceholderView];
        placeholderView.image = image;
        placeholderView.layer.opacity = 0.0;
        placeholderView.layer.transform = CATransform3DMakeScale(0.8, 0.8, 0.8);
        [self insertSubview:placeholderView belowSubview:previousPlaceholderView];
        [UIView animateWithDuration:kKKViewPlaceholderViewAnimationDuration delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^
         {
             placeholderView.layer.opacity = 1.0;
             placeholderView.layer.transform = CATransform3DIdentity;
         } completion:^(BOOL finished) {}];
    }
}

- (void)setPlaceholderToCardType
{
    KKCardBLZ *cardBLZ = [KKCardBLZ cardBLZWithString:cardBLZField.text];
    KKCardType cardType = [cardBLZ cardType];
    NSString* cardTypeName   = @"placeholder";
    
    switch (cardType) {
        case KKCardTypeDeutscheBank:
            cardTypeName = @"deutschebank";
            break;
        default:
            break;
    }

    [self setPlaceholderViewImage:[UIImage imageNamed:cardTypeName]];

}



- (BOOL)isValid
{
    return [self.cardBLZ isValid] && [self.cardNumber isValid];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
