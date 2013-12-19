//
//  CompressImage.h
//  zwy
//
//  Created by cqsxit on 13-12-12.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import <Foundation/Foundation.h>
static const CGSize imageSize = {60, 60};

typedef enum {
    drawRect_height,
    drawRect_width,
    drawRect_no
}drawRectType_Height_Width;

@interface CompressImage : NSObject
+ (void)setCellContentImage:(UIImageView *)ImageViewCell Image:(UIImage *)image filePath:(NSString *)files isDrawRect:(drawRectType_Height_Width)drawRectType;


//等宽
+ (void)drawRectToImageView:(UIImageView *)imageView;

//等高
+ (void)drawRectToImageViewWidth:(UIImageView *)imageView;

#pragma mark - touchPress
+ (void)touchPress:(int)index AnimationToView:(UIView *)view;

/*
 * 6、组合动画
 */
+ (CAAnimation *)groupAnimation:(UIView *)view;

/*淡化动画*/
+ (CAAnimation *)animationTransitionFade;
+ (UIImageView *)bubbleView:(NSString *)text;

@end
