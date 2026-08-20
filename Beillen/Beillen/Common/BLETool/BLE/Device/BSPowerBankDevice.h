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
    BSPowerBankCmdCharge_C2_TCP            =  13,    ///<  0x000D  *   设备C1口协议    BSPowerBankTypecType类别
  
    BSPowerBankCmdTypeUSBA_R_OutputA_L     =  14,     ///<  0x000E  *   USBA 电流 低字节（毫安）
    BSPowerBankCmdTypeUSBA_R_OutputA_H     =  15,     ///<  0x000F  *   USBA 电流 高字节 （毫安）
    BSPowerBankCmdTypeUSBA_R_OutputV_L     =  16,     ///<  0x0010  *   USBA 电压 低字节 （毫伏）
    BSPowerBankCmdTypeUSBA_R_OutputV_H     =  17,     ///<  0x0011  *   USBA 电压 高字节 （毫伏）
    BSPowerBankCmdTypeUSBA_R_OutputW       =  18,     ///<  0x0012  *   USBA功率 低字节（W）（不分高低字节）
    BSPowerBankCmdCharge_USBA_TCP          =  19,     ///<  0x0013  *   USBA协议    BSPowerBankTypecType类别
    
    BSPowerBankCmdDevice_state             =  21,    ///<  0x0015  *   设备状态寄存器       详情见备注2
    BSPowerBankCmdBatteryNumber            =  22,    ///<  0x0016  *   电池电量   （0-100%）
    BSPowerBankCmdBatteryT                 =  23,    ///<  0x0017  *   电池温度    单位：°C
    
    BSPowerBankCmdBattery_V_L              =  24,    ///<  0x0018  *   电池电压低节（毫伏）
    BSPowerBankCmdBattery_V_H              =  25,    ///<  0x0019  *   电池电压低节（毫伏）
    BSPowerBankCmdBattery_A_L              =  26,    ///<  0x001A  *   电池电压低节（毫伏）
    BSPowerBankCmdBattery_A_H              =  27,    ///<  0x001B  *   电池电压低节（毫伏）
    ///<
    BSPowerBankCmdBattery_LoopNum_L        =  28,    ///<  0x001C  *   电池循环次数低字节（次）
    BSPowerBankCmdBattery_LoopNum_H        =  29,    ///<  0x001D  *   电池循环次数高字节（次）
    BSPowerBankCmdBattery_State            =  30,    ///<  0x001E  *   电池健康度   0-100%
    ///< 充电‘’
    BSPowerBankCmd_Input_Time_L            =  31,     ///<  0x001F  *   充电剩余时间低字节（分钟）
    BSPowerBankCmd_Input_Time_H            =  32,     ///<  0x0020  *   充电剩余时间低字节（分钟）
    BSPowerBankCmd_Output_Time_L           =  33,     ///<  0x0021  *   放电剩余时间低字节（分钟）
    BSPowerBankCmd_Output_Time_H           =  34,     ///<  0x0022  *   放电剩余时间低字节（分钟）
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
    BSPowerBankCmdClock_RW_Time_H          =  54,     ///<  0x0036  *   小电流时间限制低字节（分钟）
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
//    BSPowerBankTypecTypeQC3_0_orNULL   = 4 ,
//    BSPowerBankTypecTypeAFC            = 5 ,
//    BSPowerBankTypecTypeFCP            = 6 ,
//    BSPowerBankTypecTypeSCP            = 7 ,
//    BSPowerBankTypecTypePD             = 8 ,
};


///  设备的工作状态
typedef NS_ENUM(NSInteger, BSPowerBankTypeCWork) {
    ///< 放电
    BSPowerBankTypeCWorkNULL               = 0 ,    // C1、C2 都空载
    BSPowerBankTypeCWorkOutput             = 1 ,    // 放电
    BSPowerBankTypeCWorkInput              = 2 ,    // 充电
};


