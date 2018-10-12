//
//  ParkListViewController.m
//  CathayPracticeCityPark
//
//  Created by Terry on 2018/9/9.
//  Copyright © 2018年 HappyTerry. All rights reserved.
//

#import "ParkListViewController.h"
#import "ParkTableViewCell.h"

#import "ParkModel.h"
#import "Helper.h"
#import "ParkManager.h"

@interface ParkListViewController ()
@property ParkManager * manager;
@property (nonatomic) int resultCount;
@end

@implementation ParkListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.parkList = [NSArray new];
    [self setupAPI];
    
    // setup ui
    [self setupTableView];
    
    // get data
    [self getParkList];
}

#pragma mark - Layout
- (void)setupTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"ParkTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ParkCell"];
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 40)];
    [self.headerView setBackgroundColor:[UIColor whiteColor]];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
    [label setText:@"台北市公園景點"];
    [label setFont:[UIFont fontWithName:@"PingFangTC-Medium" size:17]];
    [self.headerView addSubview:label];
    [self.headerView setAlpha:0];
}

#pragma mark - API
- (void)setupAPI {
    //AFNetwork manager initial
    self.manager = [[ParkManager alloc] init];
}

- (void)getParkList {
    [self.manager getListWithLimit:30
                            offset:0
                 completionHandler:^(NSDictionary * result) {
        self.parkList = [self handleDataWithResults:[self  resultsForResponse:result]];
        [self.tableView reloadData];
    }];
}

- (void)getMoreParksFrom:(int)offset {
    [self.manager getListWithLimit:30
                            offset:offset
                 completionHandler:^(NSDictionary * result) {
                     NSArray * newList = [self handleDataWithResults:[self resultsForResponse:result]];
                     NSMutableArray * indexPaths = [NSMutableArray new];
                     for (int i = (int)self.parkList.count; i < newList.count; i++) {
                         NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                         [indexPaths addObject:indexPath];
                     }
                     self.parkList = newList;
                     [self.tableView performBatchUpdates:^{
                         [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                     } completion:nil];
                 }];
}

#pragma mark - private
- (float)stringHeightWithText:(NSString *)text font:(UIFont *)font size:(CGSize)size {
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize resultSize = [text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
    return resultSize.height + 5;
}

- (NSArray *)resultsForResponse:(NSDictionary *)responseObject{
    if([responseObject isKindOfClass:[NSDictionary class]] &&
       [responseObject.allKeys containsObject:@"result"]) {
        NSDictionary * result = responseObject[@"result"];
        if([result isKindOfClass:[NSDictionary class]] &&
           [result.allKeys containsObject:@"results"]){
            self.resultCount = [Helper getIntValueWithColumn:@"count" data:result];
            NSArray * results = result[@"results"];
            if([results isKindOfClass:[NSArray class]]){
                return results;
            }
        }
    }
    return @[];
}

- (NSArray *)handleDataWithResults:(NSArray *)results {
    NSMutableArray * datas = [NSMutableArray arrayWithArray:self.parkList];
    for (NSDictionary * park in results) {
        if ([park isKindOfClass:[NSDictionary class]]) {
            ParkModel * model = [[ParkModel alloc] initWithData:park];
            [datas addObject:model];
        }
    }
    return [NSArray arrayWithArray:datas];
}

- (BOOL)isMoreData {
    if (self.parkList.count < self.resultCount) {
        return YES;
    }
    return NO;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 0;
            
        default:
            return self.parkList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            return [UITableViewCell new];
        }
        default:
        {
            ParkTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ParkCell"];
            ParkModel * model = self.parkList[indexPath.row];
            [cell configureCellName:model.name intro:model.introduction];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 &&
        indexPath.row == self.parkList.count - 2 &&
        [self isMoreData]) {
        [self getMoreParks];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 40;
            
        default:
            return 40;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            return 40;
        }
        default:
        {
            ParkModel * model = self.parkList[indexPath.row];
            CGSize labelSize = CGSizeMake(tableView.frame.size.width - 20, MAXFLOAT);
            return 50 + [self stringHeightWithText:model.introduction font:[UIFont fontWithName:@"PingFangTC-Regular" size:17] size:labelSize];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
        {
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
            [view setBackgroundColor:[UIColor clearColor]];
            return view;
        }
        default:
        {
            return self.headerView;
        }
    }
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > 40) {
        [self.headerView setAlpha:1];
        [self.titleLabel setAlpha:0];
    } else {
        CGFloat alpha = scrollView.contentOffset.y / 40;
        [self.headerView setAlpha:alpha];
        [self.titleLabel setAlpha:(1 - alpha)];
    }
    [self.view layoutIfNeeded];
}
@end
