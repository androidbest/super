//
//  CallTelView.h
//  zwyAddress
//
//  Created by cqsxit on 13-10-10.
//  Copyright (c) 2013年 cqsxit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
@interface CallTelView : BaseView
@property (weak, nonatomic) IBOutlet UIButton *btNumber0;
@property (weak, nonatomic) IBOutlet UIButton *btNumber1;
@property (weak, nonatomic) IBOutlet UIButton *btNumber2;
@property (weak, nonatomic) IBOutlet UIButton *btNumber3;
@property (weak, nonatomic) IBOutlet UIButton *btNumber4;
@property (weak, nonatomic) IBOutlet UIButton *btNumber5;
@property (weak, nonatomic) IBOutlet UIButton *btNumber6;
@property (weak, nonatomic) IBOutlet UIButton *btNumber7;
@property (weak, nonatomic) IBOutlet UIButton *btNumber8;
@property (weak, nonatomic) IBOutlet UIButton *btNumber9;
@property (weak, nonatomic) IBOutlet UIButton *btNumber100;
@property (weak, nonatomic) IBOutlet UIButton *btNumber1000;
@property (weak, nonatomic) IBOutlet UIButton *btnHidden;
@property (weak, nonatomic) IBOutlet UIButton *btncancel;
@property (weak, nonatomic) IBOutlet UIView *keyboradView;
@property (weak, nonatomic) IBOutlet UITableView *tableViewPeople;

@property (weak, nonatomic) IBOutlet UILabel *labelCall;

@end
