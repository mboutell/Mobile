//
//  RHQuickListViewController.h
//  Rose-Hulman Mobile
//
//  Copyright 2012 Rose-Hulman Institute of Technology
// 
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <UIKit/UIKit.h>

#define kRHQuickListViewControllerNibName @"RHQuickListViewController"

@class RHMapViewController;
@class RHAnnotation;

/// \ingroup views
@interface RHQuickListViewController : UIViewController
<UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) RHMapViewController *mapViewController;

@property (nonatomic, strong) IBOutlet UIPickerView *pickerView;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (unsafe_unretained, nonatomic, readonly) NSArray *quickListAnnotations;

@property (unsafe_unretained, nonatomic, readonly) RHAnnotation *currentAnnotation;

- (IBAction)goToLocation:(id)sender;

- (IBAction)cancel:(id)sender;

@end
