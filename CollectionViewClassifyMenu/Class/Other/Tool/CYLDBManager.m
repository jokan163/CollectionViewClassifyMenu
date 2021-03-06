//
//  CYLDoctorSkillDBManager.m
//  http://cnblogs.com/ChenYilong/ 
//
//  Created by https://github.com/ChenYilong on 15/4/22.
//  Copyright (c) 2015年  https://github.com/ChenYilong . All rights reserved.
//

#import "CYLDBManager.h"

NSString *const kDataSourceSectionKey     = @"Symptoms";
NSString *const kDataSourceCellTextKey    = @"Food_Name";
NSString *const kDataSourceCellPictureKey = @"Picture";

@interface CYLDBManager()

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *allTags;

@end

@implementation CYLDBManager

@synthesize dataSource = _dataSource;
@synthesize allTags = _allTags;

/**
 *  懒加载_dataSource
 *
 *  @return NSMutableArray
 */
+ (NSMutableArray *)dataSource
{
        static NSMutableArray *dataSource = nil;
        static dispatch_once_t dataSourceOnceToken;
        dispatch_once(&dataSourceOnceToken,^{
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data.json" ofType:nil];
            NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
            NSError *error;
            if (data) {
                dataSource = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            }
        });

    return dataSource;
    
}

/**
 *  懒加载_allTags
 *
 *  @return NSMutableArray
 */
+ (NSMutableArray *)allTags
{
    static NSMutableArray *allTags = nil;
    static dispatch_once_t allTagsOnceToken;
    dispatch_once(&allTagsOnceToken,^{
        allTags = [NSMutableArray array];
        [[[self class] dataSource] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            @autoreleasepool {
                NSArray *symptoms = [NSArray arrayWithArray:[obj objectForKey:kDataSourceSectionKey]];
                [symptoms enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [allTags addObject:[obj objectForKey:kDataSourceCellTextKey]];
                }];
            }
        }];
    });

    return allTags;
}

@end
