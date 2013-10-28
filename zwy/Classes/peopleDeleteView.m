//
//  peopleDeleteView.m
//  zwy
//
//  Created by cqsxit on 13-10-24.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "peopleDeleteView.h"
#import "peopleDeleteController.h"
@interface peopleDeleteView ()

@end

@implementation peopleDeleteView

- (id)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if (self) {
        peopleDeleteController *Contro =[peopleDeleteController new];
        Contro.peopleView =self;
        self.controller=Contro;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.controller initWithData];
    _tableViewAllIfo.dataSource=self.controller;
    _tableViewAllIfo.delegate=self.controller;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, 13.0, 20.0);
    [backButton setImage:[UIImage imageNamed:@"navigation_back_over"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navigation_back_out"] forState:UIControlStateHighlighted];
    [backButton addTarget:self.controller action:@selector(LeftDown) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    temporaryBarButtonItem.style = UIBarButtonItemStylePlain;
    self.navigationItem.leftBarButtonItem=temporaryBarButtonItem;
	// Do any additional setup after loading the view.
}

- (void)LeftDown{

}

- (void)returnPeoPleEditInfo:(NSMutableArray *)array{

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
