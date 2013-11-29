//
//  SmsView.h
//  zwy
//
//  Created by wangshuang on 10/12/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseView.h"

@interface SmsView : BaseView
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UIButton *btnECCode;
@property (weak, nonatomic) IBOutlet UITextView *textSMSContent;
@property (weak, nonatomic) IBOutlet UITableView *tableViewPeople;
@property (weak, nonatomic) IBOutlet UIButton *btnAddPeople;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (strong, nonatomic) IBOutlet UILabel *zishu;
@property (strong, nonatomic) IBOutlet UIButton *templates;
- (void)dissmissFromHomeView;
@end
