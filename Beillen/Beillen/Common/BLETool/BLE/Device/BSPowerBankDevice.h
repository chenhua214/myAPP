//
//  BSPowerBankDevice.h
//  JDKJAPP
//
//  Created by chen on 2026/1/13.
//

#import "BSCommonDevice.h"

NS_ASSUME_NONNULL_BEGIN
#define k_Range2_3  @"2,3"
#define k_Range2_2  @"2,2"
typedef NS_ENUM(NSInteger, BSPowerBankCommand) {
    ///< 放电
    BSPowerBankCmdTypeC1_R_OutputA_L       =  0,     ///<  0x0000  *   TypeC1电流 低字节（毫安）
    BSPowerBankCmdTypeC1_R_OutputA_H       =  1,     ///<  0x0001  *   TypeC1电流 高字节 （毫安）
    BSPowerBankCmdTypeC1_R_OutputV_L       =  2,     ///<  0x0002  *   TypeC1电压 低字节 （毫伏）
    BSPowerBankCmdTypeC1_R_OutputV_H       =  3,     ///<  0x0003  *   TypeC1电压 高字节 （毫伏）
    BSPowerBankCmdTypeC1_R_OutputW_L       =  4,     ///<  0x0004  *   TypeC1功率 低字节（W）
    BSPowerBankCmdTypeC1_R_OutputW_H       =  5,     ///<  0x0005  *   TypeC1功率 高字节（W）
    ///<
    BSPowerBankCmdTypeC2_R_OutputA_L       =  6,     ///<  0x0006  *   TypeC2电流 低字节（毫安）
    BSPowerBankCmdTypeC2_R_OutputA_H       =  7,     ///<  0x0007  *   TypeC2电流 高字节 （毫安）
    BSPowerBankCmdTypeC2_R_OutputV_L       =  8,     ///<  0x0008  *   TypeC2电压 低字节 （毫伏）
    BSPowerBankCmdTypeC2_R_OutputV_H       =  9,     ///<  0x0009  *   TypeC2电压 高字节 （毫伏）
    BSPowerBankCmdTypeC2_R_OutputW_L       =  10,    ///<  0x000A  *   TypeC2功率 低字节（W）
    BSPowerBankCmdTypeC2_R_OutputW_H       =  11,    ///<  0x000B  *   TypeC2功率 高字节（W）
    BSPowerBankCmdCharge_C1_TCP            =  12,    ///<  0x000C  *   设备C1口协议     BSPowerBankTypecType类别
    BSPowerBankCmdCharge_C2_TCP            =  13,    ///<  0x000D  *   设备C2口协议    BSPowerBankTypecType类别
  
    BSPowerBankCmdTypeUSBA_R_OutputA_L     =  14,     ///<  0x000E  *   USBA 电流 低字节（毫安）
    BSPowerBankCmdTypeUSBA_R_OutputA_H     =  15,     ///<  0x000F  *   USBA 电流 高字节 （毫安）
    BSPowerBankCmdTypeUSBA_R_OutputV_L     =  16,     ///<  0x0010  *   USBA 电压 低字节 （毫伏）
    BSPowerBankCmdTypeUSBA_R_OutputV_H     =  17,     ///<  0x0011  *   USBA 电压 高字节 （毫伏）
    BSPowerBankCmdTypeUSBA_R_OutputW       =  18,     ///<  0x0012  *   USBA功率 （W）（不分高低字节）
    BSPowerBankCmdCharge_USBA_TCP          =  19,     ///<  0x0013  *   USBA协议    BSPowerBankTypecType类别
    
    BSPowerBankCmdDevice_state             =  21,    ///<  0x0015  *   设备状态寄存器       详情见备注2
    BSPowerBankCmdBatteryNumber            =  22,    ///<  0x0016  *   电池电量   （0-100%）
    BSPowerBankCmdBatteryT                 =  23,    ///<  0x0017  *   电池温度    单位：°C
    
    BSPowerBankCmdBattery_V_L              =  24,    ///<  0x0018  *   电池电压低节（毫伏）
    BSPowerBankCmdBattery_V_H              =  25,    ///<  0x0019  *   电池电压高节（毫伏）
    BSPowerBankCmdBattery_A_L              =  26,    ///<  0x001A  *   电池电流低节（毫安）
    BSPowerBankCmdBattery_A_H              =  27,    ///<  0x001B  *   电池电流高节（毫按）
    ///<
    BSPowerBankCmdBattery_LoopNum_L        =  28,    ///<  0x001C  *   电池循环次数低字节（次）
    BSPowerBankCmdBattery_LoopNum_H        =  29,    ///<  0x001D  *   电池循环次数高字节（次）
    BSPowerBankCmdBattery_State            =  30,    ///<  0x001E  *   电池健康度   0-100%
    ///< 充电‘’
    BSPowerBankCmd_Input_Time_L            =  31,     ///<  0x001F  *   充电剩余时间低字节（分钟）
    BSPowerBankCmd_Input_Time_H            =  32,     ///<  0x0020  *   充电剩余时间高字节（分钟）
    BSPowerBankCmd_Output_Time_L           =  33,     ///<  0x0021  *   放电剩余时间低字节（分钟）
    BSPowerBankCmd_Output_Time_H           =  34,     ///<  0x0022  *   放电剩余时间高字节（分钟）
    ///< 电芯1电压
    BSPowerBankCmdCELL1V_L                 =  35,    ///<  0x0023  *   Cell  1电压低字节（毫伏）
    BSPowerBankCmdCELL1V_H                 =  36,    ///<  0x0024  *   电芯1电压
    BSPowerBankCmdCELL2V_L                 =  37,    ///<  0x0025  *   电芯2电压
    BSPowerBankCmdCELL2V_H                 =  38,    ///<  0x0026  *   电芯2电压
    BSPowerBankCmdCELL3V_L                 =  39,    ///<  0x0027  *   电芯3电压
    BSPowerBankCmdCELL3V_H                 =  40,    ///<  0x0028  *   电芯3电压
    BSPowerBankCmdCELL4V_L                 =  41,    ///<  0x0029  *   电芯4电压
    BSPowerBankCmdCELL4V_H                 =  42,    ///<  0x002A  *   电芯4电压
    BSPowerBankCmdCELL5V_L                 =  43,    ///<  0x002B  *   电芯5电压
    BSPowerBankCmdCELL5V_H                 =  44,    ///<  0x002C  *   电芯5电压
    BSPowerBankCmdCELL6V_L                 =  45,    ///<  0x002D  *   电芯6电压
    BSPowerBankCmdCELL6V_H                 =  46,    ///<  0x002E  *   电芯6电压
    BSPowerBankCmdCELL7V_L                 =  48,    ///<  0x0030  *   电芯7电压
    BSPowerBankCmdCELL7V_H                 =  49,    ///<  0x0031  *   电芯7电压
    ///<  Read  and Write
    BSPowerBankCmdTypeC1_RW_OutputW        =  50,     ///<  0x0032  *  C1 输出功率设置（w）
    BSPowerBankCmdTypeC2_RW_OutputW        =  51,     ///<  0x0033  *  C2 输出功率设置（w）
    BSPowerBankCmdClock_RW_open            =  52,     ///<  0x0034  *  小电流模式设置 0：关闭小电流模式   1：开启小电流模式
    BSPowerBankCmdClock_RW_Time_L          =  53,     ///<  0x0035  *   小电流时间限制低字节（分钟）
    BSPowerBankCmdClock_RW_Time_H          =  54,     ///<  0x0036  *   小电流时间限制高字节（分钟）
    ///<
    BSPowerBankCmdBattery_RW_T_H           =  55,     ///<  0x0037  *  高温保护阈值设置（°C）
    BSPowerBankCmdBattery_RW_T_L           =  56,     ///<  0x0038  *   低温保护阈值设置（°C）
    BSPowerBankCmdBattery_R_state1         =  57,     ///<  0x0039  *   电池状态1   根据AFE分类
    BSPowerBankCmdBattery_R_state2         =  58,     ///<  0x003A  *   电池状态2   根据AFE分类
    
    ///<  0x0060  *  设置模式状态：0x00标准模式；0x01时间模式；0x02：天气模式；0x03歌词模式；0x04微信模式；0x05 图片投影模式； 0x06 心情模式
    BSPowerBankCmdSetting_RW_Model             =  96,
    ///<  0x0061  *   模式状态：0x00标准模式；0x01时间模式；0x02：天气模式；0x03歌词模式；0x04微信模式；0x05 图片投影模式； 0x06 心情模式
    BSPowerBankCmdSetting_R_Model              =  97,


};

