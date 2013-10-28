//
//  ToolUtils.m
//  ZheWuYi
//
//  Created by wangshuang on 13-6-18.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "ToolUtils.h"
#import "ConfigFile.h"
@implementation ToolUtils


#pragma mark - 获取当前日期，时间
+(NSDate *)getCurrentDate{
    NSDate *now = [NSDate date];
    return now;
}

#pragma mark - 日期转字符串
+ (NSString * )NSDateToNSString: (NSDate * )date
{
    NSDateFormatter * formatter = [NSDateFormatter new];
    [formatter setDateFormat: kDEFAULT_DATE_TIME_FORMAT];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

#pragma mark - 字符串转日期
+ (NSDate * )NSStringToNSDate: (NSString * )string
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: kDEFAULT_DATE_TIME_FORMAT];
    NSDate *date = [formatter dateFromString :string];
    return date;
}

#pragma mark - 判断网络状态
+(BOOL)isExistenceNetwork
{
    BOOL isExistenceNetwork=NO;
    
//    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if([ToolUtils IsEnableWIFI]||[ToolUtils IsEnable3G]){
        isExistenceNetwork=YES;
    }
    else{
        isExistenceNetwork=NO;
    }
    return isExistenceNetwork;
}

#pragma mark - 判断wifi
+ (BOOL) IsEnableWIFI {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

#pragma mark - 判断3g
+ (BOOL) IsEnable3G {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

#pragma mark - 弹出框提示信息
+ (void) alertInfo:(NSString*) string{
    UIAlertView *alertInfo = [[UIAlertView alloc] initWithTitle:@"提示"
                                                     message:string
                                                    delegate:nil
                                           cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alertInfo show];
}

#pragma mark - 弹出框提示信息监听事件
+ (void) alertInfo:(NSString*) string lister:(id<UIAlertViewDelegate>) lister{
    UIAlertView *alertInfo = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:string
                                                       delegate:lister
                                              cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertInfo show];
}
+ (void) alertInfo:(NSString *)string delegate:(id)delegate otherBtn:(NSString *)BtnTitle{
    UIAlertView *alertInfo =[[UIAlertView alloc] initWithTitle:@"提示"
                                                       message:string
                                                      delegate:delegate
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:BtnTitle, nil];
    [alertInfo show];
}

#pragma mark - 自定义隐藏tabBar
+(void) hideTabBar:(UITabBarController*) tabbarcontroller {

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    for(UIView*view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {            
            [view setFrame:CGRectMake(view.frame.origin.x,ScreenHeight, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width,ScreenHeight)];
        }
    }
    [UIView commitAnimations];

}

#pragma mark - 自定义显示tabBar
+(void) showTabBar:(UITabBarController*) tabbarcontroller {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    for(UIView*view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x,ScreenHeight-49, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width,ScreenHeight)];
        }
    }
    [UIView commitAnimations];
}

//利用正则表达式验证邮箱
+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//验证手机号码
+(BOOL)isValidatePhone:(NSString *)phone {
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,3-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

#pragma mark -组装json
+(NSData *)packageJsonFormat:(NSDictionary *) dic{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    return jsonData;
}

#pragma mark -解析json
+(NSDictionary *)analyzeJsonFormat:(NSData *) dic{
    NSDictionary* json =[NSJSONSerialization
                         JSONObjectWithData:dic 
                         options:kNilOptions
                         error:nil];
    return json;
}
//数字转字符串
+(NSString*)numToString:(NSInteger)numInt{
    NSNumber *num = [NSNumber numberWithInteger:numInt];
    return num.stringValue;
}

//字符串转数字
+(NSInteger)stringToNum:(NSString *)str{
    return str.integerValue;
}

//过渡 动画
+ (void)TableViewPullDownAnimation:(UITableView *)view PathAnimationType:(int)type{
    switch (type) {
        case 0:{
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3f;         /* 间隔时间*/
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]; /* 动画的开始与结束的快慢*/
            transition.type = kCATransitionPush; /* 各种动画效果*/
            transition.repeatCount=1;//动画次数
            transition.autoreverses = NO;						//动画是否回复
            transition.subtype = kCATransitionFromLeft;   /* 动画方向*/
            [view.layer addAnimation:transition forKey:@"PushAnimation"];
        }
            break;
        case 1:{
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3f;         /* 间隔时间*/
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]; /* 动画的开始与结束的快慢*/
            transition.type = kCATransitionPush; /* 各种动画效果*/
            transition.repeatCount=1;//动画次数
            transition.autoreverses = NO;						//动画是否回复
            transition.subtype = kCATransitionFromRight;   /* 动画方向*/
            [view.layer addAnimation:transition forKey:@"PushAnimation"];
        }
            break;
        default:
            break;
    }
    
}

@end
