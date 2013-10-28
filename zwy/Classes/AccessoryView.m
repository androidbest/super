//
//  AccessoryView.m
//  zwy
//
//  Created by cqsxit on 13-10-19.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "AccessoryView.h"
#import "AccessoryController.h"
@interface AccessoryView ()

@end

@implementation AccessoryView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self =[super initWithCoder:aDecoder];
    if(self){
        self.tabBarItem=[self.tabBarItem initWithTitle:@"公文附件" image:[UIImage imageNamed:@"accessory_out"] selectedImage:[UIImage imageNamed:@"accessory_over"]];
        
        AccessoryController *contro =[[AccessoryController alloc] init];
        self.controller=contro;
        contro.accView=self;
        }
           return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableViewDowning.delegate=self.controller;
    _tableViewDowning.dataSource=self.controller;
    _tableViewDowning.tag=0;
    _tableViewDowning.hidden=NO;
    
    _tableViewEndDown.delegate=self.controller;
    _tableViewEndDown.dataSource=self.controller;
    _tableViewEndDown.tag=1;
    _tableViewEndDown.hidden=YES;
    
    [_segControl addTarget:self.controller action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
}

-(void)segmentAction:(UISegmentedControl *)Seg{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