///    备注 1
///    Register 0x000F: 控制模式寄存器
///    端口输出模式,由主控制器指定;
///    Bit
///    0     0: 允许C1口放电  1: 禁止C1口放电
///    1     0: 允许C2口放电  1: 禁止C2口放电
///    2-15  保留


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

///     备注 2
///     Register 0x0010:  端口状态寄存器
///     此寄存器的值根据端口状态实时更新,主控制器获取各个端口状态,据此进行空载的延时关断;
///     Bit
///     0-1  TypeC1口(双向口)状态  0:端口输出空载;     1:端口正在带载;  2:端口正在充电;
///     2-3  TypeC2口(双向口)状态  0:端口输出空载;     1:端口正在带载;  2:端口正在充电;
///     4    小电流模式状态         0:未处在小电流模式; 1:处在小电流模式;
///     5    仕兰MCU的休眠状态      0:未进入休眠       1:即将进入休眠(提前3秒)
///           ////   6- 11  电芯 1-6 的修复状态
///     6    0：未进行CELL6自动修复  1：正在进行CELL6自动修复
///     7
///     8
///     9
///     10
///     11
///     6-7  保留


///     备注 3
///     Register 0x0011：设备异常标志寄存器
///     Bit
///     0~7 bit为  TypeC1端口异常位，
///     8~15bit为  TypeC2端口异常位
///     TypeC1端口和TypeC2端口发生过压/欠压保护、过流保护、过温保护、短路保护后异常赋相应的值,所有异常清除后清0;
///     TypeC1端口异常
///     0     0: 未欠压   1: 欠压保护
///     1     保留
///     2     0: 未短路    1: 短路保护
///     3     0: 未过流    1: 过流保护
///     4     0: 温度正    1: 过温保护
///     5-7   保留
///
///     TypeC2端口异常
///     8     0: 未欠压    1: 欠压保护
///     9     保留
///     10    0: 未短路    1: 短路保护
///     11    0: 未过流    1: 过流保护
///     12    0: 温度正    1: 过温保护
///     13-15 保留


///     备注  4
///     Register 0x0012 设备快充协议寄存器
///     C1和C2口的协议类型
///     Bit
///     0~7 bit为  TypeC1端口 协议
///     8~15bit为  TypeC2端口 协议
///     0-7
///     8-15
///  65W 定义
///            NULL     0
///            PPS      1
///            PD3.0    2
///            QC2.0    3
///            QC3.0    4
///            AFC      5
///            FCP      6
///            SCP      7
///
///     140W 定义
///            NULL     0
///            DCP      1
///            未定义    2
///            QC       3
///            未定义    4
///            AFC      5
///            FCP      6
///            SCP      7
///            PD       8
///
///










@interface BSPowerBankDevice : BSCommonDevice
/// TypeC1 当前状态  0:空载 1:放电  2:充电
/// @property (nonatomic, assign) NSInteger typeC1State;
@property (nonatomic, assign) NSInteger typeC1State;
@property (nonatomic, assign) NSInteger typeC2State;
@property (nonatomic, assign) BSPowerBankTypeCWork workState ;
@property (nonatomic, assign) BSPowerBankTypecType typeC1Type;
@property (nonatomic, assign) BSPowerBankTypecType typeC2Type;
@property (nonatomic, copy  ) NSString* typeC1TypeStr;
@property (nonatomic, copy  ) NSString* typeC2TypeStr;

///  小电流模式状态   0:未处在小电流模式; 1:处在小电流模式;
@property (nonatomic, assign) NSInteger smallAMPType;
@property (nonatomic, assign) NSInteger deviceTemp;            //设备温度 // 显示真实值减100
@property (nonatomic, copy)   NSString* deviceTempStr;         //设备温度 // 显示真实值减100

/// 电池  0%-100%
@property (nonatomic, assign) NSInteger batterySOC;
@property (nonatomic, copy)   NSString* batterySOCStr;
///输出、输入总功率
@property (nonatomic, assign) float outputPowerC1;
@property (nonatomic, assign) float inputPowerC1;
@property (nonatomic, assign) float outputPowerC2;
@property (nonatomic, assign) float inputPowerC2;

