//
//  ToolUtils.h
//  ZheWuYi
//
//  Created by wangshuang on 13-6-18.
//  Copyright (c) 2013年 Mac. All rights reserved.
//
#define kDEFAULT_DATE_TIME_FORMAT (@"yyyy-MM-dd HH:mm")
#import <Foundation/Foundation.h>
#import "Reachability.h"


@interface ToolUtils : NSObject


+(NSDate *)getCurrentDate;
+ (NSString *)NSDateToNSString: (NSDate * )date;
+ (NSDate * )NSStringToNSDate: (NSString * )string;
+(BOOL)isExistenceNetwork;
+ (void) alertInfo:(NSString*) string;
+ (void) alertInfo:(NSString*) string lister:(id<UIAlertViewDelegate>) lister;
+ (void) alertInfo:(NSString *)string delegate:(id)delegate otherBtn:(NSString *)BtnTitle;
+(void) hideTabBar:(UITabBarController*) tabbarcontroller;
+(void) showTabBar:(UITabBarController*) tabbarcontroller;
+(NSData *)packageJsonFormat:(NSDictionary *) dic;
+(NSDictionary *)analyzeJsonFormat:(NSData *) dic;
+(BOOL)isValidateEmail:(NSString *)email;
+(BOOL)isValidatePhone:(NSString *)phone;
+(NSString*)numToString:(NSInteger)num;
+(NSInteger)stringToNum:(NSString *)str;
+ (void)TableViewPullDownAnimation:(UITableView *)view PathAnimationType:(int)type;
@end
