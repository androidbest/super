//
//  NoticeDetailView.h
//  zwy
//
//  Created by wangshuang on 10/15/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseView.h"
#import "NoticeView.h"
@interface NoticeDetailView : BaseView
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic)  NoticeView *data;
@property (strong, nonatomic)  UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UITextView *content;
@property (strong, nonatomic)  UILabel *time;
@end
