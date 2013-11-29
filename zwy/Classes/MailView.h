//
//  MailView.h
//  zwy
//
//  Created by wangshuang on 10/12/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseView.h"
#import "PublicMailDetaInfo.h"
@interface MailView : BaseView
@property (strong, nonatomic) IBOutlet UISegmentedControl *selecter;
@property(strong,nonatomic)PublicMailDetaInfo *info;

- (void)dissmissFromHomeView;

@end
