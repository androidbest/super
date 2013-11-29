//
//  UpdataDate.h
//  zwy
//
//  Created by cqsxit on 13-11-26.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdataDate : NSObject

#pragma mark  - 获取最近星期数
+ (NSString *)reqeatWithWeekTodate:(NSString *)warningDate;

#pragma mark - 按月循环,获取最近月数
+ (NSString *)reqeatWithMonthTodate:(NSString *)warningDate;

#pragma mark - 按月循环,获取最近月数
+ (NSString *)reqeatWithYearTodate:(NSString *)warningDate;

#pragma mark -时间比较大小
+(int)bigOrsmallOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;

#pragma mark  -当前时间转换为毫秒
+ (NSTimeInterval)TimeStingWithInterVal:(NSString *)strTime;
@end
