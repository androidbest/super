//
//  SMSModeDetaView.h
//  zwy
//
//  Created by cqsxit on 13-10-24.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseView.h"
#import "SmsSonDetaInto.h"
@interface SMSModeDetaView : BaseView
@property (strong ,nonatomic)SmsSonDetaInto * info;
@property (assign ,nonatomic) id SMSModeDetaViewDelegate;
@property (strong, nonatomic) IBOutlet UINavigationBar *naviBar;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) IBOutlet UITableView *tableViewModeInfo;
- (void)returnSMSModeDetaInfo:(NSString *)SMSContent;
@end
