//
//  ToolUtils.m
//  ZheWuYi
//
//  Created by wangshuang on 13-6-18.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "ToolUtils.h"
#import "ConfigFile.h"
#import "solarOrLunar.h"
#import "Date+string.h"
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
                                             cancelButtonTitle:@"取消"
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

#pragma mark -时间比较天数
+(int)compareOneDay:(NSString *)startDate withAnotherDay:(NSString *)endDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setFormatterBehavior:NSDateFormatterBehaviorDefault];
    [formatter setDateFormat:@"yyyy-MM-dd"];

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *startDate_ = [formatter dateFromString:startDate];
    NSDate *endDate_ = [formatter dateFromString:endDate];
    unsigned int unitFlags = NSDayCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:startDate_  toDate:endDate_  options:0];
    int days = [comps day];
    return days;
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

#pragma mark  -当前时间转换为毫秒
+ (NSTimeInterval)TimeStingWithInterVal:(NSString *)strTime{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date =[dateFormatter dateFromString:strTime];
    /*避免时差*/
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSTimeInterval time_=[localeDate timeIntervalSince1970];
    return time_;
}

+ (NSTimeInterval)intervalFromDate:(NSDate *)date{
    /*避免时差*/
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSTimeInterval time_=[localeDate timeIntervalSince1970];
    return time_;
}

+ (NSString *)solarOrLunar:(NSDate *)date{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strTime =[dateFormatter stringFromDate:date];
    int year =[[[strTime componentsSeparatedByString:@"-"] firstObject] integerValue];
    int month =[[[strTime componentsSeparatedByString:@"-"] objectAtIndex:1] integerValue];
    int day =[[[strTime componentsSeparatedByString:@"-"] lastObject] integerValue];
    hjz lunar =solar_to_lunar(year, month, day);//将当前的公历时间转换为农历
    NSString *strYear =[NSString stringWithFormat:@"%d",lunar.year];
    strYear =[Date_string setYearBaseSting:strYear];
    NSString *strMonth =[NSString stringWithFormat:@"%dx%d",lunar.month,lunar.reserved];
    if (lunar.month<10) strMonth =[@"0" stringByAppendingString:strMonth];
    strMonth =[Date_string setMonthBaseSting:strMonth];
    NSString *strDay=[NSString stringWithFormat:@"%d",lunar.day];
    if (lunar.day<10) strDay =[@"0" stringByAppendingString:strDay];
    strDay=[Date_string setDayBaseSting:strDay];
    NSString *strLunarTime=[NSString stringWithFormat:@"%@月%@日",strMonth,strDay];
    return strLunarTime;
}

+ (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve
{
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            return UIViewAnimationOptionCurveEaseInOut;
            break;
        case UIViewAnimationCurveEaseIn:
            return UIViewAnimationOptionCurveEaseIn;
            break;
        case UIViewAnimationCurveEaseOut:
            return UIViewAnimationOptionCurveEaseOut;
            break;
        case UIViewAnimationCurveLinear:
            return UIViewAnimationOptionCurveLinear;
            break;
    }
    
    return kNilOptions;
}

//泡泡文本
+(UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf withPosition:(int)position view:(UIView *)returnView{
    
    //计算大小
    UIFont *font = [UIFont systemFontOfSize:13];
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(180.0f, 2000.0f)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
//                       | NSStringDrawingUsesFontLeading
                                                   attributes:@{NSFontAttributeName:font}
                                                      context:nil];
    
    
	// build single chat bubble cell with given text
	returnView.backgroundColor = [UIColor clearColor];
	
    //背影图片
	UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"chat_lefttext":@"chat_righttext" ofType:@"png"]];
    
	UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:21 topCapHeight:70]];
//	NSLog(@"%f,%f",textRect.size.width,textRect.size.height);
	
    
    //添加文本信息
	UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(fromSelf?15.0f:22.0f, 6.0f, textRect.size.width+10, textRect.size.height+10)];
	bubbleText.backgroundColor = [UIColor clearColor];
	bubbleText.font = font;
	bubbleText.numberOfLines = 0;
	bubbleText.lineBreakMode = NSLineBreakByWordWrapping;
	bubbleText.text = text;
	
	bubbleImageView.frame = CGRectMake(0.0f, 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+20.0f);
    
	if(fromSelf)
		returnView.frame = CGRectMake(320-position-(bubbleText.frame.size.width+30.0f), 30, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
	else
		returnView.frame = CGRectMake(position, 30, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
	

//    returnView.layer.borderWidth = 1;
	[returnView addSubview:bubbleImageView];
	[returnView addSubview:bubbleText];
    
//    CGRect rect=returnView.frame;
//    rect.size.height=20;
//    returnView.frame=rect;
    
    
    return returnView;
}

//泡泡文本
+(UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf{
    
    //计算大小
    UIFont *font = [UIFont systemFontOfSize:13];
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(180.0f, 2000.0f)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                       //                       | NSStringDrawingUsesFontLeading
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
    
    
	// build single chat bubble cell with given text
    UIView *returnView =[[UIView alloc] initWithFrame:CGRectZero];
	returnView.backgroundColor = [UIColor clearColor];
	
    //背影图片
	UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"chat_lefttext":@"chat_righttext" ofType:@"png"]];
    
	UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:21 topCapHeight:70]];
	NSLog(@"%f,%f",textRect.size.width,textRect.size.height);
	
    
    //添加文本信息
	UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(fromSelf?15.0f:22.0f, 6.0f, textRect.size.width+10, textRect.size.height+10)];
	bubbleText.backgroundColor = [UIColor clearColor];
	bubbleText.font = font;
	bubbleText.numberOfLines = 0;
	bubbleText.lineBreakMode = NSLineBreakByWordWrapping;
	bubbleText.text = text;
	
	bubbleImageView.frame = CGRectMake(0.0f, 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+20.0f);
    
	if(fromSelf)
		returnView.frame = CGRectMake(320-0-(bubbleText.frame.size.width+30.0f), 30, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
	else
		returnView.frame = CGRectMake(0, 30, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
	
    
    //    returnView.layer.borderWidth = 1;
	[returnView addSubview:bubbleImageView];
	[returnView addSubview:bubbleText];
    
    //    CGRect rect=returnView.frame;
    //    rect.size.height=20;
    //    returnView.frame=rect;
    
    
    return returnView;
}

@end
