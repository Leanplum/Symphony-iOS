//
//  LPActionDefinition.h
//  Symphony
//
//  Created by Grace on 4/16/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPModelProtocol.h"
#import "LPAlert.h"
#import "LPModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPActionDefinition : LPModel<LPModelProtocol>

@property (nonatomic, strong) LPAlert *alert;
//@property (nonatomic, strong) LPCenterPopup *centerPopup;
//@property (nonatomic, strong) LPConfirm *confirm;
//@property (nonatomic, strong) LPInterstitial *interstitial;
//@property (nonatomic, strong) LPOpenURL *openURL;
//@property (nonatomic, strong) LPPushAskToAsk *pushAskToAsk;
//@property (nonatomic, strong) LPRegisterForPush *registerForPush;
//@property (nonatomic, strong) LPWebInterstitial *webInterstitial;

@end

NS_ASSUME_NONNULL_END
