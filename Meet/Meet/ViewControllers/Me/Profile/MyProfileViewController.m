//
//  MyProfileViewController.m
//  Meet
//
//  Created by jiahui on 16/4/30.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "MyProfileViewController.h"
#import "CellTextField.h"
#import "LabelAndTextFieldCell.h"
#import "TextViewCell.h"
//#import "CellPlaceHolderTextView.h"
#import "MoreProfileViewController.h"
#import "AddInformationViewController.h"
#import "AddStarViewController.h"
#import "WXUserInfo.h"
#import "NetWorkObject.h"

typedef NS_ENUM(NSUInteger, SectonContentType) {
    SectionProfile,
    SectionWoerkExperience,
    SectionOccupation,///职业
    SectionEducateExp,//教育
    sectionPrivate,///个人亮点
    sectionMore,//更多
};

@interface MyProfileViewController () <UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate,UITextViewDelegate> {
    NSArray *_titleContentArray;
    
    __weak IBOutlet UIView *_chooseView;
    __weak IBOutlet UIView *_bottomPickerView;
    __weak IBOutlet UIDatePicker *_datePicker;
    __weak IBOutlet UIPickerView *_picker;

    
    NSArray *_arraySex;
    NSArray *_arrayLoved;
    NSArray *_arrayConstellation;
    NSIndexPath *_selectIndexParth;////当前选择的位置
    NSInteger _pickerSelectRow;
    
    NSMutableDictionary *_dicValues;////////for mapping values
    NSMutableDictionary *_dicPickSelectValues;
    
    
    NSMutableArray *_arrayWorkExper;///工作经历
    NSMutableArray *_arrayOccupationLable;///职业标签
    NSMutableArray *_arrayEducateExper;///教育背景
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConstraint;


@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"个人信息";
    [UITools customNavigationLeftBarButtonForController:self action:@selector(backAction:)];
    [UITools navigationRightBarButtonForController:self action:@selector(saveAction:) normalTitle:@"保存" selectedTitle:nil];
    _titleContentArray = @[@"头像",@"真实姓名",@"性别",@"出生日期",@"身高",@"手机号",@"微信号",@"工作地点",@"年收入",@"情感状态",@"家乡",@"星座"];
    _dicValues = [NSMutableDictionary dictionary];
    _dicPickSelectValues = [NSMutableDictionary dictionary];
//    _arrayWorkExper = [NSMutableArray array];
    _arrayWorkExper = [NSMutableArray arrayWithArray:@[@"产品总监 - 面包旅行",@"产品经理 - 百度"]];
    _arrayOccupationLable = [NSMutableArray arrayWithArray:@[@"产品总监, 产品经理 "]];
    _arrayEducateExper = [NSMutableArray arrayWithArray:@[@"哈尔滨工业大学 - 电子商务 - 本科 ",@"光山县第三高级中学 - 高中"]];
    
    _arraySex = @[@"男",@"女"];
    _arrayLoved = @[@"单身",@"恋爱",@"已婚"];
    _arrayConstellation = @[@"水平座",@"双鱼座",@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座"];
    
    _chooseView.hidden = YES;
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.maximumDate = [NSDate  date];
    _picker.backgroundColor = [UIColor whiteColor];
    
    if (_isFristLogin) {
        [self loadUserWeChatImage];
    }
}

- (void)loadUserWeChatImage {
    [NetWorkObject downloadTask:[WXUserInfo shareInstance].headimgurl progress:^(NSProgress *downloadProgress) {
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath.path);
        UIImage *image = [UIImage imageWithContentsOfFile:filePath.path];
        NSString *savePath = [AppData getCachesDirectoryDocumentPath:[[WXUserInfo shareInstance].unionid stringByAppendingPathComponent:@"/headimg"]];
        
    }];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    _bottomViewConstraint.constant = - 300;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - data
- (NSArray *)setPickerViewContentArray:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == 2) {
        return _arraySex;
    } else if (row == 9) {
        return _arrayLoved;
    } else if (row == 11) {
        return _arrayConstellation;
    }
    return nil;
}

#pragma mark - Action
- (void)backAction:(id)sender {
    if (_isFristLogin) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    } else
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveAction:(id)sender {
    
}

- (IBAction)tapGestureRecognizer:(UITapGestureRecognizer *)sender {
    [self mappingPickContentInDic];
    [self showChooseViewAnimation:NO];
}

- (IBAction)cancelAction:(id)sender {
    [self showChooseViewAnimation:NO];
}

