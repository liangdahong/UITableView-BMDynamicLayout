//
//  AppDelegate.m
//  BMDragCellCollectionViewDemo
//
//  Created by __liangdahong on 2017/7/17.
//  Copyright © 2017年 http://idhong.com. All rights reserved.
//

#import "AppDelegate.h"
#import "BMHomeVC.h"
#import "YYFPSLabel.h"
#import "UITableViewDynamicLayoutCacheHeight.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    // UITableViewDynamicLayoutCacheHeight.debugLog = NO;

    BMHomeVC *vc = BMHomeVC.new;
    vc.dataArray = self.dataArray;
    UINavigationController *nav   = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.translucent = NO;
    nav.navigationBar.hidden      = NO;
    self.window.rootViewController = nav;

    YYFPSLabel *label = [YYFPSLabel new];
    label.frame = CGRectMake(10, 20, 60, 20);
    [self.window addSubview:label];

    return YES;
}

#pragma mark - 构造数据

- (NSMutableArray<BMGroupModel *> *)dataArray {

    NSMutableArray<BMGroupModel *> * _dataArray = [@[] mutableCopy];
    int arc = arc4random_uniform(10)+4;
    while (arc--) {
        NSMutableArray *arr1 = @[].mutableCopy;
        int arc1 = arc4random_uniform(3)+10;
        while (arc1--) {
            BMModel *model = [BMModel new];
            model.icon = [NSString stringWithFormat:@"%d.png", arc4random_uniform(30) + 1];
            UIImage *img = [UIImage imageNamed:model.icon];
            CGFloat imageWidth = img.size.width;
            CGFloat imageHeight = img.size.height;

            CGFloat screenWidth = MIN(UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width)-20;

            CGFloat modelWidth = 0;
            CGFloat modelHeight = 0;

            if (imageWidth <= screenWidth) {
                modelWidth = imageWidth;
                modelHeight = imageHeight;
            } else {
                modelWidth = screenWidth;
                modelHeight = imageHeight * (screenWidth/imageWidth);
            }
            model.size = CGSizeMake(modelWidth, modelHeight);
            [arr1 addObject:model];
        }
        BMGroupModel *obj = BMGroupModel.new;
        obj.modelArray = arr1.mutableCopy;
        [_dataArray addObject:obj];
    }

    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"text"];
    NSString *string = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSArray <NSDictionary *> *arr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:NULL];

    __block NSInteger count = 0;
    [_dataArray enumerateObjectsUsingBlock:^(BMGroupModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.headerTitle = arr[(unsigned long)arc4random_uniform((unsigned int)arr.count)][@"title"];
        obj.footerTitle = arr[(unsigned long)arc4random_uniform((unsigned int)arr.count)][@"artist"];
        [obj.modelArray enumerateObjectsUsingBlock:^(BMModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (count > arr.count) {
                obj.name =  arr[(unsigned long)arc4random_uniform((unsigned int)arr.count)][@"title"];
                obj.desc =  arr[(unsigned long)arc4random_uniform((unsigned int)arr.count)][@"summary"];
            } else {
                obj.name =  arr[(unsigned long)arc4random_uniform((unsigned int)count)][@"title"];
                obj.desc =  arr[(unsigned long)arc4random_uniform((unsigned int)arr.count)][@"summary"];
            }
            obj.size = CGSizeMake(obj.size.width*.4, obj.size.height*.4);
            count++;
        }];
    }];
    return _dataArray;
}

@end
