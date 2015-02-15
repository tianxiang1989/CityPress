//
//  ViewController.m
//  CityPress
//
//  Created by liuxq on 15-2-9.
//  Copyright (c) 2015年 liuxq. All rights reserved.
//  经验共享demo
//

#import "ViewController.h"

#pragma mark - 常量定义
//获取设备的物理高度
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//获取设备的物理宽度
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

//设定地市button的起始tag，防止0对此的影响
#define CITY_BTN_TAG_START_VALUE 10000

//设定下方imgview的起始tag，防止0对此的影响
#define CITY_IMGVIEW_TAG_START_VALUE 20000

//设置一行几个按键
const int HOW_MANY_BTN_ONE_ROW = 5;

#pragma mark - 变量定义
@interface ViewController () {
 @private
  NSArray *cityNameArray;  //地市名称数组
 @private
  NSArray *cityIdArray;  //地市id数组

 @private
  NSArray *cityPicArray;  //地市图片数组

 @private
  UIImageView *selectTipImgView;  //标示当前地市的滚动条

 @private
  UIImageView *cityImageView;  //下方sv中的地市图片UIImageView

 @private
  NSInteger svLastScrollPosition;  //保存topSv滑动/点击前的按键位置
}

/**
 *  上方的滚动栏
 */
@property(weak, nonatomic) IBOutlet UIScrollView *topSv;

/**
 *  下方的scrollView主视图
 */
@property(weak, nonatomic) IBOutlet UIScrollView *bottomSv;

@end

@implementation ViewController

#pragma mark - init method
- (void)viewDidLoad {
  [super viewDidLoad];
  [self initData];     //初始化数据
  [self initNavItem];  //初始化导航栏
  [self initView];     //初始化视图
}  // viewDidLoad

/**
 *  初始化数据
 */
- (void)initData {
  cityNameArray = @[
    @"石家庄",
    @"承德",
    @"张家口",
    @"秦皇岛",
    @"唐山",
    @"廊坊",
    @"保定",
    @"沧州",
    @"衡水",
    @"邢台",
    @"邯郸"
  ];
  cityIdArray = @[
    @"311350",
    @"314050",
    @"313500",
    @"335300",
    @"315400",
    @"316250",
    @"312002",
    @"317100",
    @"318200",
    @"319450",
    @"320150"
  ];

  cityPicArray = @[
    @"shijiazhuang.png",
    @"chende.png",
    @"zhangjiakou.png",
    @"qinhuangdao.png",
    @"tangshan.png",
    @"langfang.png",
    @"baoding.png",
    @"cangzhou.png",
    @"henshui.png",
    @"xingtai.png",
    @"handan.png"
  ];
}  // initData

#pragma mark - 导航栏部分
//初始化导航按钮
- (void)initNavItem {
  UINavigationBar *navigationBar = [[UINavigationBar alloc]
      initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 45)];
  // 把导航栏添加到视图中
  [self.view addSubview:navigationBar];

  // 把导航栏集合添加入导航栏中，设置动画打开
  [navigationBar pushNavigationItem:[self makeNavItem] animated:YES];

  [navigationBar setBackgroundImage:[UIImage imageNamed:@"topBackground"]
                      forBarMetrics:UIBarMetricsDefault];

}  // initNavItem

/**
 *  设置导航栏UINavigationItem
 *
 *  @return UINavigationItem
 */
