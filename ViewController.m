//
//  ViewController.m
//  XZMenu
//
//  Created by 肖准 on 7/6/16.
//  Copyright © 2016 肖准. All rights reserved.
//

#import "ViewController.h"
#import "MenuView.h"

@interface ViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>{
    UIView* _maskView;
    MenuView * _menuview;
    UIButton* _catoBtn;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //生成遮盖层
    [self initMask];
    //cell注册
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"text_cell"];
    // 取消cell多余下划线
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}
#pragma  mark - 遮盖层
-(void)initMask{
    
    _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenwith, screenheight-64)];
    _maskView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.352];
    [self.view addSubview:_maskView];
    _maskView.hidden = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMaskView:)];
    tap.delegate = self;
    [_maskView addGestureRecognizer:tap];
    
    _menuview = [[MenuView alloc]initWithFrame:CGRectMake(0, 0, screenwith, _maskView.frame.size.height-90)];
    
  //  __weak typeof(self) weakself= self;
    _menuview.didselectAtrowWithId = ^(NSInteger Id){
        NSLog(@"点击二级目录:%d",Id);
      
    };
    
    [_maskView addSubview:_menuview];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 点击遮盖层
-(void)tapMaskView:(UITapGestureRecognizer*) sender{
    [self catohidden];
}

#pragma mark - 遮盖层显示
-(void)catohidden{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFromTop;
    animation.duration = 0.2;
    [_maskView.layer addAnimation:animation forKey:nil];
    _maskView.hidden = YES;
    _menuview.hidden = YES;
    self.tableView.scrollEnabled =YES;
    _catoBtn.selected = NO;
}
-(void)catoshow{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFromBottom;
    animation.duration = 0.2;
    [_maskView.layer addAnimation:animation forKey:nil];
    _maskView.hidden = NO;
    _menuview.hidden = NO;
    
    self.tableView.scrollEnabled =NO;
    _catoBtn.selected = YES;
}



#pragma mark - tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return screenheight/8;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    UIView * headerview = [UIView new];
    [headerview setBounds:CGRectMake(0, 0, screenwith, 40)];
    [headerview setBackgroundColor:[UIColor colorWithWhite:0.937 alpha:1.000]];
    
    
    UIView * toolview = [UIView new];
    [toolview setFrame:CGRectMake(0, 0, screenheight, 40)];
    [toolview setBackgroundColor:[UIColor colorWithRed:0.365 green:0.780 blue:0.145 alpha:1.000]];
    [headerview addSubview:toolview];
    
    //课程类别
    _catoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_catoBtn setTitle:@"全部课程" forState:UIControlStateNormal];
    [_catoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_catoBtn setTitleColor:[UIColor colorWithRed:0.128 green:0.883 blue:0.526 alpha:1.000] forState:UIControlStateSelected];
    [_catoBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    _catoBtn.frame = CGRectMake(10, 2, 120, 36);
    [_catoBtn addTarget:self action:@selector(btnpress:) forControlEvents:UIControlEventTouchUpInside];

    
    [toolview addSubview:_catoBtn];
    
  
    
    return headerview;
    
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
 
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"text_cell" forIndexPath:indexPath];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"text_cell"];
    }
    return cell;
    
}

-(void)btnpress:(UIButton*)sender{
    if(sender.selected == NO){
                    [self catoshow];
                }else {
                    [self catohidden];
                }
                

}

#pragma mark - 手势 delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    //  NSLog(@"view class:%@",[touch.view class]);
    //    if([touch.view isKindOfClass:[UITableView class]]){
    //        return NO;
    //    }
    //  NSLog(@"frame:%@",NSStringFromCGRect(_menuview.frame));
    
    CGPoint p = [touch locationInView:_maskView];
    //NSLog(@"frame:%@",NSStringFromCGPoint(p));
    
    if(CGRectContainsPoint (_menuview.frame, p)){
        return NO;
    }
    return YES;
}


@end
