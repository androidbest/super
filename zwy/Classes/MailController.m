//
//  MailController.m
//  zwy
//
//  Created by wangshuang on 10/12/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "MailController.h"
#import "Constants.h"
#import "ToolUtils.h"
#import "TemplateCell.h"
#import "PackageData.h"
#import "AnalysisData.h"
#import "PublicMailDetaInfo.h"
@implementation MailController{
    NSString *page0;
    NSString *page1;
    NSMutableArray *arr0;
    NSMutableArray *arr1;
    NSInteger arr0Count;
    NSInteger arr1Count;
    BOOL isUpdata;
    BOOL isUpdata1;
    BOOL isInitData;
    NSInteger selecter;
}

-(id)init{
    self=[super init];
    if(self){
        page0=@"1";
        page1=@"1";
        selecter=0;
        isInitData=YES;
        arr0=[NSMutableArray new];
        arr1=[NSMutableArray new];
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handleData:)
                                                    name:xmlNotifInfo
                                                  object:self];
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handleData1:)
                                                    name:xmlNotifInfo1
                                                  object:self];
    }
    return self;
}

//页签选择
-(void)segmentAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    switch (Index) {
        case 0:{
            //意见办理
            selecter=0;
            [self.mailView.listview reloadDataPull];
            self.mailView.listview.hidden=NO;
            self.mailView.listview1.hidden=YES;
        }
            break;
        case 1:{
            //意见审核
            selecter=1;
            if(arr1.count==0&&isInitData){
                
            self.mailView.listview1.separatorStyle = NO;
            [self.mailView.listview1 reloadDataPull];
            [self.mailView.listview1 LoadDataBegin];
                
            isInitData=NO;
            }else{
            [self.mailView.listview reloadDataPull];
            }
            
            self.mailView.listview.hidden=YES;
            self.mailView.listview1.hidden=NO;
            
        }
            break;
}
    
    
}

//处理网络数据
-(void)handleData:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    if (isUpdata) {
        
            [arr0 removeAllObjects];
        
        isUpdata=NO;
    }
    if(dic){
        RespList *list=[AnalysisData getPublicMailList:dic];
            arr0Count=list.rowCount;
        
        if(list.resplist.count>0||arr0.count!=0){
            [arr0 addObjectsFromArray:list.resplist];
            self.mailView.listview.separatorStyle = YES;
            self.mailView.listview.backgroundColor=[UIColor whiteColor];
        }else{
//            [ToolUtils alertInfo:@"暂无数据"];
            self.mailView.listview.backgroundColor=[UIColor clearColor];
        }
    }else{
        [ToolUtils alertInfo:requestError];
    }
    [self.mailView.listview reloadDataPull];
}

//处理网络数据
-(void)handleData1:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    if (isUpdata1) {

            [arr1 removeAllObjects];
        
        isUpdata1=NO;
    }
    if(dic){
            RespList *list=[AnalysisData getAuditMailList:dic];
            arr1Count=list.rowCount;
        
        if(list.resplist.count>0||arr1.count!=0){
           
                [arr1 addObjectsFromArray:list.resplist];
            
            self.mailView.listview1.separatorStyle = YES;
            self.mailView.listview1.backgroundColor =[UIColor whiteColor];
        }else{
//            [ToolUtils alertInfo:@"暂无数据"];
            self.mailView.listview1.backgroundColor =[UIColor clearColor];
        }
    }else{
        [ToolUtils alertInfo:requestError];
    }
    [self.mailView.listview1 reloadDataPull];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}



//判断是否需要下拉加载更多内容
- (NSInteger)tableViewReacherdTheEnd:(NSInteger)count{
    if (selecter==0) {
        if (count==arr0Count||count>arr0Count) {
            self.mailView.listview.reachedTheEnd=YES;
        }else{
            self.mailView.listview.reachedTheEnd=NO;
        }
    }
    if (selecter==1) {
        if (count==arr1Count||count>arr1Count) {
            self.mailView.listview.reachedTheEnd=YES;
        }else{
            self.mailView.listview.reachedTheEnd=NO;
        }
    }
    return count;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger ret=0;
    if(tableView.tag==0){
        ret=arr0.count;
    }else{
        ret=arr1.count;
    }
    return ret;
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
        cell.imageMark.hidden=NO;
    }
    
    PublicMailDetaInfo *info;
    if(tableView.tag==0){
    info=arr0[indexPath.row];
        
    }else{
    info=arr1[indexPath.row];
    }
    cell.title.text=info.content;
    cell.time.text=info.senddate;
    cell.content.text=info.content;
    
    return cell;
}


/*下拉刷新*/
- (void)upLoadDataWithTableView:(PullRefreshTableView *)tableView{
    //    [self performSelector:@selector(upData) withObject:nil afterDelay:2];
    if(tableView.tag==0){
        page0=@"1";
        isUpdata=YES;
        [packageData getPublicMailList:self Pages:page0 SELType:xmlNotifInfo];
    }else{
        page1=@"1";
        isUpdata1=YES;
        [packageData getAuditMailList:self Pages:page1 SELType:xmlNotifInfo1];
    }
}

//处理后刷新列表
-(void)refreshListView:(NSInteger)row{
    if(selecter==0){
        [arr0 removeObjectAtIndex:row];
    }else{
        [arr1 removeObjectAtIndex:row];
    }
[self.mailView.listview reloadDataPull];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.mailView performSegueWithIdentifier:@"mailtodetail" sender:self.mailView];
    [self initBackBarButtonItem:self.mailView];
    if(tableView.tag==0){
        PublicMailDetaInfo *info=arr0[indexPath.row];
        info.type=@"0";
        info.row=indexPath.row;
        info.listview=tableView;
        info.arr=arr0;
        self.mailView.info=info;
    }else{
        PublicMailDetaInfo *info=arr1[indexPath.row];
        info.row=indexPath.row;
        info.type=@"1";
        info.row=indexPath.row;
        info.listview=tableView;
        info.arr=arr1;
        self.mailView.info=info;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*上拉加载*/
- (void)refreshDataWithTableView:(PullRefreshTableView *)tableView{
    //    [self performSelector:@selector(loadData) withObject:nil afterDelay:2];
    
    NSInteger sumPage=0;
    NSInteger tempPage=0;
    if(tableView.tag==0){
        tempPage=[ToolUtils stringToNum:page0];
        tempPage++;
        if((arr0Count%20)==0){
            sumPage=arr0Count/20;
        }else{
            sumPage=(arr0Count/20)+1;
        }
        
        if(tempPage>sumPage){
            self.mailView.listview.reachedTheEnd=NO;
            [self.mailView.listview reloadDataPull];
        }else{
            
                page0=[ToolUtils numToString:tempPage];
                [packageData getPublicMailList:self Pages:page0 SELType:xmlNotifInfo];
            
        }
    }else{
        tempPage=[ToolUtils stringToNum:page1];
        tempPage++;
        if((arr1Count%20)==0){
            sumPage=arr1Count/20;
        }else{
            sumPage=(arr1Count/20)+1;
        }
        
        if(tempPage>sumPage){
            self.mailView.listview1.reachedTheEnd=NO;
            [self.mailView.listview1 reloadDataPull];
        }else{
                page1=[ToolUtils numToString:tempPage];
                [packageData getAuditMailList:self Pages:page1 SELType:xmlNotifInfo1];
            
        }
    }
    

}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.tag==0){
    [self.mailView.listview scrollViewDidPullScroll:scrollView];
    }else{
    [self.mailView.listview1 scrollViewDidPullScroll:scrollView];
    }
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
