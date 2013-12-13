//
//  CompressImage.m
//  zwy
//
//  Created by cqsxit on 13-12-12.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "CompressImage.h"
#import "ConfigFile.h"
@implementation CompressImage

/*
 *过渡动画//淡化
 */
+ (CAAnimation *)animationTransitionFade{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;         /* 间隔时间*/
    transition.type = @"fade"; /* 各种动画效果*/
    transition.repeatCount=1;//动画次数
    transition.autoreverses = NO;						//动画是否回复
    //@"cube" @"moveIn" @"reveal" @"fade"(default)/淡化/   @"pageCurl" @"pageUnCurl" @"suckEffect" @"rippleEffect" @"oglFlip"
    transition.subtype = kCATransitionFromTop;   /* 动画方向*/
    return transition;
}

#pragma mark -压缩图片
//保存本地压缩图
+ (void)setCellContentImage:(UIImageView *)ImageViewCell Image:(UIImage *)image filePath:(NSString *)files{
    __block UIImage * blockImage =image;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        blockImage=[self imageContentWithSimple:image];
        dispatch_async(dispatch_get_main_queue(), ^{
            CAAnimation *animation =[self animationTransitionFade];
            [ImageViewCell.layer addAnimation:animation forKey:@"animationTransitionFade"];
            ImageViewCell.image=blockImage;
            [self writeFile:ImageViewCell.image Type:files];
        });
        
    });
}

//压缩图片
+ (UIImage *)imageContentWithSimple:(UIImage*)image{
 float width =CGImageGetWidth(image.CGImage);
 float height=CGImageGetHeight(image.CGImage);
 float WroH=width/height;
    NSData * data =UIImageJPEGRepresentation(image, 0.1);
    image=[UIImage imageWithData:data];
    UIGraphicsBeginImageContext(CGSizeMake(WroH*300, 300));
    [image drawInRect:CGRectMake(0,0,WroH*300,300)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//写入本地缓存
+ (void)writeFile:(UIImage *)image Type:(NSString * )type{
    __block UIImage * blockImage =image;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        blockImage = [self imageContentWithSimple:image];
        NSString * strpaths =[NSString stringWithFormat:@"%@/%@/%@",DocumentsDirectory,MESSGEFILEPATH,type];
        [self foundFilepath:MESSGEFILEPATH];
        NSData * data =UIImageJPEGRepresentation(blockImage, 0.5);
        [data writeToFile:strpaths atomically:NO];
    });
}

+ (void)foundFilepath:(NSString *)Files{
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //更改到待操作的目录下
    [fileManager changeCurrentDirectoryPath:[DocumentsDirectory stringByExpandingTildeInPath]];
    //创建文件fileName文件名称，contents文件的内容，如果开始没有内容可以设置为nil，attributes文件的属性，初始为nil
    NSString *filePath =[NSString stringWithFormat:@"%@/%@",DocumentsDirectory,Files];
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

@end
