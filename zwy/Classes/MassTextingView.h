//
//  MassTextingView.h
//  zwy
//
//  Created by cqsxit on 13-10-21.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseView.h"
#import "GreetDetaInfo.h"
@interface MassTextingView : BaseView
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *BtnGroupAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnMyAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnSelfAdd;
@property (weak, nonatomic) IBOutlet UIButton *btnClear;
@property (weak, nonatomic) IBOutlet UITextView *textSendContext;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (strong, nonatomic) IBOutlet UIButton *btnSign;
@property (strong, nonatomic) IBOutlet UITextField *textsign;
@property (strong, nonatomic) IBOutlet UIButton *btnSMSMode;
@property (weak, nonatomic) IBOutlet UITableView *tableViewPeople;
@property (strong, nonatomic) IBOutlet UILabel *labelTextMaxLengh;
@property (strong, nonatomic) IBOutlet UIImageView *navigationBarImage;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigtionBarMass;
@property (assign ,nonatomic)BOOL isSchedule;
@property (strong ,nonatomic) GreetDetaInfo *detaInfo;
@property (strong ,nonatomic) NSString *strFromGeetingName;
@property (assign) id massTextDelegate;
- (void)massTextInfoFromWarningViewWithGreetingID:(GreetDetaInfo *)GreetInfo;
@end
