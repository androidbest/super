//
//  AddChatPeoplesCell.m
//  zwy
//
//  Created by cqsxit on 13-12-25.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "AddChatPeoplesCell.h"

@implementation AddChatPeoplesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //勾选图片
        _imageViewAdd =[[UIImageView alloc] init];
        _imageViewAdd.frame =CGRectMake(10, 20, 20, 20);
        _imageViewAdd.image=[UIImage imageNamed:@""];
        [self addSubview:_imageViewAdd];
        
        //头像
        _imageHead =[[UIImageView alloc] init];
        _imageHead.frame =CGRectMake(40, 10, 40, 40);
        [self addSubview:_imageHead];
        
        //姓名标签
        _labelTitle =[[UILabel alloc] init];
        _labelTitle.frame=CGRectMake(90, 20, 20, 200);
        _labelTitle.backgroundColor=[UIColor clearColor];
        _labelTitle.font =[UIFont boldSystemFontOfSize:17];
        [self addSubview:_labelTitle];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
