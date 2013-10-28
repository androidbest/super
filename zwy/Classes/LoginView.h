//
//  LoginView.h
//  zwy
//
//  Created by sxit on 9/26/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseView.h"
#import "CustomPageControl.h"
@interface LoginView : BaseView
@property(strong,nonatomic)UIScrollView * scrollView;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UITextField *msisdn;
@property (strong, nonatomic) IBOutlet UIView *statusbar;
@property (strong, nonatomic) IBOutlet UIButton *verifyBtn;
@property (strong, nonatomic) IBOutlet UITextField *verifyField;
@property(strong,nonatomic)CustomPageControl *pageControl;
@end
