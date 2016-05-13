//
//  MyDisplayViewController.m
//  Meet
//
//  Created by jiahui on 16/5/13.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "MyDisplayViewController.h"
#import "MoreProfileViewController.h"
#import "UIView+frameAdjust.h"

#import "CTTextView.h"
#import "CTFrameParserConfig.h"
#import "CoreTextData.h"
#import "CTFrameParser.h"
#import "UIImageView+MHFacebookImageViewer.h"

@interface MyDisplayViewController () {
    
    __weak IBOutlet UIScrollView *scrollView;
    NSInteger _scrollViewContentHeight;
    NSMutableDictionary *_dicContentImages;
    
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewConstraintH;


@property (weak, nonatomic) IBOutlet CTTextView *ctView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ctviewHConstraint;

@end
@implementation MyDisplayViewController

#define SECTION_MARGIN  12
#define VIEW_MARGIN     5
#define IMAGEVIEW_X     5
#define IMAGAVIEW_W     (self.view.width - 2*IMAGEVIEW_X)
//#define IMAGEVIEW_H     IMAGAVIEW_W

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人介绍";
    [UITools customNavigationLeftBarButtonForController:self action:@selector(backAction:)];
    [UITools navigationRightBarButtonForController:self action:@selector(editAction:) normalTitle:@"编辑" selectedTitle:nil];
    self.hidesBottomBarWhenPushed = YES;
    _dicContentImages = [NSMutableDictionary dictionary];
    [self loadDocumentGetAllBigImages];
    
    _scrollViewContentHeight = 10;
    
//    CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
//    config.width = self.view.width;
////    CoreTextData *data = [CTFrameParser parseContent:@"至若春和景明，波澜不惊，上下天光，一碧万顷；沙鸥翔集，锦鳞游泳，岸芷(zhǐ）汀（tīng）兰，郁郁青青。而或长烟一空，皓月千里，浮光跃金，静影沉璧；渔歌互答，此乐何极！登斯楼也，则有心旷神怡，宠辱偕忘，把酒临风，其喜洋洋者矣。\n 嗟(jiē)夫（fú）！予(yú)尝求古仁人之心，或异二者之为，何哉（zāi)？　不以物喜，不以己悲；\n居庙堂之高则忧其民；处（chǔ）江湖之远则忧其君。是进亦忧，退亦忧。然则何时而乐耶？\n其必曰：“先天下之忧而忧，后天下之乐而乐”乎。噫（yī）！微斯人，吾谁与归？" config:config];
//    
//    NSString *content = @"岳阳楼记\n至若春和景明，波澜不惊，上下天光，一碧万顷；沙鸥翔集，锦鳞游泳，岸芷(zhǐ）汀（tīng）兰，郁郁青青。而或长烟一空，皓月千里，浮光跃金，静影沉璧；渔歌互答，此乐何极！登斯楼也，则有心旷神怡，宠辱偕忘，把酒临风，其喜洋洋者矣。\n 嗟(jiē)夫（fú）！予(yú)尝求古仁人之心，或异二者之为，何哉（zāi)？　不以物喜，不以己悲；\n居庙堂之高则忧其民；处（chǔ）江湖之远则忧其君。是进亦忧，退亦忧。然则何时而乐耶？\n其必曰：“先天下之忧而忧，后天下之乐而乐”乎。噫（yī）！微斯人，吾谁与归？";
//    NSDictionary *attr  = [CTFrameParser attributesWithConfig:config];
//    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:content attributes:attr];
//    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, 3)];
//    CoreTextData *data = [CTFrameParser parseAttributedContent:attStr config:config];
//    
//    self.ctView.data = data;
//    _ctviewHConstraint.constant = data.height;
//    self.ctView.backgroundColor = [UIColor yellowColor];

    [self loadCoreTextViewAndImageViews];
    _scrollViewConstraintH.constant = _scrollViewContentHeight + 10;
}

