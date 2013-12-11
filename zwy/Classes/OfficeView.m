//
//  OfficeView.m
//  zwy
//
//  Created by wangshuang on 10/12/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "OfficeView.h"
#import "OfficeController.h"
@interface OfficeView ()

@end

@implementation OfficeView

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
        OfficeController *office=[OfficeController new];
        office.officeView=self;
        self.controller=office;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
         self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItem=self.temporaryBarButtonItem;
    
    [_selecter addTarget:self.controller action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.listview =[[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, topLayout+NavigationBarHeight, ScreenWidth,ScreenHeight-topLayout-NavigationBarHeight) withDelegate:self.controller];
    self.listview.backgroundColor=[UIColor whiteColor];
    //    [self.listview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.listview.tag=0;
    self.listview.separatorStyle = NO;
    [self.view addSubview:self.listview];
    [self.listview LoadDataBegin];/*刷新数据*/
    
    
    self.listview1 =[[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, topLayout+NavigationBarHeight, ScreenWidth,ScreenHeight-topLayout-NavigationBarHeight) withDelegate:self.controller];
    self.listview1.backgroundColor=[UIColor whiteColor];
    //    [self.listview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.listview1.tag=1;
    self.listview1.separatorStyle = NO;
    [self.view addSubview:self.listview1];
    self.listview1.hidden=YES;
    
    
    self.listview2 =[[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, topLayout+NavigationBarHeight, ScreenWidth,ScreenHeight-topLayout-NavigationBarHeight) withDelegate:self.controller];
    self.listview2.backgroundColor=[UIColor whiteColor];
    //    [self.listview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.listview2.tag=2;
    self.listview2.separatorStyle = NO;
    [self.view addSubview:self.listview2];
    self.listview2.hidden=YES;
    
    self.listview3 =[[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, topLayout+NavigationBarHeight, ScreenWidth,ScreenHeight-topLayout-NavigationBarHeight) withDelegate:self.controller];
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
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBarHidden)self.navigationController.navigationBarHidden=NO;
}

-(void)segmentAction:(UISegmentedControl *)Seg{}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dissmissFromHomeView{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
