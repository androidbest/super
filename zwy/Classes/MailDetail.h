//
//  MailDetail.h
//  zwy
//
//  Created by wangshuang on 10/15/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseView.h"
#import "PublicMailDetaInfo.h"
#import "MailView.h"
#import "DaiBanView.h"
@interface MailDetail : BaseView
@property (strong, nonatomic) IBOutlet UITextView *content;
@property (strong, nonatomic) IBOutlet UITextField *selecter;
@property (strong, nonatomic) IBOutlet UITextView *inputContent;
@property (strong, nonatomic) IBOutlet UIButton *selecthandle;
@property (strong, nonatomic) IBOutlet UINavigationBar *secondMenu;
@property (strong, nonatomic) IBOutlet UIButton *brnOptionPeople;
@property (strong, nonatomic)  BaseView *data;
@property (strong, nonatomic)  UILabel *phoneLab;
@property (strong, nonatomic)  UILabel *time;
@property (strong, nonatomic) IBOutlet UIButton *okbtn;
@property (strong, nonatomic) PublicMailDetaInfo *info;
@property (assign, nonatomic)id MailDelegate;
@property (strong, nonatomic) IBOutlet UILabel *contentHint;
@end
