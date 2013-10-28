//
//  OfficFlowView.h
//  zwy
//
//  Created by wangshuang on 10/18/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseView.h"
#import "DocContentInfo.h"
@interface OfficFlowView : BaseView
@property (strong, nonatomic) IBOutlet UITableView *flowList;
@property (strong, nonatomic)  DocContentInfo *data;
@end
