//
//  CommentListController.m
//  zwy
//
//  Created by cqsxit on 13-12-16.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#define NOTIFICATIONLISTDATA @"notificationListData"

#import "CommentListController.h"
#import "TemplateCell.h"

@implementation CommentListController{
    BOOL isUpdata;
}

- (id)init{
    self =[super init];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handleListData:)
                                                    name:NOTIFICATIONLISTDATA
                                                  object:self];
        _arrCommentList =[[NSMutableArray alloc] init];
        isUpdata=NO;
    }
    return self;
}

#pragma mark -解析数据
- (void)handleListData:(NSNotification *)notification{
    NSDictionary *dic =[notification userInfo];
    if (isUpdata) {
        [_arrCommentList removeAllObjects];
        isUpdata=NO;
    }
    
    if(dic){
        
        CommentListInfo *info =[AnalysisData getCommentList:dic];
        if(info.arrCommentList.count>0){
            [_arrCommentList addObjectsFromArray:info.arrCommentList];
            self.comListView.tableViewComment.separatorStyle = YES;
        }else{
                [ToolUtils alertInfo:@"暂无数据"];
            self.comListView.tableViewComment.reachedTheEnd=NO;
        }
    
    }else{
        
        [ToolUtils alertInfo:requestError];
    }
    
    self.comListView.tableViewComment.reachedTheEnd=NO;
    [self.comListView.tableViewComment reloadDataPull];
}

#pragma  mark - 按钮触发
//返回
- (void)btnBack{
    [self.comListView.navigationController popViewControllerAnimated:YES];
}

//评论
- (void)btnComment{
    [self.comListView performSegueWithIdentifier:@"CommentListToCommentDeta" sender:self.comListView];
}

//刷新
- (void)btnRefresh{

}

#pragma mark - UITableViewDateSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        UITableViewCell * cell =[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return _arrCommentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
static NSString *strCell=@"cell";
    TemplateCell *cell =[tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell) {
        cell =[[TemplateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
    }
    
    float cellContentHeight=20;
    CommentDetaInfo *info =_arrCommentList[indexPath.row];
    cell.content.text=info.content;
    cell.content.textColor=[UIColor blackColor];
    CGRect textRect = [cell.content.text boundingRectWithSize:CGSizeMake(280.0f, 1000.0f)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:cell.content.font}
                                                      context:nil];
    CGRect rect=cell.content.frame;
    rect.size.height=textRect.size.height;
    rect.origin.y=cellContentHeight+10;
    cell.content.frame=rect;
    cellContentHeight+=textRect.size.height+20;
    
    //设置cell尺寸
    rect =cell.frame;
    rect.size.height=cellContentHeight;
    cell.frame=rect;
    return cell;

    
    return cell;
}


/*下拉刷新*/
- (void)upLoadDataWithTableView:(PullRefreshTableView *)tableView{
    isUpdata=YES;
    [packageData getCommentListData:self newsID:_comListView.InfoNewsDeta.newsID pages:0 SELType:NOTIFICATIONLISTDATA];
}

/*上拉加载*/
- (void)refreshDataWithTableView:(PullRefreshTableView *)tableView{
    isUpdata=YES;
     [packageData getCommentListData:self newsID:_comListView.InfoNewsDeta.newsID pages:0 SELType:NOTIFICATIONLISTDATA];
}

#pragma mark - baseControllerDelagete
- (void)BasePrepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}
@end
