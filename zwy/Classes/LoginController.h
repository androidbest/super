//
//  LoginController.h
//  zwy
//
//  Created by sxit on 9/26/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "BaseController.h"
#import "LoginView.h"
@interface LoginController : BaseController
@property (strong ,nonatomic)LoginView * logView;
@property (strong ,nonatomic)NSTimer * nsTime;
-(void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)dismissLeadView:(id)sender;
- (void)login;
-(void)stopTimer;
-(void)alertnetwork;
@end
