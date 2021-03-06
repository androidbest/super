//
//  ScheduleCell.m
//  zwy
//
//  Created by cqsxit on 13-11-18.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "ScheduleCell.h"

@implementation ScheduleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect rect =self.frame;
        rect.size.height=65;
        self.contentViews=[[UIView alloc] initWithFrame:rect];
        self.contentViews.backgroundColor=[UIColor whiteColor];
        [self addSubview:self.contentViews];
        
        _labelTitle =[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 16)];
        _labelTitle.backgroundColor=[UIColor whiteColor];
        _labelTitle.textColor=[UIColor blackColor];
        _labelTitle.textAlignment=NSTextAlignmentLeft;
        _labelTitle.font =[UIFont boldSystemFontOfSize:16];
        [self.contentViews addSubview:_labelTitle];
        
        _labelTime =[[UILabel alloc] initWithFrame:CGRectMake(10, _labelTitle.frame.size.height+10+10, 150, 15)];
        _labelTime.backgroundColor=[UIColor whiteColor];
        _labelTime.textColor=[UIColor grayColor];
        _labelTitle.textAlignment=NSTextAlignmentLeft;
        [self.contentViews addSubview:_labelTime];
        
        _labelDays =[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-140, 20, 130, 25)];
         _labelDays.textAlignment=NSTextAlignmentRight;
        [self.contentViews addSubview:_labelDays];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
    [super setHighlighted:highlighted animated:animated];
}


@end