- (IBAction)tureButtonAction:(id)sender {
    [self mappingPickContentInDic];
    [self showChooseViewAnimation:NO];
}

- (void)mappingPickContentInDic {
    NSString *key = _titleContentArray[_selectIndexParth.row];
    if (_datePicker.hidden) {
        NSString *result = [self setPickerViewContentArray:_selectIndexParth][_pickerSelectRow];
        _dicValues[key] = result;
        [_dicPickSelectValues setObject:[NSNumber numberWithInt:_pickerSelectRow] forKey:_selectIndexParth];
    } else {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        NSDate *date = _datePicker.date;
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSString *strDate = [dateFormat stringFromDate:date];
        _dicValues[key] = strDate;
    }
}

- (void)hiddenDatePicker:(BOOL)hidden {
    if (hidden) {
        _datePicker.hidden = YES;
        _picker.hidden = NO;
        [_picker reloadAllComponents];
    } else {
        _datePicker.hidden = NO;
        _picker.hidden = YES;
    }
}

- (void)showChooseViewAnimation:(BOOL)show {
    if (show) {
        _bottomViewConstraint.constant = 0;
    } else {
        _bottomViewConstraint.constant = -250;
    }
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState |   UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                             [_bottomPickerView layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             if (show) {
                                 _chooseView.hidden = NO;
                             } else {
                                 _chooseView.hidden = YES;
                                 [self.tableView reloadRowsAtIndexPaths:@[_selectIndexParth] withRowAnimation:UITableViewRowAnimationNone];
                             }
                         }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
    return NO;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self setPickerViewContentArray:_selectIndexParth].count;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return (NSString *)[self setPickerViewContentArray:_selectIndexParth][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _pickerSelectRow = row;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return  @"工作经历";
    } if (section == 2) {
        return  @"职业标签";
    } if (section == 3) {
        return  @"教育背景";
    } if (section == 4) {
        return  @"您的个人亮点";
    } if (section == 5) {
        return  @"更多个人介绍";
    } 
    
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _titleContentArray.count;
    } else if( section == 1) {
        return _arrayWorkExper.count + 1;
    } else if (section == 2) {
        return  _arrayOccupationLable.count+ 1;
    } else if (section == 3) {
        return  _arrayEducateExper.count+ 1;
    }else if (section == 4 || section == 5) {
        return  1;
    }
        return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 82;
        } else
            return 49;
    } else if (indexPath.section == 4 || indexPath.section == 5) {
        return 90;
    }
        return 49;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0 && row == 0) {
        NSString *const cellIdentifier = @"profileImageCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:2];
        _dicValues[_titleContentArray[0]] ? (imageView.image = [UIImage imageNamed:_dicValues[_titleContentArray[0]]]) :(imageView.image = [UIImage imageNamed:@"RadarKeyboard_HL"]) ;
        return cell;
    } else if(section == 0) {
        if (row == 1 || row == 4 || row == 5 || row == 6 || row == 8) {
            NSString *cellIdentifier = @"profileTextFieldCell";
            LabelAndTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = (LabelAndTextFieldCell *)[[[NSBundle mainBundle] loadNibNamed:@"LabelAndTextFieldCell" owner:self options:nil] objectAtIndex:0];
                cell.textField.delegate = self;
            }
            cell.titelLabel.text = _titleContentArray[row];
            cell.textField.placeholder = _titleContentArray[row];
            if (row == 4) {
                cell.textField.placeholder = @"身高（cm）";
            }
             cell.textField.indexPath = indexPath;
            cell.textField.text = _dicValues[_titleContentArray[row]];
            return  cell;
        } else {
            NSString *cellIdentifier = @"profileLabelCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            UILabel *titlLabel = (UILabel *)[cell viewWithTag:1];
            titlLabel.text = _titleContentArray[row];
            UILabel *contentLabel = (UILabel *)[cell viewWithTag:2];
            contentLabel.text = _dicValues[_titleContentArray[row]];
            return  cell;
        }
    } else if (section == 1 || section == 2 || section == 3) {
        NSString * const labelCell =@"defaultCell";
        cell = [tableView dequeueReusableCellWithIdentifier:labelCell];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:labelCell];
            cell.textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        }
        if (section == 1) {
            if (row < _arrayWorkExper.count) {
                cell.textLabel.text = _arrayWorkExper[row];
                cell.imageView.image = nil;
            } else {
                cell.imageView.image = [UIImage imageNamed:@"imageAdd"];
                cell.textLabel.text =  @"添加工作经历";
            }
        } else if(section == 2) {
            if (row < _arrayOccupationLable.count) {
                cell.textLabel.text = _arrayOccupationLable[row];
                cell.imageView.image = nil;
            } else {
                cell.imageView.image = [UIImage imageNamed:@"imageAdd"];
                cell.textLabel.text =  @"添加职业标签";
            }
        } else if (section == 3) {
            if (row < _arrayEducateExper.count) {
                cell.textLabel.text = _arrayEducateExper[row];
                cell.imageView.image = nil;
            } else {
                cell.imageView.image = [UIImage imageNamed:@"imageAdd"];
                cell.textLabel.text =  @"添加教育背景";
            }
        }
