//
//  BaiduMapVC.m
//  kaixun
//
//  Created by 张凯 on 2018/3/15.
//  Copyright © 2018年 zhangkai. All rights reserved.
//

#import "BaiduMapVC.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>

@interface BaiduMapVC ()<BMKMapViewDelegate, BMKPoiSearchDelegate,BMKSuggestionSearchDelegate,BMKLocationServiceDelegate,UISearchBarDelegate>
{
//    BMKSuggestionSearch *_searcher;//建议搜索
    UISearchBar *_searchBar;
    NSString *_searchText;
    CGFloat _statuBarHeight;
    BMKAnnotationView *_currentAnnotationView;
}
@property (nonatomic,strong) BMKMapView *mapView;//地图视图
@property (nonatomic,strong) BMKLocationService *service;//定位服务
@property (nonatomic,strong) BMKPoiSearch *poiSearch;//搜索服务
@property (nonatomic,strong) NSMutableArray *dataArray;


@end

@implementation BaiduMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"空间";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithDecimalRed:0 green:175 blue:240 alpha:1];
    
    _statuBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, _statuBarHeight, SCREEN_WIDTH - 50, 44)];
    _searchBar.placeholder = @"输入药店名称或地址";
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor colorWithRed:67/255.0 green:74/255.0 blue:84/255.0 alpha:1];
    
    searchField.font = [UIFont systemFontOfSize:15];
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];
    [_searchBar becomeFirstResponder];
    //取消按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, _statuBarHeight, 50, 44)];
    [cancelBtn setTitleColor:[UIColor colorWithDecimalRed:0 green:175 blue:240 alpha:1] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelSearch:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:cancelBtn];
    
    //初始化地图
    self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 44+_statuBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-_statuBarHeight-44)];
    self.mapView.delegate =self;
    //设置地图的显示样式
    self.mapView.mapType = BMKMapTypeStandard;//标准地图

    //设定地图是否打开路况图层
    self.mapView.trafficEnabled = YES;

    //底图poi标注
    self.mapView.showMapPoi = YES;

    //在手机上当前可使用的级别为3-21级
    self.mapView.zoomLevel = 13;

    //设定地图View能否支持旋转
    self.mapView.rotateEnabled = NO;

    //设定地图View能否支持用户移动地图
    self.mapView.scrollEnabled = YES;

    //添加到view上
    [self.view addSubview:self.mapView];

    //初始化定位
    self.service = [[BMKLocationService alloc] init];
    self.service.delegate = self;

    //开启定位
    [self.service startUserLocationService];

    //初始化搜索
    self.poiSearch =[[BMKPoiSearch alloc] init];
    self.poiSearch.delegate = self;
    
    //跳转动画
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.navigationController.navigationBarHidden = YES;
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.poiSearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.service.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    self.navigationController.navigationBarHidden = NO;
    self.mapView.delegate = nil; // 不用时，置nil
    self.poiSearch.delegate = nil; // 不用时，置nil
    self.service.delegate = nil;

}

- (void)cancelSearch:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;{
    _searchText = searchBar.text;
    [self updateBMKuserLocation:self.service.userLocation];
    [_searchBar resignFirstResponder];
    
}

//更新搜索条件
- (void)updateBMKuserLocation:(BMKUserLocation *)userLocation{
    //展示定位
    self.mapView.showsUserLocation = YES;
    
    //更新位置数据
    [self.mapView updateLocationData:userLocation];
    
    
    //获取用户的坐标
    self.mapView.centerCoordinate = userLocation.location.coordinate;
    
    self.mapView.zoomLevel =18;
    
    if (_searchText.length>0) {
        //初始化一个周边云检索对象
        BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc] init];
        //索引 默认为0
        option.pageIndex = 0;
        //页数默认为10
        option.pageCapacity = 10;
        //搜索半径
        option.radius = 100000;
        //检索的中心点，经纬度
        option.location = userLocation.location.coordinate;
        //搜索的关键字
        option.keyword = _searchText;
        //根据中心点、半径和检索词发起周边检索
        BOOL flag = [self.poiSearch poiSearchNearBy:option];
        if (flag) {
            NSLog(@"搜索成功");
            //关闭定位
            [self.service stopUserLocationService];
        }
        else {
            NSLog(@"搜索失败");
        }
    }
}


#pragma mark -------BMKLocationServiceDelegate
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    [self updateBMKuserLocation:userLocation];
    
}
#pragma mark -------BMKPoiSearchDelegate
/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    
    //若搜索成功
    if (errorCode ==BMK_SEARCH_NO_ERROR) {
        [self.dataArray removeAllObjects];
        
        //POI信息类
        //poi列表
        for (BMKPoiInfo *info in poiResult.poiInfoList) {
            
            [self.dataArray addObject:info];
            
            //初始化一个点的注释 //只有三个属性
            BMKPointAnnotation *annotoation = [[BMKPointAnnotation alloc] init];
            
            //坐标
            annotoation.coordinate = info.pt;
            
            //title
            annotoation.title = info.name;
            
            //子标题
            annotoation.subtitle = info.address;
            
            //将标注添加到地图上
            [self.mapView addAnnotation:annotoation];
        }
    }
}
/**
 *返回POI详情搜索结果
 *@param searcher 搜索对象
 *@param poiDetailResult 详情搜索结果
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiDetailResult:(BMKPoiSearch *)searcher result:(BMKPoiDetailResult *)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode {
    
    NSLog(@"%@",poiDetailResult.name);
    
}
#pragma mark -------------BMKMapViewDelegate

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    
//    //如果是注释点
//    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
//
//        //根据注释点,创建并初始化注释点视图
//        BMKPinAnnotationView  *newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"an"];
//
//        //设置大头针的颜色
//        newAnnotation.pinColor = BMKPinAnnotationColorPurple;
//
//        //设置动画
//        newAnnotation.animatesDrop = YES;
//
//        return newAnnotation;
//
//    }
//
//    return nil;
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    annotationView.image = [UIImage imageNamed:@"s260_tianjiayaodian_yaodian"];
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    
    return annotationView;
}

/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    
    view.image = [UIImage imageNamed:@"s260_list_yaodian_s"];
    if (_currentAnnotationView) {
        _currentAnnotationView.image = [UIImage imageNamed:@"s260_tianjiayaodian_yaodian"];
    }
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
    _currentAnnotationView = view;
    
    //poi详情检索信息类
    BMKPoiDetailSearchOption *option = [[BMKPoiDetailSearchOption alloc] init];


    BMKPoiInfo *info = self.dataArray.firstObject;

    //poi的uid，从poi检索返回的BMKPoiResult结构中获取
    option.poiUid = info.uid;

    /**
     *根据poi uid 发起poi详情检索
     *异步函数，返回结果在BMKPoiSearchDelegate的onGetPoiDetailResult通知
     *@param option poi详情检索参数类（BMKPoiDetailSearchOption）
     *@return 成功返回YES，否则返回NO
     */
    BOOL flag = [self.poiSearch poiDetailSearch:option];

    if (flag) {
        NSLog(@"检索成功");
    }
    else {

        NSLog(@"检索失败");
    }
    
    
    
}




- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
