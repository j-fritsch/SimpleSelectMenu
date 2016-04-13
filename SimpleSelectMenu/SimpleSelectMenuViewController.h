//
//  SimpleSelectMenuViewController.h
//  SimpleSelectMenu
//
//  Created by Fritsch, Jared on 4/12/16.
//  Copyright © 2016 Fritsch, Jared. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SimpleSelectMenuViewControllerDelegate <NSObject>

@required
- (void)simpleSelectMenuCloseForSender:(id)sender;

@optional
- (void)simpleSelectMenuItemsSelected:(NSArray *)selectedItems sender:(id)sender;

@end

@interface SimpleSelectMenuViewController : UIViewController

typedef NS_ENUM(int, SimpleSelectMenuTableViewCell)
{
    SimpleSelectMenuTableViewCellBasic = 0,
    SimpleSelectMenuTableViewCellSubtitle = 1,
    SimpleSelectMenuTableViewCellRightDetail = 2,
    SimpleSelectMenuTableViewCellBasicImage = 3
};

extern NSString * const kKeyDisplayField;
extern NSString * const kKeyDisplayDetailField;
extern NSString * const kKeyValueField;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) id<SimpleSelectMenuViewControllerDelegate> delegate;

/*!
 This will return you the height of the header plus the height of the contentSize
 of the tableView.
 
 \b Note: This will only give an accurate result if the view controller has fully
 loaded the controls.
 \returns CGFloat The height of the header and the tableview's content size.
 */
- (CGFloat)contentHeight;

/*!
 Use this method to set the data source of the table view.
 
 \b Note: An array of dictionaries can be used in case you think your data source may
 contain duplicate display values. You can pass along another value to uniquely identify
 the data. For example, it is possible a name could be duplicated, but they are actually
 two different people. You would pass dictionaries formatted like so:
 
 @code
 NSDictionary *dict1 = @{
 kDisplayField: @"John Smith",
 kValueField: 1
 };
 NSDictionary *dict2 = @{
 kDisplayField: @"John Smith",
 kValueField: 2
 };@endcode
 If an array of strings or numbers is passed, the string or number simply acts as both the display
 field and the value field.
 
 kKeyDisplayField should be the primary value to display.
 
 kKeyDisplayDetailField should be a secondary/supplementary value to display.
 
 kKeyValueField should be a behind-the-scenes value used to uniquely identify each item.
 
 \param dataSource  An NSArray of values representing the data to display. You can pass
 an array of NSStrings or NSNumbers. Or you can pass an array of NSDictionaries using
 the key constants provided by this class (kKeyDisplayField, kKeyDisplayDetailField, and
 kKeyValueField).
 */
- (void)setDataSource:(NSArray *)dataSource;

/*!
 Using the SimpleSelectMenuTableViewCell enum, you can choose between the following:
 
 A basic table view cell with only one label for text.
 
 A subtitle table view cell with a larger label on top and a smaller label underneath.
 
 A right detail table view cell with darker primary text on the left and lighter, supplementary text on the right.
 
 A basic image cell with text supplemented by an image to its left.
 
 \b Note: In order to use SimpleSelectMenuTableViewCellSubtitle, SimpleSelectMenuTableViewCellRightDetail,
 or SimpleSelectMenuTableViewCellBasicImage you must pass an array of dictionaries as the datasource. Use
 the kKeyDisplayDetailField key in the dictionary to set the image/subtitle/detail text of the cell.
 
 \param cellToUse A SimpleSelectMenuTableViewCell enum value of the cell you would like
 to use. The default is SimpleSelectMenuTableViewCellBasic.
 */
- (void)setTableViewCellToUse:(SimpleSelectMenuTableViewCell)cellToUse;

/*!
 Pass a string or a dictionary to this method to have it selected when the table view loads
 the data. For example, this can be used to show a default value or to persist a prior selected
 value.
 \param text The text of the cell that should be selected.
 */
- (void)setPreSelectedItem:(NSObject *)item;

/*!
 Pass an array of strings or dictionaries to this method to have them selected when the table
 view loads the data. For example, this can be used to show default values or to persist prior
 selected values.
 \param items An NSArray containing the text of the cells that should be selected.
 */
- (void)setPreSelectedItems:(NSArray *)items;

/*!
 Use this method to set the text for the header displayed above the table view. If you do
 not specify any text, no header will be shown.
 \param text The text to be displayed as the header.
 */
- (void)setHeaderText:(NSString *)text;

/*!
 Use this method to set the view that triggered this view to be displayed. This is used
 when calling the delegate return method. The delegate method will then know which view
 the return value is for.
 \param sender The view that triggered this view to be displayed.
 */
- (void)setSender:(id)sender;

/*!
 Use this method to set whether or not a user can select more than one row. If multi-select
 is not turned on, the menu defaults to single selection.
 \param multiSelectOn YES if the user can select multiple rows. NO if not. The default
 value is NO.
 */
- (void)setMultiSelectOn:(BOOL)multiSelectOn;

@end
