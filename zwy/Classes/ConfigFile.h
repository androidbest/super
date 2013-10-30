//
//  ConfigFile.h
//  zwy
//
//  Created by wangshuang on 13-5-5.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

//UIKIT_EXTERN NSString *NSStringFromCGPoint(CGPoint point);
//UIKIT_EXTERN NSString *NSStringFromCGSize(CGSize size);
//UIKIT_EXTERN NSString *NSStringFromCGRect(CGRect rect);
//UIKIT_EXTERN NSString *NSStringFromCGAffineTransform(CGAffineTransform transform);
//UIKIT_EXTERN NSString *NSStringFromUIEdgeInsets(UIEdgeInsets insets);
//
//UIKIT_EXTERN CGPoint CGPointFromString(NSString *string);
//UIKIT_EXTERN CGSize CGSizeFromString(NSString *string);
//UIKIT_EXTERN CGRect CGRectFromString(NSString *string);
//UIKIT_EXTERN CGAffineTransform CGAffineTransformFromString(NSString *string);
//UIKIT_EXTERN UIEdgeInsets UIEdgeInsetsFromString(NSString *string);

#import <Foundation/Foundation.h>
@interface ConfigFile : NSObject

@property(nonatomic,strong) NSMutableDictionary *configData;
+(ConfigFile *)newInstance;

//创建公文附件路径
- (void)paths;

-(void)initData;

//创建单位通讯录文件
+ (void)pathECGroups;

#pragma mark - 获取通讯录所有信息
+ (NSMutableArray *)setAllPeopleInfo:(NSString *)str;
@end
