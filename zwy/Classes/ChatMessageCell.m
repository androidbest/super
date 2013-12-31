//
//  ChatMessageCell.m
//  zwy
//
//  Created by wangshuang on 12/18/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "ChatMessageCell.h"

@implementation ChatMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //"时间"标签
        _chatTime =[[UILabel alloc] initWithFrame:CGRectMake(110,5,110,15)];
        _chatTime.font=[UIFont systemFontOfSize:13];
        _chatTime.backgroundColor=[UIColor clearColor];
        _chatTime.textColor=[UIColor lightGrayColor];
//        _chatTime.layer.borderWidth=0.5;
//        _chatTime.layer.borderColor=[[UIColor lightGrayColor] CGColor];
        _chatTime.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_chatTime];
        
        _voiceTimes =[[UILabel alloc] initWithFrame:CGRectZero];
        _voiceTimes.font=[UIFont systemFontOfSize:13];
        _voiceTimes.backgroundColor=[UIColor clearColor];
        _voiceTimes.textColor=[UIColor lightGrayColor];
        //        _chatTime.layer.borderWidth=0.5;
        //        _chatTime.layer.borderColor=[[UIColor lightGrayColor] CGColor];
        _chatTime.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_voiceTimes];
        
        //"左头像"标签
        _leftHead=[[UIButton alloc] initWithFrame:CGRectMake(10,30,40,40)];
        [_leftHead setBackgroundImage:[UIImage imageNamed:@"default_avatar"] forState:UIControlStateNormal];
        [self addSubview:_leftHead];
        
        //左内容
        _leftMessage =[[VoiceBtn alloc] initWithFrame:CGRectZero];
        [self addSubview:_leftMessage];
        
        //"右头像"标签
        _rightHead=[[UIButton alloc] initWithFrame:CGRectMake(270,30,40,40)];
        [_leftHead setBackgroundImage:[UIImage imageNamed:@"default_avatar"] forState:UIControlStateNormal];
        [self addSubview:_rightHead];
        
        //右内容
        _rightMessage =[[VoiceBtn alloc] initWithFrame:CGRectZero];
        [self addSubview:_rightMessage];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
