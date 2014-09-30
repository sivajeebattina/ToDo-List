//
//  TasksView.m
//  To-DoList
//
//  Created by pcs20 on 9/30/14.
//  Copyright (c) 2014 Paradigmcreatives. All rights reserved.
//

#import "TasksView.h"
#import "sqlite3.h"
#import "Task.h"
#import "ViewController.h"
#import "UpdateViewController.h"

@interface TasksView (){
    NSMutableArray *tasksObjectArray;
    sqlite3 *database;

    NSString *taskName;
    
    NSIndexPath *selectedIndexpath;
   
}

@end

@implementation TasksView

- (void)viewDidLoad {
    [super viewDidLoad];
   
    selectedIndexpath=[[NSIndexPath alloc] init];
    
    [self createDatabase];
    
    [self fetchResults];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return tasksObjectArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Task" forIndexPath:indexPath];
    
    Task *temporaryTask=[tasksObjectArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text=temporaryTask.taskName;
    
    cell.detailTextLabel.text=temporaryTask.date;
    
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
       
        
       
        
        Task *temp=[tasksObjectArray objectAtIndex:indexPath.row];
        
        taskName=temp.taskName;
        [self deleteFromDatabase];
        
        [tasksObjectArray removeObjectAtIndex:indexPath.row];
        
        [self.tableView reloadData];
      
    
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"addTask"]) {
        ViewController *addViewController=[segue destinationViewController];
        
        addViewController.delegate=self;
    }
    
    else if ([[segue identifier] isEqualToString:@"showDetails"]){
    
        UpdateViewController *update=[segue destinationViewController];
        
        update.seconddelegate=self;
        
        NSIndexPath *selectedIndex=[self.tableView indexPathForSelectedRow];
        
        update.taskObject=[tasksObjectArray objectAtIndex:selectedIndex.row];
      
    
    }
}


-(NSString *)getDBPathFromBundle{
    NSString *dbpath=[[NSBundle mainBundle] bundlePath];
    
    dbpath=[dbpath stringByAppendingPathComponent:@"ToDoList.sqlite"];
    
    return dbpath;


}

-(NSString *)getDBPathFromDocument{
    NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *dpath=[pathArray objectAtIndex:0];
    
    dpath=[dpath stringByAppendingPathComponent:@"ToDoList.sqlite"];
    
    return dpath;

}


-(void)createDatabase{

    NSString *dbPathBundle=[self getDBPathFromBundle];
    NSString *dbPathDocument=[self getDBPathFromDocument];
    
    NSFileManager *fileM=[[NSFileManager alloc] init];
    
    if (![fileM fileExistsAtPath:dbPathDocument]) {
        BOOL Success=[fileM copyItemAtPath:dbPathBundle toPath:dbPathDocument error:nil];
        
        if (Success) {
            NSLog(@"Database for todo list created succesfully");
        }
        else
            NSLog(@"Database creation failed");
        
    }
    
   

}


-(void)recieveInsertedData:(Task *)taskObject{

    [tasksObjectArray addObject:taskObject];

    [self.tableView reloadData];
}


#pragma mark FetchResults

-(void)fetchResults{
    NSString *dbpath=[self getDBPathFromDocument];
    const char *utfpath=[dbpath UTF8String];
    
    tasksObjectArray=[[NSMutableArray alloc] init];
    
    if (sqlite3_open(utfpath, &database)==SQLITE_OK) {
        
        
        NSString *selectQuery=[NSString stringWithFormat:@"select * from Tasks"];
        
        
        const char *utfquery=[selectQuery UTF8String];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare(database, utfquery, -1, &statement, nil)==SQLITE_OK) {
           while(sqlite3_step(statement)==SQLITE_ROW) {
               
               NSString *taskName=[NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 0)];
               
               NSString *date=[NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 1)];
               
              
               
               Task *task=[[Task alloc] init];
               
               task.taskName=taskName;
               task.date=date;
               
           

               
               [tasksObjectArray addObject:task];
               
            }
            
        }
        
        sqlite3_finalize(statement);
        
    }
    
    sqlite3_close(database);

    [self.tableView reloadData];
   
}


#pragma mark deleteFromDatabase

-(void)deleteFromDatabase{

    NSString *dbpath=[self getDBPathFromDocument];
    const char *utfpath=[dbpath UTF8String];
    
    if (sqlite3_open(utfpath, &database)==SQLITE_OK) {
        
        
        NSString *selectQuery=[NSString stringWithFormat:@"delete from Tasks where taskName='%@'",taskName];
        
        
        const char *utfquery=[selectQuery UTF8String];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare(database, utfquery, -1, &statement, nil)==SQLITE_OK) {
            if(sqlite3_step(statement)==SQLITE_DONE) {
                
                NSLog(@"Deleted from database successfully");
             
                
            }
            
        }
        
        sqlite3_finalize(statement);
        
    }
    
    sqlite3_close(database);
    
   

}

-(void)getDataFromUpdate:(Task *)taskObject{

    [self fetchResults];

}

@end
