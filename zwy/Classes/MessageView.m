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
//        self.tabBarItem=[self.tabBarItem initWithTitle:@"消息" image:[UIImage imageNamed:@"im_message"] selectedImage:[UIImage imageNamed:@"home_over"]];
        MessageController *contacts=[MessageController new];
        contacts.messageView=self;
        self.controller=contacts;
        
        
//        NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"7.0" options: NSNumericSearch];
//        if (order == NSOrderedSame || order == NSOrderedDescending)
//        {
//            // OS version >= 7.0
//            self.edgesForExtendedLayout = UIRectEdgeNone;
//        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.tabBarController.navigationItem.leftBarButtonItem =self.temporaryBarButtonItem;
    self.navigationController.navigationBarHidden=NO;
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    _searchBar.placeholder = @"搜索";
    _searchBar.delegate = self.controller;
    [_searchBar sizeToFit];
    
    _uitableview.dataSource = self.controller;
    _uitableview.delegate = self.controller;
    _uitableview.tableHeaderView = self.searchBar;
    _uitableview.contentOffset = CGPointMake(0, CGRectGetHeight(_searchBar.bounds));
    _uitableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    _displayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self.tabBarController];
    self.searchDisplayController.searchResultsDataSource = self.controller;
    self.searchDisplayController.searchResultsDelegate = self.controller;
    self.searchDisplayController.delegate = self.controller;
    
//    [self setMySearchDisplayController:_displayController];
    
   
    
}





-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.navigationItem.title=@"最近消息";
}

//- (void)backButtonToHome{
//    if (!self.navigationController.navigationBarHidden)self.navigationController.navigationBarHidden=YES;
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    //    self.filteredPersons = self.famousPersons;
//    self.navigationController.navigationBarHidden=YES;
//    self.navigationController.navigationBar.hidden=YES;
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    self.tableView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//    [self.navigationController.view addSubview:self.tableView];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.2];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    CGRect frame = self.navigationBar.frame;
//    int customNavH = frame.size.height;
//    if(hide)
//    {
//        [self.tableView setFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height - customNavH)];
//        frame.origin.y = 0;
//        [self.navigationBar setFrame:frame];
//    }else
//    {
//        [self.tableView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 460)];
//        frame.origin.y = -frame.size.height;
//        [self.navigationBar setFrame:frame];
//    }
//    [UIView commitAnimations];
    
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    //    self.filteredPersons = nil;
//    self.navigationController.navigationBar.hidden=YES;
//     self.tableView.frame=CGRectMake(0, topLayout, ScreenWidth, ScreenHeight-topLayout-UITabBarHeight);
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    //    self.filteredPersons = [self.filteredPersons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchString]];
    
    return YES;
}
@end