/// 0x0012、0x0013  设备快充协议寄存器    C1和C2口的协议类型
typedef NS_ENUM(NSInteger, BSPowerBankTypecType) {
    ///< 放电
    BSPowerBankTypecType_IDLE           = 0 ,
    BSPowerBankTypecType_PD             = 1 ,
    BSPowerBankTypecType_QC             = 2 ,
    BSPowerBankTypecType_SCP            = 3 ,
};


///  设备的工作状态
typedef NS_ENUM(NSInteger, BSPowerBankTypeCWork) {
    ///< 放电
    BSPowerBankTypeCWorkNULL               = 0 ,    // C1、C2 都空载
    BSPowerBankTypeCWorkOutput             = 1 ,    // 放电
    BSPowerBankTypeCWorkInput              = 2 ,    // 充电
};


///     备注 2
///     Register  0x0015  *   设备状态寄存器
///     Bit
///     0~7 bit为  设备状态寄存器，
///
///     TypeC1端口异常   Bit
///     0     C1 连接状态
///     1     C2  连接状态保留
///     2     C1  充电1   /    放电 0
///     3     C2  充电1  /    放电 0
///     4     C1  异常
///     5     C2  异常
///     6     C2  Usba连接状态
///     7     C2  小电流模式




@interface BSCommonTypeByteModel : NSObject
///
@property (nonatomic, assign) Byte typeByte_L;
@property (nonatomic, assign) Byte typeByte_H;
@property (nonatomic, assign) NSInteger typeValue;

