//
//  NoticeController.m
//  zwy
//
//  Created by wangshuang on 10/11/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "NoticeController.h"
#import "Constants.h"
#import "AnalysisData.h"
#import "PackageData.h"
#import "ToolUtils.h"
#import "RespList.h"
#import "NoticeDetaInfo.h"
#import "TemplateCell.h"
@implementation NoticeController{
    NSString *page;
    NSMutableArray *arr;
    NSInteger allCount;
    BOOL isUpdata;
}

-(id)init{
    self=[super init];
    if(self){
        page=@"1";
        arr=[NSMutableArray new];
        //注册通知
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handleData:)
                                                    name:xmlNotifInfo
                                                  object:self];
    }
    return self;
}

//处理网络数据
-(void)handleData:(NSNotification *)notification{
    [self.HUD hide:YES];
    
    NSDictionary *dic=[notification userInfo];
    if (isUpdata) {
        [arr removeAllObjects];
        isUpdata=NO;
    }
    
    
    if(dic){
        RespList *list=[AnalysisData getNoticeList:dic];
        if(list.resplist.count>0){
            [arr addObjectsFromArray:list.resplist];
            self.noticeView.listview.separatorStyle = YES;
            
            allCount=list.rowCount;
        }else{
            [ToolUtils alertInfo:@"暂无数据"];
        }
    }else{
        [ToolUtils alertInfo:requestError];
    }
    [self.noticeView.listview reloadDataPull];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * strCell =@"cell";
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//    TemplateCell *cell = [storyboard instantiateViewControllerWithIdentifier:@"templateCell"];
    TemplateCell * cell =[tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell) {
        cell = [[TemplateCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:strCell];
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NoticeDetaInfo *info=arr[indexPath.row];
    cell.title.text=info.title;
    cell.time.text=info.publicdate;
    cell.content.text=info.content;
    return cell;
}


/*下拉刷新*/
- (void)upLoadDataWithTableView:(PullRefreshTableView *)tableView{
//    [self performSelector:@selector(upData) withObject:nil afterDelay:2];
    isUpdata=YES;
    page=@"1";
    [packageData getNoticeList:self pages:page];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.noticeView performSegueWithIdentifier:@"noticetodetail" sender:nil];
    [self initBackBarButtonItem:self.noticeView];
    self.noticeView.noticeInfo=arr[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*上拉加载*/
- (void)refreshDataWithTableView:(PullRefreshTableView *)tableView{
//    [self performSelector:@selector(loadData) withObject:nil afterDelay:2];
    NSInteger tempPage=[ToolUtils stringToNum:page];
    tempPage++;
    NSInteger sumPage=0;
    if((allCount%20)==0){
        sumPage=allCount/20;
    }else{
        sumPage=(allCount/20)+1;
    }
    
    if(tempPage>sumPage){
        self.noticeView.listview.reachedTheEnd=NO;
        [self.noticeView.listview reloadDataPull];
    }else{
        page=[ToolUtils numToString:tempPage];
        [packageData getNoticeList:self pages:page];
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.noticeView.listview scrollViewDidPullScroll:scrollView];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
