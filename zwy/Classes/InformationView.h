//
//  InformationView.h
//  zwy
//
//  Created by wangshuang on 10/12/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseView.h"
#import "InformationInfo.h"
@interface InformationView : BaseView
@property (strong, nonatomic) IBOutlet UISegmentedControl *selecter;
@property (strong, nonatomic) InformationInfo *informationInfo;

- (void)dissmissFromHomeView;
@end
