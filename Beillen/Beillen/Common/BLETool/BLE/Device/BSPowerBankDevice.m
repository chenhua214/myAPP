//
//  BSPowerBankDevice.m
//  JDKJAPP
//
//  Created by chen on 2026/1/13.
//

#import "BSPowerBankDevice.h"
#import "BSDeviceCRC.h"
#import "BSPowerBankBLE.h"
//#import "BSFridgeDevice+Utils.h"

@implementation BSCommonTypeByteModel
-(NSInteger)typeValue{
    long  validDataNumber = _typeByte_H << 8 | _typeByte_L;
    return validDataNumber;
}

-(void)setTypeByte_H:(Byte)typeByte_H
{
    _typeByte_H = typeByte_H;
    NSLog(@"当前数值=====  %ld",self.typeValue);
}
@end

@implementation BSCommonDeviceTypeModel
-(BSCommonTypeByteModel*)typeModelA{
    if (!_typeModelA) {
        _typeModelA = [BSCommonTypeByteModel new];
    }
    return _typeModelA;
}

-(BSCommonTypeByteModel*)typeModelV{
    if (!_typeModelV) {
        _typeModelV = [BSCommonTypeByteModel new];
    }
    return _typeModelV;
}
-(BSCommonTypeByteModel*)typeModelW{
    if (!_typeModelW) {
        _typeModelW = [BSCommonTypeByteModel new];
    }
    return _typeModelW;
}

@end




@interface BSPowerBankDevice()

/// 写入指令时的倍数
@property (nonatomic, strong) NSDictionary *w_multipleDict;
/// 存放指令的数组
@property (nonatomic, strong) NSMutableArray <NSData *> *commandArray;
/// 指令队列定时器
@property (nonatomic, strong) dispatch_source_t commandTimer;
/// 销毁定时器时间
@property (nonatomic, assign) double cancelTimerTime;

@property (nonatomic, strong) NSArray <NSString *> *typecTypeArray;

@end


@implementation BSPowerBankDevice

- (void)dealloc {
    [self cancelCommandTimer];
}

- (void)cancelCommandTimer
{
    if (!self.commandTimer) return;
    dispatch_source_cancel(self.commandTimer);
    self.commandTimer = nil;
    NSLog(@"\n*\n* ⭐️ commandTimer 销毁 \n*");
}

#pragma mark- BSBaseusBLEDelegate

- (void)didUpdateValue:(NSData *)value
{
    NSLog(@"⭐️ didUpdateValue  ： %@   sn====%@",value,self.identifier);
    if (![self commandDataSumFitBill:value]) {
        NSLog(@"⚠️ 数据返回错误，CRC校验失败");
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UInt8 *command = (UInt8 *)[value bytes];
        [self didUpdateCommand:command value:value];
    });
}


/// 返回数据处理为单个数据
- (void)didUpdateCommand:(UInt8 *)command value:(NSData *)value {
       
    NSUInteger dataLength = value.length ;
    if (dataLength < 7) {
        return;
    }

    short cmdType = command[1];  // 数据的类型
    short cmd = command[2];
    if (cmdType == 2 && cmd == 150 ) {
        //  写入请求返回的响应事件类型
        [self writeBlockValueCommand:value];
        return;
    }
    
    short cmdLength = command[3];
    if ( cmdLength + 4 > dataLength ) {
        return;
    }
    /// 有效数据
    NSData*validData = [value subdataWithRange:NSMakeRange(4, cmdLength)];
    
    const uint8_t *bytes = [validData bytes];
    NSUInteger sum = 0;
    NSUInteger length = [validData length];
    for (NSUInteger i = 0; i < length; i++) {
        Byte byteValue = bytes[i];
        [self readValueReturnCommand:cmd + i value:byteValue];
    }
    NSData *dataD = [value subdataWithRange:NSRangeFromString(k_Range2_2)];
    BSBLEResponse *response = [self responseWithCommandByte:dataD];

    id number = @((float)sum);
    if (response && response.commandBlock) {
        response.commandBlock(YES,number);
    }
    if (self.dataDidChangedBlock) {
        self.dataDidChangedBlock(YES);
    }
}


#pragma mark  设置写入，返回数据的处理
- (void)writeBlockValueCommand:(NSData *)value  {
    UInt8 *command = (UInt8 *)[value bytes];
    
//    short cmdLong = command[3];  // 数据的类型
//    short cmd = command[4];
    short cmdNumber = command[5];
    BOOL settingNumber = NO;
    if (cmdNumber == 0) {
        settingNumber = YES;
    }
//        // 设置成功
//        NSData *dataD = [value subdataWithRange:NSRangeFromString(@"4,1")];
//        
//        NSMutableData *dataMut = [[NSMutableData alloc]initWithData:dataD];
//        [dataMut appendData:dataD];
//    }
    
    NSData *dataD = [value subdataWithRange:NSRangeFromString(@"4,1")];
    
    NSMutableData *blockData = [[NSMutableData alloc]initWithData:dataD];
    [blockData appendData:dataD];
    
//    NSUInteger sum = 0;
//    NSData *dataD = [value subdataWithRange:NSRangeFromString(k_Range2_2)];
    BSBLEResponse *response = [self responseWithCommandByte:blockData];

    id number = @((BOOL)settingNumber);
    if (response && response.commandBlock) {
        response.commandBlock(settingNumber,number);
    }
    
//    0xaa0296023400ce55
}


