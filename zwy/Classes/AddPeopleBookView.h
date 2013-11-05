//
//  AddPeopleBookView.h
//  zwy
//
//  Created by cqsxit on 13-11-5.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseView.h"
#import "MyAddressView.h"
@interface AddPeopleBookView : BaseView
@property (strong, nonatomic) IBOutlet UITextField *textName;
@property (strong, nonatomic) IBOutlet UITextField *textTel;
@property (strong, nonatomic) IBOutlet UIButton *btnSave;
@property (strong ,nonatomic) MyAddressView * addressView;
@end
