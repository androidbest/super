//
//  DocFlowCell.h
//  zwy
//
//  Created by wangshuang on 10/18/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DocFlowCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *handler;
@property (strong, nonatomic) IBOutlet UILabel *handletime;
@property (strong, nonatomic) IBOutlet UILabel *hanldeStep;
@property (strong, nonatomic) IBOutlet UILabel *auditStatus;
@property (strong, nonatomic) IBOutlet UILabel *num;
@property (strong, nonatomic) IBOutlet UILabel *labelHeaher;
@property (strong, nonatomic) IBOutlet UILabel *content;
@property (strong, nonatomic) IBOutlet UILabel *topLabel;
@end