#pragma mark  返回数据的处理之后的单个数据处理
- (void)readValueReturnCommand:(NSInteger)cmd value:(Byte)value {
    
//    NSLog(@"cmd==== %ld  cmdStr16=== %@H,value==== %hhu",cmd,[[NSString new] ToHex:cmd],value);
    NSUInteger cmdValue = value;
    NSString *numberForType = @"";
    switch (cmd) {
            ///C1
        case BSPowerBankCmdTypeC1_R_OutputA_L:
        {
            ///<  0x0000  *   TypeC1电流 低字节（毫安）
            self.typeC1.typeModelA.typeByte_L = value;
        }
            break;
        case BSPowerBankCmdTypeC1_R_OutputA_H:
        {
            ///<  0x0001  *   TypeC1电流 高字节 （毫安）
            numberForType = @"TypeC1电流";
            self.typeC1.typeModelA.typeByte_H = value;
        }
            break;
        case BSPowerBankCmdTypeC1_R_OutputV_L:
        {
            ///<  0x0002  *   TypeC1电压 低字节 （毫伏）
            self.typeC1.typeModelV.typeByte_L = value;
        }
            break;
        case BSPowerBankCmdTypeC1_R_OutputV_H:
        {
            ///<  0x0003  *   TypeC1电压 高字节 （毫伏）
            numberForType = @"TypeC1电压";
            self.typeC1.typeModelV.typeByte_H = value;
        }
            break;
        case BSPowerBankCmdTypeC1_R_OutputW_L:
        {
            ///<  0x0004  *   TypeC1功率 低字节（W）
            self.typeC1.typeModelW.typeByte_L = value;
        }
            break;
        case BSPowerBankCmdTypeC1_R_OutputW_H:
        {
            numberForType = @"TypeC1功率";
            ///<  0x0005  *   TypeC1功率 高字节（W）
            self.typeC1.typeModelW.typeByte_H = value;
        }
            break;
            ///C2
        case BSPowerBankCmdTypeC2_R_OutputA_L:
        {
            ///<  0x0006  *   TypeC2电流 低字节（毫安）
            self.typeC2.typeModelA.typeByte_L = value;
        }
            break;
        case BSPowerBankCmdTypeC2_R_OutputA_H:
        {
            numberForType = @"TypeC2电流";
            ///<  0x0007  *   TypeC2电流 高字节（毫安）
            self.typeC2.typeModelA.typeByte_H = value;
        }
            break;
        case BSPowerBankCmdTypeC2_R_OutputV_L:
        {
            ///<  0x0008  *   TypeC2电压 低字节 （毫伏）
            self.typeC2.typeModelV.typeByte_L = value;
        }
            break;
        case BSPowerBankCmdTypeC2_R_OutputV_H:
        {
            numberForType = @"TypeC2电压";
            ///<  0x0009  *   TypeC2电压 高字节 （毫伏）
            self.typeC2.typeModelV.typeByte_H = value;
        }
            break;
        case BSPowerBankCmdTypeC2_R_OutputW_L:
        {
            ///<  0x000A  *   TypeC2功率 低字节（W）
            self.typeC2.typeModelW.typeByte_L = value;
        }
            break;
        case BSPowerBankCmdTypeC2_R_OutputW_H:
        {
            numberForType = @"TypeC2功率";
            ///<  0x000B  *   TypeC2功率 高字节（W）
            self.typeC2.typeModelW.typeByte_H = value;
        }
           
            break;
        case BSPowerBankCmdCharge_C1_TCP_Read:
        {
            numberForType = @"设备C1口协议";
            ///<  0x000C  *   设备C1口协议
            self.typeC1.typeCType = cmdValue;
        }
            break;
        case BSPowerBankCmdCharge_C2_TCP_Read:
        {
            numberForType = @"设备C2口协议";
            ///<  0x000D  *   设备C2口协议
           
            self.typeC2.typeCType = cmdValue;
        }
            break;
            /// USBA1
        case BSPowerBankCmdTypeUSBA_R_OutputA_L:
        {
            ///<  0x000E  *   USBA 电流 低字节（毫安）
            self.USBA1.typeModelA.typeByte_L = value;
        }
            break;
        case BSPowerBankCmdTypeUSBA_R_OutputA_H:
        {
            numberForType = @"USBA 电流 ";
            ///<  0x000F  *   USBA 电流 高字节 （毫安）
            self.USBA1.typeModelA.typeByte_H = value;
        }
            break;
        case BSPowerBankCmdTypeUSBA_R_OutputV_L:
        {
            ///<  0x0010  *   USBA 电压 低字节 （毫伏）
            self.USBA1.typeModelV.typeByte_L = value;
        }
            break;
        case BSPowerBankCmdTypeUSBA_R_OutputV_H:
        {
            numberForType = @"USBA 电压 ";
            ///<  0x0011  *   USBA 电压 高字节 （毫伏）
            self.USBA1.typeModelV.typeByte_H = value;
        }
            break;
        case BSPowerBankCmdTypeUSBA_R_OutputW:
        {
            numberForType = @"USBA 电功率 ";
            ///<  0x0012  *   USBA功率 （W）（不分高低字节）
            self.USBA1.typeModelW.typeByte_L = value;
        }
            break;
        case BSPowerBankCmdCharge_USBA_TCP_Read:
        {
            numberForType = @"USBA协议  ";
            ///<  0x0013  *   USBA协议   类别
            self.USBA1.typeCType = cmdValue;
        }
            break;
        case BSPowerBankCmdDevice_state_Read:
        {
            numberForType = @"设备状态寄存器 ";
            /// 0x0015  *   设备状态寄存器
            ///  另外处理数据
            [self CmdDevice_state:cmdValue];
            if (self.typeConnectState != cmdValue) {
                self.typeConnectState = cmdValue;
            }
        }
            break;
        case BSPowerBankCmdBatteryNumber_Read:
        {
            numberForType = @"电池电量";
            ///<  0x0016  *   电池电量   （0-100%）
            self.batterySOC = cmdValue;
        }
            break;
        case BSPowerBankCmdBatteryT_Read:
        {
            numberForType = @"电池温度    单位：°C";
            ///<  0x0017  *   电池温度    单位：°C
            self.deviceTemp = cmdValue;
        }
            break;
        case BSPowerBankCmdBattery_V_L_Read:
        {
            ///<  0x0018  *   电池电压低节（毫伏）
            self.batteryModelV.typeByte_L = value;
        }
            break;
        case BSPowerBankCmdBattery_V_H_Read:
        {
            numberForType = @"电池电压高节（毫伏）";
            ///<  0x0019  *   电池电压高节（毫伏）
            self.batteryModelV.typeByte_H = value;
        }
            break;
        case BSPowerBankCmdBattery_A_L_Read:
        {
            ///<  0x001A  *   电池电流低节（毫伏）
            self.batteryModelA.typeByte_L = value;
        }
            break;
        case BSPowerBankCmdBattery_A_H_Read:
        {
            numberForType = @"电池电流高节（毫伏）";
            ///<  0x001B  *   电池电流高节（毫伏）
            self.batteryModelA.typeByte_H = value;
        }
            break;
        case BSPowerBankCmdBattery_LoopNum_L_Read:
        {
            ///<  0x001C  *   电池循环次数低字节（次）
//            self.batteryCyclesModel.typeByte_L = value;
            self.batteryCyclesModel.typeByte_L = 12;
        }
            break;
        case BSPowerBankCmdBattery_LoopNum_H_Read:
        {
            numberForType = @"电池循环次数";
            ///<  0x001D  *   电池循环次数高字节（次）
            self.batteryCyclesModel.typeByte_H = value;
        }
            break;
        case BSPowerBankCmdBattery_State_Read:
        {
            numberForType = @"电池健康度 ";
            ///<  0x001E  *   电池健康度   0-100%
            self.batteryState = cmdValue;
        }
            break;
        case BSPowerBankCmd_Input_Time_L_Read:
        {
            ///<  0x001F  *   充电剩余时间低字节（分钟）
            self.inputTimeModel.typeByte_L = value;
        }
            break;
        case BSPowerBankCmd_Input_Time_H_Read:
        {
            numberForType = @"充电剩余时间（分钟）";
            ///<  0x0020  *   充电剩余时间高字节（分钟）
            self.inputTimeModel.typeByte_H = value;
        }
            break;
        case BSPowerBankCmd_Output_Time_L_Read:
        {
            ///<  0x0021  *   放电剩余时间低字节（分钟）
            self.outputTimeModel.typeByte_L = value;
        }
            break;
        case BSPowerBankCmd_Output_Time_H_Read:
        {
            numberForType = @"放电剩余时间（分钟）";
            ///<  0x0022  *   放电剩余时间高字节（分钟）
            self.outputTimeModel.typeByte_H = value;
        }
            break;
        /// 电芯
        case BSPowerBankCmdCELL1V_L_Read:
        {
            ///<  0x0023  *   电芯1电压
            self.batteryCell_1.typeByte_L = value;
        }
            break;
        case BSPowerBankCmdCELL1V_H_Read:
        {
            numberForType = @" 电芯1电压";
            ///<  0x0024  *   电芯1电压
            self.batteryCell_1.typeByte_H = value;
        }
            break;
        case BSPowerBankCmdCELL2V_L_Read:
        {
            ///<  0x0025  *   电芯2电压
            self.batteryCell_2.typeByte_L = value;
        }
            break;
        case BSPowerBankCmdCELL2V_H_Read:
        {
            numberForType = @" 电芯2电压";
            ///<  0x0026  *   电芯2电压
            self.batteryCell_2.typeByte_H = value;
        }
            break;
        case BSPowerBankCmdCELL3V_L_Read:
        {
            ///<  0x0027  *   电芯3电压
            self.batteryCell_3.typeByte_L = value;
        }
            break;
        case BSPowerBankCmdCELL3V_H_Read:
        {
            numberForType = @" 电芯3电压";
            ///<  0x0028  *   电芯3电压
            self.batteryCell_3.typeByte_H = value;
        }
            break;
        case BSPowerBankCmdCELL4V_L_Read:
        {
            ///<  0x0029  *   电芯4电压
            self.batteryCell_4.typeByte_L = value;
        }
            break;
        case BSPowerBankCmdCELL4V_H_Read:
        {
            numberForType = @" 电芯4电压";
            ///<  0x002A  *   电芯4电压
            self.batteryCell_4.typeByte_H = value;
        }
            break;
        case BSPowerBankCmdCELL5V_L_Read:
        {
            
            ///<  0x002B *   电芯5电压
            self.batteryCell_5.typeByte_L = value;
        }
            break;
        case BSPowerBankCmdCELL5V_H_Read:
        {
            numberForType = @" 电芯5电压";
            ///<  0x002EC *   电芯5电压
            self.batteryCell_5.typeByte_H = value;
        }
            break;
        case BSPowerBankCmdCELL6V_L_Read:
        {
            ///<  0x002D  *   电芯6电压
            self.batteryCell_6.typeByte_L = value;
        }
            break;
        case BSPowerBankCmdCELL6V_H_Read:
        {
            numberForType = @" 电芯6电压";
            ///<  0x002E  *   电芯6电压
            self.batteryCell_6.typeByte_H = value;
        }
            break;
        case BSPowerBankCmdCELL7V_L_Read:
        {
            ///<  0x0030  *   电芯7电压
            self.batteryCell_7.typeByte_L = value;
        }
            break;
        case BSPowerBankCmdCELL7V_H_Read:
        {
            numberForType = @" 电芯7电压";
            ///<  0x0031  *   电芯7电压
            self.batteryCell_7.typeByte_H = value;
        }
            break;
        case BSPowerBankCmdTypeC1_RW_OutputW:
        {
            numberForType = @" C1 输出功率（w）";
            ///< 0x0032  *  C1 输出功率设置（w）
            self.typeC1.outputSetW = cmdValue;
        }
            break;
        case BSPowerBankCmdTypeC2_RW_OutputW:
        {
            numberForType = @" C2 输出功率（w）";
            ///< 0x0033  *  C2 输出功率设置（w）
            self.typeC2.outputSetW = cmdValue;
        }
            break;
        case BSPowerBankCmdClock_RW_open:
        {
            numberForType = @" 小电流模式";
            ///<  0x0034  *  小电流模式设置 0 关  1 开
            self.smallAMPType = cmdValue;
        }
            break;
        case BSPowerBankCmdClock_RW_Time_L:
        {
            ///<  0x0035  *   小电流时间限制低字节（分钟）
            self.smallAMPTimeModel.typeByte_L = value;
        }
            break;
        case BSPowerBankCmdClock_RW_Time_H:
        {
            numberForType = @" 小电流时间限制  分钟";
            ///<  0x0036  *   小电流时间限制高字节（分钟）
            self.smallAMPTimeModel.typeByte_H = value;
        }
            break;
        case BSPowerBankCmdBattery_RW_T_H:
        {
            numberForType = @" 高温保护阈值";
            ///<  0x0037  *  高温保护阈值设置（°C）
            self.deviceTempSet_H = cmdValue;
        }
            break;
        case BSPowerBankCmdBattery_RW_T_L:
        {
            numberForType = @" 低温保护阈值";
            ///<  0x0038  *   低温保护阈值设置（°C）
            self.deviceTempSet_L = cmdValue;
        }
            break;
        case BSPowerBankCmdBattery_R_state1:
        {
            ///<  0x0039  *   电池状态1   根据AFE分类
            self.batterySOC_state1 = cmdValue;
        }
            break;
        case BSPowerBankCmdBattery_R_state2:
        {
            ///<  0x003A  *   电池状态2   根据AFE分类
            self.batterySOC_state2 = cmdValue;
        }
            break;
        case BSPowerBankCmdInputType_RW_state_C1:
        {
            ///<  0x003B  * C1充电模式   0：智能模式；1 idle模式； 2 自定义模式（32H生效）
            self.typeC1.inputModelSet = cmdValue;
        }
            break;
        case BSPowerBankCmdInputType_RW_state_C2:
        {
            ///<  0x003C  * C2充电模式   0：智能模式；1 idle模式； 2 自定义模式（32H生效）
            self.typeC2.inputModelSet = cmdValue;
        }
            break;
        case BSPowerBankCmdLcdSetting_RW_state:
        {
            ///<   0x003E  *   Lcd 设置
            ///<   Bit0 显示时间 1 on/ 0 off
            ///<   Bit1 成就互动开关1 on/ 0 off
            ///<   Bit2-3 文字颜色设置 2 浅色/1 深色，0 默认
            [self CmdDevice_LcdSettingState:cmdValue];
            if (self.LcdStateType != cmdValue) {
                self.LcdStateType = cmdValue;
            }
        }
            break;
            
//            BSPowerBankCmdBattery_R_Time_L
        case BSPowerBankCmdBattery_R_Time_L:
        {
            ///<  0x0040  *   累计放电时长低字节,低8位数据，单位分钟
            self.outpuSumTimeModel.typeByte_L = cmdValue;
        }
            break;
        case BSPowerBankCmdBattery_R_Time_H:
        {
            numberForType = @"  累计放电时长 分钟";
            ///<  0x0041  *   累计放电时长高字节,高8位数据，单位分钟
            self.outpuSumTimeModel.typeByte_H = cmdValue;
        }
            break;
            
        case BSPowerBankCmdBattery_R_Sum_L:
        {
            ///<  0x0042  *   累计放电量低字节,低8位数据，单位mAH
            self.outpuSumMAHModel.typeByte_L = cmdValue;
        }
            break;
        case BSPowerBankCmdBattery_R_Sum_H:
        {
            numberForType = @"  累计放电放电量 单位mAH";
            ///< 0x0043  *   累计放电量,高8位数据，单位mAH
       
            self.outpuSumMAHModel.typeByte_H = cmdValue;
        }
            break;
            
        case BSPowerBankCmdBattery_R_Number_L:
        {
            ///<  0x0045  *   剩余电量低字节（mAH）
            self.batterySOCModel.typeByte_L = cmdValue;
        }
            break;
            
        case BSPowerBankCmdBattery_R_Number_H:
        {
            ///<  0x0046  *   剩余电量高字节（mAH）
            numberForType = @"  剩余电量（mAH）";
            self.batterySOCModel.typeByte_H = cmdValue;
        }
            break;
            
        case BSPowerBankCmdSetting_RW_Model:
        {
            ///<  0x0060  *  设置模式状态：
            self.setModel_state = cmdValue;
        }
            break;
        default:
            break;
    }
    
//    NSLog(@"%@",numberForType);
    NSLog(@"%@===cmd==== %ld  cmdStr16=== %@H,value==== %hhu",numberForType,cmd,[[NSString new] ToHex:cmd],value);
   
  
    
    
}

