//
//  CustomPageControl.m
//  zwy
//
//  Created by wangshuang on 9/30/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "CustomPageControl.h"

@implementation CustomPageControl{
    UIImage *_activeImage;
    UIImage *_inactiveImage;
    BOOL isCreate;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _activeImage=[UIImage imageNamed:@"point_over"];
        _inactiveImage=[UIImage imageNamed:@"point_out"];
        isCreate=YES;
    }
    return self;
}

- (void)updateDots { // 更新显示所有的点按钮
    if (_activeImage || _inactiveImage)
    {
        NSArray *subview = self.subviews;  // 获取所有子视图
        if (isCreate && [subview count] > 0) {
            for (NSInteger i = 0; i < [subview count]; i++)
            {
                UIView *bgView = [subview objectAtIndex:i];
                UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0.f, 0.f, 8.f, 8.f)];
                image.tag = 1000 + i;
                [bgView addSubview:image];
                image.image = self.currentPage == i ? _activeImage : _inactiveImage;
            }
            isCreate = NO;
        }else{
            for (NSInteger i = 0; i < [subview count]; i++)
            {
                UIView *bgView = [subview objectAtIndex:i];
                UIImageView *image = (UIImageView *)[bgView viewWithTag:1000 + i];
                image.image = self.currentPage == i ? _activeImage : _inactiveImage;
            }
        }
    }
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    [super setCurrentPage:currentPage];
    [self updateDots];
}



@end
