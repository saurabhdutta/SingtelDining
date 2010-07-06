//
//  AdvanceSearchViewController.m
//  SingtelDining
//
//  Created by Alex Yao Cheng on 7/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AdvanceSearchViewController.h"
#import "SDBoxView.h"
#import "StringTable.h"
#import <extThree20JSON/extThree20JSON.h>
#import "AppDelegate.h"


@implementation AdvanceSearchViewController

- (void)dealloc {
  TT_RELEASE_SAFELY(keywordField);
  TT_RELEASE_SAFELY(locationField);
  TT_RELEASE_SAFELY(cuisineField);
  
  TT_RELEASE_SAFELY(locationPicker);
  TT_RELEASE_SAFELY(cuisinePicker);
  
  TT_RELEASE_SAFELY(locationData);
  TT_RELEASE_SAFELY(cuisineData);
  TT_RELEASE_SAFELY(subLocations);
  
  TT_RELEASE_SAFELY(query);
  
  [super dealloc];
}

- (id)init {
  if (self = [super init]) {
    query = [[NSMutableDictionary alloc] init];
  }
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
  NSLog(@"requestDidFinishLoad:%@", request);
  TTURLJSONResponse* response = request.response;
  TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
  
  NSDictionary* feed = response.rootObject;
  TTDASSERT([[feed objectForKey:@"data"] isKindOfClass:[NSArray class]]);
  
  NSArray* data = [feed objectForKey:@"data"];
  
  if (request.urlPath == URL_GET_LOCATION) {
    
    NSMutableArray* tmpLoc = [[NSMutableArray alloc] init];
    NSMutableDictionary* tmpDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* tmpSubloc = [[NSMutableDictionary alloc] init];
    [tmpSubloc setObject:@"0" forKey:@"id"];
    [tmpSubloc setObject:@"All" forKey:@"name"];
    [tmpDic setObject:@"0" forKey:@"id"];
    [tmpDic setObject:@"Around Me" forKey:@"name"];
    [tmpDic setObject:[NSArray arrayWithObject:tmpSubloc] forKey:@"sublocation"];
    [tmpLoc addObject:tmpDic];
    [tmpLoc addObjectsFromArray:data];
    
    locationData = [[NSArray alloc] initWithArray:tmpLoc];
    TT_RELEASE_SAFELY(tmpDic);
    TT_RELEASE_SAFELY(tmpLoc);
    TT_RELEASE_SAFELY(tmpSubloc);
    
    NSDictionary* firstLoc = [locationData objectAtIndex:0];
    NSLog(@"first loc: %@", firstLoc);
    NSArray* firstSubloc = [firstLoc objectForKey:@"sublocations"];
    
    subLocations = [[NSMutableArray alloc] initWithArray:firstSubloc];
    locationField.enabled = YES;
    /*
    for (int i = 0; i < [data count]; i++) {
      NSDictionary* loc = [data objectAtIndex:i];
      // add to picker column 1
      TTDASSERT([[loc objectForKey:@"sublocation"] isKindOfClass:[NSArray class]]);
      NSArray* sub = [loc objectForKey:@"sublocation"];
      for (int j = 0; j < [sub count]; j++) {
        NSDictionary* subloc = [sub objectAtIndex:j];
        // add to picker coulmn 2
      }
    }
     */
  } else if (request.urlPath == URL_GET_CUISINE) {
    cuisineData = [[NSArray alloc] initWithArray:data];
    cuisineField.enabled = YES;
    /*
    for (int i = 0; i < [data count]; i++) {
      NSDictionary* type = [data objectAtIndex:i];
      // add to cuisine picker
    }
     */
  }
}

