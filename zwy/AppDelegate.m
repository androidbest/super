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
#import "WXApi.h"
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
    
    
//    [WXApi registerApp:@"wx22ca181d6fb789e2"];
    return YES;
}

//-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//    return [WXApi handleOpenURL:url delegate:self];
//}
//
//-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
//    return [WXApi handleOpenURL:url delegate:self];
//}


							
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

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end
