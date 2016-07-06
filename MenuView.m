//
//  MenuView.m
//  qunxin_edu
//
//  Created by 肖准 on 6/28/16.
//  Copyright © 2016 肖准. All rights reserved.
//

#import "MenuView.h"
#import "CourseSeries.h"
#import "courseTypeMJ.h"



@interface MenuView()<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray* _leftArr;
    NSMutableArray* _rightArr;
    
    NSInteger _leftIndex;
    NSInteger _rightIndex;
}
@end

@implementation MenuView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _leftArr = [NSMutableArray new];
        _rightArr = [NSMutableArray new];
        
        [self initsubview];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self getData];
        });
        
    }
    return self;
}

-(void)initsubview{
    
     //左边的课程目录
    _leftTableView = [UITableView new];
    [_leftTableView setFrame:CGRectMake(0, 0, screenwith/5*2, self.frame.size.height)];
    _leftTableView.tag = 10;
    _leftTableView.delegate = self;
    _leftTableView.dataSource =self;
    _leftTableView.backgroundColor = [UIColor whiteColor];
    [_leftTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];

    [self addSubview:_leftTableView];
    
    
    //右边的详细课程体系
    _rightTableView = [UITableView new];
    [_rightTableView setFrame:CGRectMake(screenwith/5*2, 0, screenwith/5*3, self.frame.size.height)];
    _rightTableView.tag = 20;
    _rightTableView.delegate = self;
    _rightTableView.dataSource =self;
    _rightTableView.separatorStyle=UITableViewCellSelectionStyleNone;
    _rightTableView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_rightTableView];
    
    self.userInteractionEnabled=YES;
    
    
}


//获取目录数据 ，一层二层数据一次性获取 此处是本地获取 一般情况下是网络获取json数据
-(void)getData{
   
    NSString *newPath=[NSString stringWithFormat:@"%@%@%@",[[NSBundle mainBundle]resourcePath],@"/",@"data"];
    
    //根据文件路径读取数据
    NSData *jdata = [[NSData alloc]initWithContentsOfFile:newPath];
   // 格式化成json数据
    NSDictionary* jsonObject = [NSJSONSerialization JSONObjectWithData:jdata options:kNilOptions error:nil];
    NSArray* arr = (NSArray*)jsonObject[@"data"];
       __weak typeof(self) weakself= self;

     _leftArr = [CourseSeries mj_objectArrayWithKeyValuesArray:arr];
                  dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself.leftTableView reloadData];
    
                });
    
//    NSString * url = [NSString stringWithFormat:@"%@%@%@",MAIN,COURSE,GETCOURSETYPEINFO];
//    __weak typeof(self) weakself= self;
//    [[XZHttp sharedInstance]getWithURLString:url parameters:nil success:^(id responseObject) {
//    
//        [_leftArr removeAllObjects];
//        [_rightArr removeAllObjects];
//        
//        NSDictionary *json = [Utils getJsonStringFromResponseObj:responseObject];
//        NSInteger isSuccess = [(NSString*)json[@"isSuccess"] intValue];
//        NSString* msg = (NSString*)json[@"message"];
//        NSLog(@"isSuccess :%d",isSuccess);
//
//        if(isSuccess!=1){
//            [Utils createHUDWithText:msg delayTime:1];
//        }else {
//             NSArray* arr = (NSArray*)json[@"data"];
//             _leftArr = [CourseSeries mj_objectArrayWithKeyValuesArray:arr];
//              dispatch_async(dispatch_get_main_queue(), ^{
//                [weakself.leftTableView reloadData];
//
//            });
//        }
//    } failure:^(NSError *error) {
//        [Utils createHUDErrorWithError:error];
//    }];
    
}

#pragma mark - tableview 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(tableView.tag == 10){
        return [_leftArr count];
    }else {
        
        if(_leftArr.count==0){
            return 0;
        }
        CourseSeries *serie = _leftArr[_leftIndex];
        return [serie.list count];
    }

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 42;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView.tag==10){
        
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"lefttable_cell_id"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CourseSeries* dict = _leftArr[indexPath.row];
        NSDictionary* typedict = dict.data;
        courseTypeMJ* type = [courseTypeMJ mj_objectWithKeyValues:typedict];
        cell.textLabel.text = type.typeName;
        [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
        [cell.textLabel setTextColor:[UIColor grayColor]];
        
        return cell;
        
    }else {
        
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"righttable_cell_id"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:13]];
        [cell.textLabel setTextColor:[UIColor grayColor]];
//        if(indexPath.row==0){
//            cell.textLabel.text =@"全部课程";
//            [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
//
//        }else{
           CourseSeries *cs = _leftArr[_leftIndex];
            NSArray* arr = [courseTypeMJ mj_objectArrayWithKeyValuesArray:cs.list];
            courseTypeMJ* type = arr[indexPath.row];
        
           cell.textLabel.text =type.typeName;
    //    }
        return cell;
        
    }
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(tableView.tag == 10){
        _leftIndex = indexPath.row;
        
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor whiteColor];
      
        [_rightTableView reloadData];
        
    }else {
        _rightIndex = indexPath.row;
//        if(_rightIndex == 0){
//            return;
//        }
        CourseSeries* sr = _leftArr[_leftIndex];
        NSArray* arr = [courseTypeMJ mj_objectArrayWithKeyValuesArray:sr.list];
     
        courseTypeMJ* ct = arr[indexPath.row];
        
      //    NSString *name = [dic objectForKey:@"name"];
        NSLog(@"coursetype name:%@",ct.typeName);
        if(_didselectAtrowWithId){
            _didselectAtrowWithId(ct.Id);
    
        }
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
