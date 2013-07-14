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

#define kKKViewCardNumberFieldStartX 84 + 200
#define kKKViewCardNumberFieldEndX 84

#define kKKViewPlaceholderViewAnimationDuration 0.25

#import "KKView.h"
#import "KKTextField.h"
#import "konto_check.h"

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

-(void)dealloc {
    lut_cleanup();
}

- (void)setup
{
    int retval;
    NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString * lutPath = [resourcePath stringByAppendingPathComponent:@"blz.lut2"];
    
    if ((retval = lut_init([lutPath UTF8String], 5, 0)) != OK)
    {
        NSLog(@"lut_init: %@", [[NSString alloc] initWithUTF8String:kto_check_retval2txt(retval)]);
    }
    
    //retval = kto_check_blz("12070024", "3193422");
    retval = kto_check_blz("12070024", "");
    NSLog(@"kto_check_blz: %@", [[NSString alloc] initWithUTF8String:kto_check_retval2txt(retval)]);
    
    
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
    
    [self.innerView addSubview:cardBLZField];
    
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

- (void)setupCardBLZField
{
    cardBLZField = [[KKTextField alloc] initWithFrame:CGRectMake(12,0,170,20)];
    
    cardBLZField.delegate = self;
    
    cardBLZField.placeholder = @"Bankleitzahl";
    cardBLZField.keyboardType = UIKeyboardTypeNumberPad;
    cardBLZField.textColor = DarkGreyColor;
    cardBLZField.font = DefaultBoldFont;
    
    [cardBLZField.layer setMasksToBounds:YES];
}

- (void)setupCardNumberField
{
    cardNumberField = [[KKTextField alloc] initWithFrame:CGRectMake(12,0,170,20)];
    
    cardNumberField.delegate = self;
    
    cardNumberField.placeholder = @"Konto-Nr.";
    cardNumberField.keyboardType = UIKeyboardTypeNumberPad;
    cardNumberField.textColor = DarkGreyColor;
    cardNumberField.font = DefaultBoldFont;
    
    [cardNumberField.layer setMasksToBounds:YES];
}

- (void)stateCardBLZ
{
    if (!isInitialState) {
        // Animate left
        isInitialState = YES;
        
        [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             opaqueOverGradientView.alpha = 0.0;
                         } completion:^(BOOL finished) {}];
        [UIView animateWithDuration:0.400
                              delay:0
                            options:(UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction)
                         animations:^{
                             cardNumberField.frame = CGRectMake(kKKViewCardNumberFieldStartX,
                                                             cardNumberField.frame.origin.y,
                                                             cardNumberField.frame.size.width,
                                                             cardNumberField.frame.size.height);
                             cardBLZField.frame = CGRectMake(12,
                                                                cardBLZField.frame.origin.y,
                                                                cardBLZField.frame.size.width,
                                                                cardBLZField.frame.size.height);
                         }
                         completion:^(BOOL completed) {
                             [cardNumberField removeFromSuperview];
                         }];
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
    
    CGSize cardBLZSize = [self.cardBLZ.formattedString sizeWithFont:DefaultBoldFont];
    CGSize lastGroupSize = [self.cardBLZ.lastGroup sizeWithFont:DefaultBoldFont];
    CGFloat frameX = self.cardBLZField.frame.origin.x - (cardBLZSize.width - lastGroupSize.width);

    [UIView animateWithDuration:0.05 delay:0.35 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         opaqueOverGradientView.alpha = 1.0;
                     } completion:^(BOOL finished) {}];
    [UIView animateWithDuration:0.400 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        cardNumberField.frame = CGRectMake(kKKViewCardNumberFieldEndX,
                                        cardNumberField.frame.origin.y,
                                        cardNumberField.frame.size.width,
                                        cardNumberField.frame.size.height);
        cardBLZField.frame = CGRectMake(frameX,
                                           cardBLZField.frame.origin.y,
                                           cardBLZField.frame.size.width,
                                           cardBLZField.frame.size.height);
    } completion:nil];
    
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setPlaceholderToCardType];
    
    if ([textField isEqual:cardBLZField] && !isInitialState) {
        [self stateCardNumber];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    if ([textField isEqual:cardBLZField]) {
        return [self cardBLZShouldChangeCharactersInRange:range replacementString:replacementString];
    }
    
    if ([textField isEqual:cardNumberField]) {
        return [self cardNumberFieldShouldChangeCharactersInRange:range replacementString:replacementString];
    }

    return YES;
}

- (BOOL)cardBLZShouldChangeCharactersInRange: (NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [cardBLZField.text stringByReplacingCharactersInRange:range withString:replacementString];
    resultString = [KKTextField textByRemovingUselessSpacesFromString:resultString];
    KKCardBLZ *cardBLZ = [KKCardBLZ cardBLZWithString:resultString];
    
    if (replacementString.length > 0) {
        cardBLZField.text = [cardBLZ formattedStringWithTrail];
    } else {
        cardBLZField.text = [cardBLZ formattedString];
    }
    
    [self setPlaceholderToCardType];
    
    if ([cardBLZ isValid]) {
        [self textFieldIsValid:cardBLZField];
        [self stateMeta];
        
    //} else if ([cardNumber isValidLength] && ![cardBLZ isValidLuhn]) {
    //    [self textFieldIsInvalid:cardNumberField withErrors:YES];
        
    //} else if (![cardBLZ isValidLength]) {
    //    [self textFieldIsInvalid:cardNumberField withErrors:NO];
    }
    
    return NO;
}

- (void)checkValid
{
    if ([self isValid] && !isValidState) {
        isValidState = YES;
        
        if ([self.delegate respondsToSelector:@selector(paymentView:withCard:isValid:)]) {
            [self.delegate paymentView:self withCard:self.card isValid:YES];
        }
        
    } else if (![self isValid] && isValidState) {
        isValidState = NO;
        
        if ([self.delegate respondsToSelector:@selector(paymentView:withCard:isValid:)]) {
            [self.delegate paymentView:self withCard:self.card isValid:NO];
        }
    }
}

- (void)textFieldIsValid:(UITextField *)textField {
    textField.textColor = DarkGreyColor;
    [self checkValid];
}


- (BOOL)cardNumberFieldShouldChangeCharactersInRange: (NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [cardNumberField.text stringByReplacingCharactersInRange:range withString:replacementString];
    resultString = [KKTextField textByRemovingUselessSpacesFromString:resultString];
    KKCardNumber *cardNumber = [KKCardNumber cardNumberWithString:resultString];
    KKCardType cardType = [[KKCardNumber cardNumberWithString:cardBLZField.text] cardType];

    
    //if ( ![cardNumber isPartiallyValidWithType:cardType] ) return NO;
    
    // Strip non-digits
    cardNumberField.text = [cardNumber string];
    
    //if ([cardNumber isValidWithType:cardType]) {
    //    [self textFieldIsValid:cardNumberField];
    //} else {
    //    [self textFieldIsInvalid:cardNumberField withErrors:NO];
    //}
    
    return NO;
}

- (void)kkTextFieldDidBackSpaceWhileTextIsEmpty:(KKTextField *)textField
{
    if (textField == self.cardBLZField)
        [self.cardNumberField becomeFirstResponder];
}

- (BOOL)isValid
{
    return [self.cardBLZ isValid] && [self.cardNumber isValid];
}

@end
