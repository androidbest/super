//
//  EcOptionView.h
//  zwy
//
//  Created by wangshuang on 10/18/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseView.h"

@interface EcOptionView : BaseView
@property (strong, nonatomic) IBOutlet UITableView *EcList;
@property (strong, nonatomic) IBOutlet UIButton *ok;
@property (strong, nonatomic) IBOutlet UIView *statusBar;

@end