@end


@interface BSCommonDeviceTypeModel: NSObject
///  、电流 （毫安）
@property(nonatomic, strong) BSCommonTypeByteModel *typeModelA;
///  、电压 （毫伏）
@property(nonatomic, strong) BSCommonTypeByteModel *typeModelV;
///  、功率 （W）
@property(nonatomic, strong) BSCommonTypeByteModel *typeModelW;

/// 接口协议类型
@property (nonatomic, assign) BSPowerBankTypecType typeCType;
/// 充电1   /    放电 0
@property (nonatomic, assign) NSInteger typeState;
/// 连接1 / 未连接 0
@property (nonatomic, assign) NSInteger typeConnect;
///  异常1 / 未有异常 0
@property (nonatomic, assign) NSInteger typeAlert;
///  输出功率设置 W
@property (nonatomic, assign) NSInteger outputSetW;
@end



@interface BSPowerBankDevice : BSCommonDevice
/// TypeC1
@property(nonatomic, strong) BSCommonDeviceTypeModel *typeC1;
/// TypeC2
@property(nonatomic, strong) BSCommonDeviceTypeModel *typeC2;
/// USBA1
@property(nonatomic, strong) BSCommonDeviceTypeModel *USBA1;
/// 电池  0%-100%
@property (nonatomic, assign) NSInteger batterySOC;
///设备温度  摄氏度
@property (nonatomic, assign) NSInteger deviceTemp;
@property (nonatomic, copy)   NSString* deviceTempStr;
/// 电池电压（毫伏）
@property(nonatomic, strong) BSCommonTypeByteModel *batteryModelV;
/// 电池电流（毫安）
@property(nonatomic, strong) BSCommonTypeByteModel *batteryModelA;
/// 电池循环次数
@property(nonatomic, strong) BSCommonTypeByteModel *batteryCyclesModel;
/// 电池健康度  0-100%
@property (nonatomic, assign) NSInteger batteryState;
/// 充电剩余时间（分钟）
@property(nonatomic, strong) BSCommonTypeByteModel *inputTimeModel;
/// 放电剩余时间（分钟）
@property(nonatomic, strong) BSCommonTypeByteModel *outputTimeModel;
///  小电流模式状态   0:未处在小电流模式; 1:处在小电流模式;
@property (nonatomic, assign) NSInteger smallAMPType;
/// 小电流时间限制（分钟）
@property(nonatomic, strong) BSCommonTypeByteModel *smallAMPTimeModel;
///设备高温设置保护  摄氏度
@property (nonatomic, assign) NSInteger deviceTempSet_H;
///设备低温设置保护  摄氏度
@property (nonatomic, assign) NSInteger deviceTempSet_L;
///电池状态1
@property (nonatomic, assign) NSInteger batterySOC_state1;
///电池状态2
@property (nonatomic, assign) NSInteger batterySOC_state2;
///模式设置
@property (nonatomic, assign) NSInteger setModel_state;

