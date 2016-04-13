//
//  ViewController.m
//  SimpleSelectMenu
//
//  Created by Fritsch, Jared on 4/12/16.
//  Copyright © 2016 Fritsch, Jared. All rights reserved.
//

#import "ViewController.h"
#import "SimpleSelectMenuViewController.h"

@interface ViewController () <SimpleSelectMenuViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnCellType;
@property (weak, nonatomic) IBOutlet UIButton *btnSingleSelection;
@property (weak, nonatomic) IBOutlet UIButton *btnMultiSelection;
@property (weak, nonatomic) IBOutlet UILabel *lblResult;

@property (strong, nonatomic) NSString *selectedTableViewCellType;
@property (strong, nonatomic) NSString *selectedItem;
@property (strong, nonatomic) NSArray *selectedItems;

@end

@implementation ViewController

static NSString * const kBasicTableViewCell = @"Basic";
static NSString * const kSubtitleTableViewCell = @"Subtitle";
static NSString * const kRightDetailTableViewCell = @"Right Detail";
static NSString * const kBasicImageTableViewCell = @"Basic Image";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set default table view cell type
    if(self.selectedTableViewCellType == nil)
    {
        self.selectedTableViewCellType = kBasicTableViewCell;
        [self.btnCellType setTitle:self.selectedTableViewCellType forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Event Handling

- (IBAction)btnCellType_Tap:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    SimpleSelectMenuViewController *menu = [[UIStoryboard storyboardWithName:@"SimpleSelectMenu"
                                                                      bundle:[NSBundle mainBundle]]
                                            instantiateViewControllerWithIdentifier:NSStringFromClass([SimpleSelectMenuViewController class])];
    
    NSArray *arOptions = [NSArray arrayWithObjects:kBasicTableViewCell, kSubtitleTableViewCell, kRightDetailTableViewCell, kBasicImageTableViewCell, nil];
    [menu setDataSource:arOptions];
    [menu setTableViewCellToUse:SimpleSelectMenuTableViewCellBasic];
    [menu setPreSelectedItem:self.selectedTableViewCellType];
    [menu setSender:button];
    [menu setDelegate:self];
    [menu setHeaderText:@"Cell Types"];
    [menu setModalPresentationStyle:UIModalPresentationPopover];
    
    // Call layoutIfNeeded so the table view loads its data, allowing us to get
    // its content height to size this popover more accurately
    [menu.view layoutIfNeeded];
    
    menu.preferredContentSize = CGSizeMake(300.0f, [menu contentHeight]);
    
    UIPopoverPresentationController *popPresenter = [menu popoverPresentationController];
    popPresenter.sourceView = button;
    popPresenter.sourceRect = button.bounds;
    popPresenter.permittedArrowDirections = UIPopoverArrowDirectionAny;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:menu animated:YES completion:nil];
    });
}

- (IBAction)btnSingleSelection_Tap:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    SimpleSelectMenuViewController *menu = [[UIStoryboard storyboardWithName:@"SimpleSelectMenu"
                                                                      bundle:[NSBundle mainBundle]]
                                            instantiateViewControllerWithIdentifier:NSStringFromClass([SimpleSelectMenuViewController class])];
    NSArray *arOptions = nil;
    
    if([self.selectedTableViewCellType isEqualToString:kBasicTableViewCell])
    {
        arOptions = [NSArray arrayWithObjects:@"Item 1", @"Item 2", @"Item 3", nil];
    }
    else if([self.selectedTableViewCellType isEqualToString:kSubtitleTableViewCell]
            || [self.selectedTableViewCellType isEqualToString:kRightDetailTableViewCell])
    {
        NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"Item 1", kKeyDisplayField,
                               @"Detail 1", kKeyDisplayDetailField,
                               nil];
        
        NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"Item 2", kKeyDisplayField,
                               @"Detail 2", kKeyDisplayDetailField,
                               nil];
        
        NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"Item 3", kKeyDisplayField,
                               @"Detail 3", kKeyDisplayDetailField,
                               nil];
        
        arOptions = [NSArray arrayWithObjects:dict1, dict2, dict3, nil];
    }
    else if([self.selectedTableViewCellType isEqualToString:kBasicImageTableViewCell])
    {
        arOptions = [self imageBasedDataSource];
    }
    
    [menu setTableViewCellToUse:[self simpleSelectMenuTableViewCellTypeByDescription:self.selectedTableViewCellType]];
    [menu setDataSource:arOptions];
    [menu setPreSelectedItem:self.selectedItem];
    [menu setSender:button];
    [menu setDelegate:self];
    [menu setHeaderText:@"Items"];
    [menu setModalPresentationStyle:UIModalPresentationPopover];
    
    // Call layoutIfNeeded so the table view loads its data, allowing us to get
    // its content height to size this popover more accurately
    [menu.view layoutIfNeeded];
    
    menu.preferredContentSize = CGSizeMake(300.0f, [menu contentHeight]);
    
    UIPopoverPresentationController *popPresenter = [menu popoverPresentationController];
    popPresenter.sourceView = button;
    popPresenter.sourceRect = button.bounds;
    popPresenter.permittedArrowDirections = UIPopoverArrowDirectionAny;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:menu animated:YES completion:nil];
    });
}

