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
        _ContextHeight=self.frame.size.height;
        _SegmentationTopY = _ContextHeight*0.575;
        _SegmentationButtonY =_ContextHeight*0.8;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
     [self drawSegmentationInContent:context];
}

- (void)drawSegmentationInContent:(CGContextRef)context{

//横线1
    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 1.0);//设置颜色
    CGContextMoveToPoint(context, 10, _SegmentationTopY);
    CGContextAddLineToPoint(context, 310, _SegmentationTopY);
    CGContextSetLineWidth(context, 0.5);
    CGContextStrokePath(context);
//横线2
    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 1.0);//设置颜色
    CGContextMoveToPoint(context, 10, _SegmentationButtonY);
    CGContextAddLineToPoint(context, 310, _SegmentationButtonY);
    CGContextSetLineWidth(context, 0.5);
    CGContextStrokePath(context);
//竖线
    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 1.0);//设置颜色
    CGContextMoveToPoint(context, ScreenWidth/2, _ContextHeight*0.35);
    CGContextAddLineToPoint(context, ScreenWidth/2, _SegmentationButtonY);
    CGContextSetLineWidth(context, 0.5);
    CGContextStrokePath(context);
}


@end
