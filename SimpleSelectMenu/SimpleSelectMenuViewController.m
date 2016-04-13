//
//  SimpleSelectMenuViewController.m
//  SimpleSelectMenu
//
//  Created by Fritsch, Jared on 4/12/16.
//  Copyright © 2016 Fritsch, Jared. All rights reserved.
//

#import "SimpleSelectMenuViewController.h"
#import "SSMBasicTableViewCell.h"
#import "SSMSubtitleTableViewCell.h"
#import "SSMRightDetailTableViewCell.h"
#import "SSMBasicImageTableViewCell.h"

@interface SimpleSelectMenuViewController ()

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcHeaderViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblHeaderTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnHeaderAction;

@property (strong, nonatomic, readonly) NSArray *arDataSource;
@property (nonatomic, readonly) SimpleSelectMenuTableViewCell cellToUse;
@property (assign, nonatomic, readonly) BOOL multiSelectOn;
@property (strong, nonatomic, readonly) id sender;
@property (strong, nonatomic, readonly) NSString *headerText;

// preSelectedItem is only to be used when multi select is off
@property (strong, nonatomic, readonly) NSObject *preSelectedItem;

// preSelectedItems is only to be used when multi select is on
@property (strong, nonatomic, readonly) NSMutableArray *marPreSelectedItems;

// selectedIndexPath is only to be used when multi select is off
@property (strong, nonatomic, readonly) NSIndexPath *selectedIndexPath;

// selectedIndexPaths is only to be used when multi select is on
@property (strong, nonatomic, readonly) NSMutableArray *selectedIndexPaths;

@end

@implementation SimpleSelectMenuViewController

NSString * const kKeyDisplayField = @"displayField";
NSString * const kKeyDisplayDetailField = @"displayDetailField";
NSString * const kKeyValueField = @"valueField";

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupRightButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupHeader];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Instance Methods

- (CGFloat)contentHeight
{
    CGFloat totalHeight = 0.0f;
    
    CGFloat tableViewContentHeight = self.tableView.contentSize.height;
    CGFloat headerHeight = self.headerView.frame.size.height;
    
    totalHeight = tableViewContentHeight;
    if(self.headerText != nil && self.headerText.length > 0)
    {
        totalHeight += headerHeight;
    }
    
    return totalHeight;
}

- (void)setDataSource:(NSArray *)dataSource
{
    _arDataSource = dataSource;
}

- (void)setTableViewCellToUse:(SimpleSelectMenuTableViewCell)cell
{
    _cellToUse = cell;
}

- (void)setPreSelectedItem:(NSObject *)item
{
    _preSelectedItem = item;
}

- (void)setPreSelectedItems:(NSArray *)items
{
    _marPreSelectedItems = [items mutableCopy];
    _selectedIndexPaths = [NSMutableArray new];
}

- (void)setHeaderText:(NSString *)text
{
    _headerText = text;
}

- (void)setSender:(id)sender
{
    _sender = sender;
}

