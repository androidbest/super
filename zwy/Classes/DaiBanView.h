//
//  DaiBanView.h
//  zwy
//
//  Created by sxit on 9/27/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseView.h"
#import "DocContentInfo.h"
#import "PublicMailDetaInfo.h"
@interface DaiBanView : BaseView
@property (strong, nonatomic) IBOutlet UISegmentedControl *selecter;
@property (strong, nonatomic) DocContentInfo *docContentInfo;
@property(strong,nonatomic)PublicMailDetaInfo *pubilcMailDetaInfo;
@end
