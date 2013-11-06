//
//  PlayVideo_VC.m
//  YouPlayList
//
//  Created by Stronger Shen on 13/3/20.
//  Copyright (c) 2013年 MobileIT. All rights reserved.
//

#import "PlayVideo_VC.h"

@interface PlayVideo_VC ()

@end

@implementation PlayVideo_VC

@synthesize href;

#pragma mark - Added methods

- (void)embedYouTube:(NSString*)url frame:(CGRect)frame {
    NSString* embedHTML = @"\
    <html><head>\
    <style type=\"text/css\">\
    body {\
    background-color: transparent;\
    color: white;\
    }\
    </style>\
    </head><body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
    width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
    NSString* html = [NSString stringWithFormat:embedHTML, url, frame.size.width, frame.size.height];
    if(videoView == nil) {
        videoView = [[UIWebView alloc] initWithFrame:frame];
        // 這兩句是可以給 html5 <video src="MyVideo.mp4" autoplay></video> 的 autoplay 用的
        videoView.allowsInlineMediaPlayback = YES;
        videoView.mediaPlaybackRequiresUserAction = NO;
        
        [self.view addSubview:videoView];
    }
    [videoView loadHTMLString:html baseURL:nil];
}

#pragma mark - View methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self embedYouTube:self.href frame:CGRectMake(0, 64, 320, 240)];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
