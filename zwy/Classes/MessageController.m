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

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{

}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{

}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    return YES;
}
@end
