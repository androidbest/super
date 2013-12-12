//
//  InformationCellContentView.m
//  zwy
//
//  Created by cqsxit on 13-12-12.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "InformationCellContentView.h"

@implementation InformationCellContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
     [self drawSegmentationInContent:context];
}

- (void)drawSegmentationInContent:(CGContextRef)context{
    CGContextSetRGBStrokeColor(context, 1.0, 0.5, 0.5, 1.0);//设置颜色
    CGContextMoveToPoint(context, 10, 20);
    CGContextAddLineToPoint(context, 300, 20);
    CGContextSetLineWidth(context, 1.0);
    CGContextStrokePath(context);
}


@end