/// 0x0015  *   设备状态寄存器 数据处理
-(void)CmdDevice_state:(NSInteger)value {
    NSString *str10To16 = [NSString stringTo2Lenght16Hex:value];
    NSString *str16To2 = [NSString getBinaryByHex:str10To16];
    NSLog(@"str10To16 ===%@ ==str16To2 ==%@",str10To16,str16To2);
    NSInteger length = str16To2.length;
    
    for (NSUInteger i = 0; i < length; i++) {
        NSString *subData = [str16To2 substringWithRange:NSMakeRange(length-1-i, 1)];
        NSLog(@"subData====%@", subData);
        [self readDevice_stateByte:i value:subData.integerValue];
    }
}

#pragma mark  0x0015  *   设备状态寄存器 数据处理
- (void)readDevice_stateByte:(NSInteger)cmdByte value:(NSInteger)value {
    switch (cmdByte) {
        case 0:
            /// C1连接状态
            self.typeC1.typeConnect = value;
            break;
        case 1:
            /// C2连接状态
            self.typeC2.typeConnect = value;
            break;
        case 2:
            /// C1充电1/放电 0
            self.typeC1.typeState = value;
            break;
        case 3:
            /// C2充电1/放电 0
            self.typeC2.typeState = value;
            break;
        case 4:
            /// C1  异常1 / 未有异常 0
            self.typeC1.typeAlert = value;
            break;
        case 5:
            /// C1  异常1 / 未有异常 0
            self.typeC2.typeAlert = value;
            break;
        case 6:
            /// USBA1 连接状态
            self.USBA1.typeConnect = value;
            break;
        case 7:
            /// 小电流模式  后期看是否从这个字段中读取数据
            break;
            
        default:
            break;
    }
}


