//
//  ViewController.h
//  To-DoList
//
//  Created by pcs20 on 9/30/14.
//  Copyright (c) 2014 Paradigmcreatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@protocol gotoFVC <NSObject>

@required
-(void)recieveInsertedData:(Task *)taskObject;

@optional
-(void)getDataFromUpdate:(Task *)taskObject;

@end

@interface ViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic,strong)IBOutlet UITextField *taskTF;

@property(nonatomic,strong)IBOutlet UITextField *dateTF;

@property(nonatomic,strong)IBOutlet UIButton *chooseDateButton;

@property(nonatomic,strong)IBOutlet UIButton *addButton;

@property(nonatomic,weak)id<gotoFVC> delegate;

-(IBAction)addButtonClicked:(id)sender;

-(IBAction)chooseDate:(id)sender;

@end

