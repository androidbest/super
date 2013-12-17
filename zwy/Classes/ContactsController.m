//
//  ContactsController.m
//  zwy
//
//  Created by wangshuang on 12/10/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "ContactsController.h"
#import "MesaageIMCell.h"
#import "ConfigFile.h"
#import "HTTPRequest.h"
#import "PeopelInfo.h"
@implementation ContactsController{
      NSMutableArray *arr;
}

-(id)init{
    self=[super init];
    if(self){
        arr=[NSMutableArray new];
    }
    return self;
}

-(void)initECnumerData{
    arr = [ConfigFile setEcNumberInfo];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@/%@/%@",DocumentsDirectory,user.msisdn,user.eccode,@"member.txt"]];
    if(arr.count==0&&!blHave){
        self.HUD.labelText = @"请同步单位通讯录";
        self.HUD.mode = MBProgressHUDModeCustomView;
        [self.HUD show:YES];
        [self.HUD  hide:YES afterDelay:2];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * contacts =@"contactsChatCell";
    MesaageIMCell * cell =[tableView dequeueReusableCellWithIdentifier:contacts];
    if (!cell) {
        cell = [[MesaageIMCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:contacts];
    }
    PeopelInfo *info=arr[indexPath.row];
    cell.username.text=info.Name;
    [HTTPRequest imageWithURL:info.headPath imageView:cell.imageMark placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    return YES;
}
@end
