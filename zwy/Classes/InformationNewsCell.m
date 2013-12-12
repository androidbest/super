//
//  InformationNewsCell.m
//  zwy
//
//  Created by cqsxit on 13-12-11.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "InformationNewsCell.h"
#import "InformationCellContentView.h"
@implementation InformationNewsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect viewFrame = CGRectMake(0.0, 0.0,
                                      self.contentView.bounds.size.width,
                                      self.contentView.bounds.size.height);
        InformationCellContentView *informationView =[[InformationCellContentView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-44)];
        informationView.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:informationView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
