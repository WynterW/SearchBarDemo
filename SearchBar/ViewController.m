//
//  ViewController.m
//  SearchBar
//
//  Created by nil on 17/5/31.
//  Copyright © 2017年 Wynter. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UISearchResultsUpdating>
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSArray *titleAry;
@property (nonatomic, strong) NSArray *detailAry;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleAry = @[@"导航栏是否半透明度（默认为YES半透明）" ,@"是否覆盖当前的视图控制器（默认为NO不覆盖当前控制器）" ,@"搜索时是否隐藏导航栏(默认为YES)" ,@"是否包含半透明的导航栏（默认为NO）"];
    
    self.detailAry = @[@"导航栏不透明时，self.view的原点是从导航栏的底部；导航栏半透明时，self.view的原点是从导航栏的顶部。" ,@"如果在当前控制器中该属性为YES时，则将设置新的视图控制器。如果当前控制器中该属性为NO，则控制器为跟视图控制" ,@"设置为NO时，searchBar不会移动；设置为YES时,searchBar会移动到导航栏的位置，同时隐藏导航栏。" , @"此属性在导航栏为不透明的情况下才生效。设置为YES是会延伸至边界，设置为NO会空出导航栏的位置"];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    UITableViewController *searchResultsController = [[UITableViewController alloc]init];
    searchResultsController.tableView.delegate = self;
    searchResultsController.tableView.dataSource = self;
    searchResultsController.tableView.estimatedRowHeight = 80;
    searchResultsController.tableView.rowHeight = UITableViewAutomaticDimension;
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    self.searchController.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
    self.searchController.searchResultsUpdater = self;
    
    UISearchBar *bar = self.searchController.searchBar;
    bar.barTintColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0];
    bar.tintColor = [UIColor blackColor];
    bar.showsBookmarkButton = YES;
    bar.translucent = YES;
    
    UIImageView *view = [[[bar.subviews objectAtIndex:0] subviews] firstObject];
    view.layer.borderColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0].CGColor;
    view.layer.borderWidth = 1;
    
    self.tableView.tableHeaderView = bar;
    
    self.navigationController.navigationBar.translucent = NO;
    self.definesPresentationContext = YES;
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell"];
        UISwitch *switch1 = [[UISwitch alloc]init];
        [switch1 addTarget:self action:@selector(setSwitchOn:) forControlEvents:UIControlEventValueChanged];
        switch1.tag = indexPath.row + 100;
        cell.accessoryView = switch1;
        cell.textLabel.numberOfLines = 0;
        cell.detailTextLabel.numberOfLines = 0;
    }
    
    cell.textLabel.text = _titleAry[indexPath.row];
    cell.detailTextLabel.text = _detailAry[indexPath.row];
    
    UISwitch *switch1 = (UISwitch *)cell.accessoryView;
    switch (switch1.tag) {
        case 100:
            [switch1 setOn:self.navigationController.navigationBar.translucent];
            break;
        case 101:
            [switch1 setOn:self.definesPresentationContext];
            break;
        case 102:
            [switch1 setOn:self.searchController.hidesNavigationBarDuringPresentation];
            break;
        case 103:
            [switch1 setOn:self.extendedLayoutIncludesOpaqueBars];
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"SeguePage" sender:self];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    UITableViewController *vc = (UITableViewController *)self.searchController.searchResultsController;
    [vc.tableView reloadData];
}

- (void)setSwitchOn:(UISwitch *)sender {
    BOOL isOn = [sender isOn];
    switch (sender.tag) {
        case 100:
            self.navigationController.navigationBar.translucent = isOn;
            break;
        case 101:
            self.definesPresentationContext = isOn;
            break;
        case 102:
            self.searchController.hidesNavigationBarDuringPresentation = isOn;
            break;
        case 103:
            self.extendedLayoutIncludesOpaqueBars = isOn;
            break;
            
        default:
            break;
    }

    [self.tableView reloadData];

}

@end
