//
//  OptionChatPeopleView.h
//  zwy
//
//  Created by cqsxit on 13-12-25.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "BaseView.h"

@interface OptionChatPeopleView : BaseView
@property (strong, nonatomic) UISearchBar *searchBar;
@property(nonatomic, strong) UISearchDisplayController *displayController;
@property (strong, nonatomic) IBOutlet UITableView *tableViewPeople;
@property (strong ,nonatomic)NSArray *arrReqeatePeoples;
@property (assign ,nonatomic)BOOL ismodeAnimation;
@property (assign ,nonatomic)id OptionChatPeopleDelegate;
- (void)MessageViewToChatMessageView:(NSArray *)peoples;
@end