/// 0x0015  *   设备状态寄存器 数据处理
-(void)CmdDevice_LcdSettingState:(NSInteger)value {
    NSString *str10To16 = [NSString stringTo2Lenght16Hex:value];
    NSString *str16To2 = [NSString getBinaryByHex:str10To16];
    NSLog(@"str10To16 ===%@ ==str16To2 ==%@",str10To16,str16To2);
    NSInteger length = str16To2.length;
    if (length>4) {
        NSString *subData0 = [str16To2 substringWithRange:NSMakeRange(length-1-0, 1)];
        NSLog(@"subData====%@", subData0);
        [self readDevice_LcdSettingStateByte:0 value:subData0.integerValue];
        
        
        NSString *subData1 = [str16To2 substringWithRange:NSMakeRange(length-1-1, 1)];
        NSLog(@"subData====%@", subData1);
        [self readDevice_LcdSettingStateByte:1 value:subData1.integerValue];
        
        NSString *subData2_3 = [str16To2 substringWithRange:NSMakeRange(length-1-3, 2)];
        /// 二进制转为 10进制
        NSInteger subdataValue2_3 = [NSString getDecimalByBinary:subData2_3];
        
        NSLog(@"subData====%@", subData2_3);
        [self readDevice_LcdSettingStateByte:2 value:subdataValue2_3];
        
    }
   
}

#pragma mark  0x0015  *   设备状态寄存器 数据处理
- (void)readDevice_LcdSettingStateByte:(NSInteger)cmdByte value:(NSInteger)value {
    switch (cmdByte) {
        case 0:
            /// 显示时间
            self.LcdTimeType = value;
            break;
        case 1:
            ///  成就互动开关
            self.LcdInteractType = value;
            break;
        case 2:
            /// 文字颜色设置
            self.LcdTextColorType = value;
            break;
            
        default:
            break;
    }
}

#pragma mark  读取数据  开头和长度，连续指令
- (void)readValueWithCommand:(BSPowerBankCommand)command  length:(NSInteger)length block:(BSResponseBlock)block
{
    /// 功能码
    NSString *commandStr = [NSString stringWithFormat:@"%02lx",command];
    /// 连续长度
    NSString *LngthStr = [NSString stringWithFormat:@"%02lx",length];
    /// 是否  连续操作：
    /// 指令类型：0x00：读请求   0x01：写请求   0x02：响应   0x03：事件
    /// Bit4  连续操作： 0x00：否  0x01：是
    commandStr = [NSString stringWithFormat:@"%@%@%@",@"10",commandStr,LngthStr];
    
    [self writeCommand:commandStr end:@"55" responseBlockDataRange:k_Range2_2 block:block];
}

