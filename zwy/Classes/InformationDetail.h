//
//  InformationDetail.h
//  zwy
//
//  Created by wangshuang on 10/16/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseView.h"
#import "InformationInfo.h"
#import "InformationView.h"
@interface InformationDetail : BaseView
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic)  InformationView *data;
@end
