//
//  PopBottomWindow.m
//  zwy
//
//  Created by wangshuang on 10/28/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "PopBottomWindow.h"

@implementation PopBottomWindow

- (id)initWithViewdelegate:(id)delegate{
    self=[super init];
    if (self) {
        [self setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    }
    return [self initWithTitle:@"\n\n\n\n\n\n"
                      delegate:self
             cancelButtonTitle:@"取消"
        destructiveButtonTitle:nil
             otherButtonTitles:nil,nil];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    UIButton *sms=[[UIButton alloc] initWithFrame:CGRectMake(0, 20, 100, 50)];
    UIButton *mail=[[UIButton alloc] initWithFrame:CGRectMake(0, 20, 100, 50)];
    UIButton *weixin=[[UIButton alloc] initWithFrame:CGRectMake(0, 20, 100, 50)];
    UIButton *weibo=[[UIButton alloc] initWithFrame:CGRectMake(0, 20, 100, 50)];
    
    
    
    
//    [btn setTitle:@"aaabbbbccdd" forState:UIControlStateNormal];
    
//    [btn setBackgroundColor:[UIColor blackColor]];
//    [self addSubview:btn];
    
}

@end
