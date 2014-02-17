//
//  UpdataDate.m
//  zwy
//
//  Created by cqsxit on 13-11-26.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "UpdataDate.h"


/*公历获取闰年算法*/
static BOOL booleanIsGregorianLeapYear(int year) {
    BOOL isLeap = false;
    if (year%4==0) isLeap = true;
    if (year%100==0) isLeap = false;
    if (year%400==0) isLeap = true;
    return isLeap;
}

@implementation UpdataDate


#pragma mark  - 获取最近星期数
+ (NSString *)reqeatWithWeekTodate:(NSString *)warningDate{
    NSTimeInterval time_warning =[self TimeStingWithInterVal:warningDate];
    NSTimeInterval time_now=[[NSDate date] timeIntervalSince1970];
    while (time_warning<time_now) {
        time_warning+=7*24*60*60;
    }
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time_warning];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];//初始化转换格式
    [formatter setDateFormat:@"yyyy-MM-dd"];//设置转换格式
    NSString *strDate =[formatter stringFromDate:date];
    return strDate;
}


#pragma mark - 按月循环,获取最近月数
+ (NSString *)reqeatWithMonthTodate:(NSString *)warningDate{
    NSTimeInterval time_warning =[self TimeStingWithInterVal:warningDate];
    NSTimeInterval time_now=[[NSDate date] timeIntervalSince1970];
    NSString *strDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];//初始化转换格式
    [formatter setDateFormat:@"yyyy-MM-dd"];//设置转换格式
    while (time_warning<time_now) {
        NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time_warning];
        strDate =[formatter stringFromDate:date];
        NSArray *array =[strDate componentsSeparatedByString:@"-"];
        if (array.count>2) {
          long long month =[array[1] intValue];
           long long year =[array[0] intValue];
            if ((month%2==1&&month!=2)&&month<8) {/*如果是大月加31*/
                time_warning+=31*24*60*60;
            }else if((month%2==0&&month!=2)&&month<8){/*如果是小月加30*/
                time_warning+=30*24*60*60;
            }else if((month%2==1&&month!=2)&&month>=8){
                time_warning+=30*24*60*60;
            }else if((month%2==0&&month!=2)&&month>=8){
                time_warning+=31*24*60*60;
            } else if(year%4==0&&month==2&&year%128!=0){/*闰月加29*/
                 time_warning+=29*24*60*60;
            } else if(year%4!=0&&month==2){/*平月加28*/
                time_warning+=28*24*60*60;
            }
        }
       
    }
    
    NSDate *returnDate = [[NSDate alloc]initWithTimeIntervalSince1970:time_warning];
    strDate =[formatter stringFromDate:returnDate];
    return strDate;
}

#pragma mark - 按年循环,获取最近年数
+ (NSString *)reqeatWithYearTodate:(NSString *)warningDate{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSArray *array =[warningDate componentsSeparatedByString:@"-"];
    NSString *NowYears=[[[dateFormatter stringFromDate:[NSDate date]] componentsSeparatedByString:@"-"] firstObject];
    
    int year;
    int month;
    int days;
    if (array.count>2) {
         year=[array[0] intValue];
         month =[array[1] intValue];
         days =[array[2] intValue];
    }else{
        return warningDate;
    }
   
    NSTimeInterval time_warning =[self TimeStingWithInterVal:warningDate];
    NSTimeInterval time_now=[[NSDate date] timeIntervalSince1970];
    NSString *strDate=nil;
    
    
    /*先将年份换算为今年的年份*/
    if (time_warning<time_now) {
        int now_year=[NowYears integerValue];
        year=now_year;
        
        /*如果是闰年的2月29号必须按4年一重复*/
        if (month==2&&days==29) {
            BOOL isLeapMonth =booleanIsGregorianLeapYear(year);
            while (!isLeapMonth) {
                year++;
                isLeapMonth =booleanIsGregorianLeapYear(year);
            }
        }
        strDate =[NSString stringWithFormat:@"%02d-%02d-%02d",year,month,days];
        time_warning=[self TimeStingWithInterVal:strDate];
    }
    
    /*如果换算过来的时间已经过了再往后推1年(闰年推4年)*/
    time_now-=60*60*24;/*减去当天的24小时*/
    if (time_warning<time_now){
        if (month==2&&days==29) year+=4;
        else year+=1;
    }
     strDate =[NSString stringWithFormat:@"%02d-%02d-%02d",year,month,days];
    
    return strDate;
}


#pragma mark  -当前时间转换为毫秒
+ (NSTimeInterval)TimeStingWithInterVal:(NSString *)strTime{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date =[dateFormatter dateFromString:strTime];
    NSTimeInterval time_=[date timeIntervalSince1970];
    return time_;
}

#pragma mark -时间比较大小
+(int)bigOrsmallOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}

@end