///输出、输入 电压
@property (nonatomic, assign) float outputVoltageC1;
@property (nonatomic, assign) float inputVoltageC1;
@property (nonatomic, assign) float outputVoltageC2;
@property (nonatomic, assign) float inputVoltageC2;
///输出、输入 电流
@property (nonatomic, assign) float outputAMPC1;
@property (nonatomic, assign) float inputAMPC1;
@property (nonatomic, assign) float outputAMPC2;
@property (nonatomic, assign) float inputAMPC2;

///电芯1-6 温度  循环次数
@property (nonatomic, assign) NSInteger batteryTemp;              //电芯温度 // 显示真实值减100
@property (nonatomic, copy)   NSString* batteryTempStr;           //电芯温度 // 显示真实值减100
@property (nonatomic, assign) NSInteger batteryCycles;            // 循环次数
@property (nonatomic, copy)   NSString* batteryCyclesStr;         // 循环次数

/// 放电、充电 剩余时间  如果超过24 小时就取最大值24小时
@property (nonatomic, assign) NSInteger outputTime;
@property (nonatomic, assign) NSInteger inputTime;
@property (nonatomic, copy)   NSString* outputTimeStr;
@property (nonatomic, copy)   NSString* inputTimeStr;

/// 倒计时关机时间
@property (nonatomic, assign) NSInteger typeC_CloseTime;
@property (nonatomic, copy)   NSString* typeC_CloseTimeStr;
/// 计时时间
@property (nonatomic, assign) NSInteger clock_CloseTime;
@property (nonatomic, copy)   NSString* clock_CloseTimeStr;

/// 格式: 二进制字符串 eg: 二进制为 1110 1010 -> 倒序后的错误对应为 01010111
@property (nonatomic, strong) NSArray *localErrorArrayStr;
/// localErrorArray 有值， 说明有异常存在
@property (nonatomic, strong) NSMutableArray *localErrorArray;
@property (nonatomic, strong) NSMutableDictionary *localErrorDict;
@property (nonatomic, copy)   NSString *localErrorWebStr;    // 异常网页参数
/// 格式: 二进制字符串 eg: 二进制为 1110 1010 -> 倒序后的对应为 ["0","1","0","1","0",,"1","1","1"]
@property (nonatomic, strong) NSString *typeCStateStr;
/// 端口协议
@property (nonatomic, strong) NSString *typeCTypeStr;
// param 数据发生变化
@property (nonatomic, copy  ) void (^dataDidChangedBlock)(BOOL success);
// param 数据发生变化
@property (nonatomic, copy  ) void (^dataDidChangedWithInfoBlock)(BOOL success);
/// 读取 BSEnergyCommand 信息
- (void)readValueWithCommand:(BSPowerBankCommand)command block:(BSResponseBlock)block;

/// 读取 BSEnergyCommand 信息
/// command ：开始的功能码（功能码）
/// isContinuity：是否连续
/// length：连续的长度
- (void)readValueWithCommand:(BSPowerBankCommand)command continuity:(BOOL)isContinuity length:(NSInteger)length block:(BSResponseBlock)block;

/// 写入 BSEnergyCommand 数据
- (void)writeData:(NSInteger)data command:(BSPowerBankCommand)command block:(BSResponseBlock)block;

- (void)writeThemeTextData:(NSString *)textStr block:(BSResponseBlock)block ;


/// 读取 BSEnergyCommand 信息
/// command ：开始的功能码（功能码）
/// isContinuity：是否连续
/// length：连续的长度
- (void)writeWithCommand:(BSPowerBankCommand)command continuity:(BOOL)isContinuity length:(NSInteger)length block:(BSResponseBlock)block;

@end

NS_ASSUME_NONNULL_END
