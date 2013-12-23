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
        _content.textAlignment=NSTextAlignmentRight;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
