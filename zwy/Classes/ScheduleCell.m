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
        _labelTitle =[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 15)];
        _labelTitle.backgroundColor=[UIColor whiteColor];
        _labelTitle.textColor=[UIColor blackColor];
        _labelTitle.textAlignment=NSTextAlignmentLeft;
        _labelTitle.font =[UIFont boldSystemFontOfSize:16];
        [self addSubview:_labelTitle];
        
        _labelTime =[[UILabel alloc] initWithFrame:CGRectMake(10, _labelTitle.frame.size.height+10+10, 150, 15)];
        _labelTime.backgroundColor=[UIColor whiteColor];
        _labelTime.textColor=[UIColor grayColor];
        _labelTitle.textAlignment=NSTextAlignmentLeft;
        [self addSubview:_labelTime];
        
        _labelDays =[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-140, 20, 130, 25)];
         _labelDays.textAlignment=NSTextAlignmentRight;
        [self addSubview:_labelDays];
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
