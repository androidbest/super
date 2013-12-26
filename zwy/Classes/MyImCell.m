//
//  MyImCell.m
//  zwy
//
//  Created by wangshuang on 12/13/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "MyImCell.h"

@implementation MyImCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //"标题"标签
        _content =[[UILabel alloc] initWithFrame:CGRectMake(75,27,100,21)];
        _content.font=[UIFont boldSystemFontOfSize:17];
        _content.backgroundColor=[UIColor clearColor];
        _content.textColor=[UIColor lightGrayColor];
        _content.textAlignment=NSTextAlignmentRight;
        [self addSubview:_content];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
