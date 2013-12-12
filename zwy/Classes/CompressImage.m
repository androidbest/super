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


#pragma mark -压缩图片

//从本地读取缓存(内容图)
+(void)setContentImage:(UIImageView *)imageContent imageData:(NSData *)data{
    UIImage *image =[UIImage imageWithData:data];
    imageContent.image=image;
    float width =CGImageGetWidth(image.CGImage);
    float height=CGImageGetHeight(image.CGImage);
    float WroH=width/height;
    CGRect rect =imageContent.frame;
    rect.size.width=WroH*100;
    imageContent.frame=rect;
}

//从网络(内容图)
+ (void)setCellContentImage:(UIImageView *)ImageViewCell Image:(UIImage *)image filePath:(NSString *)files{
//    float width =CGImageGetWidth(image.CGImage);
//    float height=CGImageGetHeight(image.CGImage);
//    float WroH=width/height;
    __block UIImage * blockImage =image;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        blockImage=[self imageContentWithSimple:image];
        dispatch_async(dispatch_get_main_queue(), ^{
            ImageViewCell.image=blockImage;
//            CGRect rect =ImageViewCell.frame;
//            rect.size.width=WroH*100;
//            ImageViewCell.frame=rect;
            [self writeFile:ImageViewCell.image Type:files];
        });
    });
    
    
}

//压内容图片
+ (UIImage *)imageContentWithSimple:(UIImage*)image{
// float width =CGImageGetWidth(image.CGImage);
// float height=CGImageGetHeight(image.CGImage);
// float WroH=width/height;
    NSData * data =UIImageJPEGRepresentation(image, 0.1);
    image=[UIImage imageWithData:data];
//    UIGraphicsBeginImageContext(CGSizeMake(WroH*100, 100));
//    [image drawInRect:CGRectMake(0,0,WroH*100,100)];
//    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    return image;
}

+ (NSData *)imageWithUpdataImage:(UIImage *)image{
    NSData * data =UIImageJPEGRepresentation(image, 0.1);
    NSLog(@"数据长度---%d",data.length);
    return data;
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
