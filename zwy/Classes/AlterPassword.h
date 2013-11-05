//
//  AlterPassword.h
//  zwy
//
//  Created by cqsxit on 13-11-5.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseView.h"

@interface AlterPassword : BaseView
@property (strong, nonatomic) IBOutlet UIButton *btnOK;
@property (strong, nonatomic) IBOutlet UITextField *textBeforePw;
@property (strong, nonatomic) IBOutlet UITextField *textNewPw;
@property (strong, nonatomic) IBOutlet UITextField *textLastPw;

@end
