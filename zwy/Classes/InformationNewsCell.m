//
//  InformationNewsCell.m
//  zwy
//
//  Created by cqsxit on 13-12-11.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "InformationNewsCell.h"

@implementation InformationNewsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect{
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        CGContextFillRect(context, rect);
        
        //上分割线，
        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
        CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
        
        //下分割线
        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
        CGContextStrokeRect(context, CGRectMake(5, rect.size.height, rect.size.width - 10, 1));
   
   // [self drawSegmentationInContent:context];
}

- (void)drawSegmentationInContent:(CGContextRef)context{
    CGContextSetRGBStrokeColor(context, 1.0, 0.5, 0.5, 1.0);//设置颜色
    CGContextMoveToPoint(context, 10, 20);
    CGContextAddLineToPoint(context, 300, 20);
    CGContextSetLineWidth(context, 1.0);
    CGContextStrokePath(context);
}
@end
