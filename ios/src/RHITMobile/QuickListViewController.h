//
//  QuickListViewController.h
//  RHIT Mobile Campus Directory
//
//  Copyright 2011 Rose-Hulman Institute of Technology
// 
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <UIKit/UIKit.h>

@class MapViewController;
@class RHAnnotation;

/// \ingroup views
@interface QuickListViewController : UIViewController
<UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) MapViewController *mapViewController;

@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, readonly) NSArray *quickListAnnotations;

@property (nonatomic, readonly) RHAnnotation *currentAnnotation;

- (IBAction)goToLocation:(id)sender;

- (IBAction)cancel:(id)sender;

@end