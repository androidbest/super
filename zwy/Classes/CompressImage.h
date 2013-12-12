//
//  CompressImage.h
//  zwy
//
//  Created by cqsxit on 13-12-12.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import <Foundation/Foundation.h>
static const CGSize imageSize = {60, 60};
@interface CompressImage : NSObject

+ (void)setCellContentImage:(UIImageView *)ImageViewCell Image:(UIImage *)image filePath:(NSString *)files;

//写入本地缓存
+ (void)writeFile:(UIImage *)image Type:(NSString * )type;
@end
