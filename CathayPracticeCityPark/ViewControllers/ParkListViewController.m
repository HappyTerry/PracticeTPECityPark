//
//  ParkListViewController.m
//  CathayPracticeCityPark
//
//  Created by Terry on 2018/9/9.
//  Copyright © 2018年 HappyTerry. All rights reserved.
//

#import "ParkListViewController.h"
#import "ParkTableViewCell.h"
#import <AFNetworking/AFNetworking.h>

@class ParkModel;
@class Helper;

@interface ParkListViewController ()
@property AFHTTPSessionManager * manager;
@property (nonatomic) int resultCount;
@end

@interface ParkModel:NSObject
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * introduction;
- (id)initWithData:(NSDictionary *)data;
@end

@interface Helper:NSObject
+ (NSString *)getStringValueWithColumn:(NSString *)column data:(NSDictionary *)data;
+ (int)getIntValueWithColumn:(NSString *)column data:(NSDictionary *)data;
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
    self.manager = [[AFHTTPSessionManager alloc] init];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json",@"text/plain", nil];
    self.manager.responseSerializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 300)];
}

- (void)getParkList {
    NSString *URLString = @"http://data.taipei/opendata/datalist/apiAccess";
    NSDictionary *parameters =
  @{@"scope": @"resourceAquire",
    @"rid": @"bf073841-c734-49bf-a97f-3757a6013812",
    @"limit": @"30",
    @"offset": @"0"
    };
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];
    
    [[self.manager dataTaskWithRequest:request
                        uploadProgress:nil
                      downloadProgress:nil
                     completionHandler:^(NSURLResponse * response, id responseObject, NSError * error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"response \n%@ \nresponse object \n%@", response, responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.parkList = [self handleDataWithResults:[self  resultsForResponse:responseObject]];
                [self.tableView reloadData];
            });
        }
    }] resume];
}

- (void)getMoreParks {
    NSString *URLString = @"http://data.taipei/opendata/datalist/apiAccess";
    NSDictionary *parameters =
    @{@"scope": @"resourceAquire",
      @"rid": @"bf073841-c734-49bf-a97f-3757a6013812",
      @"limit": @"30",
      @"offset": [NSString stringWithFormat:@"%lu",(unsigned long)self.parkList.count]
      };
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];
    
    [[self.manager dataTaskWithRequest:request
                        uploadProgress:nil
                      downloadProgress:nil
                     completionHandler:^(NSURLResponse * response, id responseObject, NSError * error) {
                         if (error) {
                             NSLog(@"Error: %@", error);
                         } else {
                             NSLog(@"response \n%@ \nresponse object \n%@", response, responseObject);
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 NSArray * newList = [self handleDataWithResults:[self  resultsForResponse:responseObject]];
                                 NSMutableArray * indexPaths = [NSMutableArray new];
                                 for (int i = (int)self.parkList.count; i < newList.count; i++) {
                                     NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:1];
                                     [indexPaths addObject:indexPath];
                                 }
                                 self.parkList = newList;
                                 [self.tableView performBatchUpdates:^{
                                     [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                                 } completion:nil];
                             });
                         }
                     }] resume];
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

@implementation ParkModel
- (id)init {
    self = [super init];
    if(self){
        self.name = @"";
        self.introduction = @"";
    }
    return self;
}
- (id)initWithData:(NSDictionary *)data {
    self = [self init];
    self.name = [Helper getStringValueWithColumn:@"ParkName" data:data];
    self.introduction = [Helper getStringValueWithColumn:@"Introduction" data:data];
    return self;
}
@end

@implementation Helper
+ (NSString *)getStringValueWithColumn:(NSString *)column data:(NSDictionary *)data {
    if ([data.allKeys containsObject:column]) {
        return [NSString stringWithFormat:@"%@", data[column]];
    }
    return @"";
}
+ (int)getIntValueWithColumn:(NSString *)column data:(NSDictionary *)data {
    NSString * result = [self getStringValueWithColumn:column data:data];
    if (result.length > 0) {
        return [result intValue];
    }
    return 0;
}
@end
