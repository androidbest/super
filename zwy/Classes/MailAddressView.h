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
@interface MailAddressView : BaseView
@property (strong, nonatomic) IBOutlet UISearchBar *serchBar;
@property (strong, nonatomic) IBOutlet UIButton *btnAffirm;
@property (strong, nonatomic) PullRefreshTableView *tableViewPeople;
@property (assign ,nonatomic)id MailAddressDelegate;
- (void)returnDidAddress:(PeopleDedaInfo *)deta;
@end
