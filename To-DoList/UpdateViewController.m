//
//  UpdateViewController.m
//  To-DoList
//
//  Created by pcs20 on 9/30/14.
//  Copyright (c) 2014 Paradigmcreatives. All rights reserved.
//

#import "UpdateViewController.h"
#import "sqlite3.h"
@interface UpdateViewController (){

    sqlite3 *database;
}

@end

@implementation UpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"Update ToDo List details";
    
    _taskNameTF.text=_taskObject.taskName;
    _dateTF.text=_taskObject.date;
    
    [_taskNameTF setEnabled:NO];
    [_dateTF setEnabled:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(IBAction)editClicked:(id)sender{

    [_editButton setTitle:@"Update" forState:UIControlStateNormal];
    
    [_taskNameTF setEnabled:YES];
    [_dateTF setEnabled:YES];
    
    if ([_editButton.titleLabel.text isEqualToString:@"Update"]) {
        [self updateDatabase];
    }

}

-(void)updateDatabase{
    
    NSString *dbpath=[self getDBPathFromDocument];
    const char *utfpath=[dbpath UTF8String];
    
    if (sqlite3_open(utfpath, &database)==SQLITE_OK) {
        
        
        
        NSString *selectQuery=[NSString stringWithFormat:@"update Tasks set TaskName='%@',Time='%@' where TaskName='%@'",_taskNameTF.text,_dateTF.text,_taskObject.taskName];
        
        Task *temp=[[Task alloc] init];
        
        temp.taskName=_taskNameTF.text;
        temp.date=_dateTF.text;
       
        
        
        const char *utfquery=[selectQuery UTF8String];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare(database, utfquery, -1, &statement, nil)==SQLITE_OK) {
            if (sqlite3_step(statement)==SQLITE_DONE) {
                NSLog(@"Values updated successfully");
                
                [self.seconddelegate getDataFromUpdate:temp];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
        
        sqlite3_finalize(statement);
        
    }
    
    sqlite3_close(database);
}


#pragma mark pathDirectory
-(NSString *)getDBPathFromDocument{
    NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *dpath=[pathArray objectAtIndex:0];
    
    dpath=[dpath stringByAppendingPathComponent:@"ToDoList.sqlite"];
    
    return dpath;
    
}


@end