/// 电池Cell 电压（毫伏）
@property(nonatomic, strong) BSCommonTypeByteModel *batteryCell_1;
@property(nonatomic, strong) BSCommonTypeByteModel *batteryCell_2;
@property(nonatomic, strong) BSCommonTypeByteModel *batteryCell_3;
@property(nonatomic, strong) BSCommonTypeByteModel *batteryCell_4;
@property(nonatomic, strong) BSCommonTypeByteModel *batteryCell_5;
@property(nonatomic, strong) BSCommonTypeByteModel *batteryCell_6;
@property(nonatomic, strong) BSCommonTypeByteModel *batteryCell_7;



//
///// 倒计时关机时间
//@property (nonatomic, assign) NSInteger typeC_CloseTime;
//@property (nonatomic, copy)   NSString* typeC_CloseTimeStr;
///// 计时时间
//@property (nonatomic, assign) NSInteger clock_CloseTime;
//@property (nonatomic, copy)   NSString* clock_CloseTimeStr;
//
///// 格式: 二进制字符串 eg: 二进制为 1110 1010 -> 倒序后的错误对应为 01010111
//@property (nonatomic, strong) NSArray *localErrorArrayStr;
///// localErrorArray 有值， 说明有异常存在
//@property (nonatomic, strong) NSMutableArray *localErrorArray;
//@property (nonatomic, strong) NSMutableDictionary *localErrorDict;
//@property (nonatomic, copy)   NSString *localErrorWebStr;    // 异常网页参数
///// 格式: 二进制字符串 eg: 二进制为 1110 1010 -> 倒序后的对应为 ["0","1","0","1","0",,"1","1","1"]
//@property (nonatomic, strong) NSString *typeCStateStr;
///// 端口协议
//@property (nonatomic, strong) NSString *typeCTypeStr;
//// param 数据发生变化

@property (nonatomic, copy  ) void (^dataDidChangedBlock)(BOOL success);
// param 数据发生变化
@property (nonatomic, copy  ) void (^dataDidChangedWithInfoBlock)(BOOL success);


/// 读取 BSEnergyCommand 信息
/// command ：开始的功能码（功能码）
/// isContinuity：是否连续
/// length：连续的长度
- (void)readValueWithCommand:(BSPowerBankCommand)command length:(NSInteger)length block:(BSResponseBlock)block;


/// 读取 BSEnergyCommand 信息
/// startCommand ：开始的功能码（功能码）
/// ：是连续
/// endCommand ：结束的功能码（功能码）
- (void)readValueWithStartCommand:(BSPowerBankCommand)startCommand endCommand:(BSPowerBankCommand)endCommand  block:(BSResponseBlock)block;



- (void)writeThemeTextData:(NSString *)textStr block:(BSResponseBlock)block ;


///  设置写入单个 信息
/// command ：开始的功能码（功能码）
/// cmdValue：设置值
///
- (void)writeWithSingleCommand:(BSPowerBankCommand)command  cmdValue:(NSInteger)cmdValue block:(BSResponseBlock)block;


///  设置写入高低两个字节 信息
/// command ：开始的功能码（功能码）
/// cmdValue：设置值
- (void)writeWithTwoByteCommand:(BSPowerBankCommand)command  cmdValue:(NSInteger)cmdValue block:(BSResponseBlock)block;

/// 写入数据   Array 信息
/// command ：开始的功能码（功能码）
/// length：连续的长度
/// arrWriteData：写入的数据
- (void)writeWithArrayCommand:(BSPowerBankCommand)command length:(NSInteger)length array:(NSArray*)arrWriteData block:(BSResponseBlock)block;
@end

NS_ASSUME_NONNULL_END
