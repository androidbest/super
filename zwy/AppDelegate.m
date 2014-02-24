//
//  AppDelegate.m
//  zwy
//
//  Created by sxit on 9/24/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#define NOTIFICATIONMESSAGE @"notificationMessage"

//#define DoorsBgTaskBegin() { \
//UIApplication *app = [UIApplication sharedApplication]; \
//UIBackgroundTaskIdentifier task = [app beginBackgroundTaskWithExpirationHandler:^{ \
//[app endBackgroundTask:task]; \
///* task = UIBackgroundTaskInvalid; */ \
//}]; \
//dispatch_block_t block = ^{ \
//
//#define DoorsBgTaskEnd() \
//[app endBackgroundTask:task]; \
///* task = UIBackgroundTaskInvalid; */ \
//}; \
//dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block); \
//}
const int kTimerInterval = 1 * 3;              // 3秒，定时器时间间隔
const int kSysMaxTimePerBgTask = 10 * 600;      // 10分钟，系统为每个后台任务分配的最大时间

#import "AppDelegate.h"
#import "ConfigFile.h"
#import "Constants.h"
#import "ToolUtils.h"
#import "SqlLiteHelper.h"
#import "PackageData.h"
#import "CoreDataManageContext.h"
#import "AnalysisData.h"

@implementation AppDelegate{
UIBackgroundTaskIdentifier backgroundTask;//写成成员

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //注册接收即时聊天的通知
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(notificationImRevice:)
                                                name:NOTIFICATIONMESSAGE
                                              object:self];
//    if(application.enabledRemoteNotificationTypes){
//        NSLog(@"aaadfdsafdsafdasf");
//    }
    
    //判断是否由远程消息通知触发应用程序启动
//    if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]!=nil) {
//        NSLog(@"aaaa");
////        //获取应用程序消息通知标记数（即小红圈中的数字）
////        int badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
////        if (badge>0) {
////            //如果应用程序消息通知标记数（即小红圈中的数字）大于0，清除标记。
////            badge--;
////            //清除标记。清除小红圈中数字，小红圈中数字为0，小红圈才会消除。
////            [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
////        }
//    }
    
   [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    
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
        user.headurl=[appConfig stringForKey:@"headurl"];
        user.job=[appConfig stringForKey:@"job"];
        user.userid=[appConfig stringForKey:@"userid"];
        user.province =[appConfig stringForKey:@"userprovince"];
        user.ecsystem =[appConfig stringForKey:@"ecSystem"];
    }
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:@"3905012986"];
    [WXApi registerApp:@"wx22ca181d6fb789e2"];
    return YES;
}


- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    NSString* oldToken = [dataModel deviceToken];
    NSString* newToken = [deviceToken description];
//    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"&lt;&gt;"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    newToken = [newToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
    newToken = [newToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    EX_newToken=newToken;
    
//    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    NSLog(@"%@", newToken); 
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@", error);
}

//处理收到的消息推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
//    [application cancelLocalNotification:notification];
    //在此处理接收到的消息。
    NSLog(@"Receive remote notification : %@",userInfo);
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

//新浪微博返回
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
    //发送后台通知（激活APNS）
    [packageData iosProcessKill:self];
    //关闭网络指示灯
    //if ([UIApplication sharedApplication ].networkActivityIndicatorVisible)
    //    [UIApplication sharedApplication ].networkActivityIndicatorVisible=NO;
/*
     int i = kSysMaxTimePerBgTask;
    while (i > 0)
    {
        DoorsBgTaskBegin();
        [NSThread sleepForTimeInterval:kTimerInterval];
        if ([EX_timerUpdateMessage isValid])[self timerFired:nil];
        DoorsBgTaskEnd();
        i--;
    }
*/
}


//日程提醒本地通知
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification/*本地通知响应方法*/
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSString * strTitle =[notification.userInfo objectForKey:@"content"];
    dicLocalNotificationInfo=notification.userInfo;
    if (application.applicationState == UIApplicationStateActive) {
        // 如不加上面的判断，点击通知启动应用后会重复提示
        // 这里暂时用简单的提示框代替。
        // 也可以做复杂一些，播放想要的铃声。
        if (strTitle) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"日程提醒"
                                                            message:strTitle
                                                           delegate:self
                                                  cancelButtonTitle:@"关闭"
                                                  otherButtonTitles:@"前往", nil];
            
            [alert show];
        }

    }else{
        
        //触发日程提醒接收本地通知页面跳转
        [[NSNotificationCenter defaultCenter] postNotificationName:@"homeToWarningView"
                                                            object:notification.userInfo
                                                          userInfo:nil];
    }
    
    /*如果通知过期就删除掉,删除通知栏的记录*/
    if ([notification.userInfo[@"RequestType"] isEqualToString:@"0"]) {
        [application cancelLocalNotification:notification];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        //触发日程提醒接收本地通知页面跳转
        [[NSNotificationCenter defaultCenter] postNotificationName:@"homeToWarningView"
                                                            object:nil
                                                          userInfo:nil];
    }else{
        dicLocalNotificationInfo=nil;
    }
}

//执行取时聊天定时器
- (void)timerFired:(id)sender{
    [packageData imRevice:self SELType:NOTIFICATIONMESSAGE];
}

/*接受消息*/
- (void)notificationImRevice:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    NSMutableArray *arrmessages =[AnalysisData imRevice:dic];
   
    if (!arrmessages||arrmessages.count==0)return;
    
    
    /*插入数据*/
    CoreDataManageContext *coredataManage =[CoreDataManageContext newInstance];
    BOOL ischek=NO;
    for (int i=0; i<arrmessages.count; i++) {
        ChatMsgObj *obj =arrmessages[i];
        
        NSString *chatMessageID =nil;
        
            if (!obj.groupid||[obj.groupid isEqualToString:@"(null)"]||[obj.groupid isEqualToString:@""]||[obj.groupid isEqualToString:@"null"]) {
                chatMessageID =[NSString stringWithFormat:@"%@%@%@%@",user.msisdn,user.eccode,obj.receivermsisdn,user.eccode];
                 ischek =[EX_chatMessageID  isEqualToString:chatMessageID];
                 [coredataManage setChatInfo:obj status:@"1" isChek:ischek  gid:nil arr:nil];
                
            }else{
                 chatMessageID =[NSString stringWithFormat:@"%@%@%@%@",user.msisdn,user.eccode,obj.groupid,user.eccode];
                 //是否在聊天界面，返回yes＝是 返回no=否
                 ischek =[EX_chatMessageID  isEqualToString:chatMessageID];
                [coredataManage setChatInfo:obj status:@"1" isChek:ischek];
            }
    }

    
    //ischek 0,增加未读提示 1.不加
    NSDictionary *dicNOtification;
    if (!ischek) dicNOtification =@{@"isCheck":@"0"};
    else dicNOtification =@{@"isCheck":@"1"};
    /*刷新数据
     *发送通告
     *观察者为"MessageController"--"ChatMessageController"--"HomeController"
     */
    //接收消息刷新数据，触发以上三个界面
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATIONCHAT object:arrmessages userInfo:dicNOtification];
    
}




- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber=0;
    
     //发送前台通知（冻结APNS)
    [packageData iosProcessRestart:self];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
