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
        strTitle =[NSString stringWithFormat:@"%@%@",_title,@"\n\n\n\n\n\n\n"];
        [self setActionSheetStyle:UIActionSheetStyleDefault];
        self.DetaSource=delegate;
    }
    return [self initWithTitle:strTitle
                      delegate:self
             cancelButtonTitle:@"取消"
        destructiveButtonTitle:nil
             otherButtonTitles:nil];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIButton * btn1 =[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame=CGRectMake(30, 40, 65, 65);
    btn1.tag=0;
    [btn1 setImage:[UIImage imageNamed:@"share_SMS"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btnIndex:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setExclusiveTouch:YES];
    [self addSubview:btn1];
    UILabel *lableSMS=[[UILabel alloc] init];
    lableSMS.frame =CGRectMake(0, 0, 50, 20);
    lableSMS.center=CGPointMake(btn1.center.x, 120);
    lableSMS.textAlignment=NSTextAlignmentCenter;
    lableSMS.font =[UIFont systemFontOfSize:14];
    lableSMS.backgroundColor=[UIColor clearColor];
    lableSMS.textColor=[UIColor grayColor];
    lableSMS.text=@"短信";
    [self addSubview:lableSMS];
    
    UIButton * btn2 =[UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame=CGRectMake(130, 40, 65, 65);
    btn2.tag=1;
    [btn2 setImage:[UIImage imageNamed:@"share_weixin"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btnIndex:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setExclusiveTouch:YES];
    [self addSubview:btn2];
    UILabel *labelWeixin=[[UILabel alloc] init];
    labelWeixin.frame =CGRectMake(0, 0, 50, 20);
    labelWeixin.center=CGPointMake(btn2.center.x, 120);
    labelWeixin.textAlignment=NSTextAlignmentCenter;
    labelWeixin.font =[UIFont systemFontOfSize:14];
    labelWeixin.backgroundColor=[UIColor clearColor];
    labelWeixin.textColor=[UIColor grayColor];
    labelWeixin.text=@"微信";
    [self addSubview:labelWeixin];
    
    
    
    
    UIButton * btn3 =[UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame =CGRectMake(230, 40, 65, 65);
    btn3.tag=2;
    [btn3 setImage:[UIImage imageNamed:@"share_xinlang"] forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(btnIndex:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 setExclusiveTouch:YES];
    [self addSubview:btn3];
    UILabel *labelXinlang=[[UILabel alloc] init];
    labelXinlang.frame =CGRectMake(0, 0, 50, 20);
    labelXinlang.center=CGPointMake(btn3.center.x, 120);
    labelXinlang.textAlignment=NSTextAlignmentCenter;
    labelXinlang.font =[UIFont systemFontOfSize:14];
    labelXinlang.backgroundColor=[UIColor clearColor];
    labelXinlang.textColor=[UIColor grayColor];
    labelXinlang.text=@"新浪";
    [self addSubview:labelXinlang];
}

- (void)btnIndex:(UIButton *)sender{
    [self dismissWithClickedButtonIndex:sender.tag animated:YES];
    [self.DetaSource actionSheetIndex:sender.tag];
}

@end
