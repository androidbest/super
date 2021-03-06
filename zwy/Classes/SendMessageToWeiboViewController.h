//
//  SendMessageToWeiboViewController.h
//  WeiboSDKDemo
//
//  Created by Wade Cheng on 3/29/13.
//  Copyright (c) 2013 SINA iOS Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProvideMessageForWeiboViewController.h"
#import "WeiboSDK.h"

@interface SendMessageToWeiboViewController : ProvideMessageForWeiboViewController<UIAlertViewDelegate,WeiboSDKJSONDelegate>
- (void)shareButtonPressed;
@end
