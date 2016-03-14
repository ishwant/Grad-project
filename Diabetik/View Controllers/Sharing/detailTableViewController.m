//
//  detailTableViewController.m
//  Diabetik
//
//  Created by project on 3/10/16.
//  Copyright © 2016 UglyApps. All rights reserved.
//

#import "detailTableViewController.h"

@interface detailTableViewController ()

@end

@implementation detailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"detailTableViewController loading");
    self.title = @"Details";
    
    self.details = [NSArray arrayWithObjects:@"Select details..",
                    @"Fasting",
                    @"Pre-Prandial",
                    @"Post-Prandial",
                    @"Pre-Exercise",
                    @"Post-Exercise",
                    nil];
    
    self.selectedDetails = [[NSMutableArray alloc] init];
    self.selectedEvents = [[NSMutableArray alloc] init];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.delegate sendData:self.selectedDetailsString];
    NSLog(@"Data sent: %@", self.selectedDetailsString);
//    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ([self.details count]);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    static NSString *simpleTableIdentifier = @"eventDetails";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    // Configure the cell...
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = [self.details objectAtIndex:indexPath.row];
    if(!indexPath.row==0){
        [cell setBackgroundColor:[UIColor colorWithRed:240.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==1||indexPath.row==2||indexPath.row==3||indexPath.row==4||indexPath.row==5)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if(cell.accessoryType == UITableViewCellAccessoryCheckmark){
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            for(id item in self.selectedDetails) {
                if([item isEqual:cell.textLabel.text]) {
                    [self.selectedDetails removeObject:item];
                    NSLog(@"detail Removed: %@", cell.textLabel.text);
                    NSLog(@"selectedDetails: %@", self.selectedDetails);
                    self.selectedDetailsString = [self.selectedDetails componentsJoinedByString:@","];
                    break;
                }
            }
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self.selectedDetails addObject:cell.textLabel.text];
            NSLog(@"category added: %@", cell.textLabel.text);
            NSLog(@"selectedDetails: %@", self.selectedDetails);
            self.selectedDetailsString = [self.selectedDetails componentsJoinedByString:@","];
            NSLog(@"selectedDetailsString %@", self.selectedDetailsString);
        }
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
