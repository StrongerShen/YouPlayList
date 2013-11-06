//
//  PlayLists_TVC.m
//  YouPlayList
//
//  Created by Stronger Shen on 13/3/24.
//  Copyright (c) 2013年 MobileIT. All rights reserved.
//

#import "PlayLists_TVC.h"
#import "List_TVC.h"

@interface PlayLists_TVC ()

@end

@implementation PlayLists_TVC

- (NSMutableArray *)getPlaylistsByID:(NSString *)userID

{
    NSMutableArray *rows = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSString *urlList = [NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/users/%@/playlists?v=2&alt=json", userID ];
    
    NSURL *url = [NSURL URLWithString:urlList];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
    
    
    NSMutableArray *entry = [[jsonDictionary objectForKey:@"feed"] objectForKey:@"entry"];
    
    for (NSDictionary *dict in entry) {
        NSString *playlistId = [[dict objectForKey:@"yt$playlistId"] objectForKey:@"$t"];
        NSString *title = [[dict objectForKey:@"title"] objectForKey:@"$t"];
        NSString *href = [[[dict objectForKey:@"link"] objectAtIndex:1] objectForKey:@"href"];
        
        [rows addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                          playlistId, @"playList_id",
                          title, @"playList_name",
                          href, @"href",
                          nil]];
    }

    // NSURLConnection sendAsynchronousRequest:request Block 的方式
    /*
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if ([data length]>0 && connectionError==nil) {
            //有收到正確的資料，連線沒有錯誤
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            NSMutableArray *entry = [[jsonDictionary objectForKey:@"feed"] objectForKey:@"entry"];
            
            for (NSDictionary *dict in entry) {
                NSString *playlistId = [[dict objectForKey:@"yt$playlistId"] objectForKey:@"$t"];
                NSString *title = [[dict objectForKey:@"title"] objectForKey:@"$t"];
                NSString *href = [[[dict objectForKey:@"link"] objectAtIndex:1] objectForKey:@"href"];
                
                [items addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                  playlistId, @"playList_id",
                                  title, @"playList_name",
                                  href, @"href",
                                  nil]];
            }
        } else if ([data length]==0 && connectionError==nil) {
            //沒有資料，連線沒有錯誤
        } else if (connectionError != nil) {
            //連線有誤
        }
    }];
     */

    return rows;
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
    
    self.title = @"頻道播放清單";
    
    // 可以從這裡取得 userid 的 playlist
    //http://gdata.youtube.com/feeds/api/users/binmusictaipei/playlists?v=2&alt=json
    /*
    playLists = [NSMutableArray arrayWithObjects:
                 [NSMutableDictionary dictionaryWithObjectsAndKeys:
                  @"PL32AD21DDA508E875", @"playList_id",
                  @"Adele 21", @"playList_name",
                  nil],
                 [NSMutableDictionary dictionaryWithObjectsAndKeys:
                  @"PL900BAE9FE97D8AE1", @"playList_id",
                  @"Adele - Live At The Royal Albert Hall", @"playList_name",
                  nil],
                 [NSMutableDictionary dictionaryWithObjectsAndKeys:
                  @"PLpHXzFT8CGrOU9Ma4XKYo-HqPMo1gh_5P", @"playList_id",
                  @"iOS Dev Club 聚會，魏巍分享 2013-01-26", @"playList_name",
                  nil],
                 [NSMutableDictionary dictionaryWithObjectsAndKeys:
                  @"PLV9mlJAqqQBwH30rkYT3fisAdwiKYBgcm", @"playList_id",
                  @"名醫相隨", @"playList_name",
                  nil],
                 [NSMutableDictionary dictionaryWithObjectsAndKeys:
                  @"PLpHXzFT8CGrONQfpYrXJDavDD2WRtZOkY", @"playList_id",
                  @"蘇慧倫 20100618 Legacy+", @"playList_name",
                  nil],
                 nil];
     */
    
    playLists = [self getPlaylistsByID:@"binmusictaipei"];
    
//    NSString *userID = @"ytbmmkan";
//    NSString *userID = @"binmusictaipei";
//    NSString *userID = @"warnertaiwan";

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
    return [playLists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [[playLists objectAtIndex:indexPath.row] objectForKey:@"playList_name"];
    cell.detailTextLabel.text = [[playLists objectAtIndex:indexPath.row] objectForKey:@"playList_id"];
    
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

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:[[playLists objectAtIndex:indexPath.row] objectForKey:@"href"]]];
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    
    List_TVC *list_tvc = segue.destinationViewController;
    list_tvc.listDict = [playLists objectAtIndex:indexPath.row];
}

@end
