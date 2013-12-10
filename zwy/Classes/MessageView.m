//
//  MessageView.m
//  zwy
//
//  Created by wangshuang on 12/10/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "MessageView.h"
#import "MessageController.h"
@interface MessageView ()

@end

@implementation MessageView

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
        self.tabBarItem=[self.tabBarItem initWithTitle:@"消息" image:[UIImage imageNamed:@"home_out"] selectedImage:[UIImage imageNamed:@"home_over"]];
        MessageController *contacts=[MessageController new];
        contacts.messageView=self;
        self.controller=contacts;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//	_tableview.dataSource=self.controller;
//    _tableview.delegate=self.controller;
    
    UISearchDisplayController *searchController = [[UISearchDisplayController alloc]
                        initWithSearchBar:_searchBar contentsController:self];
    searchController.delegate = self;
    searchController.searchResultsDataSource = self;
    searchController.searchResultsDelegate = self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    if (tableView == self.tableView) {
//        return ...;
//    }
    // If necessary (if self is the data source for other table views),
    // check whether tableView is searchController.searchResultsTableView.
    return 5;
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.navigationItem.title=@"最近消息";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
