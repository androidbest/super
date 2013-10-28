//
//  AddressDetailsView.h
//  zwyAddress
//
//  Created by cqsxit on 13-10-10.
//  Copyright (c) 2013年 cqsxit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
@interface AddressDetailsView : BaseView

@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UITextField *textTel;

@property(strong ,nonatomic)NSDictionary * dicAddressData;
@property (weak, nonatomic) IBOutlet UIButton *btnSendSMS;
@property (weak, nonatomic) IBOutlet UIButton *btnCallTel;

/*更改信息后刷新本地通讯录列表*/
@property (assign,nonatomic)id pushAddressBook;
- (void)updateAddressBook;
@end
