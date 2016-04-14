# SimpleSelectMenu

SimpleSelectMenu is a reusable iOS menu that allows for both single and multi-selection and provides various UITableViewCell styles for convenience.

### Usage Basics
See the SimpleSelectMenu-Example directory for example usage.

- Create the view controller to display
```objective-c
SimpleSelectMenuViewController *menu = [[UIStoryboard storyboardWithName:@"SimpleSelectMenu" 
                                                                  bundle:[NSBundle mainBundle]]
                                 instantiateViewControllerWithIdentifier:NSStringFromClass([SimpleSelectMenuViewController class])];
```
- Create a datasource
    - NSArray of NSStrings, NSNumbers, or NSDates
    - NSArray of NSDictionaries using the provided string constants
        - kDisplayField
        - kDisplayDetailField
        - kValueField
- Set the datasource
```objective-c
[menu setDataSource:dataSource];
```
- Set a table view cell style
```objective-c
[menu setTableViewCellToUse:SimpleSelectMenuTableViewCellBasic];
```
- Display the view controller how you want

See SimpleSelectMenuViewController.h for more options!

### Cell Styles
A few UITableViewCell styles are provided but these can be customized to your liking.
  - Basic
  - Subtitle
  - Right Detail
  - Basic Image
