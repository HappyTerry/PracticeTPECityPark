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

@property (strong, nonatomic) NSArray * parkList;

@end