- (void)loadView {
  
  self.view = [[[UIView alloc] initWithFrame:TTApplicationFrame()] autorelease];
  self.view.backgroundColor = [UIColor clearColor];
  self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
  
  
  TTURLRequest* locationRequest = [TTURLRequest requestWithURL:URL_GET_LOCATION delegate:self];
  locationRequest.response = [[[TTURLJSONResponse alloc] init] autorelease];
  [locationRequest send];
  
  TTURLRequest* cuisineRequest = [TTURLRequest requestWithURL:URL_GET_CUISINE delegate:self];
  cuisineRequest.response = [[[TTURLJSONResponse alloc] init] autorelease];
  [cuisineRequest send];
  
  //
  UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
  [cancelButton setImage:[UIImage imageNamed:@"button-cancel.png"] forState:UIControlStateNormal];
  [cancelButton addTarget:self action:@selector(dismissKeyboardOrPicker:) forControlEvents:UIControlEventTouchUpInside];
  [cancelButton setHidden:YES];
  UIBarButtonItem *barCancelButton = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
  [cancelButton release];
  self.navigationItem.leftBarButtonItem = barCancelButton;
  [barCancelButton release];
  
  UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57, 30)];
  [doneButton setImage:[UIImage imageNamed:@"button-done.png"] forState:UIControlStateNormal];
  [doneButton addTarget:self action:@selector(doneForKeyboradOrPicker:) forControlEvents:UIControlEventTouchUpInside];
  [doneButton setHidden:YES];
  UIBarButtonItem *barDoneButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
  [doneButton release];
  self.navigationItem.rightBarButtonItem = barDoneButton;
  [barDoneButton release];
  
  UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 128, 19)];
  titleView.image = [UIImage imageNamed:@"advance-search.png"];
  SDBoxView *boxView = [[SDBoxView alloc] initWithFrame:CGRectMake(5, 0, 310, kBoxNormalHeight) titleView:titleView];
  [titleView release];
  {
    // keyword
    UILabel* keywordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 100, 30)];
    keywordLabel.textAlignment = UITextAlignmentRight;
    keywordLabel.text = @"Keywords: ";
    [boxView addSubview:keywordLabel];
    TT_RELEASE_SAFELY(keywordLabel);
    
    keywordField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 160, 30)];
    keywordField.placeholder = @"Search";
    keywordField.autocorrectionType = NO;
    keywordField.autocapitalizationType = NO;
    keywordField.clearsOnBeginEditing = YES;
    keywordField.borderStyle = UITextBorderStyleRoundedRect;
    keywordField.tag = 0;
    keywordField.delegate = self;
    [boxView addSubview:keywordField];
    
    // location
    UILabel* locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 140, 100, 30)];
    locationLabel.textAlignment = UITextAlignmentRight;
    locationLabel.text = @"Location: ";
    [boxView addSubview:locationLabel];
    TT_RELEASE_SAFELY(locationLabel);
    
    UIButton* locationbg = [[UIButton alloc] initWithFrame:CGRectMake(100, 140, 160, 30)];
    [locationbg setImage:[UIImage imageNamed:@"dropdown.png"] forState:UIControlStateNormal];
    
    locationField = [[UITextField alloc] initWithFrame:CGRectMake(110, 143, 120, 27)];
    locationField.text = @"Around Me";
    locationField.backgroundColor = [UIColor clearColor];
    locationField.tag = 1;
    locationField.delegate = self;
    locationField.enabled = YES;
    //[locationField addTarget:self action:@selector(textBarDidBeginEditing:) forControlEvents:UIControlEventTouchDown];
    [boxView addSubview:locationbg];
    TT_RELEASE_SAFELY(locationbg);
    [boxView addSubview:locationField];
    
    // location
    UILabel* cuisineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 180, 100, 30)];
    cuisineLabel.textAlignment = UITextAlignmentRight;
    cuisineLabel.text = @"Cuisine: ";
    [boxView addSubview:cuisineLabel];
    TT_RELEASE_SAFELY(cuisineLabel);
    
    UIButton* cuisinebg = [[UIButton alloc] initWithFrame:CGRectMake(100, 180, 160, 30)];
    [cuisinebg setImage:[UIImage imageNamed:@"dropdown.png"] forState:UIControlStateNormal];
    
    cuisineField = [[UITextField alloc] initWithFrame:CGRectMake(110, 183, 120, 27)];
    cuisineField.text = @"Around Me";
    cuisineField.backgroundColor = [UIColor clearColor];
    cuisineField.tag = 2;
    cuisineField.delegate = self;
    cuisineField.enabled = YES;
    //[cuisineField addTarget:self action:@selector(textBarDidBeginEditing:) forControlEvents:UIControlEventTouchDown];
    [boxView addSubview:cuisinebg];
    TT_RELEASE_SAFELY(cuisinebg);
    [boxView addSubview:cuisineField];
    
    locationPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 480, 320, 270)];
    locationPicker.delegate = self;
    locationPicker.dataSource = self;
    locationPicker.showsSelectionIndicator = YES;
    [self.view addSubview:locationPicker];
    
    cuisinePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 480, 320, 270)];
    cuisinePicker.delegate = self;
    cuisinePicker.dataSource = self;
    cuisinePicker.showsSelectionIndicator = YES;
    [self.view addSubview:cuisinePicker];
    
  }
  [self.view addSubview:boxView];
  [boxView release];
}

