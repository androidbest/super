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

/*
 *缩放动画(由小变大)
 */

+ (CAAnimation *)animationTransitionOglflip{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //  animation.beginTime=10;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]; /* 动画的开始与结束的快慢*/
    animation.duration                = 1.5;
    animation.autoreverses            = NO;
    animation.repeatCount            = 1;  //"forever"
    animation.removedOnCompletion    = NO;
    animation.fromValue =[NSNumber numberWithFloat:1.0];	//动画起始值
    animation.toValue = [NSNumber numberWithFloat:1.5];		//动画目标值
    return animation;
    
}
/*
 * 位移动画
 */
+ (CAAnimation *)animationRotate:(UIView *)view
{
    // rotate animation
    // CATransform3D rotationTransform  = CATransform3DMakeRotation(M_PI, 1.0, 0, 0.0);
    
    CABasicAnimation* animation;
    animation=[CABasicAnimation animationWithKeyPath:@"position"];
    //动画类型
    animation.duration=1.5;        //动画持续时间
    animation.repeatCount=1;     //动画重复次数
    animation.beginTime=0.0f;    //动画开始时间
    animation.autoreverses=YES;  //动画是否回复
    animation.fromValue=[NSValue valueWithCGPoint:CGPointMake(view.layer.frame.origin.x+10, view.layer.frame.origin.y)];//动画起始值
    animation.toValue=[NSValue valueWithCGPoint:CGPointMake(view.layer.frame.origin.x+10, view.layer.frame.origin.y-50)];//动画的目标值
    return animation;
}
/*
 * 6、组合动画
 */
+ (CAAnimation *)groupAnimation:(UIView *)view{
    view.alpha=1.0;
    [UIView animateWithDuration:1.5 animations:^{
        view.alpha=0.0;
    }];
    CAAnimation* myAnimationFallingDown        = [self animationRotate:view];//位移动画
    CAAnimation* animationTransitionOglflip    = [self animationTransitionOglflip];//缩放动画
    
    CAAnimationGroup*m_pGroupAnimation    = [CAAnimationGroup animation];
    
    //设置动画代理
    m_pGroupAnimation.delegate = self;
    
    m_pGroupAnimation.removedOnCompletion = NO;
    
    m_pGroupAnimation.duration             = 1.5;//动画时间
    m_pGroupAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];//开始与结束时的快慢
    /** timingFunction
     *
     *  用于变化起点和终点之间的插值计算,形象点说它决定了动画运行的节奏,比如是均匀变化(相同时间变化量相同)还是
     *  先快后慢,先慢后快还是先慢再快再慢.
     *
     *  动画的开始与结束的快慢,有五个预置分别为(下同):
     *  kCAMediaTimingFunctionLinear            线性,即匀速
     *  kCAMediaTimingFunctionEaseIn            先慢后快
     *  kCAMediaTimingFunctionEaseOut           先快后慢
     *  kCAMediaTimingFunctionEaseInEaseOut     先慢后快再慢
     *  kCAMediaTimingFunctionDefault           实际效果是动画中间比较快.
     */
    m_pGroupAnimation.repeatCount         = 1;//FLT_MAX;  //"forever";
    m_pGroupAnimation.fillMode             = kCAFillModeForwards;
    m_pGroupAnimation.animations             = [NSArray arrayWithObjects:
                                                myAnimationFallingDown,
                                                animationTransitionOglflip,
                                                nil];
    return m_pGroupAnimation;
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

//自动拉长图片
+ (UIImageView *)bubbleView:(NSString *)text{
    UIImageView *returnView = [[UIImageView alloc] initWithFrame:CGRectZero];
    returnView.backgroundColor = [UIColor clearColor];
    
    UIImage *bubble =[UIImage imageNamed:@"chat_righttext.png"];
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
    
    UIFont *font = [UIFont systemFontOfSize:13];
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(150.0f, 1000.0f)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
    
    UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(24.0f+20, 14.0f-9, textRect.size.width+10, textRect.size.height+10)];
    bubbleText.backgroundColor = [UIColor clearColor];
    bubbleText.font = font;
    bubbleText.numberOfLines = 0;
    bubbleText.text =text;
    
    bubbleImageView.frame = CGRectMake(0.0f+20+5, 0.0f, textRect.size.width+50, textRect.size.height+30.0f-10);
    returnView.frame = CGRectMake(200-textRect.size.width, 0.0f, textRect.size.width+50, textRect.size.height+50.0f-10);
    
    [returnView addSubview:bubbleImageView];
    [returnView addSubview:bubbleText];
    
    return returnView ;
}


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
    if (100*WroH>270) {
        rect.size.width=270;
    }else{
     rect.size.width=100*WroH;
    }
    rect.size.height=100;
    imageView.frame=rect;
}
@end
