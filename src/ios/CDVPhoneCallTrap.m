

#import "CDVPhoneCallTrap.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>


@implementation CDVPhoneCallTrap

//Initialize the plugin
- (void)pluginInitialize:(CDVInvokedUrlCommand*)command
{
    self.callCenter = [[CTCallCenter alloc] init];
    [self handleCall];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callReceived:) name:CTCallStateIncoming object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callEnded:) name:CTCallStateDisconnected object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callConnected:) name:CTCallStateConnected object:nil];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}


//handle calls
-(void)onCall:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* result = nil;
    NSString* callState;

    self.callCenter.callEventHandler = ^(CTCall *call){
        
        if ([call.callState isEqualToString: CTCallStateConnected])
        {
            NSLog(@"call CTCallStateConnected");//Background task stopped
            callState = @"connected";
        }
        else if ([call.callState isEqualToString: CTCallStateDialing])
        {
            NSLog(@"call CTCallStateDialing");
             callState = @"dialing";
        }
        else if ([call.callState isEqualToString: CTCallStateDisconnected])
        {
            NSLog(@"call CTCallStateDisconnected");//Background task started
            callState = @"disconnected";
        }
        else if ([call.callState isEqualToString: CTCallStateIncoming])
        {
            NSLog(@"call CTCallStateIncoming");
             callState = @"incoming";
        }
        else  {
            NSLog(@"call NO");
            callState = @"idle";
        }

        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:callState];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    };
}

@end