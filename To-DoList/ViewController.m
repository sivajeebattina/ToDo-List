//
//  ViewController.m
//  To-DoList
//
//  Created by pcs20 on 9/30/14.
//  Copyright (c) 2014 Paradigmcreatives. All rights reserved.
//

#import "ViewController.h"
#import "sqlite3.h"


@interface ViewController (){


    sqlite3 *database;
    UIDatePicker *datepicker;
    
    NSString *date;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"Add Task Details";
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

   
    [_taskTF resignFirstResponder];
    return YES;
}


-(IBAction)chooseDate:(id)sender{

    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Choose Date" message:@"Choose Date from picker" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    //UIView *pickerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, alert.bounds.size.height, alert.bounds.size.width)];
    //[pickerView setBackgroundColor:[UIColor greenColor]];
    
    datepicker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, alert.bounds.size.height, alert.bounds.size.width)];
   
    datepicker.datePickerMode=UIDatePickerModeDate;
    [alert setValue:datepicker forKey:@"accessoryView"];
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex==1) {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        
        dateFormatter.dateFormat=@"dd-MM-yyyy";
        
        
        
        date=[dateFormatter stringFromDate:datepicker.date];
        
        _dateTF.text=date;
        [_dateTF setEnabled:NO];
    }

}


#pragma mark addButtonClicked

-(IBAction)addButtonClicked:(id)sender{

    NSString *dbpath=[self getDBPathFromDocument];
    const char *utfpath=[dbpath UTF8String];
    
    if (sqlite3_open(utfpath, &database)==SQLITE_OK) {
        
      

        NSString *selectQuery=[NSString stringWithFormat:@"insert into Tasks values('%@','%@')",_taskTF.text,_dateTF.text];
        
        Task *temp=[[Task alloc] init];
        temp.taskName=_taskTF.text;
        temp.date=_dateTF.text;
        
        
        const char *utfquery=[selectQuery UTF8String];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare(database, utfquery, -1, &statement, nil)==SQLITE_OK) {
            if (sqlite3_step(statement)==SQLITE_DONE) {
                NSLog(@"Values inserted successfully");
                
                [self.delegate recieveInsertedData:temp];
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
