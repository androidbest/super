//
//  OfficFlowView.m
//  zwy
//
//  Created by wangshuang on 10/18/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "OfficFlowView.h"
#import "OfficeFlowController.h"
@interface OfficFlowView ()

@end

@implementation OfficFlowView

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
        OfficeFlowController *office=[OfficeFlowController new];
        office.officeFlowView=self;
        self.controller=office;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.controller initData:self];
    _flowList.delegate=self.controller;
    _flowList.dataSource=self.controller;
    
    
    [(OfficeFlowController *)self.controller performSelector:@selector(sendDocFlow) withObject:nil];
}

-(void)sendDocFlow{}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
