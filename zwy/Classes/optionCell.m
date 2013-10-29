//
//  optionCell.m
//  zwy
//
//  Created by cqsxit on 13-10-17.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "optionCell.h"

@implementation optionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withDelegate:(id)delegate
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _btnOption =[UIButton buttonWithType:UIButtonTypeCustom];
        _btnOption.frame =CGRectMake(280, 0, 40, 40);
        [_btnOption setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [_btnOption setImage:[UIImage imageNamed:@"btn_uncheck"] forState:UIControlStateNormal];
        [_btnOption addTarget:delegate action:@selector(btnOption:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnOption];
    }
    return self;
}

- (void)btnOption:(id)sender{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
