//
//  ChatMessageController.m
//  zwy
//
//  Created by wangshuang on 12/17/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "ChatMessageController.h"

@implementation ChatMessageController{
    NSMutableArray *arrData;
    NSMutableArray *arrTime;
}

-(id)init{
    self=[super init];
    if(self){
        arrData=[NSMutableArray new];
        arrTime=[NSMutableArray new];
    }
    return self;
}


-(void)sendMessage{
    [arrData addObject:self.chatMessageView.im_text.text];
    [arrTime addObject:[NSData data]];
    self.chatMessageView.im_text.text=nil;
//    NSIndexPath * rownu=[NSIndexPath indexPathForRow:array_.count-1 inSection:0];
//    [self.chatMessageView.tableview selectRowAtIndexPath:rownu animated:YES scrollPosition:UITableViewScrollPositionBottom];
//    [self.chatMessageView.tableview deselectRowAtIndexPath:rownu animated:NO];
    NSInteger rows = [self.chatMessageView.tableview numberOfRowsInSection:0];
    if(rows > 0) {
        [self.chatMessageView.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:YES];
    }
    [self.chatMessageView.tableview reloadData];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrData.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(![self.delegate messageMediaTypeForRowAtIndexPath:indexPath]){
//        return [JSBubbleMessageCell neededHeightForText:[self.dataSource textForRowAtIndexPath:indexPath]
//                                              timestamp:[self shouldHaveTimestampForRowAtIndexPath:indexPath]
//                                                 avatar:[self shouldHaveAvatarForRowAtIndexPath:indexPath]];
//    }else{
//        return [JSBubbleMessageCell neededHeightForImage:[self.dataSource dataForRowAtIndexPath:indexPath]
//                                               timestamp:[self shouldHaveTimestampForRowAtIndexPath:indexPath]
//                                                  avatar:[self shouldHaveAvatarForRowAtIndexPath:indexPath]];
//    }
//}

@end