- (void)readSingleValueWithCommand:(BSPowerBankCommand)command  block:(BSResponseBlock)block
{
    /// 功能码
    NSString *commandStr = [NSString stringWithFormat:@"%02lx",command];
    /// 连续长度
//    NSString *LngthStr = [NSString stringWithFormat:@"%02lx",length];
    /// 是否  连续操作：
    /// 指令类型：0x00：读请求   0x01：写请求   0x02：响应   0x03：事件
    /// Bit4  连续操作： 0x00：否  0x01：是
    commandStr = [NSString stringWithFormat:@"%@%@01",@"10",commandStr];
    
    [self writeCommand:commandStr end:@"55" responseBlockDataRange:k_Range2_2 block:block];
}

#pragma mark  读取数据  开头和结尾，连续指令
- (void)readValueWithStartCommand:(BSPowerBankCommand)startCommand endCommand:(BSPowerBankCommand)endCommand  block:(BSResponseBlock)block{
    
    
    if (endCommand<startCommand) {
        NSLog(@"开始数据和 结束数据有误，请检查数据！！！");
        return;
    }
    /// 开始功能码
    NSString *commandStr = [NSString stringWithFormat:@"%02lx",startCommand];
    /// 连续长度
    NSString *LngthStr = [NSString stringWithFormat:@"%02lx",endCommand-startCommand+1];
    /// 连续读操作：指令 10
    /// 指令类型：0x00：读请求   0x01：写请求   0x02：响应   0x03：事件
    /// Bit4  连续操作： 0x00：否  0x01：是
    commandStr = [NSString stringWithFormat:@"%@%@%@",@"10",commandStr,LngthStr];
    [self writeCommand:commandStr end:@"55" responseBlockDataRange:k_Range2_2 block:block];
}

#pragma mark  事件读取信息  开头和结尾，连续指令
/// 事件读取信息 BSEnergyCommand 信息
/// startCommand ：开始的功能码（功能码）
/// ：是连续
/// endCommand ：结束的功能码（功能码）
- (void)eventValueWithStartCommand:(BSPowerBankCommand)startCommand endCommand:(BSPowerBankCommand)endCommand  block:(BSResponseBlock)block{
//    if (endCommand<startCommand) {
//        NSLog(@"开始数据和 结束数据有误，请检查数据！！！");
//        return;
//    }
//    /// 开始功能码
//    NSString *commandStr = [NSString stringWithFormat:@"%02lx",startCommand];
//    /// 连续长度
//    NSString *LngthStr = [NSString stringWithFormat:@"%02lx",endCommand-startCommand+1];
//    /// 连续读操作：指令 10
//    /// 指令类型：0x00：读请求   0x01：写请求   0x02：响应   0x03：事件
//    /// Bit4  连续操作： 0x00：否  0x01：是
//    commandStr = [NSString stringWithFormat:@"%@%@%@",@"12",commandStr,LngthStr];
//    [self writeCommand:commandStr end:@"55" responseBlockDataRange:k_Range2_2 block:block];
    
//    if (endCommand<startCommand) {
//        NSLog(@"开始数据和 结束数据有误，请检查数据！！！");
//        return;
//    }
    /// 开始功能码
    NSString *commandStr = [NSString stringWithFormat:@"%02lx",startCommand];
    /// 连续长度
//    NSString *LngthStr = [NSString stringWithFormat:@"%02lx",endCommand-startCommand+1];
    /// 连续读操作：指令 10
    /// 指令类型：0x00：读请求   0x01：写请求   0x02：响应   0x03：事件
    /// Bit4  连续操作： 0x00：否  0x01：是
    commandStr = [NSString stringWithFormat:@"%@%@",@"02",commandStr];
    [self writeCommand:commandStr end:@"55" responseBlockDataRange:k_Range2_2 block:block];
}


#pragma mark -  写入数据
- (void)writeData:(NSData *)data responseBlockData:(NSData *)blockData block:(BSResponseBlock)block
{
    [self addBleCommandByte:blockData responseBlock:block];
    [self addCommandData:data];
}



#pragma mark -    设置写入单个 信息
/// command ：开始的功能码（功能码）
/// cmdValue：设置值
///
- (void)writeWithSingleCommand:(BSPowerBankCommand)command  cmdValue:(NSInteger)cmdValue block:(BSResponseBlock)block
{
    /// 功能码
    NSString *commandStr = [NSString stringWithFormat:@"%02lx",command];
    /// 数据
    NSString *cmdValueStr = [NSString stringWithFormat:@"%02lx",cmdValue];
    /// 是否  连续操作：
    /// 指令类型：0x00：读请求   0x01：写请求   0x02：响应   0x03：事件
    /// Bit4  连续操作： 0x00：否  0x01：是
    /// 连续写入：11     长度01
    commandStr = [NSString stringWithFormat:@"%@%@%@%@",@"11",commandStr,@"01",cmdValueStr];
//    [self writeCommand:commandStr end:@"55" responseBlockDataRange:k_Range2_2 block:block];
    [self settingWriteCommand:commandStr end:@"55" block:block];
}

#pragma mark -    设置写入高低两个字节 信息
/// command ：开始的功能码（功能码）
/// cmdValue：设置值
- (void)writeWithTwoByteCommand:(BSPowerBankCommand)command  cmdValue:(NSInteger)cmdValue block:(BSResponseBlock)block
{
    /// 功能码
    NSString *commandStr = [NSString stringWithFormat:@"%02lx",command];
    /// 数据
    NSString *cmdValueStr = [NSString stringWithFormat:@"%04lx",cmdValue];
    NSInteger length = cmdValueStr.length;
    if (length!=4) {
        NSLog(@"写入数据不是两个字节，不符合数据结构要求");
        return;
    }
    NSString *firstTwo = [cmdValueStr substringToIndex:2];
    NSString *lastTwo = [cmdValueStr substringFromIndex:length-2];
    
    /// 是否  连续操作：
    /// 指令类型：0x00：读请求   0x01：写请求   0x02：响应   0x03：事件
    /// Bit4  连续操作： 0x00：否  0x01：是
    /// 连续写入：11     长度01
    commandStr = [NSString stringWithFormat:@"%@%@%@%@%@",@"11",commandStr,@"02",lastTwo,firstTwo];
//    [self writeCommand:commandStr end:@"55" responseBlockDataRange:k_Range2_2 block:block];
    [self settingWriteCommand:commandStr end:@"55" block:block];
}



