//
//  ActionSheetWeibo.m
//  zwy
//
//  Created by cqsxit on 13-10-30.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "ActionSheetWeibo.h"

@implementation ActionSheetWeibo

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithViewdelegate:(id)delegate WithSheetTitle:(NSString *)_title{
    self=[super init];
    NSString * strTitle;
    if (self) {
        strTitle =[NSString stringWithFormat:@"%@%@",_title,@"\n\n\n\n\n\n\n\n\n\n\n\n"];
        [self setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    }
    return [self initWithTitle:strTitle
                      delegate:self
             cancelButtonTitle:@"取消"
        destructiveButtonTitle:nil
             otherButtonTitles:@"确定",nil];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIButton * btn1 =[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame=CGRectMake(30, 30, 50, 50);
    btn1.tag=0;
    [btn1 setImage:[UIImage imageNamed:@"share_SMS"] forState:UIControlStateNormal];
    [self addSubview:btn1];
    
    UIButton * btn2 =[UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame=CGRectMake(120, 30, 50, 50);
    btn2.tag=1;
    [btn2 setImage:[UIImage imageNamed:@"share_weixin"] forState:UIControlStateNormal];
    [self addSubview:btn2];
    
    UIButton * btn3 =[UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame =CGRectMake(210, 30, 50, 50);
    btn3.tag=2;
    [btn3 setImage:[UIImage imageNamed:@"share_xinlang"] forState:UIControlStateNormal];
    [self addSubview:btn3];
}

@end
