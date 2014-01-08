//
//  MesaageIMCell.m
//  zwy
//
//  Created by wangshuang on 12/12/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "MesaageIMCell.h"

@implementation MesaageIMCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //"标题"标签
        _title =[[UILabel alloc] initWithFrame:CGRectMake(64,9,135,15)];
        _title.font=[UIFont boldSystemFontOfSize:15];
        _title.backgroundColor=[UIColor clearColor];
        _title.textColor=[UIColor blackColor];
        [self addSubview:_title];
        
        //"内容"标签
        _content =[[UILabel alloc] initWithFrame:CGRectMake(64,30,250,20)];
        _content.numberOfLines=1;
        _content.font=[UIFont systemFontOfSize:13];
        _content.backgroundColor=[UIColor clearColor];
        _content.textColor=[UIColor grayColor];
        [self addSubview:_content];
        
        //"时间"标签
        _time =[[UILabel alloc] initWithFrame:CGRectMake(202,12,120,10)];
        _time.font=[UIFont systemFontOfSize:13];
        _time.backgroundColor=[UIColor clearColor];
        _time.textColor=[UIColor grayColor];
        _time.textAlignment=NSTextAlignmentLeft;
        [self addSubview:_time];
        
   
        
        
        //"头像"标示
        _imageMark =[[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 45, 45)];
        [self addSubview:_imageMark];
        
        _username =[[UILabel alloc] initWithFrame:CGRectMake(64,15,200,30)];
        _username.font=[UIFont boldSystemFontOfSize:17];
        _username.backgroundColor=[UIColor clearColor];
        _username.textColor=[UIColor blackColor];
        [self addSubview:_username];
        
        _bottomBorder = [CALayer layer];
        float width=self.frame.size.width;
        _bottomBorder.frame = CGRectMake(0.0f, 63, width, 0.5f);
        _bottomBorder.backgroundColor = [UIColor colorWithWhite:0.7f alpha:0.5f].CGColor;
        [self.layer addSublayer:_bottomBorder];
        
        //未读条数
        _labelCount =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 15)];
        _labelCount.center=CGPointMake(52, 10);
        _labelCount.layer.masksToBounds = YES;
        _labelCount.layer.cornerRadius = 15/2;
        _labelCount.backgroundColor =[UIColor redColor];
        _labelCount.font=[UIFont systemFontOfSize:11];
        _labelCount.hidden=YES;
        _labelCount.textColor =[UIColor whiteColor];
        _labelCount.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_labelCount];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
