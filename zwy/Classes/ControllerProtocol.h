//
//  ControllerProtocol.h
//  zwy
//
//  Created by sxit on 9/26/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import "MBProgressHUD.h"
#import "AIMTableViewIndexBar.h"
#import "MBProgressHUD.h"
#import "SGFocusImageFrame.h"
@protocol ControllerProtocol <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UISearchBarDelegate,MFMessageComposeViewControllerDelegate,AIMTableViewIndexBarDelegate,MBProgressHUDDelegate,UIWebViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,SGFocusImageFrameDelegate,UISearchDisplayDelegate>
@optional
- (void)initWithData;
//初始化进度条
-(void)initData:(id)base;
-(void)updateAddressBook;
@end
