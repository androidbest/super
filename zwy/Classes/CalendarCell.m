//
//  CalendarCell.m
//  zwy
//
//  Created by cqsxit on 14-2-13.
//  Copyright (c) 2014年 sxit. All rights reserved.
//

#import "CalendarCell.h"

@implementation CalendarCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageMonth =[[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        self.imageMonth.layer.zPosition=1;
        [self.contentView addSubview:self.imageMonth];
        
        self.labelToday =[[UILabel alloc] init];
        self.labelToday.frame=CGRectMake(10, 10, 40, 40);
        self.labelToday.backgroundColor=[UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:0.5];
        self.labelToday.layer.zPosition=2;
        [self.contentView addSubview:self.labelToday];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
