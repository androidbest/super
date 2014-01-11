//
//  BaseController.m
//  zwy
//
//  Created by sxit on 9/26/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "BaseController.h"
#import "BaseView.h"
#import "ToolUtils.h"
@implementation BaseController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
}
- (void)tableViewIndexBar:(AIMTableViewIndexBar*)indexBar didSelectSectionAtIndex:(NSInteger)index{
}

- (void)VoiceRecorderBaseVCRecordFinish:(NSString *)_filePath fileName:(NSString*)_fileName{}



//初始化进度条
-(void)initData:(BaseView *)base{
    if(base.navigationController){
        _HUD = [[MBProgressHUD alloc] initWithView:base.view];
        [base.navigationController.view addSubview:_HUD];
    }else{
        _HUD = [[MBProgressHUD alloc] initWithView:base.view];
        [base.view addSubview:_HUD];
    }
}

//判断网络
-(BOOL)judgeNetwork{
    BOOL ret=[ToolUtils isExistenceNetwork];
    if(!ret){
        [ToolUtils alertInfo:@"无网络,请检查网络设置"];
    }
    return ret;
}

//初始化返回按钮
-(void)initBackBarButtonItem:(BaseView *)baseView{
     baseView.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:baseView action:nil];
}

- (void)dismissWithView{
}

- (void)viewWillAppearBase{

}

//0 播放 1 播放完成 2出错
-(void)RecordStatus:(int)status{

}
@end
