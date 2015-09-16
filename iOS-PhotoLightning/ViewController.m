//
//  ViewController.m
//  iOS-PhotoLightning
//
//  Created by Emiliano Barbosa on 9/16/15.
//  Copyright © 2015 Bocamuchas. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *frontCameraView;
@property (strong, nonatomic) IBOutlet UIImageView *backCameraView;


@end

@implementation ViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //----- SHOW LIVE CAMERA PREVIEW -----
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    CALayer *frontLayer = self.frontCameraView.layer;
    CALayer *backLayer = self.backCameraView.layer;
    NSLog(@"viewLayer = %@\nviewLayerBack: %@", frontLayer, backLayer);
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    
    captureVideoPreviewLayer.frame = self.frontCameraView.bounds;
    [self.frontCameraView.layer addSublayer:captureVideoPreviewLayer];
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDevice *deviceFront = devices[1];
    
    NSError *error = nil;
    AVCaptureDeviceInput *inputFront = [AVCaptureDeviceInput deviceInputWithDevice:deviceFront error:&error];
    if (!inputFront) {
        // Handle the error appropriately.
        NSLog(@"ERROR: trying to open camera: %@", error);
    }
    [session addInput:inputFront];
    
    [session startRunning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIDeviceBatteryState currentState = [[UIDevice currentDevice] batteryState];
    if (currentState == UIDeviceBatteryStateCharging || currentState == UIDeviceBatteryStateFull) {
        // The battery is either charging, or connected to a charger and is fully charged
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeCamera:(UIButton *)sender{
    
}

#pragma mark UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.frontCameraView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)takePhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

@end
