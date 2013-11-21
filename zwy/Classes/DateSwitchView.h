//
//  DateSwitchView.h
//  zwy
//
//  Created by cqsxit on 13-11-19.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISwitch (extended)
- (void) setAlternateColors:(BOOL) boolean;
@end
// 自定义Slider 类
@interface _UISwitchSlider : UIView
@end



@interface DateSwitchView : UISwitch
- (void) setLeftLabelText:(NSString *)labelText
                     font:(UIFont*)labelFont
                    color: (UIColor *)labelColor;

- (void) setRightLabelText:(NSString *)labelText
                      font:(UIFont*)labelFont
                     color:(UIColor *)labelColor;

- (UILabel*) createLabelWithText:(NSString*)labelText
                            font:(UIFont*)labelFont
                           color:(UIColor*)labelColor;
@end
