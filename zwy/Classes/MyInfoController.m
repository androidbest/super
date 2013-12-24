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
}

-(id)init{
    self=[super init];
    if(self){
     arr=[NSMutableArray new];
        isInitHead=YES;
        
        
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        return 80;
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyImCell * cell =[tableView dequeueReusableCellWithIdentifier:@"myimCell"];
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
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
                }];
                if (!isStart) [ToolUtils alertInfo:@"获取权限失败!"];
            }
               
                break;
            case 1:
            {
                PhotoOptional *photoController=[PhotoOptional newInstance];
                BOOL isStart=   [photoController startCameraController:self.myInfoView isAllowsEditing:YES photoImage:^(UIImage *image) {
                    [btnHead setBackgroundImage:image forState:UIControlStateNormal];
                }];
                 if (!isStart) [ToolUtils alertInfo:@"设备摄像头错误!"];
            }
                break;
            default:
                break;
        }
    }
}
@end
