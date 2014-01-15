//
//  MailAddressView.h
//  zwy
//
//  Created by cqsxit on 13-10-22.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseView.h"
#import "PullRefreshTableView.h"
#import "PeopleDedaInfo.h"
#import "PeopelInfo.h"
@interface MailAddressView : BaseView
@property (strong, nonatomic) IBOutlet UISearchBar *serchBar;
@property (strong, nonatomic) IBOutlet UIButton *btnAffirm;
@property (strong, nonatomic) UITableView *tableViewPeople;
@property (assign ,nonatomic)id MailAddressDelegate;
- (void)returnDidAddress:( PeopelInfo*)deta;
@end
