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
        
        
//        UIGestureRecognizer *singleTap = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(UesrClicked:)];
//        singleTap.voiceurl=msgObj.filepath;
//        [_rightMessage addGestureRecognizer:singleTap];
//        _rightMessage.userInteractionEnabled = YES;
        
        //"时间"标签
//        _time =[[UILabel alloc] initWithFrame:CGRectMake(140,10,150 ,20)];
//        _time.font=[UIFont systemFontOfSize:13];
//        _time.backgroundColor=[UIColor clearColor];
//        _time.textColor=[UIColor grayColor];
//        _time.textAlignment=NSTextAlignmentRight;
//        [self addSubview:_time];
//        
//        //"已读未读"标示
//        _imageMark =[[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 8, 8)];
//        _imageMark.image=[UIImage imageNamed:@"list_yuan"];
//        _imageMark.hidden=YES;
//        [self addSubview:_imageMark];
//        
//        //"人气数"标签
//        _greetingCount =[[UILabel alloc] initWithFrame:CGRectMake(320-100, self.frame.size.height-40, 90, 30)];
//        _greetingCount.hidden=YES;
//        _greetingCount.textAlignment=NSTextAlignmentRight;
//        [self addSubview:_greetingCount];
//        
//        //"内容图片"
//        _imageContent =[[UIImageView alloc] initWithFrame:CGRectMake(25, 20, 280, 100)];
//        _imageContent.hidden=YES;
//        [self addSubview:_imageContent];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
