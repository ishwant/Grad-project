//
//  SharePostViewController.m
//  Diabetik
//
//  Created by project on 1/15/16.
//  Copyright © 2016 UglyApps. All rights reserved.
//

#import "SharePostViewController.h"
#import "CustomCell.h"

#import "TextFieldFormElement.h"

@interface SharePostViewController ()

@property (strong, nonatomic) NSMutableArray *formItems;
@property (strong, nonatomic) CustomCell *cell;

@end

@implementation SharePostViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"SHARE POST", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    

    _toolbar.hidden = true;
    _datePicker.hidden = true;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.formItems = [[NSMutableArray alloc] initWithCapacity:3];
    
    for (int i=0; i<3; i++)
    {
        if(i == 0)
        {
            TextFieldFormElement *item = [[TextFieldFormElement alloc] init];
            item.label = [[NSString alloc] initWithFormat:@"Category: "];
            item.value = @"";
            [self.formItems insertObject:item atIndex:0];
        }
        else if(i == 1)
        {
            TextFieldFormElement *item = [[TextFieldFormElement alloc] init];
            item.label = [[NSString alloc] initWithFormat:@"From: "];
            item.value = @"";
            [self.formItems insertObject:item atIndex:1];
        }
        else if(i == 2)
        {
            TextFieldFormElement *item = [[TextFieldFormElement alloc] init];
            item.label = [[NSString alloc] initWithFormat:@"To: "];
            item.value = @"";
            [self.formItems insertObject:item atIndex:2];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}


- (void)configureAppearanceForTableViewCell:(CustomCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==1){
        UIDatePicker *datePicker = [[UIDatePicker alloc]init];
        [datePicker setDate:[NSDate date]];
        [cell.valueField setInputView:datePicker];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // We are looking for cells with the Cell identifier
    // We should reuse unused cells if there are any
    static NSString *cellIdentifier = @"Cell";
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // If there is no cell to reuse, create a new one
    if(cell == nil)
    {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell before it is displayed...
    
    if(indexPath.row == 0){
        TextFieldFormElement *item = [self.formItems objectAtIndex:indexPath.row];
        cell.labelField.text = item.label;
        cell.valueField.delegate = self;
        cell.valueField.placeholder = @"Select Category";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    else if(indexPath.row == 1){
        TextFieldFormElement *item = [self.formItems objectAtIndex:indexPath.row];
        cell.labelField.text = item.label;
        cell.valueField.delegate = self;
        cell.valueField.placeholder = @"Select Start Date";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIDatePicker *picker = (UIDatePicker*)self.cell.inputView;
        cell.valueField.text = [NSString stringWithFormat:@"%@",picker.date];
    }
    else if(indexPath.row == 2){
        TextFieldFormElement *item = [self.formItems objectAtIndex:indexPath.row];
        cell.labelField.text = item.label;
        cell.valueField.delegate = self;
        cell.valueField.placeholder = @"Select End Date";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [self configureAppearanceForTableViewCell:cell atIndexPath:indexPath];
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - ITextFieldDelegate protocol

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (UIColor *)tintColor
{
    return [UIColor colorWithRed:127.0f/255.0f green:192.0f/255.0f blue:241.0f/255.0f alpha:1.0f];
}

- (UIImage *)navigationBarBackgroundImage
{
    return [UIImage imageNamed:@"ActivityNavBarBG"];
}

@end