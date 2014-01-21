//
//  InformationDetail.h
//  zwy
//
//  Created by wangshuang on 10/16/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseView.h"
#import "InformationInfo.h"
#import "InformationView.h"
@interface InformationDetail : BaseView
@property (strong, nonatomic) UITextView *textView;
@property (strong ,nonatomic) UIScrollView *scrollView;
@property (strong ,nonatomic) CALayer *layerTitleBackView;
@property (strong ,nonatomic) UILabel *labelTitle;
@property (strong ,nonatomic) UIImageView *imageContentView;
@property (strong ,nonatomic) UILabel *labelContent;
@property (strong ,nonatomic) UILabel *labelSource;
@property (strong ,nonatomic) UILabel *labelTime;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) IBOutlet UIButton *btnCommend;
@property (strong, nonatomic) IBOutlet UIButton *btnShare;
@property (strong, nonatomic) IBOutlet UIButton *btnComment;
@property (strong, nonatomic) IBOutlet UIButton *btnNextNews;
@property (strong, nonatomic) UILabel *labelCommend;
@property (strong, nonatomic)  InformationView *data;
@end
