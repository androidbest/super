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
        layer.bounds=CGRectMake(0, 0, 15, 15);
        layer.masksToBounds = YES;
        layer.cornerRadius = 6.0;
        layer.contents=CFBridgingRelease([UIImage imageNamed:@"chat_delete"].CGImage);
        _layerBubble=layer;
        [self.layer addSublayer:_layerBubble];
        
        _labelName =[[UILabel alloc] init];
        _labelName.font =[UIFont systemFontOfSize:11];
        _labelName.textColor =[UIColor grayColor];
        _labelName.frame=CGRectMake(0, 0, 55, 15);
        _labelName.center=CGPointMake(55/2, 63);
        _labelName.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_labelName];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    
}


@end
