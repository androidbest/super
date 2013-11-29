//
//  HomeView.h
//  zwy
//
//  Created by sxit on 9/27/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseView.h"
#import "HomeView.h"

@interface HomeView : BaseView
@property (strong, nonatomic) IBOutlet UIButton *information;
@property (strong, nonatomic) IBOutlet UIButton *notice;
@property (strong, nonatomic) IBOutlet UIButton *sms;
@property (strong, nonatomic) IBOutlet UIButton *address;
@property (strong, nonatomic) IBOutlet UIButton *office;
@property (strong, nonatomic) IBOutlet UIButton *mail;
@property (strong, nonatomic) IBOutlet UIButton *meetting;

@property (strong, nonatomic) IBOutlet UILabel *mailsum;

@property (strong, nonatomic) IBOutlet UILabel *officesum;
@property (strong, nonatomic)  UILabel *homeTitle;
@property (strong, nonatomic)  UILabel *name;
@property (strong, nonatomic)  UILabel *ecname;

@end
