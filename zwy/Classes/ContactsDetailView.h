//
//  ContactsDetailView.h
//  zwy
//
//  Created by wangshuang on 12/17/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseView.h"
#import "PeopelInfo.h"
@interface ContactsDetailView : BaseView
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UILabel *msisdn;
@property (strong, nonatomic) IBOutlet UILabel *department;
@property (strong, nonatomic) IBOutlet UILabel *job;
@property (strong, nonatomic) IBOutlet UIButton *sumbitBtn;
@property (strong, nonatomic) IBOutlet UIButton *call;
@property (strong, nonatomic) IBOutlet UIButton *sms;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) PeopelInfo *data;

@end
