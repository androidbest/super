//
//  DaiBanView.m
//  zwy
//
//  Created by sxit on 9/27/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "DaiBanView.h"
#import "DaibanController.h"
@interface DaiBanView ()

@end

@implementation DaiBanView

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
        self.tabBarItem=[self.tabBarItem initWithTitle:@"待办事宜" image:[UIImage imageNamed:@"daiban_out"] selectedImage:[UIImage imageNamed:@"daiban_over"]];
        
        DaibanController *home=[DaibanController new];
        home.daibanView=self;
        self.controller=home;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[_selecter addTarget:self.controller action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.listview =[[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, topLayout+NavigationBarHeight, ScreenWidth,ScreenHeight-topLayout-NavigationBarHeight-49) withDelegate:self.controller];
    self.listview.backgroundColor=[UIColor whiteColor];
    //    [self.listview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.listview.tag=0;
    self.listview.separatorStyle = NO;
    [self.view addSubview:self.listview];
    [self.listview LoadDataBegin];/*刷新数据*/
    
    
    self.listview1 =[[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, topLayout+NavigationBarHeight, ScreenWidth,ScreenHeight-topLayout-NavigationBarHeight-49) withDelegate:self.controller];
    self.listview1.backgroundColor=[UIColor whiteColor];
    //    [self.listview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.listview1.tag=1;
    self.listview1.separatorStyle = NO;
    [self.view addSubview:self.listview1];
    self.listview1.hidden=YES;
    
    
    self.listview2 =[[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, topLayout+NavigationBarHeight, ScreenWidth,ScreenHeight-topLayout-NavigationBarHeight-49) withDelegate:self.controller];
    self.listview2.backgroundColor=[UIColor whiteColor];
    //    [self.listview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.listview2.tag=2;
    self.listview2.separatorStyle = NO;
    [self.view addSubview:self.listview2];
    self.listview2.hidden=YES;
    
    self.listview3 =[[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, topLayout+NavigationBarHeight, ScreenWidth,ScreenHeight-topLayout-NavigationBarHeight-49) withDelegate:self.controller];
    self.listview3.backgroundColor=[UIColor whiteColor];
    //    [self.listview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.listview3.tag=3;
    self.listview3.separatorStyle = NO;
    [self.view addSubview:self.listview3];
    self.listview3.hidden=YES;

    
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *send=segue.destinationViewController;
    [send setValue:self forKey:@"data"];
    send.tabBarController.tabBar.hidden=YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=NO;
    if (!isZaiXian) {
        [self.controller initWithData];
        isZaiXian=YES;
    }
}

-(void)segmentAction:(UISegmentedControl *)Seg{}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
