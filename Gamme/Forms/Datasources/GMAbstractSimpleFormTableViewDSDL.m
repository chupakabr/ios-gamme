//
//  GMAbstractSimpleFormTableViewDSDL.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/2/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMAbstractSimpleFormTableViewDSDL.h"
#import "GMLog.h"


@implementation GMAbstractSimpleFormTableViewDSDL

@synthesize parentController = parentController_;
@synthesize resultDataKey = _resultDataKey;
@synthesize canDelete = _canDelete;
@synthesize canCreate = _canCreate;


- (id)init
{
    GMLog(@"GMAbstractSimpleFormTableViewDSDL - init()");
    
    self = [super init];
    if (self) {
        self.canCreate = YES;
        self.canDelete = YES;
    }
    
    return self;
}

- (id)initWithResultKey:(NSString *)resultDataKey
{
    GMLog(@"GMAbstractSimpleFormTableViewDSDL - initWithResultKey()");
    
    self = [self init];
    if (self) {
        self.resultDataKey = resultDataKey;
    }
    
    return self;
}

- (void)dealloc
{
    self.resultDataKey = nil;
    [data_ release];
    
    [super dealloc];
}


#pragma mark - Abstract methods to override

- (NSString *) getTitleForModel:(NSManagedObject *)obj
{
    [NSException raise:NSInternalInconsistencyException format:@"Abstract getTitleForModel() must be implemented in the child"];
    return nil;
}

- (NSString *) getDetailForModel:(NSManagedObject *)obj
{
    return nil; // default is nil
}

- (NSFetchRequest *) getFetchRequest
{
    [NSException raise:NSInternalInconsistencyException format:@"Abstract getFetchRequest() must be implemented in the child"];
    return nil;
}

- (GMAbstractFormController *) createEditFormControllerForSelectedData:(NSManagedObject *)selectedData
{
    [NSException raise:NSInternalInconsistencyException format:@"Abstract createEditFormControllerForSelectedData() must be implemented in the child"];
    return nil;
}

- (void) customCellConfigaration:(UITableViewCell *)cell forRow:(NSInteger)row
{
    // Override when needed
}


#pragma mark - Data loading

- (UITableView *) tableView
{
    if (![parentController_ respondsToSelector:@selector(tableView)]) {
        [NSException raise:NSInternalInconsistencyException format:@"TableView must be available here!"];
    }
    
    return [(GMSimpleListFormTableViewController *) parentController_ tableView];
}

- (NSArray *) getData_:(BOOL)refresh
{
    if (!data_ || refresh) {
        GMPersistenceHelper * ph = [[GMAppDelegate instance] persistenceHelper];
        
        NSError * errors;
        NSArray * result = [[ph MOC] executeFetchRequest:[self getFetchRequest] error:&errors];
        if (!result) {
            [NSException raise:NSInternalInconsistencyException format:@"Cannot execute fetch query (TableView): %@", [errors description]];
        }
        
        [data_ release];
        data_ = [result retain];
    }
    
    return data_;
}

- (NSManagedObject *) getDataAtIndex_:(NSInteger)idx
{
    return (NSManagedObject *) [[self getData_:NO] objectAtIndex:idx];
}


#pragma mark - Table view data source

- (void) cellEditButtonPressed:(id)sender
{
    NSManagedObject * selectedData = [self getDataAtIndex_:[sender tag]];
    GMAbstractFormController * controller = [self createEditFormControllerForSelectedData:selectedData];
    [parentController_.navigationController pushViewController:controller animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = [[self getData_:YES] count];
    
    if (self.tableView.editing) {
        if (self.canCreate) {
            return rowCount+1;
        }
    }
    
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SimpleFormTableViewCell";
    static NSString *CellIdentifierEditing = @"SimpleFormTableViewCell_Editing";
    static NSString *CellIdentifierEditingAdd = @"SimpleFormTableViewCell_Editing_Add";
    
    UITableViewCell *cell = nil;
    
    if (self.tableView.editing) {
        if ([indexPath row] == [[self getData_:NO] count]) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierEditingAdd];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierEditingAdd] autorelease];
            }
        }
        else {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierEditing];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierEditing] autorelease];
            }            
        }
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        }        
    }
    
    // Configure cell colors
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.detailTextLabel setTextColor:[UIColor colorWithRed:(CGFloat)153/255 green:(CGFloat)204/255 blue:0.0 alpha:1.0]];
    
    // Configure the cell...
    if ([indexPath row] == [[self getData_:NO] count]) {
        [cell.textLabel setText:NSLocalizedString(@"Add new", nil)];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    else {
        
        [cell.textLabel setText:[self getTitleForModel:[self getDataAtIndex_:[indexPath row]]]];
        [cell.detailTextLabel setText:[self getDetailForModel:[self getDataAtIndex_:[indexPath row]]]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        // Button if in editing
        if (self.tableView.editing) {
            
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            
            [btn addTarget:self action:@selector(cellEditButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                [btn setFrame:CGRectMake(280, 5, btn.frame.size.width, btn.frame.size.height)];
            }
            else {
                [btn setFrame:CGRectMake(665, 5, btn.frame.size.width, btn.frame.size.height)];
            }
            [btn setTag:[indexPath row]];
            
            [cell addSubview:btn];
        }
        
        // Custom cell configuration
        [self customCellConfigaration:cell forRow:(NSInteger)indexPath.row];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [[self getData_:NO] count]) {
        NSManagedObject * obj = [self getDataAtIndex_:indexPath.row];
        
        if ([obj respondsToSelector:@selector(isSystem)]) {
            return ![(NSNumber *)[obj performSelector:@selector(isSystem)] boolValue];
        }
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    GMLog(@"GMAbstractSimpleFormTableViewDSDL - commitEdit()");
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        GMLog(@"GMAbstractSimpleFormTableViewDSDL - DELETE");
        
        // Delete the row from the persistense
        NSObject * selectedData = (NSObject *) [self getDataAtIndex_:[indexPath row]];
        [self deleteSelectedData:selectedData];
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
        GMLog(@"GMAbstractSimpleFormTableViewDSDL - INSERT");
        
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        GMAbstractFormController * controller = [self createEditFormControllerForSelectedData:nil];
        [parentController_.navigationController pushViewController:controller animated:YES];
    }
}

- (void) deleteSelectedData:(NSObject *)obj
{
    if (self.resultDataKey) {
        if (obj == [(GMSimpleListFormTableViewController *) parentController_ getOutgoingResultData:self.resultDataKey]) {
            [(GMSimpleListFormTableViewController *) parentController_ setOutgoingResultData:nil forKey:self.resultDataKey];
        }
    }
    
    [[[GMAppDelegate instance] persistenceHelper] deleteObjectNow:(NSManagedObject*) obj];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *) indexPath
{
    if (self.canCreate) {
        if (indexPath.row == [[self getData_:NO] count]) {
            return UITableViewCellEditingStyleInsert;
        }
    }
    
    if (self.canDelete) {
        return UITableViewCellEditingStyleDelete;        
    }
    
    return UITableViewCellEditingStyleNone;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.resultDataKey) {
        NSManagedObject * selectedData = [self getDataAtIndex_:[indexPath row]];
        
        [(GMSimpleListFormTableViewController *) parentController_ setOutgoingResultData:selectedData forKey:self.resultDataKey];
        [(GMSimpleListFormTableViewController *) parentController_ setOutgoingResultData:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%@_set", self.resultDataKey]];
    }
    
    [parentController_.navigationController popViewControllerAnimated:YES];
}


@end
