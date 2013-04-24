//
//  List_TVC.h
//  YouPlayList
//
//  Created by Stronger Shen on 13/3/20.
//  Copyright (c) 2013年 MobileIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface List_TVC : UITableViewController
{
    NSMutableArray *lists;
    NSMutableArray *entries;
    
    NSDictionary *list;
}

@property (strong, nonatomic) NSDictionary *listDict;

- (IBAction)btnRefresh:(id)sender;
- (BOOL)getSettingPref;

@end
