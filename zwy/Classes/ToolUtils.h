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



+(BOOL)isValidateEmail:(NSString *)email;
+(BOOL)isValidatePhone:(NSString *)phone;
+(NSString*)numToString:(NSInteger)num;
+(NSInteger)stringToNum:(NSString *)str;
+ (void)TableViewPullDownAnimation:(UITableView *)view PathAnimationType:(int)type;

#pragma mark -组装json
+(NSData *)packageJsonFormat:(NSDictionary *) dic;

#pragma mark -解析json
+(NSDictionary *)analyzeJsonFormat:(NSData *) dic;

#pragma mark -时间比较
+(int)compareOneDay:(NSString *)startDate withAnotherDay:(NSString *)endDate;

#pragma mark -时间比较大小
+(int)bigOrsmallOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;

#pragma mark  -当前时间转换为毫秒
+ (NSTimeInterval)TimeStingWithInterVal:(NSString *)strTime;

#pragma mark  -当前时间转换为毫秒
+ (NSTimeInterval)intervalFromDate:(NSDate *)date;

//公历转农历
+ (NSString *)solarOrLunar:(NSDate *)date;

//类型转换
+ (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve;
//泡泡文本
+ (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf withPosition:(int)position view:(UIView *)returnView;
+(UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf;

#pragma mark - 汉字转换为拼音
+ (NSString *)pinyinFromString:(NSString *)str;
@end
