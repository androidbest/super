//
//  InfoDetailsView.h
//  zwyAddress
//
//  Created by cqsxit on 13-10-10.
//  Copyright (c) 2013年 cqsxit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeopelInfo.h"
#import "BaseView.h"
@interface InfoDetailsView : BaseView
@property (strong ,nonatomic)PeopelInfo *infoDeta;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelTel;
@property (weak, nonatomic) IBOutlet UILabel *labelGroup;
@property (weak, nonatomic) IBOutlet UILabel *labelJob;
@property (weak, nonatomic) IBOutlet UIButton *btnSendSMS;
@property (weak, nonatomic) IBOutlet UIButton *btnCall;
@end
