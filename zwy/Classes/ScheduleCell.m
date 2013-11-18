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
        _labelTitle =[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 15)];
        _labelTitle.backgroundColor=[UIColor whiteColor];
        _labelTitle.textColor=[UIColor blueColor];
        _labelTitle.textAlignment=NSTextAlignmentLeft;
        [self addSubview:_labelTitle];
        
        _labelTime =[[UILabel alloc] initWithFrame:CGRectMake(10, self.frame.size.height-30, 150, 15)];
        _labelTime.backgroundColor=[UIColor whiteColor];
        _labelTime.textColor=[UIColor grayColor];
        _labelTitle.textAlignment=NSTextAlignmentLeft;
        [self addSubview:_labelTime];
        
        _labelDays =[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-100, 20, 100, 20)];
        _labelDays.backgroundColor=[UIColor whiteColor];
        _labelDays.textColor=[UIColor grayColor];
        _labelDays.textAlignment=NSTextAlignmentLeft;
        [self addSubview:_labelDays];
    }
    return self;
}

- (void) formatText:(BOOL)isSelected{
    UIFont *font = [UIFont systemFontOfSize:14.0];
    UIFont *secondFont = [UIFont systemFontOfSize:10.0];
    
    NSMutableDictionary *firstAttributes;
    NSMutableDictionary *secondAttributes;
    
    NSDictionary *firstAttributeFont = @{NSFontAttributeName:font};
    NSDictionary *secondAttributeFont = @{NSFontAttributeName:secondFont};
    
    [firstAttributes addEntriesFromDictionary:firstAttributeFont];
    [secondAttributes addEntriesFromDictionary:secondAttributeFont];
    
    if (!isSelected) {
        [firstAttributes addEntriesFromDictionary:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
        [secondAttributes addEntriesFromDictionary:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        
    }
    else{
        [firstAttributes addEntriesFromDictionary:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [secondAttributes addEntriesFromDictionary:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:1.0 alpha:4.0]}];
    }
    
    
    NSString* completeString = [NSString stringWithFormat:@"%@ %@",@"还有",@"11"];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]     initWithString:completeString];
    [attributedString setAttributes:firstAttributes range:[completeString rangeOfString:@"还有"]];
    [attributedString setAttributes:secondAttributes range:[completeString rangeOfString:@"11"]];
    self.labelDays.attributedText = attributedString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
    [super setSelected:selected animated:animated];
    [self formatText:selected];
    // Configure the view for the selected state
    
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
    [super setHighlighted:highlighted animated:animated];
    [self formatText:highlighted];
    
}


@end
