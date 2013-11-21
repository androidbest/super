//
//  AppDelegate.m
//  zwy
//
//  Created by sxit on 9/24/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "AppDelegate.h"
#import "ConfigFile.h"
#import "Constants.h"
#import "ToolUtils.h"
@implementation AppDelegate{
UIBackgroundTaskIdentifier backgroundTask;//写成成员

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //初始化配置文件
    self.window.backgroundColor=[UIColor whiteColor];
    [[ConfigFile newInstance] initData];
    [[ConfigFile newInstance] paths];
    NSUserDefaults *appConfig=[NSUserDefaults standardUserDefaults];
    if([appConfig boolForKey:@"isLogin"]){
        user=[Tuser new];
        user.msisdn=[appConfig stringForKey:@"msisdn"];
        user.eccode=[appConfig stringForKey:@"eccode"];
        user.ecname=[appConfig stringForKey:@"ecname"];
        user.username= [appConfig stringForKey:@"username"];
    }
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:@"3905012986"];
    [WXApi registerApp:@"wx22ca181d6fb789e2"];
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if([sourceApplication isEqualToString:@"com.tencent.xin"]){
    return [WXApi handleOpenURL:url delegate:self];
    }else if([sourceApplication isEqualToString:@"com.sina.weibo"]){
    return [WeiboSDK handleOpenURL:url delegate:self];
    }else{
        return YES;
    }
}
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    if ([request isKindOfClass:WBProvideMessageForWeiboRequest.class])
    {
        ProvideMessageForWeiboViewController *controller = [[ProvideMessageForWeiboViewController alloc] init];
        [self.viewController presentViewController:controller animated:YES completion:nil];
    }
}

//微信返回
-(void) onResp:(BaseResp*)resp
{
    
   
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        if(resp.errCode==0){
         [ToolUtils alertInfo:@"分享成功"];
        }
        
//        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
//        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
    }
}

//微博返回
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        
        if(response.statusCode==0){
        [ToolUtils alertInfo:@"分享成功"];
        }
        
        
//        NSString *title = @"发送结果";
//        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",
//                             response.statusCode, response.userInfo, response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
//        NSString *title = @"认证结果";
//        NSString *message = [NSString stringWithFormat:@"响应状态: %d\nresponse.userId: %@\nresponse.accessToken: %@\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",
//                             response.statusCode, [(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken], response.userInfo, response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        
//        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
//        
//        [alert show];
    }
}


							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0))
    {
        // Acquired additional time
        UIDevice *device = [UIDevice currentDevice];
        BOOL backgroundSupported = NO;
        if ([device respondsToSelector:@selector(isMultitaskingSupported)])
        {
            backgroundSupported = device.multitaskingSupported;
        }
        if (backgroundSupported)
        {
            backgroundTask = [application beginBackgroundTaskWithExpirationHandler:^{
                [application endBackgroundTask:backgroundTask];
                backgroundTask = UIBackgroundTaskInvalid;
            }];
        }
    }

    
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification/*本地通知响应方法*/
{
    NSString * strTitle =[notification.userInfo objectForKey:@"AlarmKey"];
    if (application.applicationState == UIApplicationStateActive) {
        // 如不加上面的判断，点击通知启动应用后会重复提示
        // 这里暂时用简单的提示框代替。
        // 也可以做复杂一些，播放想要的铃声。
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"日程提醒"
                                                         message:strTitle
                                                        delegate:self
                                               cancelButtonTitle:@"关闭"
                                               otherButtonTitles:nil, nil];
        [alert show];
    }
    [AppDelegate deleteLocalNotification:strTitle];
}

/*
删除本地通知
*/
+(void)deleteLocalNotification:(NSString*)alarmKey
{
    NSArray*allLocalNotification=[[UIApplication sharedApplication]scheduledLocalNotifications];
     for(UILocalNotification*localNotification in allLocalNotification){
        NSString*alarmValue=[localNotification.userInfo objectForKey:@"AlarmKey"];
        if([alarmKey isEqualToString:alarmValue]){
            [[UIApplication sharedApplication]cancelLocalNotification:localNotification];
        }
        }
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
   UILocalNotification*notification=[[UILocalNotification alloc]init];
    if(notification!=nil){
        notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:10];;//开始时间
        notification.timeZone=[NSTimeZone defaultTimeZone];// 设置时区
        notification.soundName=UILocalNotificationDefaultSoundName;//播放音乐类型
        notification.alertBody=@"测试";//提示的消息
        notification.alertLaunchImage = @"lunch.png";// 这里可以设置从通知启动的启动界面，类似Default.png的作用。
        notification.soundName=@"ping.caf";
        notification.alertAction = @"打开"; //提示框按钮
        
        notification.hasAction=NO;//是否显示额外的按钮
        notification.userInfo=[[NSDictionary alloc]initWithObjectsAndKeys:@"测试",@"AlarmKey",nil];//notification信息
        [[UIApplication sharedApplication]scheduleLocalNotification:notification];
        }

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end
