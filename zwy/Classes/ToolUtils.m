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
#import "PinYin4Objc.h"
#import "Constants.h"
#import "ZipArchive.h"
#import "MBProgressHUD.h"
#import "GroupAddressController.h"
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

#pragma mark - 日期转字符串
+ (NSString * )NSDateToNSString: (NSDate * )date format:(NSString *)format
{
    NSDateFormatter * formatter = [NSDateFormatter new];
    [formatter setDateFormat: format];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

#pragma mark - 字符串转日期
+ (NSDate * )NSStringToNSDate: (NSString * )string format:(NSString *)format
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: format];
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
    return ( [[Reachability reachabilityForLocalWiFi] currentReachabilityStatus]!= NotReachable);
}

#pragma mark - 是否是3G
+(BOOL)is3G{
    switch ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus]) {
        case 0:
            return NO;
        break;
        case 1:
            return YES;
        break;
        case 2:
            return NO;
        break;
    }
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
//    NSString *strYear =[NSString stringWithFormat:@"%d",lunar.year];
//    strYear =[Date_string setYearBaseSting:strYear];
    NSString *strMonth =[NSString stringWithFormat:@"%dx%d",lunar.month,lunar.reserved];
    if (lunar.month<10) strMonth =[@"0" stringByAppendingString:strMonth];
    strMonth =[Date_string setMonthBaseSting:strMonth];
    NSString *strDay=[NSString stringWithFormat:@"%d",lunar.day];
    if (lunar.day<10) strDay =[@"0" stringByAppendingString:strDay];
    strDay=[Date_string setDayBaseSting:strDay];
    NSString *strLunarTime=[NSString stringWithFormat:@"%@月%@",strMonth,strDay];
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

//selType 0. 1.语音、
//泡泡文本
+(UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf withPosition:(int)position view:(UIView *)returnView selfType:(NSString *)selfType voicetime:(NSString *)voicetime{
    
    //计算大小
    UIFont *font = [UIFont systemFontOfSize:13];
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(180.0f, 2000.0f)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
//                       | NSStringDrawingUsesFontLeading
                                                   attributes:@{NSFontAttributeName:font}
                                                      context:nil];
//
//    
//	// build single chat bubble cell with given text
	returnView.backgroundColor = [UIColor clearColor];

    UIImageView *bubbleImageView=nil;
    //背影图片
    if([selfType isEqualToString:@"0"]){
    if(fromSelf){
        UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chat_lefttext" ofType:@"png"]];
        bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
    }else{
        UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"chat_righttext" ofType:@"png"]];
        bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
    }
    }else{
        if(fromSelf){
            UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rightvoice" ofType:@"png"]];
            bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:30 topCapHeight:58]];
        }else{
            UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"leftvoice" ofType:@"png"]];
            bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:50 topCapHeight:58]];
        }

    }

////	NSLog(@"%f,%f",textRect.size.width,textRect.size.height);
//	
//    
//    //添加文本信息
	UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(fromSelf?10.0f:22.0f, 6.0f, textRect.size.width+10, textRect.size.height+10)];
	bubbleText.backgroundColor = [UIColor clearColor];
	bubbleText.font = font;
	bubbleText.numberOfLines = 0;
	bubbleText.lineBreakMode = NSLineBreakByWordWrapping;
    if([selfType isEqualToString:@"0"]){
    bubbleText.text = text;
    }else{
    bubbleText.text = @"";
    }

    
    NSInteger times=[self stringToNum:voicetime];
    times=times*2;
    if([selfType isEqualToString:@"0"]){
    bubbleImageView.frame = CGRectMake(0.0f, 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+15.0f);
    }else{
    bubbleImageView.frame = CGRectMake(0.0f, 0.0f, 65+times, 44);
    }
    
    if([selfType isEqualToString:@"0"]){
        if(fromSelf)
            returnView.frame = CGRectMake(320-position-(bubbleText.frame.size.width+30.0f), 30, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+40.0f);
        else
            returnView.frame = CGRectMake(position, 30, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
    }else{
    
        if(fromSelf)
            returnView.frame = CGRectMake(320-position-(bubbleText.frame.size.width+30.0f)-times, 30, bubbleText.frame.size.width+30.0f+times, bubbleText.frame.size.height+30.0f);
        else
            returnView.frame = CGRectMake(position, 30, bubbleText.frame.size.width+30.0f+times, bubbleText.frame.size.height+30.0f);
    }
    
	[returnView addSubview:bubbleImageView];
	[returnView addSubview:bubbleText];
//
//    returnView.layer.borderColor=[[UIColor blackColor] CGColor];
//    returnView.layer.borderWidth=1;
//
////    CGRect rect=returnView.frame;
////    rect.size.height=20;
////    returnView.frame=rect;
    
    
    return returnView;
}

