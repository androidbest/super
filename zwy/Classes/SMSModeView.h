//
//  SMSModeView.h
//  zwy
//
//  Created by cqsxit on 13-10-24.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseView.h"

@interface SMSModeView : BaseView
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) IBOutlet UITableView *tableViewSMSMode;
@property (assign,  nonatomic)id SMSModeViewDelegate;
- (void)returnSMSModeInfo:(NSString *)SMSContent;
@end
