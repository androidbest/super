//
//  PhotoOptional.h
//  campusjoke
//
//  Created by Mac on 13-8-15.
//  Copyright (c) 2013年 campus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface PhotoOptional : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

+ (PhotoOptional *)newInstance;

//选择相机
- (BOOL)startCameraController:(UIViewController *)controller isAllowsEditing:(BOOL)allowsEditing photoImage:(void (^)(UIImage *image))blockImage;

//选择图库
- (BOOL)startMediaBrowser:(UIViewController *)controller isAllowsEditing:(BOOL)allowsEditing photoImage:(void (^)(UIImage *image))blockImage;

@end
