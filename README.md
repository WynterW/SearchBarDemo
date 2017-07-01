# searchBarDemo
相信很多朋友都在使用`UISearchController`总会遇到一些莫名其妙的问题，当然我也遇到了，下面就记录下使用`UISearchController`中遇到问题部分问题。

初始代码：
```obj 

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
    
```
### 问题1：点击搜索框时searchResultsController和searchBar间隔44px，并且点击跳转无响应，如下图：
![问题1.gif](http://upload-images.jianshu.io/upload_images/937490-9a01655d2ac2e824.gif?imageMogr2/auto-orient/strip)

解决办法，添加代码：
```obj
    self.definesPresentationContext = YES;
```

### 问题2：在设置导航栏为不透明时，点击搜索时searchBar偏移出屏幕

解决办法同上

### 问题3：在设置导航栏为不透明时，点击搜索框出现如下情况：
![问题3.gif](http://upload-images.jianshu.io/upload_images/937490-799753f433a621eb.gif?imageMogr2/auto-orient/strip)

解决办法，添加代码：
```obj
    self.extendedLayoutIncludesOpaqueBars = YES;
```

### 属性介绍：

```obj
    // 导航栏是否为半透明
    self.navigationController.navigationBar.translucent = YES;
    // 如果在当前控制器中该属性为YES时，则将设置新的视图控制器。如果当前控制器中该属性为NO，则控制器为跟视图控制
    self.definesPresentationContext = NO;
    // 是否隐藏navigationBar
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    // 延伸视图包是否含不透明的bar
    self.extendedLayoutIncludesOpaqueBars = NO;
    
```
### 引起问题的原因：
- 出现searchResultsController和searchBar间隔44px的原因就在于，UISearchController有个`hidesNavigationBarDuringPresentation`属性，其默认值为YES，就是在点击searchBar时进行搜索时会将导航栏隐藏，并将searchBar移动到navigationBar的位置处，而tableView并不知道searchBar已经移动到navigationBar的位置所以就多出了44px；
- 在searchResultsController中点击cell无法跳转是因为searchResultsController并不是主视图，而在设置`self.definesPresentationContext = YES`后，系统会将searchResultsController设置为新的主视图；
- 在设置导航栏为不透明时（`self.navigationController.navigationBar.translucent = NO`），点击搜索时searchBar偏移出屏幕，导航栏不透明时，self.view的原点是从导航栏的底部，那么相对self.view而言navigationBar的x=-64，所以搜searchBar弹出时获取`     self.navigationController.navigationBar.x = searchBar.x;`,此navigationBar已经隐藏，searchBar.x = -64这个时候就会偏移出屏幕。
- 那么到searchBar向下偏移64px原理同上。

### 总结：
可能有些地方解释的不到位，欢迎大家指正。
