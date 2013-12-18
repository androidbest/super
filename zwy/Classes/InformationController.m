//
//  InformationController.m
//  zwy
//
//  Created by wangshuang on 10/12/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#define PATH_NEWS @"informationNews.plist"
#define PATH_JOKES @"informationJokes.plist"
#define MAX_PAGES 18
#import "InformationController.h"
#import "Constants.h"
#import "ToolUtils.h"
#import "TemplateCell.h"
#import "InformationInfo.h"
#import "InformationNewsCell.h"
@implementation InformationController{
    NSString *page;
    NSMutableArray *arr0;
    NSMutableArray *arr1;
    NSMutableArray *arrYetNews;
    NSMutableArray *arrYetJokes;
    NSInteger arr0Count;
    NSInteger arr1Count;
    BOOL isUpdata;
    BOOL isUpdata1;
    NSInteger selecter;
    NSString *start;
    NSString *end;
    NSString *start1;
    NSString *end1;

}

-(id)init{
    self=[super init];
    if(self){
        page=@"1";
        selecter=0;
        arr0=[NSMutableArray new];
        arr1=[NSMutableArray new];
        
        NSString *uniquePath=[DocumentsDirectory stringByAppendingPathComponent:PATH_NEWS];
        BOOL blNews=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
        if (blNews)arrYetNews =[[NSMutableArray alloc] initWithContentsOfFile:uniquePath];
        else arrYetNews=[NSMutableArray new];
        
        uniquePath =[DocumentsDirectory stringByAppendingPathComponent:PATH_JOKES];
        BOOL blJokes=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
        if (blJokes) arrYetJokes =[[NSMutableArray alloc] initWithContentsOfFile:uniquePath];
        else arrYetJokes =[NSMutableArray new];
        
        start=@"1";
        end=[ToolUtils numToString:MAX_PAGES];
        start1=@"1";
        end1=[ToolUtils numToString:MAX_PAGES];
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
            //新闻资讯
            selecter=0;
            [self.informationView.listview reloadDataPull];
            self.informationView.listview.hidden=NO;
            self.informationView.listview1.hidden=YES;
        }
            break;
        case 1:{
            //经典笑话
            selecter=1;
            if(arr1.count==0){
                self.informationView.listview1.separatorStyle = NO;
                [self.informationView.listview1 reloadDataPull];
                [self.informationView.listview1 LoadDataBegin];
            }else{
                [self.informationView.listview1 reloadDataPull];
            }
            
            self.informationView.listview.hidden=YES;
            self.informationView.listview1.hidden=NO;
            
        }
            break;
    }
    
    
}

//处理网络数据(新闻)
-(void)handleData:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    if (isUpdata) {
       [arr0 removeAllObjects];
        isUpdata=NO;
    }
    if(dic){
        RespList *list=[AnalysisData newsInfo:dic];
        
        if(list.resplist.count>0){
            [arr0 addObjectsFromArray:list.resplist];
            self.informationView.listview.separatorStyle = YES;
        }else{
            if(arr0.count==0)
            [ToolUtils alertInfo:@"暂无数据"];
            self.informationView.listview.reachedTheEnd=NO;
        }
    }else{
        self.informationView.listview.reachedTheEnd=NO;
        [ToolUtils alertInfo:requestError];
    }
    [self.informationView.listview reloadDataPull];
}

