//
//  PhotoButton.m
//  zwy
//
//  Created by cqsxit on 13-12-26.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "PhotoButton.h"

@implementation PhotoButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CALayer *layer =[CALayer layer];
        layer.bounds=CGRectMake(0, 0, 10, 10);
        layer.masksToBounds = YES;
        layer.cornerRadius = 6.0;
        layer.backgroundColor=[UIColor redColor].CGColor;
        _layerBubble=layer;
        [self.layer addSublayer:_layerBubble];
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
