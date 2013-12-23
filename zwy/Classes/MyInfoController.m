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
@implementation MyInfoController{
    NSMutableArray *arr;
}

-(id)init{
    self=[super init];
    if(self){
     arr=[NSMutableArray new];
     
        
        
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
            cell.title.text=@"头像";
            [HTTPRequest imageWithURL:user.headurl imageView:cell.titleImg placeUIButtonImage:[UIImage imageNamed:@"im_head"]];
            cell.content.hidden=YES;
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
            cell.content.text=@"";
            cell.titleImg.hidden=YES;
            break;
        case 4:
            cell.title.text=@"职务";
            
            cell.content.text=@"";
            cell.titleImg.hidden=YES;
            break;
    }
    return cell;
}

@end
