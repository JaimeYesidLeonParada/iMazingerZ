//
//  GBTMazingerViewController.m
//  iMazinger
//
//  Created by Jaime Yesid Leon Parada on 9/8/14.
//  Copyright (c) 2014 Globant. All rights reserved.
//

#import "GBTMazingerViewController.h"

@import MessageUI;

@interface GBTMazingerViewController () <MKMapViewDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) id <MKAnnotation>model;
@end

@implementation GBTMazingerViewController

#pragma mark - Init

-(id)initWithAnnotationObject:(id<MKAnnotation>)model
{
    if (self == [super initWithNibName:nil bundle:nil]) {
        _model = model;
    }
    return self;
}

#pragma mark - View LifeCicle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView addAnnotation:_model];
    self.mapView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        MKCoordinateRegion spain = MKCoordinateRegionMakeWithDistance(self.model.coordinate, 1000000, 1000000);
        [self.mapView setRegion:spain animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.model.coordinate, 200, 200);
            [self.mapView setRegion:region animated:YES];
        });
    });
}

#pragma mark - MKMapViewDelegate

-(MKAnnotationView*) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *reuseID = @"Mazinger";
    
    MKPinAnnotationView *mazingerView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseID];
    
    if (mazingerView == nil) {
        mazingerView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:reuseID];
        mazingerView.pinColor = MKPinAnnotationColorGreen;
        mazingerView.canShowCallout = YES;
        
        UIImageView *mz = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mazinger.jpg"]];
        mazingerView.leftCalloutAccessoryView = mz;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [btn addTarget:nil
                action:nil
      forControlEvents:UIControlEventTouchUpInside];
        mazingerView.rightCalloutAccessoryView = btn;
        
    }
    return mazingerView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    MKMapSnapshotOptions *options = [MKMapSnapshotOptions new];
    options.region = self.mapView.region;
    options.mapType = MKMapTypeHybrid;
    
    MKMapSnapshotter *shotter = [[MKMapSnapshotter alloc]initWithOptions:options];
    [shotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
        if (error) {
            NSLog(@"Error Snapshot: %@", error);
        }else{
            MFMailComposeViewController *mailVC = [MFMailComposeViewController new];
            [mailVC setSubject:self.model.title];
            mailVC.mailComposeDelegate = self;
            
            NSData *image = UIImageJPEGRepresentation(snapshot.image, 0.9);
            [mailVC addAttachmentData:image
                             mimeType:@"image/jpeg"
                             fileName:@"mazinger.jpeg"];
            
            [self presentViewController:mailVC
                               animated:YES
                             completion:nil];
        }
    }];
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}


#pragma mark - Actions

- (IBAction)vectorial:(id)sender
{
    self.mapView.mapType = MKMapTypeStandard;
}
- (IBAction)satelite:(id)sender
{
    self.mapView.mapType = MKMapTypeSatellite;
}
- (IBAction)hibrido:(id)sender
{
    self.mapView.mapType = MKMapTypeHybrid;
}

@end