- (void)setMultiSelectOn:(BOOL)multiSelectOn
{
    _multiSelectOn = multiSelectOn;
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseID = [self reuseIDForTableViewCell:self.cellToUse];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    
    id valueField;
    id displayField;
    id displayDetailField;
    id data = self.arDataSource[indexPath.row];
    if([data isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = self.arDataSource[indexPath.row];
        displayField = [dict objectForKey:kKeyDisplayField];
        displayDetailField = [dict objectForKey:kKeyDisplayDetailField];
        valueField = [dict objectForKey:kKeyValueField];
        
        if(valueField == nil && displayField != nil)
        {
            valueField = displayField;
        }
    }
    else
    {
        valueField = data;
        displayField = data;
    }
    
    // Depending on the cell type to use, set the text of the labels
    if(self.cellToUse == SimpleSelectMenuTableViewCellBasic)
    {
        [((SSMBasicTableViewCell *)cell).lblPrimary setText:[self getStringForValue:displayField]];
    }
    else if(self.cellToUse == SimpleSelectMenuTableViewCellSubtitle)
    {
        [((SSMSubtitleTableViewCell *)cell).lblPrimary setText:[self getStringForValue:displayField]];
        [((SSMSubtitleTableViewCell *)cell).lblSubtitle setText:[self getStringForValue:displayDetailField]];
    }
    else if(self.cellToUse == SimpleSelectMenuTableViewCellRightDetail)
    {
        [((SSMRightDetailTableViewCell *)cell).lblPrimary setText:[self getStringForValue:displayField]];
        [((SSMRightDetailTableViewCell *)cell).lblRightDetail setText:[self getStringForValue:displayDetailField]];
    }
    else if(self.cellToUse == SimpleSelectMenuTableViewCellBasicImage)
    {
        [((SSMBasicImageTableViewCell *)cell).lblPrimary setText:[self getStringForValue:displayField]];
        
        if([displayDetailField isKindOfClass:[UIImage class]])
        {
            [((SSMBasicImageTableViewCell *)cell).ivImage setImage:displayDetailField];
        }
    }
    
    
    if(self.multiSelectOn)
    {
        // If there are any rows that should be pre selected, do so
        if(self.marPreSelectedItems != nil && self.marPreSelectedItems.count > 0)
        {
            id preSelectedItemToRemove;
            for(id object in self.marPreSelectedItems)
            {
                if([object isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *dict = (NSDictionary *)object;
                    
                    NSString *currentValueField = [dict objectForKey:kKeyValueField];
                    NSString *currentDisplayField = [dict objectForKey:kKeyDisplayField];
                    if(currentValueField == nil && currentDisplayField != nil)
                    {
                        currentValueField = currentDisplayField;
                    }
                    
                    if([valueField isEqual:currentValueField])
                    {
                        preSelectedItemToRemove = object;
                        [_selectedIndexPaths addObject:indexPath];
                        break;
                    }
                }
                else
                {
                    if([object isEqual:valueField])
                    {
                        preSelectedItemToRemove = object;
                        [_selectedIndexPaths addObject:indexPath];
                        break;
                    }
                }
            }
            [_marPreSelectedItems removeObject:preSelectedItemToRemove];
        }
    }
    
    // If there is a row that should be pre selected, do so
    if(self.preSelectedItem != nil)
    {
        id preSelectedValue;
        if([self.preSelectedItem isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = (NSDictionary *)self.preSelectedItem;
            
            NSString *currentValueField = [dict objectForKey:kKeyValueField];
            NSString *currentDisplayField = [dict objectForKey:kKeyDisplayField];
            if(currentValueField == nil && currentDisplayField != nil)
            {
                currentValueField = currentDisplayField;
            }
            
            preSelectedValue = currentValueField;
        }
        else
        {
            preSelectedValue = self.preSelectedItem;
        }
        
        if([valueField isEqual:preSelectedValue])
        {
            _selectedIndexPath = indexPath;
            _preSelectedItem = nil;
        }
    }
    
    if((self.selectedIndexPath != nil && [indexPath isEqual:self.selectedIndexPath])
       || (self.selectedIndexPaths != nil && [self.selectedIndexPaths containsObject:indexPath]))
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // Check if multi select is on first as that should take priority if both
    // multi and single selection happen to both be on
    if(self.multiSelectOn)
    {
        // If it was already selected, deselect it
        if([self.selectedIndexPaths containsObject:indexPath])
        {
            [self.selectedIndexPaths removeObject:indexPath];
            UITableViewCell *prevSelectedCell = [tableView cellForRowAtIndexPath:indexPath];
            prevSelectedCell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            if(self.selectedIndexPaths == nil)
            {
                _selectedIndexPaths = [NSMutableArray new];
            }
            [self.selectedIndexPaths addObject:indexPath];
            
            // Check the cell that was selected
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    else
    {
        // If there is a selected path and it is different from what was just selected, deselect it
        if(self.selectedIndexPath != nil && ![self.selectedIndexPath isEqual:indexPath])
        {
            UITableViewCell *prevSelectedCell = [tableView cellForRowAtIndexPath:self.selectedIndexPath];
            prevSelectedCell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        // Check the cell that was selected
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(simpleSelectMenuItemsSelected:sender:)])
        {
            id value = self.arDataSource[indexPath.row];
            
            // Let the delegate know what was selected
            [self.delegate simpleSelectMenuItemsSelected:@[value] sender:self.sender];
        }
    }
}




#pragma mark - Event Handling

- (void)btnMultiSelectDone_Tap:(id)sender
{
    NSMutableArray *marSelectedItems = [NSMutableArray new];
    for(NSIndexPath *indexPath in self.selectedIndexPaths)
    {
        id value = self.arDataSource[indexPath.row];
        [marSelectedItems addObject:value];
    }
    
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(simpleSelectMenuItemsSelected:sender:)])
    {
        // Let the delegate know what was selected
        [self.delegate simpleSelectMenuItemsSelected:[marSelectedItems copy] sender:self.sender];
    }
}

- (void)btnCancel_Tap:(id)sender
{
    [self close];
}




#pragma mark - Private Methods

- (void)close
{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(simpleSelectMenuCloseForSender:)])
    {
        [self.delegate simpleSelectMenuCloseForSender:self.sender];
    }
}

- (void)setupRightButton
{
    if(self.multiSelectOn)
    {
        [self.btnHeaderAction setTitle:@"Done" forState:UIControlStateNormal];
        [self.btnHeaderAction removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        [self.btnHeaderAction addTarget:self action:@selector(btnMultiSelectDone_Tap:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [self.btnHeaderAction setTitle:@"Cancel" forState:UIControlStateNormal];
        [self.btnHeaderAction removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        [self.btnHeaderAction addTarget:self action:@selector(btnCancel_Tap:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setupHeader
{
    if(self.headerText != nil && self.headerText.length > 0)
    {
        [self.lblHeaderTitle setText:self.headerText];
    }
    else
    {
        [self.lblHeaderTitle setText:@""];
        [self.lcHeaderViewHeight setConstant:0.0f];
    }
}

- (NSString *)getStringForValue:(id)value
{
    NSString *returnString = @"";
    
    if([value isKindOfClass:[NSString class]])
    {
        returnString = value;
    }
    else if([value isKindOfClass:[NSNumber class]])
    {
        returnString = [((NSNumber *)value) stringValue];
    }
    else if([value isKindOfClass:[NSDate class]])
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MMM dd, yyy"];
        
        returnString = [dateFormat stringFromDate:value];
    }
    
    // TODO (future): Add date functionality. Let the view controller pass in a
    // special date format but fall back to a default one.
    
    return returnString;
}

- (NSString *)reuseIDForTableViewCell:(SimpleSelectMenuTableViewCell)cell
{
    NSString *reuseID = nil;
    switch (cell)
    {
        case SimpleSelectMenuTableViewCellBasic:
            reuseID = @"ssmBasicTableViewCell";
            break;
        case SimpleSelectMenuTableViewCellSubtitle:
            reuseID = @"ssmSubtitleTableViewCell";
            break;
        case SimpleSelectMenuTableViewCellRightDetail:
            reuseID = @"ssmRightDetailTableViewCell";
            break;
        case SimpleSelectMenuTableViewCellBasicImage:
            reuseID = @"ssmBasicImageTableViewCell";
            break;
        default:
            reuseID = @"ssmBasicTableViewCell";
            break;
    }
    return reuseID;
}

@end