#pragma mark -    设置事件写入高低两个字节 信息
/// command ：开始的功能码（功能码）
/// cmdValue：设置值
- (void)eventWithTwoByteCommand:(BSPowerBankCommand)command  cmdValue:(NSInteger)cmdValue block:(BSResponseBlock)block
{
    /// 功能码
    NSString *commandStr = [NSString stringWithFormat:@"%02lx",command];
    /// 数据
    NSString *cmdValueStr = [NSString stringWithFormat:@"%04lx",cmdValue];
    NSInteger length = cmdValueStr.length;
    if (length!=4) {
        NSLog(@"写入数据不是两个字节，不符合数据结构要求");
        return;
    }
    NSString *firstTwo = [cmdValueStr substringToIndex:2];
    NSString *lastTwo = [cmdValueStr substringFromIndex:length-2];
    
    /// 是否  连续操作：
    /// 指令类型：0x00：读请求   0x01：写请求   0x02：响应   0x03：事件
    /// Bit4  连续操作： 0x00：否  0x01：是
    /// 连续写入：11     长度01
    commandStr = [NSString stringWithFormat:@"%@%@%@%@%@",@"13",commandStr,@"02",lastTwo,firstTwo];
    [self writeCommand:commandStr end:@"55" responseBlockDataRange:k_Range2_2 block:block];
}


/// command ：开始的功能码（功能码）
/// cmdValue：设置值
- (void)readBlockWithTwoByteCommand:(BSPowerBankCommand)command  cmdValue:(NSInteger)cmdValue block:(BSResponseBlock)block
{
    /// 功能码
    NSString *commandStr = [NSString stringWithFormat:@"%02lx",command];
    /// 数据
    NSString *cmdValueStr = [NSString stringWithFormat:@"%02lx",cmdValue];
//    NSInteger length = cmdValueStr.length;
//    if (length!=4) {
//        NSLog(@"写入数据不是两个字节，不符合数据结构要求");
//        return;
//    }
//    NSString *firstTwo = [cmdValueStr substringToIndex:2];
//    NSString *lastTwo = [cmdValueStr substringFromIndex:length-2];
    
    /// 是否  连续操作：
    /// 指令类型：0x00：读请求   0x01：写请求   0x02：响应   0x03：事件
    /// Bit4  连续操作： 0x00：否  0x01：是
    /// 连续写入：11     长度01
    commandStr = [NSString stringWithFormat:@"%@%@%@",@"20",commandStr,cmdValueStr];
    [self writeCommand:commandStr end:@"55" responseBlockDataRange:k_Range2_2 block:block];
}



#pragma mark -   写入数据   Array  信息
/// command ：开始的功能码（功能码）
/// isContinuity：是否连续
/// length：连续的长度
/// arrWriteData：写入的数据
- (void)writeWithArrayCommand:(BSPowerBankCommand)command length:(NSInteger)length array:(NSArray*)arrWriteData block:(BSResponseBlock)block
{
    /// 功能码
    NSString *commandStr = [NSString stringWithFormat:@"%02lx",command];
    /// 连续长度
    NSString *LngthStr = [NSString stringWithFormat:@"%02lx",length];
    NSInteger arrNum = arrWriteData.count;
    if (arrNum !=length) {
        NSLog(@"写入数据和数据域长度不一致，请检查数据！！！");
        return;
    }
    NSMutableString *mutableStr = [NSMutableString string];
    for (NSNumber* num in arrWriteData) {
        NSInteger numData = [num integerValue];
        NSString *numStr = [NSString stringWithFormat:@"%02lx",(long)numData];
        [mutableStr appendString:numStr];
    }
    /// 是否  连续操作：
    /// 指令类型：0x00：读请求   0x01：写请求   0x02：响应   0x03：事件
    /// Bit4  连续操作： 0x00：否  0x01：是
    commandStr = [NSString stringWithFormat:@"%@%@%@%@",@"11",commandStr,LngthStr,mutableStr];
    [self writeCommand:commandStr end:@"55" responseBlockDataRange:k_Range2_2 block:block];
    
    
   
}

//// 设置屏保文字
- (void)writeThemeTextData:(NSString *)textStr block:(BSResponseBlock)block
{


}

#pragma mark -    设置事件写入高低两个字节 信息
/// command ：开始的功能码（功能码）
/// cmdValue：设置值
- (void)writeWithEventTwoByteCommand:(BSPowerBankCommand)command  cmdValue:(NSInteger)cmdValue block:(BSResponseBlock)block{
    /// 功能码
    NSString *commandStr = [NSString stringWithFormat:@"%02lx",command];
    /// 数据
    NSString *cmdValueStr = [NSString stringWithFormat:@"%04lx",cmdValue];
    NSInteger length = cmdValueStr.length;
    if (length!=4) {
        NSLog(@"写入数据不是两个字节，不符合数据结构要求");
        return;
    }
    NSString *firstTwo = [cmdValueStr substringToIndex:2];
    NSString *lastTwo = [cmdValueStr substringFromIndex:length-2];
    
    /// 是否  连续操作：
    /// 指令类型：0x00：读请求   0x01：写请求   0x02：响应   0x03：事件
    /// Bit4  连续操作： 0x00：否  0x01：是
    /// 连续写入：11     长度02
    commandStr = [NSString stringWithFormat:@"%@%@%@%@%@",@"13",commandStr,@"02",lastTwo,firstTwo];
    [self settingWriteCommand:commandStr end:@"55" block:block];
}

#pragma mark -    设置事件写入高低两个字节 信息
/// command ：开始的功能码（功能码）
/// cmdValue：设置值
- (void)eventWithImageStartIndex:(NSInteger)Index  cmdValue:(NSInteger)cmdValue block:(BSResponseBlock)block
{
    /// 功能码
    NSString *indexStr = [NSString stringWithFormat:@"%02lx",Index];
    NSString *commandStr = @"90";
    /// 数据
    NSString *cmdValueStr = [NSString stringWithFormat:@"%04lx",cmdValue];
    NSInteger length = cmdValueStr.length;
    if (length!=4) {
        NSLog(@"写入数据不是两个字节，不符合数据结构要求");
        return;
    }
    NSString *firstTwo = [cmdValueStr substringToIndex:2];
    NSString *lastTwo = [cmdValueStr substringFromIndex:length-2];
    
    /// 是否  连续操作：
    /// 指令类型：0x00：读请求   0x01：写请求   0x02：响应   0x03：事件
    /// Bit4  连续操作： 0x00：否  0x01：是
    /// 连续写入：11     长度01
    commandStr = [NSString stringWithFormat:@"%@%@%@%@%@",@"03",commandStr,@"03",lastTwo,firstTwo];
    [self writeCommand:commandStr end:@"55" responseBlockDataRange:k_Range2_2 block:block];
}

