//
//  PhotoOptional.m
//  campusjoke
//
//  Created by Mac on 13-8-15.
//  Copyright (c) 2013年 campus. All rights reserved.
//

#import "PhotoOptional.h"
#import "CompressImage.h"

static PhotoOptional * PhOption=nil;
@implementation PhotoOptional{

    UIViewController * _ViewContro;
    void (^blcokOptionalImgae)(UIImage *image);
}

#pragma mark -单例
+ (PhotoOptional *)newInstance{
    @synchronized(self){
        if(!PhOption){
            PhOption= [[super allocWithZone:NULL] init];;
        }
    }
    return PhOption;
}
+ (id)allocWithZone:(NSZone *)zone
{
    return [self newInstance];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

//选择相机
- (BOOL)startCameraController:(UIViewController *)controller isAllowsEditing:(BOOL)allowsEditing photoImage:(void (^)(UIImage *image))blockImage{
   _ViewContro = (UIViewController *)controller;
    blcokOptionalImgae=blockImage;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return  NO;
    }
    UIImagePickerController * cameraUI = [[UIImagePickerController alloc]init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    cameraUI.allowsEditing = allowsEditing;
    cameraUI.delegate =self;
    [_ViewContro presentViewController:cameraUI animated:YES completion:nil];
    return  YES;
}

- (BOOL)startMediaBrowser:(UIViewController *)controller isAllowsEditing:(BOOL)allowsEditing photoImage:(void (^)(UIImage *image))blockImage{
    _ViewContro = (UIViewController *)controller;
    blcokOptionalImgae=blockImage;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]==NO) {
        return NO;
    }
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc]init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    mediaUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    mediaUI.delegate =self;
    mediaUI.allowsEditing =allowsEditing;
    [_ViewContro presentViewController:mediaUI animated:YES completion:nil];
    return YES;
}
//添加图片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        UIImage * originalImage,*editedImage,*imageToSave;
        if (CFStringCompare((CFStringRef)mediaType,kUTTypeImage, 0)==kCFCompareEqualTo) {
            editedImage = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
            originalImage =(UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
            if (editedImage) {
                imageToSave =editedImage;
            }else{
                imageToSave =originalImage;
            }
            [self PushNotification:imageToSave];
            UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil);
        }
        if (CFStringCompare((CFStringRef)mediaType, kUTTypeMovie, 0)==kCFCompareEqualTo) {
            NSString *moviePath = (NSString *)[[info objectForKey:UIImagePickerControllerMediaURL] path];
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath)) {
                UISaveVideoAtPathToSavedPhotosAlbum(moviePath, nil, nil, nil);
            }
        }
    }else if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
        NSString * mediaType =[info objectForKey:UIImagePickerControllerMediaType];
        UIImage * originalImage,*editedImage,*imageToSave;
        if (CFStringCompare((CFStringRef)mediaType, kUTTypeImage, 0)==kCFCompareEqualTo) {
            editedImage = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
            originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
            if (editedImage) {
                imageToSave =editedImage;
            }else{
                imageToSave =originalImage;
            }
            [self PushNotification:imageToSave];
        }
    }
    [[picker parentViewController]dismissViewControllerAnimated:YES completion:nil];
    [_ViewContro dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)PushNotification:(UIImage *)image{
    blcokOptionalImgae(image);
}
@end
