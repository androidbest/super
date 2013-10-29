//
//  AccessoryController.h
//  zwy
//
//  Created by cqsxit on 13-10-19.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseController.h"
#import "AccessoryView.h"
#import "DownloadCell.h"
@interface AccessoryController : BaseController<DownloadCellDelegate>
@property (strong ,nonatomic)AccessoryView * accView;
@property (strong ,nonatomic)NSMutableArray *arrDowning;
@property (strong ,nonatomic)NSMutableArray *arrEnddown;
@end
