//
//  TemplateCell.m
//  zwy
//
//  Created by wangshuang on 10/14/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "TemplateCell.h"

@implementation TemplateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //"标题"标签
        _title =[[UILabel alloc] initWithFrame:CGRectMake(25,10,170 ,20)];
        _title.font=[UIFont boldSystemFontOfSize:16];
        _title.backgroundColor=[UIColor clearColor];
        _title.textColor=[UIColor blackColor];
        [self addSubview:_title];
        
        //"内容"标签
        _content =[[UILabel alloc] initWithFrame:CGRectMake(25,30,280,30)];
        _content.numberOfLines=0;
        _content.font=[UIFont systemFontOfSize:15];
        _content.backgroundColor=[UIColor clearColor];
        _content.textColor=[UIColor grayColor];
        [self addSubview:_content];
        
        //"时间"标签
        _time =[[UILabel alloc] initWithFrame:CGRectMake(140,10,150 ,20)];
        _time.font=[UIFont systemFontOfSize:13];
        _time.backgroundColor=[UIColor clearColor];
        _time.textColor=[UIColor grayColor];
        _time.textAlignment=NSTextAlignmentRight;
        [self addSubview:_time];
        
        //"已读未读"标示
        _imageMark =[[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 8, 8)];
        _imageMark.image=[UIImage imageNamed:@"list_yuan"];
        _imageMark.hidden=YES;
        [self addSubview:_imageMark];
        
        //"人气数"标签
        _greetingCount =[[UILabel alloc] initWithFrame:CGRectMake(320-100, self.frame.size.height-40, 90, 30)];
        _greetingCount.hidden=YES;
        _greetingCount.textAlignment=NSTextAlignmentRight;
        [self addSubview:_greetingCount];
        
        //"内容图片"
        _imageContent =[[UIImageView alloc] initWithFrame:CGRectMake(25, 20, 160, 100)];
        _imageContent.hidden=YES;
        [self addSubview:_imageContent];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