//        NSLog(@"defaultCell section: %d",section);
        return cell;
    } else if (section == 4 || section == 5) {
        NSString *cellIdentifier = @"textViewCell";
        TextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[TextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.textView.delegate = self;
        }
        if (section == 4) {
            cell.textView.placeholder = @"空空如也～";
        } else if (section == 5) {
            cell.textView.placeholder = @"空空如也～";
        }
        cell.textView.indexPath = indexPath;
//         NSLog(@"textViewCell section: %d",section);
        return cell;
    }
    return  cell;
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    _selectIndexParth = indexPath;
    if (section == 0) {
        if (row == 3) {/////date picker
            [self.view endEditing:YES];
            [self hiddenDatePicker:NO];
            [self showChooseViewAnimation:YES];
        } else if (row == 2 || row == 9 || row == 11) {////_pickView
            [self.view endEditing:YES];
            NSInteger value = [_dicPickSelectValues[indexPath] intValue];
            _pickerSelectRow = value;
            [_picker selectRow:value inComponent:0 animated:NO];
            [self hiddenDatePicker:YES];
            [self showChooseViewAnimation:YES];
        }
    } else if(section == 1 || section == 3 ) {
        [self performSegueWithIdentifier:@"pushToAddInformationVC" sender:self];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [textField setReturnKeyType:UIReturnKeyDone];
    CellTextField *cellTextField = nil;
    if ([textField isKindOfClass:[CellTextField class]]) {
        cellTextField = (CellTextField *)textField;
        NSIndexPath *indexPath = cellTextField.indexPath;
        if ((indexPath.section == 0) && (indexPath.row == 4 || indexPath.row == 5 )) {
            [textField setKeyboardType:UIKeyboardTypeNumberPad];
            return  YES;
        } else {
            [textField setKeyboardType:UIKeyboardTypeDefault];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    CellTextField *cellTextField = nil;
    if ([textField isKindOfClass:[CellTextField class]]) {
        cellTextField = (CellTextField *)textField;
        [self mappingTextFieldDictionary:cellTextField];
    }
    return YES;
}

- (void)mappingTextFieldDictionary:(CellTextField *)textfield {
    if (textfield.text == nil || [textfield.text isEqualToString:@""]) {
        return ;
    }
    NSIndexPath *indexPath = textfield.indexPath;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSString *dictionKey = @"key";
    if (section == 0) {
        dictionKey = _titleContentArray[row];
    }
    _dicValues[dictionKey] = textfield.text;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView isKindOfClass:[CellTextView class]]) {
        CellTextView *cellTextView = (CellTextView *)textView;
        NSIndexPath *indexPath = cellTextView.indexPath;
        if (indexPath.section == 5) {
            [self performSegueWithIdentifier:@"ModalToMoreProfile" sender:self];
            return NO;
        } else if(indexPath.section == 4) {
            [self performSegueWithIdentifier:@"ModalToStarVC" sender:self];
            return  NO;
        }
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushToAddInformationVC"]) {
        AddInformationViewController *addInfom = (AddInformationViewController *)[segue destinationViewController];
        addInfom.indexPath = _selectIndexParth;
        if ( _selectIndexParth.row == _arrayWorkExper.count || _selectIndexParth.row == _arrayEducateExper.count ) {
            addInfom.viewType = ViewTypeAdd;
        } else {
            addInfom.viewType = ViewTypeEdit;
        }
    } else if ([segue.identifier isEqualToString:@"ModalToStarVC"]) {
        AddStarViewController *starVC = (AddStarViewController *)[segue destinationViewController];
    } else if ([segue.identifier isEqualToString:@"ModalToMoreProfile"]) {
        MoreProfileViewController *starVC = (MoreProfileViewController *)[segue destinationViewController];
    }
}

@end