#pragma mark -
#pragma mark IBAction
- (IBAction)dismissKeyboardOrPicker:(id)sender {
  self.navigationItem.leftBarButtonItem.customView.hidden = YES;
  self.navigationItem.rightBarButtonItem.customView.hidden = YES;
  
  UIButton* theButton = sender;
  
  if (theButton.tag == 0) {
    [keywordField resignFirstResponder];
  } else {
    [UIView beginAnimations:@"picker" context:nil];
    [UIView setAnimationDuration:0.5];
    
    UIPickerView *thePicker;
    if (theButton.tag == 1) {
      thePicker = locationPicker;
    } else if (theButton.tag == 2) {
      thePicker = cuisinePicker;
    }
    
    thePicker.transform = CGAffineTransformMakeTranslation(0, 136);
    [UIView commitAnimations];
  }
}

- (IBAction)doneForKeyboradOrPicker:(id)sender {
  self.navigationItem.leftBarButtonItem.customView.hidden = YES;
  self.navigationItem.rightBarButtonItem.customView.hidden = YES;
  
  UIButton* theButton = sender;
  
  if (theButton.tag == 0) {
    [keywordField resignFirstResponder];
    [query setObject:[keywordField text] forKey:@"keyword"];
    return;
  }
  
  [UIView beginAnimations:@"picker" context:nil];
  [UIView setAnimationDuration:0.5];
  UIPickerView *thePicker;
  
  if (theButton.tag == 1) {
    // location picker
    NSInteger locIndex = [locationPicker selectedRowInComponent:0];
    NSInteger subLocIndex = [locationPicker selectedRowInComponent:1];
    
    NSDictionary* locDic = [locationData objectAtIndex:locIndex];
    NSDictionary* subLocDic = [subLocations objectAtIndex:subLocIndex];
    
    NSString* locName = [locDic objectForKey:@"name"];
    NSString* subLocName = [subLocDic objectForKey:@"name"];
    
    locationField.text = [NSString stringWithFormat:@"%@-%@", locName, subLocName];
    
    if (locIndex>0 && subLocIndex>0) {
      NSString* locID = [subLocDic objectForKey:@"id"];
      [query setObject:locID forKey:@"id"];
    } else {
      AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
      NSString* latitude = [NSString stringWithFormat:@"%f", delegate.currentGeo.latitude];
      NSString* longitude = [NSString stringWithFormat:@"%f", delegate.currentGeo.longitude];
      [query setObject:latitude forKey:@"latitude"];
      [query setObject:longitude forKey:@"longitude"];
    }
    thePicker = locationPicker;
  } else if (theButton.tag == 2) {
    NSInteger cuisineIndex = [cuisinePicker selectedRowInComponent:0];
    
    NSDictionary* cuisineDic = [cuisineData objectAtIndex:cuisineIndex];
    
    cuisineField.text = [cuisineDic objectForKey:@"CuisineType"];
    
    thePicker = cuisinePicker;
  }
  
  thePicker.transform = CGAffineTransformMakeTranslation(0, 136);
  [UIView commitAnimations];
}

