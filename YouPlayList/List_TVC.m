//
//  List_TVC.m
//  YouPlayList
//
//  Created by Stronger Shen on 13/3/20.
//  Copyright (c) 2013年 MobileIT. All rights reserved.
//

#import "List_TVC.h"
#import "PlayVideo_VC.h"
#import "Reachability.h"

NSString *kSettingKey = @"autoloadplaylist";

@interface List_TVC ()
@end

@implementation List_TVC

@synthesize listDict;


- (BOOL)getSettingPref {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSData *testValue = [defaults dataForKey:kSettingKey]; // setting exists?
	if (testValue == nil) {
		NSString *pathStr = [[NSBundle mainBundle] bundlePath];
		NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
		NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
		NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
        
		NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
		NSNumber *settingDefault = nil;
		NSDictionary *prefItem;
		
		for (prefItem in prefSpecifierArray) {
			NSString *keyValueStr = [prefItem objectForKey:@"Key"];
			id defaultValue = [prefItem objectForKey:@"DefaultValue"];
			
			if ([keyValueStr isEqualToString:kSettingKey]) {
				settingDefault = defaultValue;
			}
		}
		
		if (settingDefault != nil) {
			NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                         settingDefault, kSettingKey, nil];
			[defaults registerDefaults:appDefaults];
			[defaults synchronize];
		}
        
    }
	return [defaults boolForKey:kSettingKey];
}



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    list = [[NSDictionary alloc] initWithDictionary:listDict];
    
//    NSLog(@"list:%@,\n-----\nlistDict:%@", list, listDict);
    
    self.title = [list objectForKey:@"playList_name"];

    if ([self getSettingPref]) {
        [self btnRefresh:nil];
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
    return [lists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *titleString = [[[lists objectAtIndex:indexPath.row] objectForKey:@"title"] objectForKey:@"$t"];
    NSString *hrefString = [[[lists objectAtIndex:indexPath.row] objectForKey:@"content"] objectForKey:@"src"];

    cell.textLabel.text = titleString;
    cell.detailTextLabel.text = hrefString;
    
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

- (IBAction)btnRefresh:(id)sender {
    BOOL reachable = [[Reachability reachabilityForInternetConnection] isReachable];
    if (reachable) {
        NSString *urlList = [NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/playlists/%@?v=2&alt=json", [list objectForKey:@"playList_id"] ];
        
        NSURL *url = [NSURL URLWithString:urlList];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        NSError *jsonError = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        /*
         if ([jsonObject isKindOfClass:[NSArray class]]) {
         NSLog(@"NSArray!");
         NSArray *jsonArray = (NSArray *)jsonObject;
         NSLog(@"jsonArray - %@",jsonArray);
         
         //        lists = [[NSMutableArray alloc] initWithArray:jsonArray];
         }
         else {
         NSLog(@"NSDictionary!");
         NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
         NSLog(@"jsonDictionary - %@",jsonDictionary);
         
         lists = [[NSMutableArray alloc] initWithArray:
         [[jsonDictionary valueForKeyPath:@"feed"] valueForKeyPath:@"entry"]
         ];
         }
         */
        
        NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
        lists = [[NSMutableArray alloc] initWithArray:
                 [[jsonDictionary valueForKeyPath:@"feed"] valueForKeyPath:@"entry"]
                 ];
        
        [self.tableView reloadData];
    }

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PlayVideo_VC *vc = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    vc.href = [[[lists objectAtIndex:indexPath.row] objectForKey:@"content"] objectForKey:@"src"];
}

@end