#pragma mark - TOOLS

- (void)writeCommand:(NSString *)str end:(NSString *)end responseBlockDataRange:(NSString *)range block:(BSResponseBlock)block
{
    
    NSMutableData *headData = [str convertHexStrToData:@"AA"];
   
    NSMutableData *data = [str convertHexStrToData:str];
    ///  校验码 = SUM (指令码 - 数据域)
    NSString* sumStr = [self sumWithData:data];
    data = [str convertHexStrToData:str];
    NSData *dataSum = [sumStr convertHexStrToData:sumStr];
    [data appendData:dataSum];
//    uint16_t crc = [self crcWithData:data];
//    Byte byte[] = {((uint8_t)(crc >> 8)&0xFF),((uint8_t)(crc)&0xFF)};
//    Byte byte[] = {((uint8_t)(crc)&0xFF)};
//    [data appendData:[NSData dataWithBytes:byte length:1]];
    if (end) {
        NSData *endData = [end convertHexStrToData:end];
        [data appendData:endData];
    }
    [headData appendData:data];
    NSData *dataD = [headData subdataWithRange:NSRangeFromString(range)];
    [self writeData:headData responseBlockData:dataD block:block];
}


- (void)settingWriteCommand:(NSString *)str end:(NSString *)end block:(BSResponseBlock)block
{
    
    NSMutableData *headData = [str convertHexStrToData:@"AA"];
   
    NSMutableData *data = [str convertHexStrToData:str];
    ///  校验码 = SUM (指令码 - 数据域)
    NSString* sumStr = [self sumWithData:data];
    data = [str convertHexStrToData:str];
    NSData *dataSum = [sumStr convertHexStrToData:sumStr];
    [data appendData:dataSum];
//    uint16_t crc = [self crcWithData:data];
//    Byte byte[] = {((uint8_t)(crc >> 8)&0xFF),((uint8_t)(crc)&0xFF)};
//    Byte byte[] = {((uint8_t)(crc)&0xFF)};
//    [data appendData:[NSData dataWithBytes:byte length:1]];
    if (end) {
        NSData *endData = [end convertHexStrToData:end];
        [data appendData:endData];
    }
    [headData appendData:data];
    NSData *dataD = [headData subdataWithRange:NSRangeFromString(@"2,1")];
    NSMutableData *blockData = [[NSMutableData alloc]initWithData:dataD];
    [blockData appendData:dataD];
    
    [self writeData:headData responseBlockData:blockData block:block];
}

#pragma mark -+++++++ 队列写入指令 Start +++++++

- (void)addCommandData:(NSData *)data
{
    @synchronized (self.commandArray) {
        [self.commandArray addObject:data];
    }
    [self creatCommandTimer];
}

- (void)creatCommandTimer
{
    if (self.commandTimer) return;
    NSLog(@"⭐️ commandTimer 初始化完成 ");
    double num = 0.120;
    self.commandTimer = [self creatCommandTimerWithInterval:num block:^{
        
        @synchronized (self.commandArray) {
            [self writeCommandData];
        }
        self.cancelTimerTime += num;
        if (self.cancelTimerTime > 2.0) { // 如果没有指令写入，2秒之后销毁定时器
            [self cancelCommandTimer];
            if (!self.isConnected) [self.commandArray removeAllObjects];
        }
    }];
}

- (void)writeCommandData
{
    if (self.commandArray.count == 0) return;
    self.cancelTimerTime = 0; // 有指令写入，销毁定时器时间归零
    NSData *data = [self.commandArray firstObject];
    BSPowerBankBLE *bleDevice  = (BSPowerBankBLE *)self.bleDevice;
    NSLog(@"\n*\n* ⭐️ write data : %@ \n*",data);
    [bleDevice writeCommand:data];
    [self.commandArray removeObject:data];
}


- (dispatch_source_t)creatCommandTimerWithInterval:(double)interval block:(dispatch_block_t)handler
{
    // 在线程执行
    // dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 创建一个定时器
    // Dispatch Source Timer 是间隔定时器，也就是说每隔一段时间间隔定时器就会触发。在 NSTimer 中要做到同样的效果需要手动把 repeats 设置为 YES。
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 开始执行时间
    // dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    dispatch_time_t start = dispatch_walltime(NULL, 0);
    /**
     * 设置时间
     *
     * 第二个参数，当我们使用dispatch_time 或者 DISPATCH_TIME_NOW 时，系统会使用默认时钟来进行计时。然而当系统休眠的时候，默认时钟是不走的，也就会导致计时器停止。
     * 使用 dispatch_walltime 可以让计时器按照真实时间间隔进行计时。
     *
     * 第四个参数 leeway 指的是一个期望的容忍时间，将它设置为 1 秒，意味着系统有可能在定时器时间到达的前 1 秒或者后 1 秒才真正触发定时器。
     * 在调用时推荐设置一个合理的 leeway 值。需要注意，就算指定 leeway 值为 0，系统也无法保证完全精确的触发时间，只是会尽可能满足这个需求。
     */
    dispatch_source_set_timer(timer, start, interval * NSEC_PER_SEC, 0.010 * NSEC_PER_SEC);
    // 设置回调
    // 这个函数在执行完之后，block 会立马执行一遍，后面隔一定时间间隔再执行一次。而 NSTimer 第一次执行是到计时器触发之后。这也是和 NSTimer 之间的一个显著区别。
    dispatch_source_set_event_handler(timer, handler);
    // 启动定时器
    dispatch_resume(timer);
    
    return timer;
}

- (NSString*)sumWithData:(NSData *)data
{
    return [BSDeviceCRC sumOfData:data];
}

// CRC校验
- (UInt16)crcWithData:(NSData *)data
{
    return [[self class] energyCrcWithData:data];
}

/// CRC校验
+ (UInt16)energyCrcWithData:(NSData *)data
{
    return [BSDeviceCRC crcWithData:data];
}




#pragma mark 校验CRC

/// 返回数据校验CRC是否正确
/// BSEnergyCommand 数据返回末尾不带 "20" 结束符
/// BSEnergyOTACommand 、 BSEnergyLogCommand 返回数据带 "20" 结束符
- (BOOL)commandDataCRCFitBill:(NSData *)data
{
    if (!data || data.length < 4) return NO;
    UInt8 *byte = (UInt8 *)[data bytes];
    uint16_t commandCRC;
    uint16_t crc;
    if ([self isAACommand:byte])
    {
        commandCRC = [self crcWithData:[data subdataWithRange:NSMakeRange(1, data.length-3)]];
        UInt8 *crcData = (UInt8 *)[[data subdataWithRange:NSMakeRange(data.length-2,2)] bytes];
        crc = (crcData[0] << 8 | crcData[1]);
    }
    else {
        return NO;
    }
    return (crc == commandCRC);
}