- (UINavigationItem *)makeNavItem {
  // 创建一个导航项
  UINavigationItem *navigationItem =
      [[UINavigationItem alloc] initWithTitle:nil];
  UIView *navView =
      [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
  navView.backgroundColor = [UIColor greenColor];

  //导航栏标题
  UIButton *titleBt = [[UIButton alloc] init];
  [titleBt setFrame:CGRectMake(0, 0, 50, 20)];
  [titleBt setTitle:@"经验共享" forState:UIControlStateNormal];
  [titleBt setTintColor:[UIColor whiteColor]];

  UIButton *rightBtn = [[UIButton alloc] init];
  [rightBtn setTitle:@"发稿数:0" forState:UIControlStateNormal];
  rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];

  NSAttributedString *attributedText = [[NSAttributedString alloc]
      initWithString:rightBtn.titleLabel.text
          attributes:@{NSFontAttributeName : rightBtn.titleLabel.font}];
  CGSize stringSize =
      [attributedText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 999)
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                   context:nil].size;  //自动计算Labele的

  [rightBtn setFrame:CGRectMake(0, 0, stringSize.width, stringSize.height)];

  [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  UIBarButtonItem *rightButtonItem =
      [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
  [navigationItem setRightBarButtonItem:rightButtonItem];

  //按钮添加入导航栏集合中
  [navigationItem setRightBarButtonItem:rightButtonItem];
  [navigationItem setTitleView:titleBt];

  return navigationItem;
}  // makeNavItem


/**
 *  初始化视图部分
 */
- (void)initView {
  //---1.初始化上方sv部分---
  self.topSv.contentSize =
      CGSizeMake(SCREEN_WIDTH / HOW_MANY_BTN_ONE_ROW * cityNameArray.count, 48);
  self.topSv.showsHorizontalScrollIndicator = NO;
  self.topSv.showsVerticalScrollIndicator = YES;
  self.topSv.alwaysBounceHorizontal = YES;
  self.topSv.alwaysBounceVertical = NO;
  self.topSv.bounces = NO;
  self.topSv.backgroundColor = [UIColor purpleColor];
  self.topSv.pagingEnabled = NO;
  //  self.topSv.backgroundColor = [UIColor whiteColor];

  NSString *cityName = [[NSString alloc] init];

  UIImage *cityImg = [UIImage imageNamed:cityPicArray[0]];  //初始化第一张视图
  cityImageView = [[UIImageView alloc]
      initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,
                               SCREEN_WIDTH * 200 /
                                   480.0f)];  // img {width:480 height:200}
  [cityImageView setImage:cityImg];
  cityImageView.tag = CITY_IMGVIEW_TAG_START_VALUE + 0;
  [self.bottomSv addSubview:cityImageView];

  for (int index = 0; index < cityNameArray.count; index++) {
    cityName = cityNameArray[index];
    UIButton *cityNameBtn = [[UIButton alloc]
        initWithFrame:CGRectMake(index * SCREEN_WIDTH / HOW_MANY_BTN_ONE_ROW, 0,
                                 SCREEN_WIDTH / HOW_MANY_BTN_ONE_ROW, 42)];
    [cityNameBtn setTitle:cityName forState:UIControlStateNormal];
    if (index == 0) {
      UIImage *bottomLine = [UIImage imageNamed:@"selectTab.png"];
      selectTipImgView = [[UIImageView alloc]
          initWithFrame:CGRectMake(0, CGRectGetMaxY(cityNameBtn.frame) + 0,
                                   SCREEN_WIDTH / HOW_MANY_BTN_ONE_ROW, 3)];
      [selectTipImgView setImage:bottomLine];
      [self.topSv addSubview:selectTipImgView];
      [cityNameBtn setSelected:YES];
    }
    [cityNameBtn setTitleColor:[UIColor grayColor]
                      forState:UIControlStateNormal];
    [cityNameBtn setTitleColor:[UIColor colorWithRed:34 / 255.0
                                               green:173 / 255.0
                                                blue:241 / 255.0
                                               alpha:1]
                      forState:UIControlStateSelected];
      [cityNameBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];

    cityNameBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    //      [cityNameBtn setTintColor:[UIColor whiteColor]];
    [cityNameBtn setTitleColor:[UIColor whiteColor]
                      forState:UIControlStateNormal];

    cityNameBtn.contentHorizontalAlignment =
        UIControlContentHorizontalAlignmentCenter;
    [cityNameBtn addTarget:self
                    action:@selector(selectTopSelectButton:)
          forControlEvents:UIControlEventTouchUpInside];
    cityNameBtn.tag = index + CITY_BTN_TAG_START_VALUE;

    [self.topSv addSubview:cityNameBtn];
  }
  //---2.初始化下方sv部分---
  self.bottomSv.contentSize =
      CGSizeMake(SCREEN_WIDTH * cityNameArray.count, 45);
  self.bottomSv.directionalLockEnabled = YES;  //设置只能一个方向滚动
  self.bottomSv.bounces = NO;                  //滚动超过边界不反弹
  self.bottomSv.pagingEnabled = YES;           //页滚动
  self.bottomSv.delegate = self;
  self.bottomSv.showsHorizontalScrollIndicator = NO;  //不显示水平方向滚动条
}


#pragma mark - 上方地市按键的点击监听
/**
 *  上方滚动条中按键的点击事件
 *
 *  @param sender
 */
