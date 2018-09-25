//
//  PJNetwork.h
//  JJSOptionalExam
//
//  Created by wpj on 2018/9/21.
//  Copyright © 2018年 wpj. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef _PJNETWORK_
#define _PJNETWORK_

#if __has_include(<PJNetwork/PJNetwork.h>)

#import <PJNetwork/PJNetworkStation.h>
#import <PJNetwork/PJNetworkSessionManager.h>
#import <PJNetwork/PJRequest.h>
#import <PJNetwork/PJNetworkConfig.h>
#import <PJNetwork/PJNetworkDataShell.h>

#else

#import "PJNetworkStation.h"
#import "PJNetworkSessionManager.h"
#import "PJRequest.h"
#import "PJNetworkConfig.h"
#import "PJNetworkDataShell.h"

#endif /* __has_include */

#endif /* _PJNETWORK_ */
