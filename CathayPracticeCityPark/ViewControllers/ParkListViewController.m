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
    [self setupUI];
    [self setupTableView];
    
    // get data
    [self getParkList];
}

#pragma mark - Layout
- (void)setupUI {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)setupTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"ParkTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ParkCell"];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.parkList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ParkTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ParkCell"];
    ParkModel * model = self.parkList[indexPath.row];
    [cell configureCellName:model.name location:model.location behavior:model.behavior picUrl:model.picUrl];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.parkList.count - 2 &&
        [self isMoreData]) {
        [self getMoreParksFrom:(int)self.parkList.count];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat naviHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat alpha = (naviHeight - 44) / 52;
    [self.navigationController.navigationItem.titleView setAlpha:alpha];
    [self.view layoutIfNeeded];
    NSLog(@"navi bar height %f",naviHeight);
}
@end
