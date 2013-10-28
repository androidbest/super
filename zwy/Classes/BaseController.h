//
//  BaseController.h
//  zwy
//
//  Created by sxit on 9/26/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>
#import "ControllerProtocol.h"
#import "MBProgressHUD.h"
#import "PackageData.h"
#import "AnalysisData.h"
#import "HTTPRequest.h"
#import "ToolUtils.h"
#import "Constants.h"
#import "ConfigFile.h"
@interface BaseController : NSObject <ControllerProtocol>
@property(strong,nonatomic)MBProgressHUD * HUD;

-(BOOL)judgeNetwork;
-(void)initBackBarButtonItem:(id)view;
@end
