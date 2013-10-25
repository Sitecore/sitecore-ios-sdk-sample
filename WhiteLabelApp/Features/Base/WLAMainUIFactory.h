//
//  WLAMainUIFactory.h
//  WhiteLabelApp
//
//  Created by Igor on 10/16/13.
//  Copyright (c) 2013 Sitecore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLAMainUIFactory : NSObject

+(UITextField *)wlaTextFieldWithFrame:(CGRect)frame
                          placeholder:(NSString *)placeholderText
                                 text:(NSString *)text;

+(UIButton *)wlaButtonWithFrame:(CGRect)frame
                          title:(NSString *)title
                         target:(id)target
                       selector:(SEL)selector;
@end
