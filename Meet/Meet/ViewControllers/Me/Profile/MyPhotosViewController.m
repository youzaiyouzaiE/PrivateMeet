//
//  MyPhotosViewController.m
//  Meet
//
//  Created by jiahui on 16/4/30.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "MyPhotosViewController.h"
#import "MWPhotoBrowser.h"
#import "PhotosGridViewController.h"
#import "MyPhotoItem.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define LINE_Items      3
//#define MAX_IMAGES      8


@interface MyPhotosViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,MWPhotoBrowserDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PhotoGridDelegate,photoItemDelegate> {
    NSMutableArray *_imageItemsArray;
    NSMutableArray *_imagesNameArray;
    NSMutableArray *_arrayContentImages;
    
    BOOL isEditType;
    
    UIActionSheet *_sheetAction;
    
    NSString *_smallImageDocumetPath;
    NSString *_bigImageDocumetPath;
    BOOL _isChangedImage;
}


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *photos;
@property (nonatomic, strong) PHCachingImageManager *imageManager;

@end

@implementation MyPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的图片";
    _imageItemsArray = [NSMutableArray array];
    _imagesNameArray = [NSMutableArray array];
//    imageDocument = FORMAT(@"image%@",[UserInfo shareInstance].userId);
    
    [UITools customNavigationLeftBarButtonForController:self action:@selector(backAction:)];
    [UITools navigationRightBarButtonForController:self action:@selector(editAction:) normalTitle:@"编辑" selectedTitle:@"完成"];
    _smallImageDocumetPath = [[AppData shareInstance] getCachesSmallImageWithImageIndexPath:_selectIndexPath];
    _bigImageDocumetPath = [[AppData shareInstance] getCachesBigImageWithImageIndexPath:_selectIndexPath];
    
    [self checkDocumentGetSmallImages];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 2;
    flowLayout.minimumInteritemSpacing = 2;
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 2, 5, 2);
    flowLayout.itemSize = CGSizeMake((self.view.bounds.size.width -10)/LINE_Items, (self.view.bounds.size.width -10)/LINE_Items);
    _collectionView.collectionViewLayout = flowLayout;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkDocumentGetSmallImages {
    [_imageItemsArray removeAllObjects];
    
    NSArray *smallImageParthArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_smallImageDocumetPath error:nil];
    [smallImageParthArray enumerateObjectsUsingBlock:^(NSString *fileName, NSUInteger idx, BOOL * stop) {
        UIImage *image = [UIImage imageWithContentsOfFile:[_smallImageDocumetPath stringByAppendingPathComponent:fileName]];
        [_imageItemsArray addObject:image];
        [_imagesNameArray addObject:fileName];
    }];
}

#pragma mark - Action 
- (void)backAction:(id)sender {
    if (_isChangedImage) {
        self.updateBlock(YES);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editAction:(UIButton *)button {
    button.selected = !button.selected;
    isEditType = button.selected;
    [self.collectionView reloadData];
}

- (void)photoItemButtonAction:(NSInteger)selectIndex {
    NSString *realName = _imagesNameArray[selectIndex - 1];
    [self deleteImageWithName:realName atItemsArrayLocation:selectIndex - 1];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imageItemsArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *const reuseIdentifier = @"myImageItem";
    MyPhotoItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.index = indexPath.row;
    UIImageView *imageView = [cell viewWithTag:1];
    UIButton *button = [cell viewWithTag:2];
    isEditType ? (button.hidden = NO) :(button.hidden = YES);
    if (indexPath.row == 0) {
        imageView.image = [UIImage imageNamed:@"camera"];
        button.hidden = YES;
    } else {
        imageView.image = _imageItemsArray[indexPath.row - 1];
    }
    return cell;
}

#pragma mark <UICollectionViewDelegate>
// Uncomment this method to specify if the specified item should be selected
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (_imageItemsArray.count == _maxIamges) {
            [[UITools shareInstance] showMessageToView:self.view message:[NSString stringWithFormat:@"最多选择%ld张图片",(long)_maxIamges] autoHide:YES];
            return ;
        }
        [self createSheetAction];
    } else {
        NSMutableArray *photos = [NSMutableArray array];
        NSArray *sourceArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_bigImageDocumetPath error:nil];
        for (NSString *sourceStr in sourceArray) {
            NSString *bigImagePath = [_bigImageDocumetPath stringByAppendingPathComponent:sourceStr];
            UIImage *image = [UIImage imageWithContentsOfFile:bigImagePath];
            [photos addObject:[MWPhoto photoWithImage:image]];
        }
        _photos = photos;
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = NO;
        browser.displayNavArrows = NO;
        browser.displaySelectionButtons = NO;
        browser.alwaysShowControls = NO;
        browser.zoomPhotosToFill = YES;
        browser.enableGrid = NO;
        browser.startOnGrid = NO;
        browser.enableSwipeToDismiss = YES;
        browser.autoPlayOnAppear = NO;
        [browser setCurrentPhotoIndex:indexPath.row - 1];
        [self.navigationController pushViewController:browser animated:YES];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)createSheetAction {
    if (!_sheetAction) {
        _sheetAction = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"cancel") destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    [_sheetAction showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        imagePickerController.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        imagePickerController.navigationBar.titleTextAttributes = self.navigationController.navigationBar.titleTextAttributes;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];
    } else {
        
//        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//        imagePickerController.delegate = self;
//        imagePickerController.allowsEditing = YES;
//        imagePickerController.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
//        imagePickerController.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
//        imagePickerController.navigationBar.titleTextAttributes = self.navigationController.navigationBar.titleTextAttributes;
//        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//        imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
//        [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];
        
        PhotosGridViewController *photoGridVC = [[PhotosGridViewController alloc] init];
        photoGridVC.delegate = self;
        photoGridVC.maxSelected = _maxIamges;
        photoGridVC.alreadyHaveNum = _imageItemsArray.count;
        UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:photoGridVC];
        [self presentViewController:navigationVC animated:YES completion:^{
            
        }];
    }
}

