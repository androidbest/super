//
//  MyInfoController.m
//  zwy
//
//  Created by wangshuang on 12/10/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "MyInfoController.h"
#import "MyImCell.h"
#import "Constants.h"
#import "PhotoOptional.h"
@implementation MyInfoController{
    NSMutableArray *arr;
    UIButton *btnHead;
    BOOL isInitHead;
    NSString *uuid;
}

-(id)init{
    self=[super init];
    if(self){
     arr=[NSMutableArray new];
     isInitHead=YES;
     
     [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handleData:)
                                                    name:xmlNotifInfo
                                                  object:self];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(reqUrl:)
                                                    name:@"reqUrl"
                                                  object:self];
        
    }
    return self;
}


//处理网络数据
-(void)handleData:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    if(dic){
        NSString * strPath =[[NSBundle mainBundle] pathForResource:@"common" ofType:@"plist"];
        NSDictionary * dic =[NSDictionary dictionaryWithContentsOfFile:strPath];
        [packageData imUploadLink:self msisdn:user.msisdn eccode:user.eccode memberid:user.userid selType:@"reqUrl" url:[NSString stringWithFormat:@"%@%@.jpg",dic[@"hosturl"],uuid]];
        self.HUD.labelText = @"上传成功";
    }else{
        self.HUD.labelText = @"发送失败";
    }
    self.HUD.mode = MBProgressHUDModeCustomView;
    [self.HUD hide:YES afterDelay:1];
}

//请求url
-(void)reqUrl:(NSNotification *)notification{
     NSDictionary *dic=[notification userInfo];
    if(dic){
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        return 60;
    }
    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyImCell * cell =[tableView dequeueReusableCellWithIdentifier:@"myimCell"];
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row!=0) {
        cell.userInteractionEnabled = NO;
    }
    
    switch (indexPath.row) {
        case 0:
            if (isInitHead) {
                cell.title.text=@"头像";
                [HTTPRequest imageWithURL:user.headurl imageView:cell.titleImg placeUIButtonImage:[UIImage imageNamed:@"im_head"]];
                btnHead =cell.titleImg;
                [cell.titleImg addTarget:self action:@selector(BtnOptionHead:) forControlEvents:UIControlEventTouchUpInside];
                cell.content.hidden=YES;
                isInitHead=NO;
            }
            break;
        case 1:
            cell.title.frame=CGRectMake(50, 10, 50, 50);
            cell.title.text=@"姓名";
            cell.content.text=user.username;
            cell.titleImg.hidden=YES;
            break;
        case 2:
            cell.title.text=@"号码";
            cell.content.text=user.msisdn;
            cell.titleImg.hidden=YES;
            break;
        case 3:
            cell.title.text=@"部门";
            cell.content.text=user.ecname;
            cell.titleImg.hidden=YES;
            break;
        case 4:
            cell.title.text=@"职务";
            if(user.job&&![user.job isEqualToString:@"null"]){
            cell.content.text=user.job;
            }else{
            cell.content.text=@"未分配";
            }
            cell.titleImg.hidden=YES;
            break;
    }
    return cell;
}


//选择头像
- (void)BtnOptionHead:(id)sender{
    UIActionSheet *sheet =[[UIActionSheet alloc] initWithTitle:@"类型"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"相册",@"照相机", nil];
    sheet.tag=0;
    [sheet showInView:_myInfoView.view];
    

}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==0) {
        switch (buttonIndex) {
            case 0:
            {
            PhotoOptional *photoController=[PhotoOptional newInstance];
              BOOL isStart= [photoController startMediaBrowser:self.myInfoView isAllowsEditing:YES photoImage:^(UIImage *image) {
                  [btnHead setBackgroundImage:image forState:UIControlStateNormal];
                  
                  self.HUD.labelText = @"正在上传..";
                  [self.HUD show:YES];
                  [packageData imUploadUrl:self type:@"0" data:UIImageJPEGRepresentation(image,0.1) selType:xmlNotifInfo uuid:[ToolUtils uuid]];
                }];
                if (!isStart) [ToolUtils alertInfo:@"获取权限失败!"];
            }
                break;
            case 1:
            {
                PhotoOptional *photoController=[PhotoOptional newInstance];
                BOOL isStart=   [photoController startCameraController:self.myInfoView isAllowsEditing:YES photoImage:^(UIImage *image) {
                    [btnHead setBackgroundImage:image forState:UIControlStateNormal];
                    [packageData imUploadUrl:self type:@"0" data:UIImageJPEGRepresentation(image,0.1) selType:xmlNotifInfo uuid:[ToolUtils uuid]];
                }];
                 if (!isStart) [ToolUtils alertInfo:@"设备摄像头错误!"];
            }
                break;
            default:
                break;
        }
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