- (void)loadCoreTextViewAndImageViews {
    for (NSInteger i = 0; i < 4; i++) {
        _scrollViewContentHeight += SECTION_MARGIN;
        CTTextView *coreTextView = [[CTTextView alloc] init];//
        CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
        config.width = IMAGAVIEW_W;
        NSString *content = @"岳阳楼记\n\n至若春和景明，波澜不惊，上下天光，一碧万顷；沙鸥翔集，锦鳞游泳，岸芷(zhǐ）汀（tīng）兰，郁郁青青。而或长烟一空，皓月千里，浮光跃金，静影沉璧；渔歌互答，此乐何极！登斯楼也，则有心旷神怡，宠辱偕忘，把酒临风，其喜洋洋者矣。\n 嗟(jiē)夫（fú）！予(yú)尝求古仁人之心，或异二者之为，何哉（zāi)？　不以物喜，不以己悲；\n居庙堂之高则忧其民；处（chǔ）江湖之远则忧其君。是进亦忧，退亦忧。然则何时而乐耶？\n其必曰：“先天下之忧而忧，后天下之乐而乐”乎。噫（yī）！微斯人，吾谁与归？";
        NSDictionary *attr  = [CTFrameParser attributesWithConfig:config];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:content attributes:attr];
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, 4)];
        [attStr addAttribute:NSBackgroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(4, content.length - 4)];
        
        CoreTextData *data = [CTFrameParser parseAttributedContent:attStr config:config];
        coreTextView.data = data;
        coreTextView.backgroundColor = [UIColor whiteColor];
        coreTextView.frame = CGRectMake(IMAGEVIEW_X, _scrollViewContentHeight, IMAGAVIEW_W, data.height);
        [scrollView addSubview:coreTextView];
        _scrollViewContentHeight += data.height;
        [self loadImageViewsWithSection:i];
    }
}

- (void)loadImageViewsWithSection:(NSInteger)section {
    NSArray *imageArray = _dicContentImages[[NSNumber numberWithInt:section]];
    [imageArray enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL * stop) {
        CGSize size = image.size;
        CGFloat scale = size.width/IMAGAVIEW_W;
        CGFloat h = size.height/scale;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(IMAGEVIEW_X, _scrollViewContentHeight + VIEW_MARGIN, IMAGAVIEW_W, h)];
        imageView.image = image;
        [imageView setupImageViewer];
        [scrollView addSubview:imageView];
        _scrollViewContentHeight += (imageView.height + VIEW_MARGIN);
    }];
}

- (void)reloadScrollView {
    [self loadDocumentGetAllBigImages];
    _scrollViewContentHeight = 10;
    [self loadCoreTextViewAndImageViews];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
}

#pragma  mark - files Data
- (void)loadDocumentGetAllBigImages {////获取cell 2里的image
    [_dicContentImages removeAllObjects];
    NSMutableArray *array = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *mostContetPath = [[AppData shareInstance] getCacheMostContetnImagePath];
        NSArray *mostContetImagesDocArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:mostContetPath error:nil];
        [mostContetImagesDocArray enumerateObjectsUsingBlock:^(NSString *section, NSUInteger idx, BOOL *stop) {
            NSString *sectionPath = [mostContetPath stringByAppendingPathComponent:section];
            NSArray *rowConttArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sectionPath error:nil];
            [rowConttArray enumerateObjectsUsingBlock:^(NSString *row, NSUInteger idx, BOOL *stop) {
                
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row.intValue inSection:section.intValue];
                NSLog(@"path indePath Section :%ld, row :%ld",(long)indexPath.section, (long)indexPath.row);
                [array addObject:indexPath];
            }];
        }];
        [self loadAllBigImagesInCacheWithIndexPathArry:array];
    });
}

- (void)loadAllBigImagesInCacheWithIndexPathArry:(NSArray *)array {
    [array enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
        NSString *path = [[AppData shareInstance] getCachesBigImageWithImageIndexPath:indexPath];
        NSArray *imagesName = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
        NSMutableArray *array = [NSMutableArray array];
        [imagesName enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
            NSString *imagePath = [path stringByAppendingPathComponent:name];
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            [array addObject:image];
        }];
        [_dicContentImages setObject:array forKey:[NSNumber numberWithInt:indexPath.section]];
    }];
}

#pragma mark - action
- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editAction:(id)sender {
    ///填写更多个人信息
    UIStoryboard *meStoryBoard = [UIStoryboard storyboardWithName:@"Me" bundle:[NSBundle mainBundle]];
    MoreProfileViewController *moreVC = [meStoryBoard instantiateViewControllerWithIdentifier:@"MoreProfileViewController"];
    moreVC.modifyBlock = ^(){
        
    };
    moreVC.editType = 1;
    [self.navigationController pushViewController:moreVC animated:YES];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushToMyDisplayVC"]) {
        
    }
}

@end