//处理网络数据(笑话)
-(void)handleData1:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];

    if(dic){
        if (isUpdata1) {
            [arr1 removeAllObjects];
            isUpdata1=NO;
        }
        
        RespList *list=[AnalysisData JokeInfo:dic];
        if(list.resplist.count>0){
           [arr1 addObjectsFromArray:list.resplist];
            self.informationView.listview1.separatorStyle = YES;
        }else{
            if(arr1.count==0)
            [ToolUtils alertInfo:@"暂无数据"];
            self.informationView.listview1.reachedTheEnd=NO;
        }
    }else{
       // [ToolUtils alertInfo:requestError];
    }
    [self.informationView.listview1 reloadDataPull];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag==0){
        return tableView.frame.size.height;
    }else{
        UITableViewCell * cell =[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.tag==0){
        return arr0.count/6;
    }else{
        return arr1.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * strCell1 =@"cell1";
    static NSString * strCell2 =@"cell2";
   
    
    if(tableView.tag==0){//新闻资讯(新闻内容)
        InformationNewsCell *cellNews=[tableView dequeueReusableCellWithIdentifier:strCell1];
        if (!cellNews) {
            cellNews = [[InformationNewsCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                  reuseIdentifier:strCell1
                                                     withDelegate:self];
        }
        
        int IndexNews=0;
        while (IndexNews<6) {
            int indexRow=IndexNews+6*indexPath.row;
            InformationInfo *info=arr0[indexRow];
            switch (IndexNews) {
                case 0:
                {
                    cellNews.labelTitle1.text=info.title;
                    cellNews.imageFirstNews.tag=indexRow;
                    [HTTPRequest imageWithURL:info.imagePath
                                    imageView:cellNews.imageFirstNews
                             placeholderImage:[UIImage imageNamed:@"error_image.jpg"]
                                   isDrawRect:drawRect_no];
                }
                    break;
                case 1:
                {
                   cellNews.labelTitle2.text=info.title;
                   cellNews.labelTitle2.tag=indexRow;
                   cellNews.labelAddress2.text=info.sourceName;
                }
                    break;
                case 2:
                {
                    cellNews.labelTitle3.text=info.title;
                    cellNews.labelTitle3.tag=indexRow;
                    cellNews.labelAddress3.text=info.sourceName;
                }
                    break;
                case 3:
                {
                    cellNews.labelTitle4.text=info.title;
                    cellNews.labelTitle4.tag=indexRow;
                    cellNews.labelAddress4.text=info.sourceName;
                }
                    break;
                case 4:
                {
                     cellNews.labelTitle5.text=info.title;
                    cellNews.labelTitle5.tag=indexRow;
                    cellNews.labelAddress5.text=info.sourceName;
                }
                    break;
                case 5:
                {
                     cellNews.labelTitle6.text=info.title;
                    cellNews.labelTitle6.tag=indexRow;
                    cellNews.labelAddress6.text=info.sourceName;
                }
                    break;
                default:
                    break;
            }
            IndexNews++;
        }
         return cellNews;
        
//        if ([arrYetNews containsObject:info.newsID]) cell.title.textColor=[UIColor grayColor];
//        else cell.title.textColor =[UIColor blackColor];
        
    }else{//新闻资讯(笑话)
         TemplateCell * cell=[tableView dequeueReusableCellWithIdentifier:strCell2];
        if (!cell) {
            cell = [[TemplateCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:strCell2];
        }
        InformationInfo *info=arr1[indexPath.row];
       
        
        float cellContentHeight=20;
        cell.content.text=info.content;
        cell.content.textColor=[UIColor blackColor];
        CGRect textRect = [cell.content.text boundingRectWithSize:CGSizeMake(280.0f, 1000.0f)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName:cell.content.font}
                                                          context:nil];
        //设置内容尺寸
        CGRect rect=cell.content.frame;
        rect.size.height=textRect.size.height;
        rect.origin.y=15;
        cell.content.frame=rect;
        cellContentHeight+=textRect.size.height+5;
        
        
        if (info.imagePath&&![info.imagePath isEqualToString:@"null"]) {
            cell.imageContent.hidden=NO;
            [HTTPRequest imageWithURL:info.imagePath
                            imageView:cell.imageContent
                     placeholderImage:[UIImage imageNamed:@"error_image.jpg"]
                           isDrawRect:drawRect_width];
            rect=cell.imageContent.frame;
            rect.origin.y=cellContentHeight;
            cell.imageContent.frame=rect;
            
            cellContentHeight+=cell.imageContent.frame.size.height+20;
           
        }else{
            cell.imageContent.hidden=YES;
        }
        
       //设置图片尺寸
       
        
        //设置cell尺寸
        rect =cell.frame;
        rect.size.height=cellContentHeight;
        cell.frame=rect;
        return cell;
    }
   
}


/*下拉刷新*/
- (void)upLoadDataWithTableView:(PullRefreshTableView *)tableView{
    //    [self performSelector:@selector(upData) withObject:nil afterDelay:2];
    if(tableView.tag==0){
        start=@"1";
        end=[ToolUtils numToString:MAX_PAGES];
        isUpdata=YES;
        [packageData reqHotNewsInfoXml:self start:start end:end SELType:xmlNotifInfo];
    }else if(tableView.tag==1){
        start1=@"1";
        end1=[ToolUtils numToString:MAX_PAGES];
        isUpdata1=YES;
        [packageData reqJokeInfoXml:self start:start1 end:end1 SELType:xmlNotifInfo1];
    }
}

/*上拉加载*/
- (void)refreshDataWithTableView:(PullRefreshTableView *)tableView{
    //    [self performSelector:@selector(loadData) withObject:nil afterDelay:2];
    
    if(tableView.tag==0){
        NSInteger start_=[ToolUtils stringToNum:start];
        NSInteger end_=[ToolUtils stringToNum:end];
        start_+=MAX_PAGES;
        end_+=MAX_PAGES;
        start=[ToolUtils numToString:start_];
        end=[ToolUtils numToString:end_];
        [packageData reqHotNewsInfoXml:self start:start end:end SELType:xmlNotifInfo];
    }else{
        NSInteger start_1=[ToolUtils stringToNum:start1];
        NSInteger end_1=[ToolUtils stringToNum:end1];
        start_1+=MAX_PAGES;
        end_1+=MAX_PAGES;
        start1=[ToolUtils numToString:start_1];
        end1=[ToolUtils numToString:end_1];
        [packageData reqJokeInfoXml:self start:start1 end:end1 SELType:xmlNotifInfo1];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==0) {
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - InformationNewsCellDelegate
- (void)PushToNewsDetaView:(UITapGestureRecognizer *)tapGestureRecognizer{
    UIView *view =[tapGestureRecognizer view];
    [self.informationView performSegueWithIdentifier:@"informationtodetail" sender:self.informationView];
    [self initBackBarButtonItem:self.informationView];
    InformationInfo *info=arr0[view.tag];
    _informationView.newsNumber=view.tag;
    self.informationView.informationInfo=info;
}

- (void)PushNextNewsFromInformationDetaController{
    _informationView.newsNumber++;
     InformationInfo *info=arr0[_informationView.newsNumber];
    self.informationView.informationInfo=info;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.tag==0){
    [self.informationView.listview scrollViewDidPullScroll:scrollView];
    }else{
    [self.informationView.listview1 scrollViewDidPullScroll:scrollView];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
