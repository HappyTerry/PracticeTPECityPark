//
//  ParkListViewController.h
//  CathayPracticeCityPark
//
//  Created by Terry on 2018/9/9.
//  Copyright © 2018年 HappyTerry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParkListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) NSArray * parkList;
@property (strong, nonatomic) UIView * headerView;

@end