#pragma mark 返回数据校验sum是否正确
/// BSEnergyCommand 数据返回末尾不带 "20" 结束符
///
- (BOOL)commandDataSumFitBill:(NSData *)data
{
    if (!data || data.length < 4) return NO;
    UInt8 *byte = (UInt8 *)[data bytes];
    NSString* commandSum;
    uint16_t crc;
    uint16_t commandCRC;
    if ([self isAACommand:byte])
    {
        commandSum = [self sumWithData:[data subdataWithRange:NSMakeRange(1, data.length-3)]];
        NSData *dataSum = [commandSum convertHexStrToData:commandSum];
        UInt8 *commandDataSum = (UInt8 *)[dataSum bytes];
        
        UInt8 *commandSumUpData = (UInt8 *)[[data subdataWithRange:NSMakeRange(data.length-2,1)] bytes];
        commandCRC = commandSumUpData[0];
        crc = commandDataSum[0];
    }
    else {
        return NO;
    }
    return (crc == commandCRC);
}

- (BOOL)isAACommand:(UInt8 *)command
{
    return (command[0] == 0xAA );
}

- (NSMutableArray<NSData *> *)commandArray {
    if (!_commandArray) {
        _commandArray = [NSMutableArray array];
    }
    return _commandArray;
}

-(BSCommonDeviceTypeModel*)typeC1{
    if (!_typeC1) {
        _typeC1 = [BSCommonDeviceTypeModel new];
        _typeC1.typeName = @"C1";
        _typeC1.typeCMessageMaxA = 3;
        _typeC1.typeCMessageMaxW = 30;
        _typeC1.typeCTypeMessageDeviceName = @"iPhone 15 Pro";
        _typeC1.typeCType = 0;
    }
    return _typeC1;
}

-(BSCommonDeviceTypeModel*)typeC2{
    if (!_typeC2) {
        _typeC2 = [BSCommonDeviceTypeModel new];
        _typeC2.typeName = @"C2";
        _typeC2.typeCMessageMaxA = 4;
        _typeC2.typeCMessageMaxW = 40;
        _typeC2.typeCTypeMessageDeviceName = @"iPhone 16";
        _typeC2.typeCType = 1;
    }
    return _typeC2;
}

-(BSCommonDeviceTypeModel*)USBA1{
    if (!_USBA1) {
        _USBA1 = [BSCommonDeviceTypeModel new];
        _USBA1.typeName = @"A";
        _USBA1.typeCMessageMaxA = 5;
        _USBA1.typeCMessageMaxW = 60;
        _USBA1.typeCTypeMessageDeviceName = @"iPhone 17 Mac Pro";
        _USBA1.typeCType = 2;
    }
    return _USBA1;
}


-(BSCommonTypeByteModel*)batteryModelV{
    if (!_batteryModelV) {
        _batteryModelV = [self addTypeByteModel];
    }
    return _batteryModelV;
}

/// 电池电流（毫安）
-(BSCommonTypeByteModel*)batteryModelA{
    if (!_batteryModelA) {
        _batteryModelA = [self addTypeByteModel];
    }
    return _batteryModelA;
}

/// 电池循环次数
-(BSCommonTypeByteModel*)batteryCyclesModel{
    if (!_batteryCyclesModel) {
        _batteryCyclesModel = [self addTypeByteModel];
    }
    return _batteryCyclesModel;
}

/// 剩余电量   mAH
-(BSCommonTypeByteModel*)batterySOCModel{
    if (!_batterySOCModel) {
        _batterySOCModel = [self addTypeByteModel];
    }
    return _batterySOCModel;
}

-(BSCommonTypeByteModel*)inputTimeModel{
    if (!_inputTimeModel) {
        _inputTimeModel = [self addTypeByteModel];
    }
    return _inputTimeModel;
}

-(BSCommonTypeByteModel*)outputTimeModel{
    if (!_outputTimeModel) {
        _outputTimeModel = [self addTypeByteModel];
    }
    return _outputTimeModel;
}

-(BSCommonTypeByteModel*)outpuSumTimeModel{
    if (!_outpuSumTimeModel) {
        _outpuSumTimeModel = [self addTypeByteModel];
    }
    return _outpuSumTimeModel;
}

-(BSCommonTypeByteModel*)outpuSumMAHModel{
    if (!_outpuSumMAHModel) {
        _outpuSumMAHModel = [self addTypeByteModel];
    }
    return _outpuSumMAHModel;
}

-(BSCommonTypeByteModel*)smallAMPTimeModel{
    if (!_smallAMPTimeModel) {
        _smallAMPTimeModel = [self addTypeByteModel];
    }
    return _smallAMPTimeModel;
}

-(BSCommonTypeByteModel*)batteryCell_1{
    if (!_batteryCell_1) {
        _batteryCell_1 = [self addTypeByteModel];
    }
    return _batteryCell_1;
}

-(BSCommonTypeByteModel*)batteryCell_2{
    if (!_batteryCell_2) {
        _batteryCell_2 = [self addTypeByteModel];
    }
    return _batteryCell_2;
}

-(BSCommonTypeByteModel*)batteryCell_3{
    if (!_batteryCell_3) {
        _batteryCell_3 = [self addTypeByteModel];
    }
    return _batteryCell_3;
}

-(BSCommonTypeByteModel*)batteryCell_4{
    if (!_batteryCell_4) {
        _batteryCell_4 = [self addTypeByteModel];
    }
    return _batteryCell_4;
}

-(BSCommonTypeByteModel*)batteryCell_5{
    if (!_batteryCell_5) {
        _batteryCell_5 = [self addTypeByteModel];
    }
    return _batteryCell_5;
}

-(BSCommonTypeByteModel*)batteryCell_6{
    if (!_batteryCell_6) {
        _batteryCell_6 = [self addTypeByteModel];
    }
    return _batteryCell_6;
}

-(BSCommonTypeByteModel*)batteryCell_7{
    if (!_batteryCell_7) {
        _batteryCell_7 = [self addTypeByteModel];
    }
    return _batteryCell_7;
}

-(BSCommonTypeByteModel*)addTypeByteModel{
   
    BSCommonTypeByteModel *model = [BSCommonTypeByteModel new];
    return model;
}

@end
