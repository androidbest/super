//
//  OfficeDetailView.h
//  zwy
//
//  Created by wangshuang on 10/17/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseView.h"
#import "OfficeView.h"
#import "DocContentInfo.h"
#import "DaiBanView.h"
@interface OfficeDetailView : BaseView
@property (strong, nonatomic)  BaseView *data;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UIButton *docText;
@property (strong, nonatomic) IBOutlet UIButton *accessory;
@property (strong, nonatomic) IBOutlet UIButton *docFlow;
@property (strong, nonatomic) IBOutlet UIButton *selectHandle;
@property (strong, nonatomic) IBOutlet UITextView *content;
@property (strong, nonatomic) IBOutlet UIButton *addPerson;

@property (strong, nonatomic) IBOutlet UIButton *selecter;
@property (strong, nonatomic) IBOutlet UILabel *agreelabel;
@property (strong, nonatomic)  DocContentInfo *info;
@property (strong, nonatomic) IBOutlet UIButton *noagree;
@property (strong, nonatomic)  UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UIButton *agree;
@property (strong, nonatomic) IBOutlet UILabel *noargreelable;
@property (strong, nonatomic)  UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *nextstep;
@property (strong, nonatomic) IBOutlet UILabel *banli;
@property (strong, nonatomic) IBOutlet UILabel *banliLine;
@property (strong, nonatomic) IBOutlet UILabel *lable1;
@property (strong, nonatomic) IBOutlet UITextView *textContent;
@property (strong, nonatomic) IBOutlet UILabel *lable2;
@property (strong, nonatomic)  UILabel *sender;
@property (strong, nonatomic) IBOutlet UIButton *okbtn;
@property (strong, nonatomic)  DocContentInfo *detailInfo;
@end
