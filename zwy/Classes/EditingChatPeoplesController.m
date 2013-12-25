//
//  EditingChatPeoplesController.m
//  zwy
//
//  Created by cqsxit on 13-12-25.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "EditingChatPeoplesController.h"
#import "PeopelInfo.h"
@implementation EditingChatPeoplesController

- (id)init{
    self =[super init];
    if (self) {
        
    }
    return self;
}


- (void)initWithData{
    int widthIndex=4;
    int lineIndex=0;
    float imageHeadSize=55;
    float imageInterval=20;
    _editingView.arrPeoples =[[NSMutableArray alloc] initWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1", nil];
    for (int i=0; i<_editingView.arrPeoples.count/widthIndex; i++) {
        for (int j=0; j<widthIndex; j++) {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake((imageHeadSize+imageInterval)*j, imageInterval+(imageHeadSize+imageInterval)*lineIndex, imageHeadSize, imageHeadSize);
            btn.tag=lineIndex*widthIndex+j;
            [btn setImage:[UIImage imageNamed:@"navigation_back_over"] forState:UIControlStateNormal];
            [self.editingView.view  addSubview:btn];
        }
        lineIndex++;
    }
    for (int i=0; i<_editingView.arrPeoples.count%widthIndex; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake((imageHeadSize+imageInterval)*i, imageInterval+(imageHeadSize+imageInterval)*lineIndex, imageHeadSize, imageHeadSize);
        btn.tag=lineIndex*widthIndex+i;
        [btn setImage:[UIImage imageNamed:@"navigation_back_over"] forState:UIControlStateNormal];
        [self.editingView.view  addSubview:btn];
    }
}

- (void)BasePrepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}
@end
