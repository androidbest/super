//
//  SMSModeController.h
//  zwy
//
//  Created by cqsxit on 13-10-24.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseController.h"
#import "SMSModeView.h"
@interface SMSModeController : BaseController
@property (strong ,nonatomic)SMSModeView * smsView;
@property (strong ,nonatomic)NSMutableArray * arrAllModeInfo;
@property (nonatomic,strong)NSIndexPath *selectIndex;
@property (assign)BOOL isOpen;
-(void)initReqData;
@end
