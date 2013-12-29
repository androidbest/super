//
//  HTTPRequest.h
//  tongxunluCeShi
//
//  Created by Mac on 13-9-26.
//  Copyright (c) 2013年 钟伟迪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "CompressImage.h"

typedef void (^imageWithRequst)(UIImage *image);

@interface HTTPRequest : NSObject

+ (void)JSONRequestOperation:(id)delegate Request:(NSMutableURLRequest *)request;

+ (void)JSONRequestOperation:(id)delegate Request:(NSMutableURLRequest *)request SELType:(NSString *)sel;

+(void)LoadDownFile:(id)delegate URL:(NSString *)strUrl filePath:(NSString *)path  HUD:(MBProgressHUD *)hud;

+ (void)data;

/*异步加载图片*/
+ (void)imageWithURL:(NSString *)URL imageView:(UIImageView *)imageView placeholderImage:(UIImage *)image isDrawRect:(drawRectType_Height_Width)drawRectType;

+ (void)imageWithURL:(NSString *)URL imageView:(UIImageView *)imageView placeholderImage:(UIImage *)image;
+ (void)imageWithURL:(NSString *)URL imageView:(UIButton *)imageView placeUIButtonImage:(UIImage *)image;

/*获取网络图片*/
+ (void)setImageWithURL:(NSString *)URL placeholderImage:(UIImage *)image ImageBolck:(imageWithRequst)ImageBolck;

//获取音频文件
+ (void)voiceWithURL:(NSString *)URL;

+ (void)uploadRequestOperation:(id)delegate type:(NSString *)type imageData:(NSData *)data url:(NSURL *)url selType:(NSString *)selType uuid:(NSString *)uuid;
@end
