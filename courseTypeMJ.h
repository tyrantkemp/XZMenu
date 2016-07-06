//
//  courseTypeMJ.h
//  qunxin_edu
//
//  Created by 肖准 on 7/5/16.
//  Copyright © 2016 肖准. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface courseTypeMJ : NSObject

//private Long id;
///**
// * 分类名称
// */
//private String typeName;
///**
// * 父级分类
// */
//private Long parentId;
///**
// * 分类级别
// */
//private Integer level;
///**
// * 创建时间
// */
//private Date createTime;
///**
// * 更新时间
// */
//private Date updateTime;


@property(nonatomic,assign)NSInteger Id;
@property(nonatomic,assign)NSString* typeName;
@property(nonatomic,assign)NSInteger parentId;
@property(nonatomic,assign)NSInteger level;
@property(nonatomic,assign)NSString* createTime;
@property(nonatomic,assign)NSString* updateTime;
@property(nonatomic,strong)NSArray* list;

@end