- (IBAction)btnMultiSelection_Tap:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    SimpleSelectMenuViewController *menu = [[UIStoryboard storyboardWithName:@"SimpleSelectMenu"
                                                                      bundle:[NSBundle mainBundle]]
                                            instantiateViewControllerWithIdentifier:NSStringFromClass([SimpleSelectMenuViewController class])];
    
    NSArray *arOptions = nil;
    
    if([self.selectedTableViewCellType isEqualToString:kBasicTableViewCell])
    {
        arOptions = [NSArray arrayWithObjects:@"First Item", @"Second Item", @"Third Item", @"Fourth Item", @"Fifth Item", nil];
    }
    else if([self.selectedTableViewCellType isEqualToString:kSubtitleTableViewCell]
            || [self.selectedTableViewCellType isEqualToString:kRightDetailTableViewCell])
    {
        NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"First Item", kKeyDisplayField,
                               @"First Detail", kKeyDisplayDetailField,
                               nil];
        
        NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"Second Item", kKeyDisplayField,
                               @"Second Detail", kKeyDisplayDetailField,
                               nil];
        
        NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"Third Item", kKeyDisplayField,
                               @"Third Detail", kKeyDisplayDetailField,
                               nil];
        
        NSDictionary *dict4 = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"Fourth Item", kKeyDisplayField,
                               @"Fourth Detail", kKeyDisplayDetailField,
                               nil];
        
        NSDictionary *dict5 = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"Fifth Item", kKeyDisplayField,
                               @"Fifth Detail", kKeyDisplayDetailField,
                               nil];
        
        arOptions = [NSArray arrayWithObjects:dict1, dict2, dict3, dict4, dict5, nil];
    }
    else if([self.selectedTableViewCellType isEqualToString:kBasicImageTableViewCell])
    {
        arOptions = [self imageBasedDataSource];
    }
    
    [menu setTableViewCellToUse:[self simpleSelectMenuTableViewCellTypeByDescription:self.selectedTableViewCellType]];
    [menu setDataSource:arOptions];
    [menu setMultiSelectOn:YES];
    [menu setPreSelectedItems:self.selectedItems];
    [menu setSender:button];
    [menu setDelegate:self];
    [menu setHeaderText:@"Items"];
    [menu setModalPresentationStyle:UIModalPresentationPopover];
    
    // Call layoutIfNeeded so the table view loads its data, allowing us to get
    // its content height to size this popover more accurately
    [menu.view layoutIfNeeded];
    
    menu.preferredContentSize = CGSizeMake(300.0f, [menu contentHeight]);
    
    UIPopoverPresentationController *popPresenter = [menu popoverPresentationController];
    popPresenter.sourceView = button;
    popPresenter.sourceRect = button.bounds;
    popPresenter.permittedArrowDirections = UIPopoverArrowDirectionAny;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:menu animated:YES completion:nil];
    });
}




#pragma mark - Private Methods

- (SimpleSelectMenuTableViewCell)simpleSelectMenuTableViewCellTypeByDescription:(NSString *)description
{
    if([description isEqualToString:kBasicTableViewCell])
    {
        return SimpleSelectMenuTableViewCellBasic;
    }
    else if([description isEqualToString:kSubtitleTableViewCell])
    {
        return SimpleSelectMenuTableViewCellSubtitle;
    }
    else if([description isEqualToString:kRightDetailTableViewCell])
    {
        return SimpleSelectMenuTableViewCellRightDetail;
    }
    else if([description isEqualToString:kBasicImageTableViewCell])
    {
        return SimpleSelectMenuTableViewCellBasicImage;
    }
    else
    {
        return SimpleSelectMenuTableViewCellBasic;
    }
}

- (NSArray *)imageBasedDataSource
{
    UIImage *image1 = [self imageWithColor:[UIColor redColor]];
    UIImage *image2 = [self imageWithColor:[UIColor orangeColor]];
    UIImage *image3 = [self imageWithColor:[UIColor greenColor]];
    UIImage *image4 = [self imageWithColor:[UIColor purpleColor]];
    
    NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"Image 1", kKeyDisplayField,
                           image1, kKeyDisplayDetailField,
                           nil];
    
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"Image 2", kKeyDisplayField,
                           image2, kKeyDisplayDetailField,
                           nil];
    
    NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"Image 3", kKeyDisplayField,
                           image3, kKeyDisplayDetailField,
                           nil];
    
    NSDictionary *dict4 = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"Image 4", kKeyDisplayField,
                           image4, kKeyDisplayDetailField,
                           nil];
    
    NSArray *arDataSource = [NSArray arrayWithObjects:dict1, dict2, dict3, dict4, nil];
    
    return arDataSource;
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}




#pragma mark - SimpleSelectMenuViewControllerDelegate

- (void)simpleSelectMenuCloseForSender:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)simpleSelectMenuItemsSelected:(NSArray *)selectedItems sender:(id)sender
{
    if([sender isEqual:self.btnCellType])
    {
        self.selectedTableViewCellType = [selectedItems objectAtIndex:0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3f animations:^{
                [self.btnCellType setTitle:self.selectedTableViewCellType forState:UIControlStateNormal];
                [self.view layoutIfNeeded];
            }];
        });
    }
    else
    {
        NSMutableArray *marSelectedItemText = [NSMutableArray new];
        for(id selectedItem in selectedItems)
        {
            if([selectedItem isKindOfClass:[NSString class]])
            {
                [marSelectedItemText addObject:selectedItem];
            }
            else if([selectedItem isKindOfClass:[NSDictionary class]])
            {
                NSString *displayText = [selectedItem objectForKey:kKeyDisplayField];
                if(displayText != nil)
                {
                    [marSelectedItemText addObject:displayText];
                }
            }
        }
        
        NSString *resultText = [marSelectedItemText componentsJoinedByString:@", "];
        [self.lblResult setText:resultText];
        
        if([sender isEqual:self.btnSingleSelection])
        {
            self.selectedItem = [selectedItems objectAtIndex:0];
        }
        else if([sender isEqual:self.btnMultiSelection])
        {
            self.selectedItems = selectedItems;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