#pragma mark - PhotoGridDelegate
- (void)photoGrid:(PhotosGridViewController *)grid selectedAset:(NSArray *)assets {
    if (!_imageManager) {
        self.imageManager = [[PHCachingImageManager alloc] init];
    }
    PHImageRequestOptions *option = [PHImageRequestOptions new];
    option.synchronous = YES;
    [assets enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * stop) {
        [self.imageManager requestImageForAsset:asset
                                     targetSize:[self imageAssetSize:asset]
                                    contentMode:PHImageContentModeAspectFill
                                        options:option
                                  resultHandler:^(UIImage *result, NSDictionary *info) {
                                      [self saveImageToDocument:result imageName:[AppData random_uuid]];
                                  }];
    }];
    [self.collectionView reloadData];
}

- (void)saveImageToDocument:(UIImage *)image imageName:(NSString *)name {
    _isChangedImage = YES;
    UIImage *imageSmall = [UITools imageWithImageSimple:image scaledToSize:[self smallSize]];
    [_imageItemsArray addObject:imageSmall];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *bigImageSavePath = [_bigImageDocumetPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.JPG",name]];
        NSString *smallImageSavePath = [_smallImageDocumetPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.JPG",name]];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        if ([imageData writeToFile:bigImageSavePath atomically:NO]) {
            [_imagesNameArray addObject:[NSString stringWithFormat:@"%@.JPG",name]];
                         NSLog(@"存入文件 成功！");
        } else {
            NSLog(@"图片未能存入");
        }
        NSData *smallImageData = UIImageJPEGRepresentation(imageSmall, 1);
        if ([smallImageData writeToFile:smallImageSavePath atomically:NO]) {
            //             NSLog(@"存入文件 成功！");
        } else {
            NSLog(@"图片未能存入");
        }
    });
}

- (void)deleteImageWithName:(NSString *)imageName atItemsArrayLocation:(NSInteger)loc {
    _isChangedImage = YES;
    NSString *bigImagePath = [_bigImageDocumetPath stringByAppendingPathComponent:imageName];
    NSError *error = nil;
    NSString *smallImagePath = [_smallImageDocumetPath stringByAppendingPathComponent:imageName];
    NSError *smallError = nil;
    if ([[NSFileManager defaultManager] removeItemAtPath:smallImagePath error:&smallError] && [[NSFileManager defaultManager] removeItemAtPath:bigImagePath error:&error]) {
        [_imageItemsArray removeObjectAtIndex:loc];
        [_imagesNameArray removeObject:imageName];
        [self.collectionView reloadData];
    } else {
        NSLog(@"remove small %@.JPG Error :%@",imageName,smallError.localizedDescription);
        NSLog(@"remove %@.JPG error :%@",imageName,error.localizedDescription);
    }
}

- (CGSize)imageAssetSize:(PHAsset *)asset {
    return CGSizeMake(asset.pixelWidth, asset.pixelHeight);
}

- (CGSize)smallSize {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize size = CGSizeMake((self.view.bounds.size.width) * scale/LINE_Items, (self.view.bounds.size.width) * scale/LINE_Items);
//     NSLog(@"%f, %f",size.width,size.height);
    return size;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self saveImageToDocument:image imageName:[AppData random_uuid]];
    [self.navigationController dismissViewControllerAnimated: YES completion:^{
        [self.collectionView reloadData];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}


@end
