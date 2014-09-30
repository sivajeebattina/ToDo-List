//
//  UpdateViewController.h
//  To-DoList
//
//  Created by pcs20 on 9/30/14.
//  Copyright (c) 2014 Paradigmcreatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "ViewController.h"

@interface UpdateViewController : UIViewController

@property(nonatomic,strong)Task *taskObject;

@property(nonatomic,strong)IBOutlet UITextField *taskNameTF;

@property(nonatomic,strong)IBOutlet UITextField *dateTF;

@property(nonatomic,strong)IBOutlet UIButton *editButton;

@property(nonatomic,weak)id<gotoFVC> seconddelegate;

-(IBAction)editClicked:(id)sender;



@end
