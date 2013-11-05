//
//  MyAddressView.m
//  zwyAddress
//
//  Created by cqsxit on 13-10-8.
//  Copyright (c) 2013年 cqsxit. All rights reserved.
//

#import "MyAddressView.h"
#import "MyAddressController.h"
#import "AddPeopleBookView.h"
@interface MyAddressView ()

@end

@implementation MyAddressView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self=[super  initWithCoder:aDecoder];
    if (self) {
        MyAddressController *contro =[MyAddressController new];
        contro.addressView=self;
        self.controller=contro;
         self.tabBarItem=[self.tabBarItem initWithTitle:@"本地通讯录" image:[UIImage imageNamed:@"tabItem_MyArBook_out"] selectedImage:[UIImage imageNamed:@"tabItem_MyArBook_over"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableViewAddress.delegate=self.controller;
    _tableViewAddress.dataSource=self.controller;
    _indexBar.delegate=self.controller;
    
    self.navigationItem.backBarButtonItem= [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, 13.0, 20.0);
    [backButton setImage:[UIImage imageNamed:@"navigation_back_over"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navigation_back_out"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(LeftDown) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    temporaryBarButtonItem.style = UIBarButtonItemStylePlain;
    self.navigationItem.leftBarButtonItem=temporaryBarButtonItem;
    [self.controller initWithData];
    
    UIButton *  btnAddPeople =[UIButton buttonWithType:UIButtonTypeCustom];
    btnAddPeople.frame=CGRectMake(0, 0, 25, 25);
    [btnAddPeople setImage:[UIImage imageNamed:@"btn_addPeople"] forState:UIControlStateNormal];
    [btnAddPeople addTarget:self.controller action:@selector(btnAddPeople) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *temAddPeople = [[UIBarButtonItem alloc] initWithCustomView:btnAddPeople];
    temAddPeople.style = UIBarButtonItemStylePlain;
    self.navigationItem.rightBarButtonItem=temAddPeople;
	// Do any additional setup after loading the view.
}

- (void)btnAddPeople{

}

- (void)LeftDown{
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *send=segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"MyAddressToAddPeople"]) {
        AddPeopleBookView * peopelView =(AddPeopleBookView *)send;
        peopelView.addressView =self;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
