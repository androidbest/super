//
//  peopleDeleteController.m
//  zwy
//
//  Created by cqsxit on 13-10-24.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "peopleDeleteController.h"
#import "PeopelInfo.h"
#import "GroupInfo.h"

@implementation peopleDeleteController
- (id)init{
    self =[super init];
    if (self) {
        self.arrAllInfo =[[NSMutableArray alloc] init];
    }
    return self;
}

- (void)initWithData{
    self.arrAllInfo =[[NSMutableArray alloc] initWithArray:_peopleView.arrAllInfo];
    [_peopleView.tableViewAllIfo reloadData];
}

- (void)LeftDown{
    [self.peopleView.navigationController popViewControllerAnimated:YES];
    [_peopleView.peopleDeleteDelegate returnPeoPleEditInfo:_arrAllInfo];
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrAllInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * strCell=@"SMSCell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strCell];
    }
    NSObject * obj =_arrAllInfo[indexPath.row];
    if ([obj isKindOfClass:[GroupInfo class]]) {
        GroupInfo *info =(GroupInfo *)obj;
        cell.textLabel.text =info.Name;
    }else if ([obj isKindOfClass:[PeopelInfo class]]){
        PeopelInfo * info =(PeopelInfo *)obj;
        cell.textLabel.text =info.Name;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_arrAllInfo removeObjectAtIndex:indexPath.row];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
@end
