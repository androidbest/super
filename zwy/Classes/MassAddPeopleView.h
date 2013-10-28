//
//  MassAddPeopleView.h
//  zwy
//
//  Created by cqsxit on 13-10-23.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseView.h"

@interface MassAddPeopleView : BaseView
@property (strong, nonatomic) IBOutlet UITextField *textTel;
@property (strong, nonatomic) IBOutlet UIButton *btnAffirm;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (assign ,nonatomic)id MassAddPeopleDelegate;
- (void)returnDidAddress:(NSArray *)arr;
@end