//泡泡文本
+(UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf selfType:(NSString *)selfType{
    
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
//	UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"chat_lefttext":@"chat_righttext" ofType:@"png"]];
//    
//	UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:21 topCapHeight:70]];
	
    UIImageView *bubbleImageView=nil;
    //背影图片
    if([selfType isEqualToString:@"0"]){
        UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"chat_lefttext":@"chat_righttext" ofType:@"png"]];
        bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:10 topCapHeight:70]];
    }else{
        UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"rightvoice":@"leftvoice" ofType:@"png"]];
        bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:40 topCapHeight:70]];
    }
	
    
    //添加文本信息
	UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(fromSelf?15.0f:22.0f, 6.0f, textRect.size.width+10, textRect.size.height+10)];
	bubbleText.backgroundColor = [UIColor clearColor];
	bubbleText.font = font;
	bubbleText.numberOfLines = 0;
	bubbleText.lineBreakMode = NSLineBreakByWordWrapping;
	if([selfType isEqualToString:@"0"]){
        bubbleText.text = text;
    }else{
        bubbleText.text = @"";
    }
	
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

+ (NSString *)pinyinFromString:(NSString *)str{
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];
    NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:str withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
    return outputPinyin;
}

+ (NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

+ (NSString*) inputMethod:(NSString *)text{
    char* utf8Replace = "\xe2\x80\x86\0";
    NSData* data = [NSData dataWithBytes:utf8Replace length:strlen(utf8Replace)];
    NSString* utf8_str_format = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableString* mutableAblumName = [NSMutableString stringWithString:text];
    NSString* strAblum =  [mutableAblumName stringByReplacingOccurrencesOfString:utf8_str_format withString:@""];
    return strAblum;
}

/*
 *判断是push还是pop方法
 *YES为Push
 */
+ (BOOL)pushOrPopView:(UIViewController *)viewController{
    BOOL isPush=YES;
    NSArray *viewControllers = viewController.navigationController.viewControllers;
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        isPush=YES;
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        isPush=NO;
    }
    return isPush;
}

//解压zip包
+(void)unZipPackage{
    ZipArchive* zipFile = [ZipArchive new];
    NSString *strECpath =[NSString stringWithFormat:@"%@/%@.zip",user.msisdn,user.eccode];
    NSString * strPath =[DocumentsDirectory stringByAppendingPathComponent:strECpath];
    [zipFile UnzipOpenFile:strPath];
    NSString * strSavePath =[NSString stringWithFormat:@"%@/%@/%@",DocumentsDirectory,user.msisdn,user.eccode];
    [zipFile UnzipFileTo:strSavePath overWrite:YES];
    [zipFile UnzipCloseFile];
}

//下载通讯录压包
+(void)downFileZip:(MBProgressHUD*)hud delegate:(id)delegate{
    
    hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    hud.labelText = @"同步中...";
    NSString *strFileName =[NSString stringWithFormat:@"%@/%@.zip",user.msisdn,user.eccode];
    NSString * filePath =[DocumentsDirectory stringByAppendingPathComponent:strFileName];
    NSString *str=[GroupAddressController urlByConfigFile];
    NSString * strUrl =[NSString stringWithFormat:@"%@tmp/%@.zip?eccode=%@",str,user.eccode,user.eccode];
    [HTTPRequest LoadDownFile:delegate URL:strUrl filePath:filePath HUD:hud];
}

//开启即时聊天线程
+(void)startChatTimer{
    if (!EX_arrGroupAddressBooks||EX_arrGroupAddressBooks.count==0) {
        EX_arrGroupAddressBooks=[ConfigFile setEcNumberInfo];
        
        EX_arrSection=[NSMutableArray arrayWithObjects:
                       @"a",@"b",@"c",@"d",@"e",@"f",
                       @"g",@"h",@"i",@"j",@"k",@"l",
                       @"m",@"n",@"o",@"p",@"q",@"r",
                       @"s",@"t",@"u",@"v",@"w",@"x",
                       @"y",@"z",@"#",nil];
        NSMutableArray * arrRemoveObject=[[NSMutableArray alloc] init];
        for (int i = 0; i<EX_arrSection.count; i++) {
            NSString * strPre=[NSString stringWithFormat:@"SELF.Firetletter == '%@'",EX_arrSection[i]];
            NSPredicate * predicate;
            predicate = [NSPredicate predicateWithFormat:strPre];
            NSArray * results = [EX_arrGroupAddressBooks filteredArrayUsingPredicate: predicate];
            if (results.count==0) {
                [arrRemoveObject addObject:EX_arrSection[i]];
            }
        }
        [EX_arrSection removeObjectsInArray:arrRemoveObject];
    }
    /*****************************/
    /*更新完通讯录后开始接受消息*/
    //开启扫描信息定时器
    if (EX_timerUpdateMessage)[EX_timerUpdateMessage setFireDate:[NSDate distantPast]];
    else   EX_timerUpdateMessage = [NSTimer scheduledTimerWithTimeInterval:3.0 target:[[UIApplication sharedApplication] delegate] selector:@selector(timerFired:) userInfo:nil repeats:YES];
}

-(void)timerFired:(id)sender{
}

@end
