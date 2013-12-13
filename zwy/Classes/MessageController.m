//
//  MessageController.m
//  zwy
//
//  Created by wangshuang on 12/10/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "MessageController.h"
#import "MesaageIMCell.h"
@implementation MessageController{
    NSMutableArray *arr;
}

-(id)init{
    self=[super init];
    if(self){
        arr=[NSMutableArray new];
        
//        for(int i=0;i<20;i++){
//        arr addObject:[NSString stringWithFormat:@"%d"]
//        }
    }
    return self;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * messageIMCell =@"messageIMCell";
    MesaageIMCell * cell =[tableView dequeueReusableCellWithIdentifier:messageIMCell];
    if (!cell) {
        cell = [[MesaageIMCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                   reuseIdentifier:messageIMCell];
    }
    cell.title.text=@"fasdfasfasfd22222222222222222222222222222222222222222222222222222222222222222222";
    cell.content.text=@"aadfdsafasdfsadfasdfas11111111111111111111111111111111111111111111111111111111";
    cell.time.text=@"2013-11-23 19:32";
    cell.imageMark.image=[UIImage imageNamed:@"default_avatar"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
//    self.filteredPersons = self.famousPersons;
    self.messageView.navigationController.navigationBarHidden=YES;
    CGRect rect=self.messageView.tableView.frame;
    rect.origin.y-=44;
    self.messageView.tableView.frame=rect;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
//    self.filteredPersons = nil;
    self.messageView.navigationController.navigationBarHidden=NO;
    CGRect rect=self.messageView.tableView.frame;
    rect.origin.y+=44;
    self.messageView.tableView.frame=rect;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
//    self.filteredPersons = [self.filteredPersons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchString]];
    
    return YES;
}
@end
