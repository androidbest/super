//
//  AppDelegate.h
//  zwy
//
//  Created by sxit on 9/24/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "SendMessageToWeiboViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,WeiboSDKDelegate>{
   
}

@property (strong, nonatomic) NSString *wbtoken;

@property (strong, nonatomic) SendMessageToWeiboViewController *viewController;
@property (strong, nonatomic) UIWindow *window;
@end
