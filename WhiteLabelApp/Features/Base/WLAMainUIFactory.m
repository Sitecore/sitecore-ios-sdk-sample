//
//  WLAMainUIFactory.m
//  WhiteLabelApp
//
//  Created by Igor on 10/16/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import "WLAMainUIFactory.h"

@implementation WLAMainUIFactory

+(UITextField *)wlaTextFieldWithFrame:(CGRect)frame
                          placeholder:(NSString *)placeholderText
                                 text:(NSString *)text
{
    UITextField *result = [[UITextField alloc] initWithFrame:frame];
    [result setBorderStyle:UITextBorderStyleRoundedRect];
    [result setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [result setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    [result setPlaceholder:placeholderText];
    [result setText:text];
    
    return result;
}

+(UIButton *)wlaButtonWithFrame:(CGRect)frame
                          title:(NSString *)title
                         target:(id)target
                       selector:(SEL)selector
{
    UIButton *result = [UIButton buttonWithType:UIButtonTypeCustom];
    [result setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [result setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [result setBackgroundColor:[UIColor grayColor]];
    
    [result setTitle:title forState:UIControlStateNormal];
    result.frame = frame;
    
    [result addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return result;
}

@end