- (void)selectTopSelectButton:(id)sender {
  UIButton *selectBt = ((UIButton *)sender);
  NSInteger topSvCurrentIndex =
      selectBt.tag - CITY_BTN_TAG_START_VALUE;  // topSv当前选中哪个按键
  NSLog(@"选中--%@", selectBt.titleLabel.text);
  if (topSvCurrentIndex != svLastScrollPosition) {
    //根据中的按键的位置设置topSv的滚动偏移距离
    if (topSvCurrentIndex <
        HOW_MANY_BTN_ONE_ROW - 1) {  //选中左侧的按键时，topSv滚动偏移0
      [self.topSv setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (topSvCurrentIndex >=
               (cityNameArray.count - HOW_MANY_BTN_ONE_ROW +
                1)) {  //选中右侧的按键时，topSv滚动SCREEN_WIDTH /
      // HOW_MANY_BTN_ONE_ROW *(index-HOW_MANY_BTN_ONE_ROW)的距离
      [self.topSv
          setContentOffset:CGPointMake(
                               SCREEN_WIDTH / HOW_MANY_BTN_ONE_ROW *
                                   (cityNameArray.count - HOW_MANY_BTN_ONE_ROW),
                               0)
                  animated:YES];
    } else {                                           //选中中间部分的按键，向右滚动到右侧第2个位置，向左滚动到左侧第2个位置
      if (topSvCurrentIndex > svLastScrollPosition) {  //点击按键较之前靠右
        [self.topSv
            setContentOffset:CGPointMake(SCREEN_WIDTH / HOW_MANY_BTN_ONE_ROW *
                                             (topSvCurrentIndex -
                                              HOW_MANY_BTN_ONE_ROW + 2),
                                         0)
                    animated:YES];
      } else {  //点击按键较之前靠左
        [self.topSv
            setContentOffset:CGPointMake(SCREEN_WIDTH / HOW_MANY_BTN_ONE_ROW *
                                             (topSvCurrentIndex - 1),
                                         0)
                    animated:YES];
      }
    }

    //滑动动画
    [UIImageView beginAnimations:nil context:nil];
    [UIImageView setAnimationDuration:0.5];
    selectTipImgView.frame = CGRectMake(
        selectBt.frame.origin.x, CGRectGetMinY(selectTipImgView.frame),
        CGRectGetWidth(selectTipImgView.frame),
        CGRectGetHeight(selectTipImgView.frame));
    [UIImageView commitAnimations];

    [self clearCityBtnSelected]; //取消其他按键的选中状态
    [self performSelector:@selector(animationTickDone:)
               withObject:selectBt
               afterDelay:0.5];  //动画执行完毕的动作
    svLastScrollPosition = topSvCurrentIndex;
  }
}  // selectTopSelectButton

/**
 *  动画执行完毕，让顶部的地市指示器选中指定的地市
 *
 *  @param selectBt
 */
- (void)animationTickDone:(UIButton *)selectBt {
  [self clearCityBtnSelected]; //取消其他按键的选中状态,防止因点击过快导致两个btn为选中的状态
  [selectBt setSelected:YES];
  NSInteger topSvCurrentIndex = selectBt.tag - CITY_BTN_TAG_START_VALUE;

  if (![self.bottomSv
          viewWithTag:
              (CITY_IMGVIEW_TAG_START_VALUE +
               topSvCurrentIndex)]) {  //考虑性能，保证sv中每一个页面的图片都是单例的
    cityImageView = [[UIImageView alloc]
        initWithFrame:CGRectMake(topSvCurrentIndex * SCREEN_WIDTH, 0,
                                 CGRectGetWidth(cityImageView.bounds),
                                 CGRectGetHeight(cityImageView.bounds))];
    cityImageView.tag = CITY_IMGVIEW_TAG_START_VALUE + topSvCurrentIndex;
    [self.bottomSv addSubview:cityImageView];
  }
  UIImage *cityImg = [UIImage imageNamed:cityPicArray[topSvCurrentIndex]];
  [cityImageView setImage:cityImg];
  [self.bottomSv setContentOffset:CGPointMake(topSvCurrentIndex * SCREEN_WIDTH, 0)
                         animated:YES];  //设置下方sv的偏移
}  // animationTickDone

/**
 *  取消其他按键的选中状态
 */
- (void)clearCityBtnSelected {
    for (UIView *view in [self.topSv subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            [(UIButton *)view setSelected:NO];
        }
    }
} //clearCityBtnSelected

#pragma mark - 下方sv的滑动监听

/**
 *  Tells the delegate that the scroll view has ended decelerating the scrolling
 *movement.
 *
 *  @param scrollView 控制的UIScrollView
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int currentPageIndex =
    scrollView.contentOffset.x / SCREEN_WIDTH;  //当前滑动到哪个页面
    if (currentPageIndex != svLastScrollPosition) {
        UIButton *selectBt = (UIButton *)
        [self.topSv viewWithTag:currentPageIndex + CITY_BTN_TAG_START_VALUE];
        NSLog(@"滑动选中--%@", selectBt.titleLabel.text);
        [self selectTopSelectButton:selectBt];
    }
} //scrollViewDidEndDecelerating

@end