//animate the picker into view
- (void)textFieldDidEndEditing:(UITextField *)textField {
  
  if (textField.tag == 0) {
    [keywordField resignFirstResponder];
  } else {
    [UIView beginAnimations:@"picker" context:nil];
    [UIView setAnimationDuration:0.5];
    
    UIPickerView *thePicker;
    if (textField.tag == 1) {
      thePicker = locationPicker;
    } else if (textField.tag == 2) {
      thePicker = cuisinePicker;
    }
    
    thePicker.transform = CGAffineTransformMakeTranslation(0, 136);
    [UIView commitAnimations];
  }
  
}

//animate the picker out of view
- (void)textFieldDidBeginEditing:(UITextField *)textField {
  NSLog(@"textFieldDidBeginEditing %i", textField.tag);
  
  self.navigationItem.leftBarButtonItem.customView.hidden = NO;
  NSLog(@"show self.navigationItem.leftBarButtonItem.customView");
  self.navigationItem.rightBarButtonItem.customView.hidden = NO;
  
  UIButton* cancelButton = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
  cancelButton.hidden = NO;
  cancelButton.tag = textField.tag;
  
  UIButton* doneButton = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
  doneButton.hidden = NO;
  doneButton.tag = textField.tag;  
  
  if (textField.tag > 0) {
    [textField resignFirstResponder];
    [UIView beginAnimations:@"picker" context:nil];
    [UIView setAnimationDuration:0.5];
    
    UIPickerView *thePicker;
    if (textField.tag == 1) {
      thePicker = locationPicker;
      [thePicker reloadComponent:1];
      [thePicker selectRow:0 inComponent:1 animated:YES];
    } else if (textField.tag == 2) {
      thePicker = cuisinePicker;
    }
    
    thePicker.transform = CGAffineTransformMakeTranslation(0, -330);
    [self.view bringSubviewToFront:thePicker];
    
    [UIView commitAnimations];
  } else {
    NSLog(@"keyborad");
  }

}

//just hide the keyboard in this example
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [locationField resignFirstResponder];
  return NO;
}


#pragma mark -
#pragma mark UIPickerView dataSource

- (NSString *)pickerView:(UIPickerView *)pickerView 
             titleForRow:(NSInteger)row 
            forComponent:(NSInteger)component{
  NSString* titleString;
  if (pickerView == cuisinePicker) {
    titleString = (NSString*)[[cuisineData objectAtIndex:row] objectForKey:@"CuisineType"];
  } else if (pickerView == locationPicker) {
    
    NSLog(@"pickerView titleForRow:%i ForComponent: %i", row, component);
    
    if (component == 0) {
      NSDictionary* loc = [locationData objectAtIndex:row];
      titleString = [loc objectForKey:@"name"];
    } else if (component == 1) {
      NSDictionary* subloc = [subLocations objectAtIndex:row];
      NSLog(@"sub loc :%@", subloc);
      titleString = [subloc objectForKey:@"name"];
    }
  }
  return titleString;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
  NSInteger number;
  if (pickerView == cuisinePicker) {
    number = 1;
  } else if (pickerView == locationPicker) {
    number = 2;
  }
  return number;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
  NSInteger number;
  if (pickerView == cuisinePicker) {
    number = [cuisineData count];
  } else if (pickerView == locationPicker) {
    if (component == 0) {
      number = [locationData count];
    } else if (component == 1) {
      //TODO
      number = [subLocations count];
    }
  }
  return number;
}

#pragma mark -
#pragma mark UIPickerView delegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
  CGFloat width;
  if (pickerView == cuisinePicker) {
    width = 300;
  } else if (pickerView == locationPicker) {
    if (component == 0) {
      width = 120;
    } else if (component == 1) {
      width = 180;
    }
  }
  return width;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  if (pickerView == locationPicker) {
    if (component == 0) {
      NSDictionary* loc = [locationData objectAtIndex:row];
      subLocations = [loc objectForKey:@"sublocation"];
      [pickerView reloadComponent:1];
    }
  }
}

@end
