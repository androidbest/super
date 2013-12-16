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

#pragma mark - touchPress
+ (void)touchPress:(int)index AnimationToView:(UIView *)view{
 
    CATransition *  tran=[CATransition animation];
    
    
    switch (index) {
        case 10000:
            tran.type = @"suckEffect";
            break;
        case 10001:
            tran.type = @"rippleEffect";
            break;
        case 10002:
            tran.type = @"pageCurl";
            tran.subtype = kCATransitionFromRight;
            
            break;
        case 10003:
            tran.type = kCATransitionMoveIn;
            tran.subtype = kCATransitionFromRight;
            break;
        case 10004:
            tran.type = kCATransitionPush;
            tran.subtype = kCATransitionFromRight;
            break;
        case 10005:
            tran.type = kCATransitionReveal;
            tran.subtype = kCATransitionFromRight;
            break;
        case 10006:
            tran.type = kCATransitionReveal;
            tran.subtype = kCATransitionFromLeft;
            break;
        case 10007:
            tran.type = kCATransitionReveal;
            
            tran.subtype = kCATransitionFromTop;
            break;
            
        case 10008:
            tran.type = kCATransitionReveal;
            
            tran.subtype = kCATransitionFromBottom;
            break;
        case 10009:
            tran.type = @"cube";
            tran.subtype = kCATransitionFromBottom;
            break;
        case 10010:
            tran.type = @"oglFlip";
            tran.subtype = kCATransitionFromBottom;
            break;
        case 10011:
            tran.type = @"rippleEffect";
            break;
        case 10012:
            tran.type = @"cameraIrisHollowOpen";
            break;
        case 10013:
            tran.type = @"cameraIrisHollowClose";
            break;
        case 10014:
            tran.type = kCATransitionMoveIn;
            tran.subtype = kCATransitionFromTop;
            break;
        case 10015:
            tran.type = kCATransitionPush;
            tran.subtype = kCATransitionFromTop;
            break;
        case 10016:
            tran.type = @"pageCurl";
            tran.subtype = kCATransitionFromTop;
            break;
        case 10017:
            tran.type = @"pageCurl";
            tran.subtype = kCATransitionFromLeft;
            break;
        case 10018:
            tran.type = @"pageCurl";
            tran.subtype = kCATransitionFromBottom;
            break;
        case 10019:
            tran.type = @"oglFlip";
            tran.subtype = kCATransitionFromTop;
            break;
        case 10020:
            tran.type = @"oglFlip";
            tran.subtype = kCATransitionFromLeft;
            break;
        case 10021:
            tran.type = kCATransitionMoveIn;
            tran.subtype = kCATransitionFromLeft;
            
            break;
        case 10022:
            tran.type = kCATransitionMoveIn;
            tran.subtype = kCATransitionFromTop;
            
            break;
        case 10023:
            tran.type = kCATransitionMoveIn;
            tran.subtype = kCATransitionFromBottom;
            
            break;
        case 10024:
            tran.type = kCATransitionPush;
            tran.subtype = kCATransitionFromLeft;
            break;
        case 10025:
            tran.type = kCATransitionPush;
            tran.subtype = kCATransitionFromTop;
            break;
        case 10026:
            tran.type = kCATransitionPush;
            tran.subtype = kCATransitionFromBottom;
            break;
        case 10027:
            tran.type = @"cube";
            tran.subtype = kCATransitionFromRight;
            break;
        case 10028:
            tran.type = @"cube";
            tran.subtype = kCATransitionFromTop;
            break;
        case 10029:
            tran.type = @"cube";
            tran.subtype = kCATransitionFromLeft;
            break;
            
        default:
            break;
    }
    tran.duration=0.5;
    [view.layer addAnimation:tran forKey:@"kongyu"];
}

///////////////////*****************////////////////////////
///////////////////*****************////////////////////////

///////////////////*****************////////////////////////
///////////////////*****************////////////////////////

#pragma mark -压缩图片
//保存本地压缩图
+ (void)setCellContentImage:(UIImageView *)ImageViewCell Image:(UIImage *)image filePath:(NSString *)files isDrawRect:(drawRectType_Height_Width)drawRectType{
    __block UIImage * blockImage =image;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        blockImage=[self imageContentWithSimple:image];
        dispatch_async(dispatch_get_main_queue(), ^{
            CAAnimation *animation =[self animationTransitionFade];
            [ImageViewCell.layer addAnimation:animation forKey:@"animationTransitionFade"];
            ImageViewCell.image=blockImage;
            [self writeFile:ImageViewCell.image Type:files];
            if (drawRectType==drawRect_height){
                [self drawRectToImageView:ImageViewCell];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATIONIMAGEDRAWRECT
                                                                    object:nil
                                                                  userInfo:nil];
            }
            if (drawRectType==drawRect_width) {
                [self drawRectToImageViewWidth:ImageViewCell];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATIONIMAGEDRAWRECT
                                                                    object:nil
                                                                  userInfo:nil];
            }
            
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

//等宽
+ (void)drawRectToImageView:(UIImageView *)imageView{
    float width =CGImageGetWidth(imageView.image.CGImage);
    float height=CGImageGetHeight(imageView.image.CGImage);
    float WroH=width/height;
    CGRect rect =imageView.frame;
    rect.size.width=ScreenWidth-20;
    rect.size.height=(ScreenWidth-20)/WroH;
    imageView.frame=rect;
}

//等高
+ (void)drawRectToImageViewWidth:(UIImageView *)imageView{
    float width =CGImageGetWidth(imageView.image.CGImage);
    float height=CGImageGetHeight(imageView.image.CGImage);
    float WroH=width/height;
    CGRect rect =imageView.frame;
    rect.size.width=100*WroH;
    rect.size.height=100;
    imageView.frame=rect;
}
@end
