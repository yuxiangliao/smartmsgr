/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50505
Source Host           : localhost:3306
Source Database       : smartmsgr

Target Server Type    : MYSQL
Target Server Version : 50505
File Encoding         : 65001

Date: 2018-08-11 18:56:22
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for sms_number_policy
-- ----------------------------
DROP TABLE IF EXISTS `sms_number_policy`;
CREATE TABLE `sms_number_policy` (
  `Num` varchar(20) NOT NULL,
  `RPolicy` smallint(2) NOT NULL DEFAULT '0',
  `SPolicy` smallint(2) NOT NULL DEFAULT '0',
  `Actived` varchar(1) NOT NULL DEFAULT 'N',
  PRIMARY KEY (`Num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sms_number_policy
-- ----------------------------

-- ----------------------------
-- Table structure for sms_processed
-- ----------------------------
DROP TABLE IF EXISTS `sms_processed`;
CREATE TABLE `sms_processed` (
  `ID` varchar(20) NOT NULL COMMENT '事务标识',
  `BizID` varchar(2) NOT NULL COMMENT '业务标识',
  `Gateway` varchar(2) NOT NULL DEFAULT '01' COMMENT '短信网关标识',
  `RcvTime` datetime NOT NULL COMMENT '接收时间',
  `RcvNum` varchar(20) NOT NULL COMMENT '接收的号码',
  `RcvContent` varchar(512) NOT NULL COMMENT '接收的内容',
  `PBizCode` varchar(3) NOT NULL COMMENT '处理业务编号(如售电,查询等)',
  `PStartTime` datetime NOT NULL COMMENT '处理开始时间',
  `PEndTime` datetime NOT NULL COMMENT '处理结束时间',
  `PReference` varchar(20) NOT NULL COMMENT '业务处理标识',
  `PReplyID` varchar(20) NOT NULL COMMENT '短信回复标识',
  `PResult` varchar(1) NOT NULL COMMENT '处理状态: S为成功,F失败',
  `PResultContent` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`,`RcvTime`),
  KEY `ix_process_reply_id` (`PReplyID`) USING BTREE,
  KEY `ix_process_bzid_time` (`BizID`,`RcvTime`) USING BTREE,
  KEY `ix_process_time` (`RcvTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
/*!50100 PARTITION BY RANGE (year(RcvTime))
(PARTITION p2013 VALUES LESS THAN (2014) ENGINE = InnoDB,
 PARTITION p2014 VALUES LESS THAN (2015) ENGINE = InnoDB,
 PARTITION p2015 VALUES LESS THAN (2016) ENGINE = InnoDB,
 PARTITION p2016 VALUES LESS THAN (2017) ENGINE = InnoDB,
 PARTITION p2017 VALUES LESS THAN (2018) ENGINE = InnoDB,
 PARTITION p2018 VALUES LESS THAN (2019) ENGINE = InnoDB,
 PARTITION p2019 VALUES LESS THAN (2020) ENGINE = InnoDB,
 PARTITION p2020 VALUES LESS THAN (2021) ENGINE = InnoDB,
 PARTITION p2021 VALUES LESS THAN (2022) ENGINE = InnoDB,
 PARTITION p2022 VALUES LESS THAN (2023) ENGINE = InnoDB,
 PARTITION p2023 VALUES LESS THAN (2024) ENGINE = InnoDB,
 PARTITION p2099 VALUES LESS THAN MAXVALUE ENGINE = InnoDB) */;

-- ----------------------------
-- Records of sms_processed
-- ----------------------------

-- ----------------------------
-- Table structure for sms_received
-- ----------------------------
DROP TABLE IF EXISTS `sms_received`;
CREATE TABLE `sms_received` (
  `ID` varchar(20) NOT NULL COMMENT '记录编号(2位业务标识+yymmddhhMMss+4位随机数',
  `BizID` varchar(2) NOT NULL DEFAULT '' COMMENT '业务标识(2位,由数字和字母共同组成)',
  `Gateway` varchar(2) NOT NULL DEFAULT '01' COMMENT '短信网关标识',
  `RcvTime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `RcvNum` varchar(20) NOT NULL DEFAULT '',
  `RcvContent` varchar(512) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `ix_rvc_biz_time` (`BizID`,`RcvTime`) USING BTREE,
  KEY `ix_rvc_time` (`RcvTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='已接收但未处理的短信表';

-- ----------------------------
-- Records of sms_received
-- ----------------------------

-- ----------------------------
-- Table structure for sms_sending
-- ----------------------------
DROP TABLE IF EXISTS `sms_sending`;
CREATE TABLE `sms_sending` (
  `ID` varchar(20) NOT NULL,
  `BizID` varchar(2) NOT NULL,
  `Gateway` varchar(2) NOT NULL DEFAULT '01' COMMENT '短信网关标识',
  `STime` datetime NOT NULL COMMENT '预计发送时间',
  `STo` varchar(20) NOT NULL COMMENT '发送至号码',
  `SContent` varchar(512) NOT NULL,
  `Status` varchar(1) NOT NULL DEFAULT 'W' COMMENT '状态:\r\nW: 为等待发送\r\nS  : 为发送状态',
  `TryTimes` smallint(2) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `ix_send_biz_status` (`BizID`,`Gateway`,`Status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sms_sending
-- ----------------------------

-- ----------------------------
-- Table structure for sms_sent
-- ----------------------------
DROP TABLE IF EXISTS `sms_sent`;
CREATE TABLE `sms_sent` (
  `ID` varchar(20) NOT NULL COMMENT '事务标识',
  `BizTime` datetime NOT NULL COMMENT '增加时间',
  `BizID` varchar(2) NOT NULL COMMENT '业务标识',
  `Gateway` varchar(2) NOT NULL DEFAULT '01' COMMENT '短信网关',
  `STo` varchar(20) NOT NULL COMMENT '发送至号码',
  `SContent` varchar(512) NOT NULL COMMENT '发送内容',
  `SCount` smallint(6) NOT NULL DEFAULT '0' COMMENT '发送次数',
  `SStartTime` datetime DEFAULT NULL,
  `SEndTime` datetime DEFAULT NULL,
  `SResult` varchar(1) NOT NULL DEFAULT 'W' COMMENT '发送结果: W为正在发送,S为发送成功,F发送失败',
  `SResultCode` varchar(20) DEFAULT NULL COMMENT '结果编号',
  PRIMARY KEY (`ID`,`BizTime`),
  KEY `ix_send_time` (`BizTime`),
  KEY `ix_send_biz_time` (`BizID`,`Gateway`,`BizTime`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
/*!50100 PARTITION BY RANGE (year(BizTime))
(PARTITION p2013 VALUES LESS THAN (2014) ENGINE = InnoDB,
 PARTITION p2014 VALUES LESS THAN (2015) ENGINE = InnoDB,
 PARTITION p2015 VALUES LESS THAN (2016) ENGINE = InnoDB,
 PARTITION p2016 VALUES LESS THAN (2017) ENGINE = InnoDB,
 PARTITION p2017 VALUES LESS THAN (2018) ENGINE = InnoDB,
 PARTITION p2018 VALUES LESS THAN (2019) ENGINE = InnoDB,
 PARTITION p2019 VALUES LESS THAN (2020) ENGINE = InnoDB,
 PARTITION p2020 VALUES LESS THAN (2021) ENGINE = InnoDB,
 PARTITION p2021 VALUES LESS THAN (2022) ENGINE = InnoDB,
 PARTITION p2022 VALUES LESS THAN (2023) ENGINE = InnoDB,
 PARTITION p2023 VALUES LESS THAN (2024) ENGINE = InnoDB,
 PARTITION p2099 VALUES LESS THAN MAXVALUE ENGINE = InnoDB) */;

-- ----------------------------
-- Records of sms_sent
-- ----------------------------

-- ----------------------------
-- Table structure for sms_vending
-- ----------------------------
DROP TABLE IF EXISTS `sms_vending`;
CREATE TABLE `sms_vending` (
  `ID` varchar(20) NOT NULL COMMENT '事务标识',
  `VendDate` datetime NOT NULL COMMENT '购电时间',
  `SCCode` varchar(20) NOT NULL COMMENT '刮刮卡号',
  `MeterNum` varchar(20) NOT NULL COMMENT '表号',
  `VendQty` decimal(10,2) NOT NULL COMMENT '购电电量',
  `VendAmt` decimal(10,2) NOT NULL COMMENT '购电金额',
  `CommAmt` decimal(8,2) NOT NULL COMMENT '拥金金额',
  `Token` varchar(100) NOT NULL COMMENT '售电代码',
  `VendDetails` text NOT NULL,
  PRIMARY KEY (`ID`,`VendDate`),
  KEY `ix_vending_sccode` (`SCCode`) USING BTREE,
  KEY `ix_vending_meter` (`MeterNum`) USING BTREE,
  KEY `ix_vending_time` (`VendDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
/*!50100 PARTITION BY RANGE (year(VendDate))
(PARTITION p2013 VALUES LESS THAN (2014) ENGINE = InnoDB,
 PARTITION p2014 VALUES LESS THAN (2015) ENGINE = InnoDB,
 PARTITION p2015 VALUES LESS THAN (2016) ENGINE = InnoDB,
 PARTITION p2016 VALUES LESS THAN (2017) ENGINE = InnoDB,
 PARTITION p2017 VALUES LESS THAN (2018) ENGINE = InnoDB,
 PARTITION p2018 VALUES LESS THAN (2019) ENGINE = InnoDB,
 PARTITION p2019 VALUES LESS THAN (2020) ENGINE = InnoDB,
 PARTITION p2020 VALUES LESS THAN (2021) ENGINE = InnoDB,
 PARTITION p2021 VALUES LESS THAN (2022) ENGINE = InnoDB,
 PARTITION p2022 VALUES LESS THAN (2023) ENGINE = InnoDB,
 PARTITION p2023 VALUES LESS THAN (2024) ENGINE = InnoDB,
 PARTITION p2099 VALUES LESS THAN MAXVALUE ENGINE = InnoDB) */;

-- ----------------------------
-- Records of sms_vending
-- ----------------------------

-- ----------------------------
-- Table structure for sys_backup
-- ----------------------------
DROP TABLE IF EXISTS `sys_backup`;
CREATE TABLE `sys_backup` (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `Description` varchar(50) NOT NULL DEFAULT '' COMMENT '描述',
  `ActCycle` varchar(1) NOT NULL DEFAULT '2' COMMENT '备份周期：1单次，2周期天数',
  `ActDays` smallint(6) NOT NULL DEFAULT '0' COMMENT '周期天数',
  `StartupTime` datetime NOT NULL COMMENT '启动时间',
  `Folder` varchar(255) NOT NULL DEFAULT '' COMMENT '备份目录',
  `TryTimes` smallint(6) NOT NULL DEFAULT '3',
  `ExecTime` datetime NOT NULL,
  `ExecCount` smallint(6) NOT NULL DEFAULT '0' COMMENT '已执行次数',
  `Actived` varchar(1) DEFAULT 'N' COMMENT '是否执行',
  `COperator` varchar(20) NOT NULL,
  `CDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_backup
-- ----------------------------

-- ----------------------------
-- Table structure for sys_backup_history
-- ----------------------------
DROP TABLE IF EXISTS `sys_backup_history`;
CREATE TABLE `sys_backup_history` (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `ActID` int(11) NOT NULL,
  `Description` varchar(50) NOT NULL DEFAULT '' COMMENT '描述',
  `ActCycle` varchar(1) NOT NULL COMMENT '备份周期：1单次，2每天，3每周',
  `StartupTime` datetime NOT NULL COMMENT '启动时间',
  `Folder` varchar(255) NOT NULL DEFAULT '' COMMENT '备份目录',
  `ExecResult` varchar(1) DEFAULT '',
  `ExecTime` datetime DEFAULT NULL,
  `COperator` varchar(20) NOT NULL,
  `CDate` datetime NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_backup_history
-- ----------------------------

-- ----------------------------
-- Table structure for sys_backup_item
-- ----------------------------
DROP TABLE IF EXISTS `sys_backup_item`;
CREATE TABLE `sys_backup_item` (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '备份明细条目',
  `ActID` int(11) NOT NULL COMMENT '启动标识',
  `ActDate` datetime NOT NULL COMMENT '备份日期',
  `BackupFile` varchar(255) NOT NULL COMMENT '备份文件',
  `BackupSize` int(11) NOT NULL COMMENT '文件大小',
  `COperator` varchar(20) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_backup_item
-- ----------------------------

-- ----------------------------
-- Table structure for sys_code
-- ----------------------------
DROP TABLE IF EXISTS `sys_code`;
CREATE TABLE `sys_code` (
  `RuleCode` varchar(10) NOT NULL DEFAULT '',
  `Code` varchar(10) NOT NULL,
  `Description` varchar(50) NOT NULL,
  `Prefix` varchar(5) NOT NULL DEFAULT '',
  `Suffix` varchar(5) NOT NULL DEFAULT '',
  `Type` int(10) unsigned NOT NULL DEFAULT '1',
  `Len` smallint(5) unsigned NOT NULL DEFAULT '0',
  `Serial` int(10) unsigned NOT NULL DEFAULT '1',
  `OrderNo` int(10) unsigned NOT NULL DEFAULT '0',
  `CanChanged` char(1) NOT NULL DEFAULT 'Y',
  `CurrDate` date NOT NULL,
  PRIMARY KEY (`RuleCode`,`Code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_code
-- ----------------------------

-- ----------------------------
-- Table structure for sys_company
-- ----------------------------
DROP TABLE IF EXISTS `sys_company`;
CREATE TABLE `sys_company` (
  `Name` varchar(100) NOT NULL DEFAULT '',
  `TelNo` varchar(100) DEFAULT NULL,
  `FaxNo` varchar(100) DEFAULT NULL,
  `PostCode` varchar(20) DEFAULT NULL,
  `Address` varchar(200) DEFAULT NULL,
  `Url` varchar(200) DEFAULT NULL,
  `Email` varchar(200) DEFAULT NULL,
  `BankName` varchar(100) DEFAULT NULL,
  `BankCode` varchar(100) DEFAULT NULL,
  `RegKey` varchar(40) DEFAULT NULL,
  `RegLicence` text,
  PRIMARY KEY (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_company
-- ----------------------------
INSERT INTO `sys_company` VALUES ('INHE', 'aaa', 'ss', '2', '', '', null, '', '', '1526-2146-7501-7145-4262', '000000C0D3DE000027B11E8BA6FB6B186B54B9ED0F1281079DD9F8730B07C927EB6A2B06FEED2F532D37E30CE696B070700D185B6D39162A564E7174AC3E3355EBDB3C9BAC6EB1C67131A18F6D2D6F6474CFBA01243BBB560C8F328F309EEA31BF5C80772B0CA857EFCF13B9702083AD248317904E05DCEF2F29DC3683BD1BCCBCA422CDAE54F422D733700DEA9C596D873C27CDF4654709133568ED90725CD2126DBA6CF0F8949E414D84BA10D645293A870B79A50E8BC63AF786D8C98F82F52EF5B4A4F3BE15D496C37D04161925B6');

-- ----------------------------
-- Table structure for sys_country
-- ----------------------------
DROP TABLE IF EXISTS `sys_country`;
CREATE TABLE `sys_country` (
  `id_country` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_zone` int(10) unsigned NOT NULL,
  `iso_code` varchar(3) NOT NULL,
  `active` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `contains_states` tinyint(1) NOT NULL DEFAULT '0',
  `need_identification_number` tinyint(1) NOT NULL,
  PRIMARY KEY (`id_country`),
  KEY `country_iso_code` (`iso_code`) USING BTREE,
  KEY `country_` (`id_zone`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=245 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_country
-- ----------------------------
INSERT INTO `sys_country` VALUES ('1', '1', 'DE', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('2', '1', 'AT', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('3', '1', 'BE', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('4', '2', 'CA', '1', '1', '0');
INSERT INTO `sys_country` VALUES ('5', '3', 'ZH', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('6', '1', 'ES', '1', '0', '1');
INSERT INTO `sys_country` VALUES ('7', '1', 'FI', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('8', '1', 'FR', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('9', '1', 'GR', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('10', '1', 'IT', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('11', '3', 'JP', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('12', '1', 'LU', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('13', '1', 'NL', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('14', '1', 'PL', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('15', '1', 'PT', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('16', '1', 'CZ', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('17', '1', 'GB', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('18', '1', 'SE', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('19', '1', 'CH', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('20', '1', 'DK', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('21', '2', 'EN', '1', '1', '0');
INSERT INTO `sys_country` VALUES ('22', '3', 'HK', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('23', '1', 'NO', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('24', '5', 'AU', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('25', '3', 'SG', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('26', '1', 'IE', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('27', '5', 'NZ', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('28', '3', 'KR', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('29', '3', 'IL', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('30', '4', 'ZA', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('31', '4', 'NG', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('32', '4', 'CI', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('33', '4', 'TG', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('34', '2', 'BO', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('35', '4', 'MU', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('36', '1', 'RO', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('37', '1', 'SK', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('38', '4', 'DZ', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('39', '2', 'AS', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('40', '1', 'AD', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('41', '4', 'AO', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('42', '2', 'AI', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('43', '2', 'AG', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('44', '2', 'AR', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('45', '3', 'AM', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('46', '2', 'AW', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('47', '3', 'AZ', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('48', '2', 'BS', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('49', '3', 'BH', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('50', '3', 'BD', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('51', '2', 'BB', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('52', '1', 'BY', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('53', '2', 'BZ', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('54', '4', 'BJ', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('55', '2', 'BM', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('56', '3', 'BT', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('57', '4', 'BW', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('58', '2', 'BR', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('59', '3', 'BN', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('60', '4', 'BF', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('61', '3', 'MM', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('62', '4', 'BI', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('63', '3', 'KH', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('64', '4', 'CM', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('65', '4', 'CV', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('66', '4', 'CF', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('67', '4', 'TD', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('68', '2', 'CL', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('69', '2', 'CO', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('70', '4', 'KM', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('71', '4', 'CD', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('72', '4', 'CG', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('73', '2', 'CR', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('74', '1', 'HR', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('75', '2', 'CU', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('76', '1', 'CY', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('77', '4', 'DJ', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('78', '2', 'DM', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('79', '2', 'DO', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('80', '3', 'TL', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('81', '2', 'EC', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('82', '4', 'EG', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('83', '2', 'SV', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('84', '4', 'GQ', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('85', '4', 'ER', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('86', '1', 'EE', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('87', '4', 'ET', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('88', '2', 'FK', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('89', '1', 'FO', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('90', '5', 'FJ', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('91', '4', 'GA', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('92', '4', 'GM', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('93', '3', 'GE', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('94', '4', 'GH', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('95', '2', 'GD', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('96', '1', 'GL', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('97', '1', 'GI', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('98', '2', 'GP', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('99', '2', 'GU', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('100', '2', 'GT', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('101', '1', 'GG', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('102', '4', 'GN', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('103', '4', 'GW', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('104', '2', 'GY', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('105', '2', 'HT', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('106', '5', 'HM', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('107', '1', 'VA', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('108', '2', 'HN', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('109', '1', 'IS', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('110', '3', 'IN', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('111', '3', 'ID', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('112', '3', 'IR', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('113', '3', 'IQ', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('114', '1', 'IM', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('115', '2', 'JM', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('116', '1', 'JE', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('117', '3', 'JO', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('118', '3', 'KZ', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('119', '4', 'KE', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('120', '1', 'KI', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('121', '3', 'KP', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('122', '3', 'KW', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('123', '3', 'KG', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('124', '3', 'LA', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('125', '1', 'LV', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('126', '3', 'LB', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('127', '4', 'LS', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('128', '4', 'LR', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('129', '4', 'LY', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('130', '1', 'LI', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('131', '1', 'LT', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('132', '3', 'MO', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('133', '1', 'MK', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('134', '4', 'MG', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('135', '4', 'MW', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('136', '3', 'MY', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('137', '3', 'MV', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('138', '4', 'ML', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('139', '1', 'MT', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('140', '5', 'MH', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('141', '2', 'MQ', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('142', '4', 'MR', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('143', '1', 'HU', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('144', '4', 'YT', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('145', '2', 'MX', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('146', '5', 'FM', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('147', '1', 'MD', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('148', '1', 'MC', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('149', '3', 'MN', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('150', '1', 'ME', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('151', '2', 'MS', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('152', '4', 'MA', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('153', '4', 'MZ', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('154', '4', 'NA', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('155', '5', 'NR', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('156', '3', 'NP', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('157', '2', 'AN', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('158', '5', 'NC', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('159', '2', 'NI', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('160', '4', 'NE', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('161', '5', 'NU', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('162', '5', 'NF', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('163', '5', 'MP', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('164', '3', 'OM', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('165', '3', 'PK', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('166', '5', 'PW', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('167', '3', 'PS', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('168', '2', 'PA', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('169', '5', 'PG', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('170', '2', 'PY', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('171', '2', 'PE', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('172', '3', 'PH', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('173', '5', 'PN', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('174', '2', 'PR', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('175', '3', 'QA', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('176', '4', 'RE', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('177', '1', 'RU', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('178', '4', 'RW', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('179', '2', 'BL', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('180', '2', 'KN', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('181', '2', 'LC', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('182', '2', 'MF', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('183', '2', 'PM', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('184', '2', 'VC', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('185', '5', 'WS', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('186', '1', 'SM', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('187', '4', 'ST', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('188', '3', 'SA', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('189', '4', 'SN', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('190', '1', 'RS', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('191', '4', 'SC', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('192', '4', 'SL', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('193', '1', 'SI', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('194', '5', 'SB', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('195', '4', 'SO', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('196', '2', 'GS', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('197', '3', 'LK', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('198', '4', 'SD', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('199', '2', 'SR', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('200', '1', 'SJ', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('201', '4', 'SZ', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('202', '3', 'SY', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('203', '3', 'TW', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('204', '3', 'TJ', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('205', '4', 'TZ', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('206', '3', 'TH', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('207', '5', 'TK', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('208', '5', 'TO', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('209', '2', 'TT', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('210', '4', 'TN', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('211', '1', 'TR', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('212', '3', 'TM', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('213', '2', 'TC', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('214', '5', 'TV', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('215', '4', 'UG', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('216', '1', 'UA', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('217', '3', 'AE', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('218', '2', 'UY', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('219', '3', 'UZ', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('220', '5', 'VU', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('221', '2', 'VE', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('222', '3', 'VN', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('223', '2', 'VG', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('224', '2', 'VI', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('225', '5', 'WF', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('226', '4', 'EH', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('227', '3', 'YE', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('228', '4', 'ZM', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('229', '4', 'ZW', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('230', '1', 'AL', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('231', '3', 'AF', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('232', '5', 'AQ', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('233', '1', 'BA', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('234', '5', 'BV', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('235', '5', 'IO', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('236', '1', 'BG', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('237', '2', 'KY', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('238', '3', 'CX', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('239', '3', 'CC', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('240', '5', 'CK', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('241', '2', 'GF', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('242', '5', 'PF', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('243', '5', 'TF', '1', '0', '0');
INSERT INTO `sys_country` VALUES ('244', '1', 'AX', '1', '0', '0');

-- ----------------------------
-- Table structure for sys_department
-- ----------------------------
DROP TABLE IF EXISTS `sys_department`;
CREATE TABLE `sys_department` (
  `Code` varchar(20) NOT NULL DEFAULT '',
  `ParentCode` varchar(20) NOT NULL,
  `OrderNo` varchar(10) NOT NULL DEFAULT '0',
  `Name` varchar(100) NOT NULL,
  `Manager` varchar(20) NOT NULL,
  `TelNo` varchar(50) NOT NULL,
  `FaxNo` varchar(50) NOT NULL,
  `AreaCode` varchar(20) NOT NULL,
  `Address` varchar(100) NOT NULL,
  `AdminRange` varchar(1) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT 'A' COMMENT '管理范围，A为全体; C为本部门',
  `AdminDept` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '管理部门编号，为空为全体，不为空所指定的编号',
  `COperator` varchar(20) NOT NULL,
  `CDate` datetime NOT NULL,
  `UDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_department
-- ----------------------------

-- ----------------------------
-- Table structure for sys_desktop
-- ----------------------------
DROP TABLE IF EXISTS `sys_desktop`;
CREATE TABLE `sys_desktop` (
  `ID` smallint(6) NOT NULL,
  `Description` varchar(50) NOT NULL,
  `OrderNo` smallint(6) NOT NULL,
  `ModuleFile` varchar(200) NOT NULL,
  `ModulePos` char(1) NOT NULL,
  `ViewType` varchar(20) NOT NULL,
  `Lines` smallint(4) NOT NULL,
  `IsScroll` char(1) NOT NULL,
  `LangID` varchar(20) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_desktop
-- ----------------------------
INSERT INTO `sys_desktop` VALUES ('1', 'Downloads', '1', 'download.php', 'r', '2', '5', 'Y', 'DOWNLOADS');
INSERT INTO `sys_desktop` VALUES ('2', 'How to do?', '1', 'howtodo.php', 'l', '2', '5', 'N', 'DSK_HOWTODO');
INSERT INTO `sys_desktop` VALUES ('3', 'System Check', '2', 'syslogs.php', 'r', '2', '5', 'N', 'SYS_CHECK');

-- ----------------------------
-- Table structure for sys_dictionary
-- ----------------------------
DROP TABLE IF EXISTS `sys_dictionary`;
CREATE TABLE `sys_dictionary` (
  `TableName` varchar(30) NOT NULL,
  `ParentCode` varchar(30) NOT NULL DEFAULT '',
  `Code` varchar(30) NOT NULL DEFAULT '',
  `Description` varchar(1024) DEFAULT '',
  `OrderNo` int(11) DEFAULT '0',
  `V1` varchar(100) DEFAULT NULL,
  `V2` varchar(100) DEFAULT NULL,
  `V3` varchar(100) DEFAULT NULL,
  `V4` varchar(100) DEFAULT NULL,
  `LangID` varchar(20) DEFAULT NULL,
  `LevelNo` smallint(2) DEFAULT '0' COMMENT '级别',
  PRIMARY KEY (`TableName`,`ParentCode`,`Code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_dictionary
-- ----------------------------
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '001', 'Browse', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '002', 'Details', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '003', 'New', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '004', 'Modify', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '005', 'Delete', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '006', 'Print', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '007', 'Search', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '008', 'Cancel', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '009', '确认取消', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '010', '帐户充值', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '011', '销户', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '012', '确认安装表', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '013', '售电退款', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '014', '确认退款', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '015', '售电站授权', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '016', '装载密钥', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '017', '密钥比较', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '018', '版本新建', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '019', '版本修改', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '020', '启用/停用', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '021', '恢复售电', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '022', '上传', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '023', '控制服务程序', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '024', '清空密码', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '025', '对账', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '026', '支付拥金', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '027', '取消合同', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '028', '激活任务', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '029', '操作任务', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '030', '执行', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '031', '为所有客户售电', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '032', '为所有客户调整', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '033', 'Reject', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '034', 'Download', '0', '下载', null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '035', 'Export', '0', '导出', null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('ACTIONS', '', '036', 'Approval', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('AUTHKT', '', 'C', 'CURRENCY', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('AUTHKT', '', 'K', 'KWH', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('BRANCHTYPE', '', '00', 'Owner', '0', null, null, null, null, 'Owner', '0');
INSERT INTO `sys_dictionary` VALUES ('BRANCHTYPE', '', '01', 'Agent', '0', null, null, null, null, 'Agent', '0');
INSERT INTO `sys_dictionary` VALUES ('BRANCHTYPE', '', '02', 'SMS', '0', null, null, null, null, 'SMS', '0');
INSERT INTO `sys_dictionary` VALUES ('CANCELTYPE', '', '01', 'Cancellation Reason 02', '0', null, null, null, null, '', '8');
INSERT INTO `sys_dictionary` VALUES ('FIELD', '', '01', 'Code', '0', 'fieldType:0|lenght:2,2,2,3|width=100', null, null, null, 'fieldCode', '0');
INSERT INTO `sys_dictionary` VALUES ('FIELD', '', '02', 'Description', '0', 'fieldType:0|lenght:50|width=350', null, null, null, 'fieldDescription', '0');
INSERT INTO `sys_dictionary` VALUES ('FIELD1', '', '01', 'Code', '0', 'fieldType:0|lenght:2|width=100', null, null, null, 'fieldCode', '0');
INSERT INTO `sys_dictionary` VALUES ('FIELD1', '', '02', 'Description', '0', 'fieldType:0|lenght:50|width=250', null, null, null, 'fieldDescription', '0');
INSERT INTO `sys_dictionary` VALUES ('FIELD1', '', '03', 'Tick', '0', 'fieldType:1|lenght:50|width=60', null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('FIELD1', '', '04', 'Money', '0', 'fieldType:2|lenght:10|width=120', null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('FIELD1', '', '05', 'Float', '0', 'fieldType:3|lenght:10|width=120', null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('FIELD1', '', '06', 'Integer', '0', 'fieldType:4|lenght:8|width=120', null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('FIELD10', '', '01', 'Code', '0', 'fieldType:0|lenght:10|width=100', null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('FIELD10', '', '02', 'Description', '0', 'fieldType:0|lenght:50|width=250', null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('FIELD2', '', '01', 'Code', '0', 'fieldType:0|lenght:3|width=100', null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('FIELD2', '', '02', 'Description', '0', 'fieldType:0|lenght:50|width=250', null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('FIELD3', '', '01', 'Code', '0', 'fieldType:0|lenght:3|width=100', null, null, null, 'fieldCode', '0');
INSERT INTO `sys_dictionary` VALUES ('FIELD3', '', '02', 'Description', '0', 'fieldType:5|lenght:200|width=350,80', null, null, null, 'fieldDescription', '0');
INSERT INTO `sys_dictionary` VALUES ('GTWFIELD', '', '01', 'Code', '0', 'fieldType:0|lenght:2,2,2,3|width=100', null, null, null, 'fieldCode', '0');
INSERT INTO `sys_dictionary` VALUES ('GTWFIELD', '', '02', 'Description', '0', 'fieldType:0|lenght:50|width=250', null, null, null, 'fieldDescription', '0');
INSERT INTO `sys_dictionary` VALUES ('GTWFIELD', '', '03', 'Prefix', '0', 'fieldType:0|lenght:50|width=350', null, null, null, 'fieldPrefix', '0');
INSERT INTO `sys_dictionary` VALUES ('INTERFACE', '', 'APP_TITLE', 'Smart Messenger Anywhere', '0', '', '', '', '', '', '0');
INSERT INTO `sys_dictionary` VALUES ('INTERFACE', '', 'HEAD_IMG', 'screen/2014040209425499.png', '0', '', '', '', '', '', '0');
INSERT INTO `sys_dictionary` VALUES ('INTERFACE', '', 'HEAD_IMG_H', '45', '0', '', '', '', '', '', '0');
INSERT INTO `sys_dictionary` VALUES ('INTERFACE', '', 'HEAD_IMG_W', '45', '0', '', '', '', '', '', '0');
INSERT INTO `sys_dictionary` VALUES ('INTERFACE', '', 'HEAD_STYLE', '', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('INTERFACE', '', 'HEAD_TITLE', 'Smart Messenger Anywhere', '0', '', '', '', '', '', '0');
INSERT INTO `sys_dictionary` VALUES ('INTERFACE', '', 'LOG_OUT_TEXT', 'Thank you for selecting our Product!', '0', '', '', '', '', '', '0');
INSERT INTO `sys_dictionary` VALUES ('INTERFACE', '', 'STATUS_TEXT', 'Smart Messenger Anywhere\r\nCopyrigth(C) INHEMETER', '0', '', '', '', '', '', '0');
INSERT INTO `sys_dictionary` VALUES ('INTERFACE', '', 'TEMPLATE', 'default', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('PAYMODE', '', '01', 'Cash', '0', 'N', 'Y', null, null, 'PAYMODE01', '0');
INSERT INTO `sys_dictionary` VALUES ('PAYMODE', '', '02', 'Cheque', '0', 'Y', 'N', null, null, 'PAYMODE02', '0');
INSERT INTO `sys_dictionary` VALUES ('PAYMODE', '', '90', 'Credit', '0', 'N', 'N', null, null, 'PAYMODE90', '0');
INSERT INTO `sys_dictionary` VALUES ('PAYMODE', '', '96', 'SMS Account', '0', 'N', 'N', null, null, 'PAYMODE96', '0');
INSERT INTO `sys_dictionary` VALUES ('PAYMODE', '', '97', 'Scratch Card', '0', 'N', 'N', null, null, 'PAYMODE97', '0');
INSERT INTO `sys_dictionary` VALUES ('PAYMODE', '', '98', 'Account of VS', '0', 'N', 'N', null, null, 'PAYMODE98', '0');
INSERT INTO `sys_dictionary` VALUES ('PAYMODE', '', '99', 'Account of Customer', '0', 'N', 'N', null, null, 'PAYMODE99', '0');
INSERT INTO `sys_dictionary` VALUES ('PAYTYPE', '', '01', 'Open Account', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('PAYTYPE', '', '03', 'Vending', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('PAYTYPE', '', '04', 'Meter Replacement', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('PAYTYPE', '', '05', 'KW Replacement', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('PAYTYPE', '', '06', 'Pay Arrear', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('PAYTYPE', '', '07', 'Remove Frozen', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('RES_MSG', '', '000', 'This function does not support. Err. Code : 000', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('RES_MSG', '', '001', 'The data format you sent is invalid. Err. Code : 001', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('RES_MSG', '', '002', 'The server is busing now, please try again later.  Err. Code : 002', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('RES_MSG', '', '003', 'Operating Failed. Err. Code : [ERRCODE]', '0', null, null, null, null, null, '2');
INSERT INTO `sys_dictionary` VALUES ('RES_MSG', '', '004', 'Name:[NAME],Meter: [MTNM],kWh:[KWH],Total:[CASH],Token:[TOKEN].', '0', null, null, null, null, null, '6');
INSERT INTO `sys_dictionary` VALUES ('RES_MSG', '', '005', 'Time:[TIME],Name:[NAME],Meter: [MTNM],kWh:[KWH],Total:[CASH],Token:[TOKEN].(Reissue)', '0', null, null, null, null, null, '4');
INSERT INTO `sys_dictionary` VALUES ('RES_MSG', '', '006', 'Dear customer, the PIN number you sent is invalid. Err. Code : 006', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('RES_MSG', '', '007', 'Dear customer, the min. transaction amount is [MIN_AMT] . Err. Code : -10020', '0', null, null, null, null, null, '1');
INSERT INTO `sys_dictionary` VALUES ('RES_MSG', '', '008', 'Dear customer, there is [BALANCE] CFA in your account.', '0', null, null, null, null, null, '1');
INSERT INTO `sys_dictionary` VALUES ('RES_MSG', '', '009', 'The password has been changed.', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('RES_MSG', '', '010', 'Name:[NAME],Meter:[MTNM],Balance : [BALANCE], Details : [DETAILS].', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('RES_MSG', '', '011', 'Time:[TIME],Name:[NAME],Meter: [MTNM],Total:[CASH],StampTax:[STAMP],Commission:[COMM]', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('RES_MSG', '', '012', 'Time:[TIME],Name:[NAME],Meter: [MTNM],Total:[CASH],StampTax:[STAMP],Commission:[COMM].(Reissue)', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('RES_MSG', '', '013', 'Dear customer, the amount you sent is invalid. Err. Code : 013', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('RES_MSG', '', '014', 'Dear customer, your balance is [AMT], please keep your account available.', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('SMSGTWAY', '', '01', 'SMS Gateway 1', '0', '', null, null, null, 'SMS Gateway 1', '7');
INSERT INTO `sys_dictionary` VALUES ('SMSGTWAY', '', '02', 'SMS Gateway 2', '0', '', null, null, null, 'SMS Gateway 2', '4');
INSERT INTO `sys_dictionary` VALUES ('SMSGTWAY', '', '03', 'SMS Gateway 3', '0', '', null, null, null, 'SMS Gateway 3', '4');
INSERT INTO `sys_dictionary` VALUES ('SYSEVENTTYPE', '', '1', 'Login', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('SYSEVENTTYPE', '', '2', 'Logout', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('SYSEVENTTYPE', '', '3', 'Reissue', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('SYSEVENTTYPE', '', '4', 'Other', '0', null, null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('SYS_PARAM', '', '00', 'Control Parameters', '0', 'P', null, null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('SYS_PARAM', '', '01', 'System Parameters', '0', 'P', '0', null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('SYS_PARAM', '00', 'SEC_RETRY', '密码重试控制', '1', 'Y', 'Y', null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('SYS_PARAM', '00', 'SEC_RETRY_MINS', 'Password Lock Time', '3', 'V', '10', null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('SYS_PARAM', '00', 'SEC_RETRY_TIMES', 'password Try Times', '2', 'V', '3', null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('SYS_PARAM', '00', 'TOP_MENU_NUM', '顶部菜单显示个数', '4', 'V', '5', null, null, null, '0');
INSERT INTO `sys_dictionary` VALUES ('SYS_PARAM', '01', 'CURRENCY', 'Currency Symbol', '1', 'V', '$', null, 'type=0|canEmpty=0|visible=1|size=8|len=5', 'fieldCurrency', '0');
INSERT INTO `sys_dictionary` VALUES ('SYS_PARAM', '01', 'RPT_HOST', 'Report Server Host', '9', null, '', null, 'type=0|canEmpty=1|visible=1|size=47', 'fieldRptHost', '0');
INSERT INTO `sys_dictionary` VALUES ('SYS_PARAM', '01', 'RPT_PORT', 'Report Server Port', '10', 'V', '9002', null, 'type=5|canEmpty=0|visible=1|size=8', 'fieldRptPort', '0');
INSERT INTO `sys_dictionary` VALUES ('SYS_PARAM', '01', 'RPT_TYPE', 'Report Type', '8', null, '1', null, 'type=0|canEmpty=1|visible=1|size=8', 'fieldRptType', '0');
INSERT INTO `sys_dictionary` VALUES ('SYS_PARAM', '01', 'TIME_ZONE', 'Region', '0', 'V', 'Etc/GMT-8', null, 'type=6|canEmpty=0|visible=1|size=8', 'fieldTimezone', '0');
INSERT INTO `sys_dictionary` VALUES ('TABLES', '', '001', 'Area', '0', 'AREA', 'FIELD', 'maxLevel:4|opType:111|visible:N', null, 'tbAREA', '0');
INSERT INTO `sys_dictionary` VALUES ('TABLES', '', '002', 'Cancellation Reason of Branch', '0', 'CANCELTYPE', 'FIELD', 'maxLevel:1|opType:111|visible:Y', null, 'tbBRANCHREASON', '0');
INSERT INTO `sys_dictionary` VALUES ('TABLES', '', '003', 'SMS Gateway Type', '0', 'SMSGTWAY', 'GTWFIELD', 'maxLevel:1|opType:010|visible:Y', null, 'tbSMSGType', '0');
INSERT INTO `sys_dictionary` VALUES ('TABLES', '', '004', 'Response Message', '0', 'RES_MSG', 'FIELD3', 'maxLevel:1|opType:010|visible:Y', null, 'tbRMessage', '0');
INSERT INTO `sys_dictionary` VALUES ('TABLES', '', '005', 'Agnet Level.', '0', 'AGLV', 'AGLV_FIELD', 'maxLevel:1|opType:010|visible:N', null, 'tbAGLV', '0');
INSERT INTO `sys_dictionary` VALUES ('TABLES', '', '006', 'Send SMS Example', '0', 'SMSEXAMPLE', 'FIELD', 'maxLevel:1|opType:111|visible:Y', null, 'tbSMSExample', '0');
INSERT INTO `sys_dictionary` VALUES ('TSKCYCLE', '', '1', 'Minitue(s)', '0', null, null, null, null, 'Minitue(s)', '0');
INSERT INTO `sys_dictionary` VALUES ('TSKCYCLE', '', '2', 'Hour(s)', '0', null, null, null, null, 'Hour(s)', '0');
INSERT INTO `sys_dictionary` VALUES ('TSKCYCLE', '', '3', 'Day(s)', '0', null, null, null, null, 'Day(s)', '0');
INSERT INTO `sys_dictionary` VALUES ('TSKCYCLE', '', '4', 'Month(s)', '0', null, null, null, null, 'Month(s)', '0');
INSERT INTO `sys_dictionary` VALUES ('TSKCYCLE', '', '5', 'Year(s)', '0', null, null, null, null, 'Year(s)', '0');
INSERT INTO `sys_dictionary` VALUES ('TSKTYPE', '', '1', 'Once', '0', null, null, null, null, 'Once', '0');
INSERT INTO `sys_dictionary` VALUES ('TSKTYPE', '', '2', 'Cycle', '0', null, null, null, null, 'Cycle', '0');
INSERT INTO `sys_dictionary` VALUES ('TSKTYPE', '', '3', 'Service', '0', null, null, null, null, 'Service', '0');

-- ----------------------------
-- Table structure for sys_download
-- ----------------------------
DROP TABLE IF EXISTS `sys_download`;
CREATE TABLE `sys_download` (
  `DType` varchar(5) NOT NULL COMMENT '下载类型',
  `ID` int(11) NOT NULL COMMENT '下载标识',
  `OrderNo` int(11) NOT NULL DEFAULT '0' COMMENT '排序号',
  `Description` varchar(100) NOT NULL COMMENT '描述信息',
  `RolesID` text NOT NULL COMMENT '有权限下载的角色,为空时限制',
  `UsersID` text NOT NULL COMMENT '用权限下载的用户,为空时不限制',
  `FileName` varchar(50) NOT NULL COMMENT '显示名',
  `Attachment` varchar(50) NOT NULL COMMENT '附件下载名',
  `Active` varchar(1) NOT NULL COMMENT '是否激活',
  `LangID` varchar(20) NOT NULL COMMENT '语言标识',
  PRIMARY KEY (`DType`,`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_download
-- ----------------------------
INSERT INTO `sys_download` VALUES ('001', '1', '0', 'Service Component Installation', '', '', 'SVCSetup.msi', 'SVCSetup.msi', 'Y', 'SCI');

-- ----------------------------
-- Table structure for sys_event
-- ----------------------------
DROP TABLE IF EXISTS `sys_event`;
CREATE TABLE `sys_event` (
  `ID` varchar(20) NOT NULL,
  `UserCode` varchar(20) DEFAULT NULL,
  `EventTime` datetime DEFAULT NULL,
  `IP` varchar(20) DEFAULT NULL,
  `Type` smallint(4) DEFAULT NULL,
  `Remarks` text,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_event
-- ----------------------------

-- ----------------------------
-- Table structure for sys_event_time
-- ----------------------------
DROP TABLE IF EXISTS `sys_event_time`;
CREATE TABLE `sys_event_time` (
  `ID` varchar(20) NOT NULL,
  `CurrentTime` datetime DEFAULT NULL,
  `LastTime` datetime DEFAULT NULL,
  `COperator` varchar(20) DEFAULT NULL,
  `NoticeType` int(2) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_event_time
-- ----------------------------

-- ----------------------------
-- Table structure for sys_functions
-- ----------------------------
DROP TABLE IF EXISTS `sys_functions`;
CREATE TABLE `sys_functions` (
  `ID` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `ParentID` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `OrderNo` int(10) unsigned NOT NULL DEFAULT '0',
  `Type` char(1) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `Name` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `Description` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `Image` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '0',
  `OpenWindow` char(1) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '0',
  `LangID` varchar(55) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `Actived` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `PayFee` char(1) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT 'N',
  `FunctionName` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `Parameters` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `Actions` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_functions
-- ----------------------------
INSERT INTO `sys_functions` VALUES ('0', '', '0', 'S', 'General', 'General Information', '', '0', 'VA', '1', 'N', '', '', '');
INSERT INTO `sys_functions` VALUES ('009', '0', '100', 'M', 'Base Information', 'Base Information', '', '0', 'VA_BI', '1', 'N', '', '', '');
INSERT INTO `sys_functions` VALUES ('00900', '009', '0', 'A', 'Parameters', 'Parameters', '', '0', 'VA_BI_P', '1', 'N', 'sys/parameters.php', '', 0x3030312C303034);
INSERT INTO `sys_functions` VALUES ('00901', '009', '1', 'A', 'Dictionary', 'Data Dictionary', '', '0', 'VA_BI_DD', '1', 'N', 'dictionary/main.php', 0x666F726D7345782E706870, 0x3030312C3030332C3030342C303035);
INSERT INTO `sys_functions` VALUES ('00910', '009', '1', 'A', 'Region', 'Region Management', '', '0', 'VA_BI_REGION', '1', 'N', 'region/regionbrowser.php', 0x666F726D7345782E706870, 0x3030312C3030332C3030342C303035);
INSERT INTO `sys_functions` VALUES ('011', '0', '100', 'M', 'System Information', 'System Information', '', '0', 'VA_SI', '1', 'N', 'line/main.php', '', '');
INSERT INTO `sys_functions` VALUES ('01101', '011', '0', 'P', 'Organization', '', '', '0', 'VA_SI_OG', '1', 'N', '', '', '');
INSERT INTO `sys_functions` VALUES ('011011', '01101', '0', 'A', 'Register Information', 'Register Information', '', '0', 'VA_SI_OG_R', '1', 'N', 'sys/Utility/regInfo.php', '', 0x3030312C303034);
INSERT INTO `sys_functions` VALUES ('011012', '01101', '0', 'A', 'Department', 'Department Management', '', '0', 'VA_SI_OG_D', '1', 'N', 'sys/Utility/Depart.php', 0x666F726D7345782E706870, 0x3030312C3030332C3030342C303035);
INSERT INTO `sys_functions` VALUES ('011013', '01101', '1', 'A', 'Users', 'Users Management', '', '0', 'VA_SI_OG_U', '1', 'N', 'sys/Utility/User.php', 0x666F726D7345782E706870, 0x3030312C3030332C3030342C3030352C303234);
INSERT INTO `sys_functions` VALUES ('011014', '01101', '0', 'A', 'Roles&Permissions', 'Roles&Permissions', '', '0', 'VA_SI_OG_P', '1', 'N', 'sys/Utility/role.php', '', 0x3030312C3030332C3030342C303035);
INSERT INTO `sys_functions` VALUES ('01104', '011', '0', 'P', 'Interface Setting', '', '', '0', 'VA_SI_IS', '1', 'N', '', '', '');
INSERT INTO `sys_functions` VALUES ('0110401', '01104', '0', 'A', 'Screen', 'Screen Setting', '', '0', 'VA_SI_IS_S', '1', 'N', 'sys/interface.php', '', 0x3030312C303034);
INSERT INTO `sys_functions` VALUES ('0110402', '01104', '0', 'A', 'Main Menu', '', '', '0', 'VA_SI_IS_M', '0', 'N', 'sys/mainmenu.php', '', 0x303031);
INSERT INTO `sys_functions` VALUES ('0110403', '01104', '0', 'A', 'Status Bar', '', '', '0', 'VA_SI_IS_B', '0', 'N', 'sys/statusbar.php', '', 0x303031);
INSERT INTO `sys_functions` VALUES ('0110404', '01104', '0', 'A', 'Language Define', 'Language Define', '', '0', 'VA_SI_IS_LANGDEFINE', '1', 'N', 'language/main.php', '', 0x3030312C3030332C3030342C303035);
INSERT INTO `sys_functions` VALUES ('0110405', '01104', '0', 'A', 'Language Package', 'Language Package', '', '0', 'VA_SI_IS_LANGPACKAGE', '1', 'N', 'language/package.php', '', 0x3030312C3030332C3030342C303035);
INSERT INTO `sys_functions` VALUES ('0110406', '01104', '0', 'A', 'Import Language File', 'Import Language File', '', '0', 'VA_SI_IS_LANGIMPORT', '1', 'N', 'language/import.php', '', 0x3030312C3030332C3030342C303035);
INSERT INTO `sys_functions` VALUES ('01116', '011', '0', 'A', 'Time Events', 'The History of The System Time Changed', '', '0', 'VA_SI_TE', '0', 'N', 'sys/TimeEvent.php', '', 0x303031);
INSERT INTO `sys_functions` VALUES ('01118', '011', '0', 'A', '系统日志管理', '', '', '0', 'VA_SI_SL', '1', 'N', 'sys/SysEvent.php', '', 0x3030312C303035);
INSERT INTO `sys_functions` VALUES ('01120', '011', '0', 'A', '系统信息', '', '', '0', 'VA_SI_SI', '1', 'N', 'sys/register.php', '', 0x303031);
INSERT INTO `sys_functions` VALUES ('01121', '011', '0', 'A', 'System Tasks', 'System Tasks Management', '', '0', 'VA_SI_TM', '1', 'N', 'task/taskbrowser.php', '', 0x3030312C3030322C3030332C3030342C3030352C303230);
INSERT INTO `sys_functions` VALUES ('01122', '011', '0', 'A', '控制面板', '', '', '0', 'VA_SI_CP', '1', 'N', 'ControlPanel/person_info.php', '', 0x3030312C303034);
INSERT INTO `sys_functions` VALUES ('1', '', '0', 'S', 'Messenger', 'Messenger', '', '0', 'VB', '1', 'N', '', '', '');
INSERT INTO `sys_functions` VALUES ('100', '1', '0', 'M', 'Branch', 'Branch Management', '', '0', 'VB_BM', '1', 'N', '', '', '');
INSERT INTO `sys_functions` VALUES ('10001', '100', '0', 'A', 'Add Branch', 'Add a branch to system', '', '0', 'VB_BM_AB', '1', 'N', 'branch/brancheditor.php', '', 0x3030312C3030332C303036);
INSERT INTO `sys_functions` VALUES ('10002', '100', '1', 'A', 'Branch Browser', 'Browse all of the branch', '', '0', 'VB_BM_BB', '1', 'N', 'branch/branchbrowser.php', '', 0x3030312C3030322C3030332C3030342C3030362C3031312C303135);
INSERT INTO `sys_functions` VALUES ('10004', '100', '2', 'A', 'Branch Terminals', 'Branch Terminals Management', '', '0', 'VB_BM_BT', '1', 'N', 'branch/ClientBrowser.php', '', 0x3030312C3030322C3030332C3030342C3030352C303230);
INSERT INTO `sys_functions` VALUES ('10009', '100', '9', 'A', 'Cancellation', 'Cancel a branch', '', '0', 'VB_BM_CA', '1', 'N', 'branch/cancellation.php', '', 0x3030312C3030322C303033);
INSERT INTO `sys_functions` VALUES ('140', '1', '0', 'M', 'General SMS', 'General SMS', '', '0', 'VB_GS', '1', 'N', '', '', '');
INSERT INTO `sys_functions` VALUES ('14001', '140', '0', 'A', 'New SMS', 'Send New SMS', '', '0', 'VB_GS_NSMS', '1', 'N', 'generalsms/newsms.php', '', 0x3030312C3030322C303033);
INSERT INTO `sys_functions` VALUES ('14002', '140', '0', 'A', 'Received SMS', 'View the Received SMS', '', '0', 'VB_GS_REC', '1', 'N', 'generalsms/receivedbrowser.php', '', 0x3030312C3030322C303035);
INSERT INTO `sys_functions` VALUES ('14003', '140', '0', 'A', 'SMS Sent', 'View the SMS Sent', '', '0', 'VB_GS_SENT', '1', 'N', 'generalsms/sentbrowser.php', '', 0x3030312C3030322C3030332C303035);
INSERT INTO `sys_functions` VALUES ('150', '1', '0', 'M', 'SMS Vending', '', '', '0', 'VB_SMS', '1', 'N', '', '', '');
INSERT INTO `sys_functions` VALUES ('15001', '150', '0', 'A', 'Received SMS', 'View the Received SMS', '', '0', 'VB_SMS_REC', '1', 'N', 'sms/receivedbrowser.php', '', 0x3030312C303032);
INSERT INTO `sys_functions` VALUES ('15002', '150', '0', 'A', 'Processed SMS', 'View the Processed SMS', '', '0', 'VB_SMS_PRO', '1', 'N', 'sms/processedbrowser.php', '', 0x3030312C303032);
INSERT INTO `sys_functions` VALUES ('15003', '150', '0', 'A', 'SMS Sending', 'View the SMS Sending', '', '0', 'VB_SMS_SEND', '1', 'N', 'sms/sendingbrowser.php', '', 0x3030312C303032);
INSERT INTO `sys_functions` VALUES ('15004', '150', '0', 'A', 'SMS Sent', 'View the SMS Sent', '', '0', 'VB_SMS_SENT', '1', 'N', 'sms/sentbrowser.php', '', 0x3030312C3030322C303033);
INSERT INTO `sys_functions` VALUES ('15005', '150', '0', 'A', 'SMS Vending', 'View the SMS Vending', '', '0', 'VB_SMS_VEND', '1', 'N', 'sms/vendbrowser.php', '', 0x3030312C3030322C303033);

-- ----------------------------
-- Table structure for sys_lang
-- ----------------------------
DROP TABLE IF EXISTS `sys_lang`;
CREATE TABLE `sys_lang` (
  `id_lang` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `active` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `iso_code` char(2) NOT NULL,
  PRIMARY KEY (`id_lang`),
  KEY `lang_iso_code` (`iso_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_lang
-- ----------------------------
INSERT INTO `sys_lang` VALUES ('1', 'English (English)', '1', 'EN');
INSERT INTO `sys_lang` VALUES ('2', '中文 (Chinese)', '1', 'ZH');
INSERT INTO `sys_lang` VALUES ('3', 'Français', '1', 'FR');

-- ----------------------------
-- Table structure for sys_lang_fileinfo
-- ----------------------------
DROP TABLE IF EXISTS `sys_lang_fileinfo`;
CREATE TABLE `sys_lang_fileinfo` (
  `FileName` varchar(20) NOT NULL COMMENT '多语言文件名',
  `SignCode` varchar(10) NOT NULL COMMENT '变量名',
  `Description` varchar(50) NOT NULL COMMENT '描述',
  PRIMARY KEY (`FileName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='多语言文件信息表';

-- ----------------------------
-- Records of sys_lang_fileinfo
-- ----------------------------
INSERT INTO `sys_lang_fileinfo` VALUES ('common', 'LG_COMMON', '按钮和标题');
INSERT INTO `sys_lang_fileinfo` VALUES ('function', 'LG_FUNC', '功能模块');
INSERT INTO `sys_lang_fileinfo` VALUES ('message_lang', 'LG_MSG', '通用提示信息');
INSERT INTO `sys_lang_fileinfo` VALUES ('SMARTvend_lang', 'LG_SMA', '各模块具体内容');

-- ----------------------------
-- Table structure for sys_lang_package
-- ----------------------------
DROP TABLE IF EXISTS `sys_lang_package`;
CREATE TABLE `sys_lang_package` (
  `FileName` varchar(20) NOT NULL COMMENT '多语言文件名',
  `ID` varchar(30) NOT NULL COMMENT '语言标识码',
  `Lang1` varchar(255) NOT NULL COMMENT '言语1',
  `Lang2` varchar(255) NOT NULL COMMENT '言语2',
  `Lang3` varchar(255) DEFAULT NULL COMMENT '言语3',
  `Lang4` varchar(255) DEFAULT NULL COMMENT '言语4',
  `Lang5` varchar(255) DEFAULT NULL COMMENT '言语5',
  `Lang6` varchar(255) DEFAULT NULL COMMENT '言语6',
  `Lang7` varchar(255) DEFAULT NULL COMMENT '言语7',
  `Lang8` varchar(255) DEFAULT NULL COMMENT '言语8',
  `Lang9` varchar(255) DEFAULT NULL COMMENT '言语9',
  `Lang10` varchar(255) DEFAULT NULL COMMENT '言语10',
  PRIMARY KEY (`FileName`,`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='多语言文件包定义表';

-- ----------------------------
-- Records of sys_lang_package
-- ----------------------------
INSERT INTO `sys_lang_package` VALUES ('common', 'Active', 'Activate', '启用', 'Activer', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Add', 'Add', '增加', 'Ajouter', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'ADMIN_INHE', 'Cloud Walk,  Free SMARTMessenger', '云端行走，自由SMARTmessenger', 'Cloud Walk,  Free SMARTMessenger', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'ADMIN_NOTICE', 'Administrator Tip: This page execution time %V seconds', '管理员提示：本页面执行时间 %V 秒', 'Administrateur : le temps d\'exécution de cette page est de : %V seconds', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Agent', 'Agent', '代理', 'Agent', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'BaseInf', 'Base Info', '基本信息', 'Info de base', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'BtnPrint', 'Print', '打印', 'Imprimer', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'BtnReject', 'Reject', '拒绝', 'Rejeter', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'BtnReverse', 'Reverse', '反向', 'Reverse', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'BTN_REGISTER', 'Register', '注册', 'Enregistrer', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'BTN_REGISTER_AGAIN', 'Register Again', '新的注册', 'enregistrer de nouveau', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'butSearch', 'Search...', '查询...', 'Chercher...', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Cancel', 'Cancel', '取消', 'Annuler', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Check', 'Approval', '审核', 'Approver', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Clear', 'Clear', '清空', 'Effacer', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'ClearAll', 'Clear All', '清空', 'Effacer tout', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'cliCancel', 'Cancel', '取消', 'Annuler', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'cliOK', 'OK', '确认', 'OK', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'cliSendFailed', 'Send data failed, please try again!', '数据提交失败，请重试！', 'Echec d envoyer les données, SVP essayer à nouveau!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'cliSendOK', 'Submit data successful!', '数据提交成功！', 'Réussi à soumettre les données!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Code', 'Code', '编号', 'Code', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'CodeExists', 'The code exists!', '编号已存在！', 'Code existant!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Confirm', 'Confirm', '确认', 'Confirmer', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'ConfirmTime', 'Confirmation Time', '确认时间', 'Confirmation de temps', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'COPYRIGHT', 'Copyright 2009-2014 Shenzhen Inhemeter Ltd.,', '版权所有 2009-2014 深圳银河表计股份有限公司', 'Copyright 2009-2014 Shenzhen Inhemeter Ltd.,', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'CSTCancel', 'Cancellation', '销户', 'Annulation', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'CtrlPanel', 'Control Panel', '控制面板', 'Panneau de configuration', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'CtrlPanelAlt', 'Change the subject and personal setting', '改变界面主题和个人设置', 'Changer le subjet et confirguration personnelle', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'CurrTimeIs', 'The current system time is', '当前系统时间', 'Le temps actuel de système est', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Cycle', 'Cycle', '周期', 'Cycle', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'DATEFROM', 'Date From', '开始日期', 'Date depuis', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'DATETO', 'Date To', '结束日期', 'Date jusqu\'à', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Day(s)', 'Day(s)', '天(s)', 'Jours(s)', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Delete', 'Delete', '删除', 'Supprimer', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Deleted', 'Cancel', '作废', 'Annuler', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'DELETEOK', 'Deleted successfully!', '删除成功！', 'Succes de suppression!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Description', 'Description', '描述信息', 'Description', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Desktop', 'Desktop', '桌面', 'Accueil', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'DesktopAlt', 'My Desktop', '我的桌面', 'Mon Bureau', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Details', 'Details', '详情', 'Détails', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'DOWNLOADS', 'Downloads', '下载 ', 'Télécharger', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'DSK_HOWTODO', 'How to do? ', '怎么办? ', 'Comment faire?', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'EnterSystem', 'Enter System', '进入系统', 'Accéder au système', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'EXPIRY', 'Expiry, please apply a new licence!', '试用已到期，请申请新的注册码！', 'Expiration, SVP demandez un nouveau licence!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Friday', 'Friday', '星期五', 'Vendredi', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Hello', 'Hello', '您好', 'Bonjour', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Hour(s)', 'Hour(s)', '小时(s)', 'Heure(s)', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Inactive', 'Inactivate', '停用', 'Desactiver', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'infoWarn', 'Warning', '警告', 'Alarme', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'INIT_RPT_FAILED', 'Initialize the Report Viewer components failed!', '初始化报表组件失败!', 'Echec d initialiser le Composant de la Liste de Rapport!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'INIT_RPT_OK', 'Initialize the Report Viewer components successful!', '初始化报表查看器组件成功！', 'Réussir à initialiser le composant de lecture de IC!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'INVALID_PARAMETER', 'Invalid parameters, the visit is refused!', '无效的参数，访问被拒绝！', 'Paramètres invalides, la visite est refusée!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'LastUsedTime', 'Last used time for the system is', '最后一次使用系统的时间是', 'Le temps dernier utilisé dans le système est', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'login', 'Login', '登录', 'Login', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'LoginFailed', 'Login Failed', '登录失败', 'Echec à login', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'LoginNow', 'Relogin', '现在登录', 'Login à nouveau', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'logout', 'Logout', '退出', 'Déconnexion', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'MainDetails', 'Details', '详细信息', 'Détails', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Minitue(s)', 'Minitue(s)', '分钟(s)', 'Minitue(s)', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Modify', 'Modify', '修改', 'Modifier', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Monday', 'Monday', '星期一', 'Lundi', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Month(s)', 'Month(s)', '月(s)', 'Mois', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Name', 'Name', '名称', 'Nom', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'navECMenu', 'Expand/Collapse Menu', '展开/收缩菜单', 'Développer/Dissimulation Menu', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'navFavorites', 'Favorites', '收藏', 'Favori', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'navFavoritesTitle', 'My Favorites', '我的收藏', 'Mon Favori', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'navMsg', 'Messages', '信息', 'Messages', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'navNav', 'Navigator', '导航', 'Navigateur', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'navOrg', 'Organization', '企业架构', 'Organisation', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'navSearch', 'Searching', '查找', 'Chercher', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'navShortcut', 'Shortcut', '快捷', 'Raccourci', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'navShortcutTitle', 'Shortcut Menu', '快捷菜单', 'Menu de Raccourci', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'New', 'New', '新建', 'Nouveau', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Next', 'Next', '下一步', 'Prochain', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'NotEmpty', 'The value can not be empty! ', '输入值不能为空！', 'La valeur ne peut pas être nulle!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Notice', 'Information', '提交', 'Information', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'NOTICE_ERROR', 'Error Info', '错误信息', 'Info Erreur', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'NotSelEmpty', 'Please select an item , and then continue..', '请选择一条记录后继续...', 'SVP sélectionnez un élément, puis continuez..', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'NO_ITEMS', 'No items', '没有选项', 'Pas d\'élément téléchargés', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'OK', 'OK', '确认', 'OK', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Once', 'Once', '一次', 'Une fois', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'ORG_ALL', 'All', '全部', 'Tout', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'ORG_ONLINE', 'Online', '在线', 'En ligne', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'ORG_ONLINE_ALT', 'All Users', '全部用户', 'Tous les utilisateurs', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'ORG_X_USER_ONLINE', 'User(s)', '用户在线', 'Utilisateur(s)', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Owner', 'Owner', '自己', 'Propriétaire', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'PAYMODE01', 'Cash', '现金', 'Espèce', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'PAYMODE02', 'Cheque', '支票', 'Chèque', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'PAYMODE90', 'Credit', '信用卡', 'Crédit', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'PAYMODE96', 'SMS Account', 'SMS帐户', 'SMS compte', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'PAYMODE97', 'Scratch Card', '刮刮卡', 'Carte à gratter', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'PAYMODE98', 'Account of Vs', '账户容量', 'Compte de PV', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'PAYMODE99', 'Account of Customer', '账户的客户', 'Compte de abonné', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'pgFirst', 'Frist Page', '第一页', 'Première page', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'pgGoto', 'Go To', '转到', 'Aller à', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'pgLast', 'Last Page', '最后一页', 'Dernière Page', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'pgNavigator', 'Total&nbsp;[pageRecords]&nbsp;records, record&nbsp;[pagePos], page [pageNumber], turn to page&nbsp;[pageGotoNo]', '总共&nbsp;[pageRecords]&nbsp;页, 第&nbsp;[pagePos]记录, 第 [pageNumber]页, 跳转到&nbsp;[pageGotoNo]页', 'Total&nbsp;[pageRecords]&nbsp;records, record&nbsp;[pagePos], page [pageNumber], turn to page&nbsp;[pageGotoNo]', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'pgNext', 'Next Page', '下一页', 'Page suivante', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'pgPrev', 'Prior Page', '之前页', 'Page précédente', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Previous', 'Previous', '上一步', 'Antérieur', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'PwdIsWeak', 'The new password is not strong,it must be at least eight length with number and character!', '新密码不够坚固的,必须包含数字与字母的8位长度！', 'Le nouveau mot de passe n\'est pas fort, il faut être au minimum 8 caratères alphanumérique!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Refresh', 'Refresh', '刷新', 'Renouveller', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Relogin', 'Relogin', '重新登录', 'Login à nouveau', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Reset', 'Reset', '清空', 'Reset', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Return', 'Return', '返回', 'Retourner', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'RPT_BtPRpt', 'Print Report', '打印报告', 'Imprimer le Rapport', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Saturday', 'Saturday', '星期六', 'Samedi', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Save', 'Save', '保存', 'Sauvegarder', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'SCI', 'Service Component Installation', '服务组件安装', 'Installation de composant de Service', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Search', 'Search', '查询', 'Rechercher', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'SearchTittle', 'Searching Condition', '查询条件', 'Condition de recherche', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'SendAgain', 'Send Again', '重新发送', 'Envoyer de nouveau', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'SendMessage', 'Send Message', '发送短信', 'Envoyer Message', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Service', 'Service', '服务', 'Service', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'ShowHideLeft', 'Show/Hide left pannel', '显示/隐藏左边导航', 'Afficher/Cacher le panneau à gauche', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'ShowHideTop', 'Show/Hide top pannel', '显示/隐藏顶部面板', 'Afficher/Cacher le panneau en haut', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'ShowNextMenu', 'Show the next menu', '显示下一组菜单', 'Afficher le menu suivant', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'SMS', 'SMS', '短信', 'SMS', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'SMS Gateway 1', 'SMS Gateway 1', '短信网关1', 'SMS Porte 1', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'SMS Gateway 2', 'SMS Gateway 2', '短信网关2', 'SMS Porte 2', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'SMS Gateway 3', 'SMS Gateway 3', '短信网关3', 'SMS Porte 3', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Submit', 'Submit', '提交', 'Soumettre', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'SUBMITOK', 'Submitted successfully!', '提交成功！', 'succes de soumission!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Sunday', 'Sunday', '星期日', 'Dimanche', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'SureLogout', 'Are you sure to exit?', '是否确认退出系统？', 'Vous être sur à quitter?', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'SysNotUsed', 'The system has never been used since the installation !', '该系统安装后从未被使用!', 'Le système n\'est pas encore utilié depuis l\'installation!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'SYS_CHECK', 'System Check', '系统检查', 'Vérification de systeme', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Thursday', 'Thursday', '星期四', 'Jeudi', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'TimeChanged', 'The current system time has been changed, please check time-event report!', '服务器时间已改变，请查看时间变化记录报表！', 'Le temps de système a été modifié, SVP vérifiez la rapport de temps de système!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Tuesday', 'Tuesday', '星期二', 'Mardi', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'UNREGISTER', 'Unregistered', '未注册', 'Non enregistrer', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'usBusying', 'Busying', '繁忙', 'Ocuupé', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'userCode', 'User Code', '用户编号', 'Code utilisateur', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'UserLoginError', 'The user name or password entered is incorrect!', '用户输入的用户名或密码不正确！', 'le Code utilisateur ou le mot de passe est incorrect!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'username', 'User Code', '用户号', 'Code utilisateur', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'userpass', 'Password', '密码', 'Mot de passe', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'usLeft', 'Left', '离开', 'Gauche', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'usOnline', 'Online', '在线', 'En ligne', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'VendingDetails', 'Vending Details', '短信内容', 'Détails de vente', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Wednesday', 'Wednesday', '星期三', 'Mercredi', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('common', 'Year(s)', 'Year(s)', '年(s)', 'Année(s)', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA', 'BASE', '基础信息', 'BASE', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VAT', 'Smart Messenger Anywhere', '智能网络信息系统', 'Smart Messenger Anywhere', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_BI', 'Base Information', '基本信息', 'Information de base', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_BIT', 'Base Information', '基本信息', 'Information de Base', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_BI_DD', 'Dictionary', '数据字典', 'Dictionnaire', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_BI_DDT', 'Dictionary', '数据字典', 'Dictionnaire', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_BI_DMM', 'Device Model', '设备模型', 'Type de dispositif', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_BI_DMMT', 'Device Model', '设备模型', 'Type de dispositifs', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_BI_LINE', 'Line', '输电线路', 'Ligne', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_BI_LINET', 'Line', '输电线路', 'Ligne', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_BI_P', 'Parameters', '运行参数', 'Parametres', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_BI_PT', 'Parameters', '运行参数', 'Parametres', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_BI_REGION', 'Region', '区域管理', 'Région', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_BI_REGIONT', 'Region', '区域管理', 'Région', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_BI_STATION', 'Station', '变电站', 'Station', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_BI_STATIONT', 'Station', '变电站', 'Station', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_BI_TM', 'Transformer', '变压器', 'Transformateur', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_BI_TMT', 'Transformer', '变压器', 'Transformateur', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI', 'System Information', '系统信息', 'Information de System', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SIT', 'System Information', '系统信息', 'Information de System', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_CP', 'Control Panel', '控制面板', 'Panneau de configuration', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_CPT', 'Control Panel', '控制面板', 'Panneau de configuration', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_IS', 'Interface', '界面接口', 'Interface', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_IST', 'Interface', '界面接口', 'Interface', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_IS_B', 'Status Bar', '状态栏', 'Barre de statut', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_IS_BT', 'Status Bar', '状态栏', 'Barre de statut', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_IS_F', 'Main Menu', '系统功能', 'Menu principal', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_IS_FT', 'Main Menu', '系统功能', 'Menu Principal', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_IS_LANGDEFINE', 'Language ', '语言定义', 'Langue ', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_IS_LANGDEFINET', 'Language ', '语言定义', 'Langue ', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_IS_LANGIMPORT', 'Import File', '导入语言文件', 'Importer Fichier', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_IS_LANGIMPORTT', 'Import File', '导入语言文件', 'Importer fichier', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_IS_LANGPACKAGE', 'Language Package', '语言包', 'Paquet de langue', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_IS_LANGPACKAGET', 'Language Package', '语言包', 'Paque de Langue', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_IS_S', 'Screen', '主界面管理', 'Ecran', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_IS_ST', 'Screen', '主界面管理', 'Ecran', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_OG', 'Organization', '企业架构', 'Organisation', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_OGT', 'Organization', '企业架构', 'Organisation', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_OG_D', 'Department', '部门管理', 'Département', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_OG_DT', 'Department', '部门管理', 'Département', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_OG_P', 'Roles/Permissions', '角色权限管理', 'Roles/Permissions', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_OG_PT', 'Roles/Permissions', '角色权限管理', 'Roles/Permissions', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_OG_R', 'Register Information', '注册信息', 'Information d enregistrement', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_OG_RT', 'Register Information', '注册信息', 'Information d enregistrement', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_OG_U', 'Operator', '用户管理', 'Opérateur', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_OG_UT', 'Operator', '用户管理', 'Opérateur', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_SI', 'System Information', '系统信息', 'Information de System ', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_SIT', 'System Information', '系统信息', 'Information de Systeme', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_SL', 'System log', '系统日志', 'Journal de système', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_SLT', 'System log', '系统日志', 'Journal de Systeme', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_TE', 'Time Events', '时间变动列表', 'Evènement de temps', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_TET', 'Time Events', '时间变动列表', 'Evénements de temps', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_TM', 'System Tasks', '系统任务', 'Taches de System', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VA_SI_TMT', 'System Tasks', '系统任务', 'Taches de Systeme', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VB', 'Messenger', '短信管理', 'Messenger', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VBT', 'Messenger', '短信管理', 'Messenger', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VB_BM', 'Branch', '分支机构', 'Branche', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VB_BMT', 'Branch', '分支机构', 'Branche', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VB_BM_AB', 'Add Branch', '注册分支机构', 'Ajouter Branche', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VB_BM_ABT', 'Add Branch', '注册分支机构', 'Ajouter Branche', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VB_BM_BB', 'Browse Branch', '分支机构管理', 'Parcourir Branche', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VB_BM_BBT', 'Browse Branch', '分支机构管理', 'Parcourir Branche', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VB_BM_BT', 'Branch Terminals', '终端管理', 'Terminals de Branche', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VB_BM_BTT', 'Branch Terminals', '终端管理', 'Terminals de Branche', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VB_BM_CA', 'Cancellation', '注销分支机构', 'Annulation', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VB_BM_CAT', 'Cancellation', '注销分支机构', 'Annulation', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VB_GS', 'General SMS', '短信业务管理', 'SMS Général', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VB_GST', 'General SMS', '短信业务管理', 'SMS Général', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VB_GS_NSMS', 'New SMS', '新发短信', 'Nouveau SMS', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VB_GS_NSMST', 'New SMS', '新发短信', 'Nouveau SMS', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VB_GS_REC', 'Received SMS', '接收短信管理', 'SMS recu', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VB_GS_RECT', 'Received SMS', '接收短信管理', 'SMS recu', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VB_GS_SENT', 'SMS Sent', '发送短信管理', 'SMS envoyé', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VB_GS_SENTT', 'SMS Sent', '发送短信管理', 'SMS envoyé', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VB_SMS', 'SMS Vending', '短信售电', 'Vente par SMS', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VB_SMST', 'SMS Vending', '短信售电', 'Vente par SMS', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VB_SMS_PRO', 'Processed SMS', '处理短信管理', 'SMS traité', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VB_SMS_PROT', 'Processed SMS', '处理短信管理', 'SMS traité', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VB_SMS_REC', 'Received SMS', '接收短信管理', 'SMS recu', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VB_SMS_RECT', 'Received SMS', '接收短信管理', 'SMS recu', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VB_SMS_SEND', 'SMS Sending', '发送中短信管理', 'SMS envoyer', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VB_SMS_SENDT', 'SMS Sending', '发送中短信管理', 'SMS envoyer', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VB_SMS_SENT', 'SMS Sent', '发送完成短信管理', 'SMS envoi', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VB_SMS_SENTT', 'SMS Sent', '发送完成短信管理', 'SMS envoi', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VB_SMS_VEND', 'SMS Vending', '短信售电管理', 'Vente par SMS', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('function', 'VB_SMS_VENDT', 'SMS Vending', '短信售电管理', 'Vente par SMS', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-10000', 'Submit the data failed!', '提交数据失败!', 'échec de soumission de données!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-10006', 'The meter cannot be found!', '表号不能被找到!', 'on ne peut pas trouver le compteur!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-10013', 'The operator cannot be found!', '操作员不能被找到!', 'on ne peut pas trouver les détails d opérateur!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-10015', 'The details of station cannot be found!', '分支机构详细信息不能被找到!', 'on ne peut pas trouver les détails de station de vente!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-10016', 'The station is inactive!', '分支机构未激活!', 'la station de vente est désactive!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-10017', 'The station does not allow to vend the power!', '分支机构不允许售电!', 'la station de vente ne permet de vendre l\'énergie!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-10018', 'The station is not licensed or the licesnse is invalid!', '分支机构未许可或许可无效!', 'la station de vente n\'est pas licenciée ou la license est invalide!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-10019', 'the license of station is expiry!', '分支机构许可信息为空!', 'la license de station de vente expire!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-10023', 'Invalid checksum verification of information!', '无效的确认验证信息!', 'Invalid checksum verification of information!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-10026', 'The record cannot be found!', '记录不能被找到!', 'pas d\'enregistrement cherché!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-10032', 'The balance of account is not enough!', '账户余额不足!', 'la balance de compte n\'est pas assez!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-10033', 'The code is repeated!', '编号重复!', 'le code a été répété!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-10034', 'The payment type is not found!', '支付方式不能被找到!', 'on ne peut pas trouver le type de paiement!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-10037', 'The amount cannot be 0!', '金额不能为 0!', 'le montant ne peut pas etre 0!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-10038', 'The amount is less than the amount paid!', '输入金额小于支付金额!', 'le montant est inférieur que le montant a payer!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-10044', '', '', 'un département ne peut pas créer plusieurs stations de vente!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-10045', 'This station has been cancelled!', '分支机构已注销!', 'la station de vente a été annulée!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-10050', 'The typed-in amount cannot exceed the remaining paid amount!', '在输入的金额不能超过剩余支付金额!', 'The typed-in amount cannot exceed the remaining paid amount!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-10054', 'The terminal management information cannot be found!', '终端信息不能被找到!', 'On ne peut pas trouver l information de gestion de terminals!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-10055', 'The department information cannot be found!', '部门信息不能被找到!', 'on ne peut pas trouver l information de département!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-10057', 'The meter information of customer cannot be found!', '该客户表计信息不能被找到!', 'on ne peut pas trouver l information de compteur d\'abonné!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-10060', 'It cannot be found that the recharge information of the power station!', '该分支机构的充值信息不能被找到!', 'on ne peut pas trouver l information de recharge de station de vente d énergie!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-10064', 'Delete record failed!', '删除记录失败！', 'échec de suppression d\'enregistrement!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-10065', 'The record list is limited, you can not delete it!', '该记录已被使用,不能删除!', 'La liste d enregistrement est limité, on ne peut pas le supprimer!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-10066', 'The record cannot be found!', '记录不能被找到!', 'on ne peut pas trouver l enregistrement!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-10067', 'The content of result is empty !', '结果内容为空!', 'le contenu de résultat est nul!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-10068', 'The operation is not supported !', '不支持该操作!', 'l opération n est pas possible!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-10077', 'The code has been used!', '编号已被使用!', 'le code a été utilisé!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-10080', 'Record can not be deleted!', '记录不能删除！', 'On ne peut pas supprimer l enregistrement!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-10081', 'Connect to server failed!', '连接到服务器失败！', 'échec de connexion au serveur!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-10082', 'Validata failed!', '数据验证失败！', 'échec de validation!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-12001', 'Remove Failure ! ', '删除失败 ！', 'échec de suppression! ', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-12002', 'Data had existed, please input again! ', '数据已存在，请重新输入！ ', 'les données existent, SVP entrer de nouvelles données!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-12003', 'Already Existed 10 languages,you cannot add language again! ', '已经存在10种语言,不能添加新的语言！', 'il y a deja 10 langues différentes. on ne peut pas ajouter une nouvelle langue!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-12004', 'This iso_code alreday existed!', 'iso_code已经存在! ', 'This iso_code alreday existed!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-12005', 'The count more than max value, please input again!', '输入值大于最大值, 请重新输入!', 'The count more than max value, please input again!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-20', 'Register Failed!', '注册失败!', 'échec d enregistrement!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-2002', 'Authrized failed!  ', '授权失败!  ', 'échec d autorisation', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-21', 'The system is not registered!!', '系统未注册！', 'le systeme n est pas enregistré!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-2101', 'the user name can not be empty!', '用户名不能为空!', 'le nom d utilisateur ne peut pas etre nul!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-2102', 'It is stopped to login the system for the current time! ', '登录系统的当前时间是停止的! ', 'Il est arrêté pour vous connecter au système pour l heure actuelle!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-2104', 'The user name or password entered is incorrect!', '输入的用户名或密码错误!', 'le nom d utilisateur ou le mot de passe saisi est incorrect!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-2105', 'The user [username] is refused to login the system!', '该用户 [username] 被拒绝登录系统!', 'l utilisateur [nom d utilisateur] est refusé a connecter le systeme!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-2106', 'The user name or password entered is incorrect!', '输入的用户名或密码错误!', 'le nom d utilisateur ou le mot de passe saisi est incorrect!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-2107', 'The visitor has been refused!', '访问被拒绝!', 'l utilisateur est refusé!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-2108', 'The user has login the system by other clients!', '该用户已在其他客服端登录!', 'Le nom d utilisateur est entré dans le systeme a [TIME] par d autre utilisateur([IP])!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-22', 'The system is expiry!', '系统试用已到期！', 'le systeme expire!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-70009 ', 'The Data is used, can not delete', '这个数据被使用,不能删除', 'les données sont utilisées, on ne peut pas les supprimer!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-90000', 'No permission to finish this function!', '没有权限完成该模块!', 'pas de permis pour achever la fonction!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-90001', 'Not login the system, the operator will be cancelled!', '未能登录系统，操作将被取消！', 'Pas de connexion au systeme, l operateur sera annulé!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-90002', 'You have no permission to visit this function! If you want to use this, please contact the administrator!', '您没有权限访问该模块! 假如您想使用, 请联系管理员!', 'vous n avez pas le permis a visiter la fonction. SVP contacter votre administrateur!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-90003', 'Directory access restricted!', '目录访问受限制！', 'Directory access restricted!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-90004', 'Please login the system!', '未能登录系统！', 'SVP connecter dans le systeme!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-90005', 'Veridate user failed!', '验证用户失败!', 'échec de validation d utilisateur!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-90006', 'Connect to Licence Server Failed!', '连接到注册服务器失败！', 'échec de connecter au Licence Serveur!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-90007', 'The key or licence can not be empty!', '注册码不能为空！!', 'la clé ou la license ne peut pas etre nulle!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-90008', 'The number of operators is more than the number of licence !', '当前用户不能超过注册允许的用户数！', 'le nombre d opérateurs est supérieur du nombre autorisé!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-90009', 'The Service do not support network visit!', '软件版本不支持网络版!', 'The SMARTvend Service do not support network visit!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-90010', 'The number of customer is more than the number of licence !', '客户数量大于许可数量!', 'le nombre d\'abonné est supérieur du nombre autorisé!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-90020', 'The user can not be found!', '用户不能被找到!', 'on ne peut pas trouver l utilisateur!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('message_lang', '-90021', 'Data already exists!', '数据已经存在!', 'les données existent déja!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act001', 'Browse', '浏览', 'Parcourir', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act002', 'Details', '详情', 'Détails', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act003', 'Add', '增加', 'Ajouter', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act004', 'Modify', '修改', 'Modifier', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act005', 'Delete', '删除', 'Supprimer', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act006', 'Print', '打印', 'Imprimer', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act007', 'Search', '查询', 'Rechercher', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act008', 'Reverse', '取消', 'Retourner', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act009', 'Confirm Reverse', '确认取消', 'Confirmer Retour', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act010', 'Account Charge', '帐户充值', 'Frais de facturation', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act011', 'Cancellation', '销户', 'Annulation', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act012', 'Confirmation', '确认安装表', 'Confirmation', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act013', 'Refund', '售电退款', 'Rembourser', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act014', 'Confirm Refund', '确认退款', 'Confirmer Remboursement', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act015', 'Authorization', '售电站授权', 'Autorisation', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act016', 'Load Keys', '装载密钥', 'Charger clé', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act017', 'Compare Keys', '密钥比较', 'Comparer clés', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act018', 'New Version', '版本新建', 'Nouvelle Version', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act019', 'Modiyf Version', '版本修改', 'Version modifiée', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act020', 'Activate/Inactivate', '启用/停用', 'Activater/Désactiver', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act021', 'Restore Vending', '恢复售电', 'Restaurer la vente', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act022', 'Upload', '上传', 'Télécharger', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act023', 'Contron Service', '控制服务程序', 'Control des Services', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act024', 'Empty Password', '清空密码', 'Mot de passe vide', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act025', 'Check Account', '对账', 'Vérification du compte', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act026', 'Commission', '支付拥金', 'Commission', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act027', 'Cancellation', '取消合同', 'Annulation', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act028', 'Active the task', '激活任务', 'Activer la tache', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act029', 'Control the task', '操作任务', 'Controler la tache', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act030', 'Execute', '执行', 'Exécuter', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act033', 'Reject', '拒绝', 'Rejeter', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act034', 'Download', '下载', 'Download', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act035', 'Exprot', '导出', 'Exporter', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'act036', 'Approval', '批准', 'Approuver', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'AMRTask_deleteSucc', 'Delete success!', '删除成功!', 'succes de suppression!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BCLIENT_Description', 'Description', '描述', 'Description', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BCLIENT_IP', 'IP Address', 'IP地址', 'IP Adresse', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCAC_Remarks', 'Remarks', '备注', 'Remarques', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCAU_ApCon', 'Application information', '申请内容', 'Information d Application', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCAU_AppDate', 'Application Date', '申请时间', 'Date d Application', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCAU_AppInf', 'Application Information', '充值信息', 'Information d Application', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCAU_AuthCode', 'Auth Code', '授权码', 'Code d autorisation', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCAU_Description', 'Description', '描述信息', 'Description', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCAU_Inf', 'Authorization information', '授权信息', 'Information d authorisation', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCAU_NO', 'SN.', '许可序号', 'SN.', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCAU_Pro', 'Applicant', '申请人', 'Demandeur', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCAU_Remarks', 'Remarks', '备注', 'Remarques', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCAU_VS', 'Vending Station', '分支机构', 'Branche', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCC_Remarks', 'Remarks', '备注', 'Remarques', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCC_Tit', 'Contract Details', '账户信息', 'Détails de contrat', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCC_Type', 'Reason', '取消原因', 'Raisons', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCMG_AppDate', 'Date', '申请日期', 'Date', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCMG_AuDate', 'Auth. Date', '授权日期', 'Date d autorisation', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCMG_AuDay', 'Days', '许可天数', 'Jours', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCMG_AuOfVs', 'Authorization', '分支机构授权', 'Autorisation', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCMG_BsAmt', 'Amount', '变动金额', 'Montant', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCMG_BsCode', 'Code', '业务编号', 'Code', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCMG_BsDate', 'Date', '业务日期', 'Date', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCMG_BsType', 'Type', '业务类型', 'Type', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCMG_btAddAu', 'Add new authorization', '增加新的授权', 'ajouter nouvelle autorisations', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCMG_btCost', 'Recharge', '充值', 'Recharge', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCMG_BuyOut', 'Power Purchase', '购电支出', 'Achat d énergie', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCMG_Codtns', 'Searching Condtion', '查询条件', 'Condtion de Recherche', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCMG_Cost', 'Recharge', '充值', 'Recharge', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCMG_DaFrom', 'Starting Date', '许可开始日期', 'Date de démarrage', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCMG_Description', 'Description', '描述信息', 'Description', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCMG_Details', 'Details', '详细信息', 'Détails', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCMG_Name', 'Name', '名称', 'Nom', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCMG_No', 'Code', '编号', 'Code', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCMG_Operator', 'Operator', '操作员', 'Opérateur', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCMG_SeDep', 'Search department', '查询部门', 'Rechercher département', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRCMG_Title', 'List of vending station', '分支机构列表', 'Liste de branches', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRC_Actived', 'Active', '激活的', 'Active', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRC_Address', 'Address', '地址', 'Adresse', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRC_CNum', 'Phone', '联系电话', 'Phone', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRC_Code', 'Code', '分支机构编号', 'Code', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRC_Contact', 'Contact', '联系方式', 'Contact', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRC_Dep', 'Department', '部门', 'Département', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRC_Deposit', 'Deposit', '押金', 'Dépot', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRC_DoMess', 'Submitted successfully!', '提交成功!', 'succes de soumission!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRC_FaxNo', 'Fax No', '传真', 'Fax Numero', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRC_General', 'General', '一般信息', 'Général', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRC_Info', 'Information of vending station', '分支机构信息', 'Information de branches', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRC_IputFaxNo', 'Please enter fax number', '请输入传真号码', 'SVP entrer numéro de fax', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRC_Mobile', 'Mobile', '手机号', 'Mobile', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRC_Name', 'Description', '名称', 'Description', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRC_Num', '(Num1;Num2)', '(号码1;号码2)', '(Numéro 1;Numéro 2)', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRC_ReDate', 'Date', '注册时间', 'Date', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRC_SDep', 'Select department', '选择部门', 'Sélectionner département', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRC_SPow', 'Vending', '允许售电', 'Vente', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRC_SubSucc', 'Submitted successfully!', '提交成功！', 'succes de soumission!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'BRC_Type', 'Types', '分支机构类型', 'Types', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CST_Active', 'Active', '激活', 'Active', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CST_Code', 'Code', '编号', 'Code', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CST_Description', 'Description', '描述', 'Description', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CST_IPAddress', 'IP Address', 'IP地址', 'IP Adresse', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CST_LastTime', 'Last Time', '上一次登陆时间', 'dernière fois', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CST_LastUser', '', '上一次登陆用户', null, null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CST_List', 'List of Terminals  ', '终端列表', 'Liste de Terminals', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CST_RegBrVS', 'Vending Station', '所属分支机构', 'Branche', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CST_RegSBra', 'Select the Vending Station', '选择分支机构', 'Sélectionner la branche', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CTMES_AlItems', 'Backup Menu Item', '备选菜单项', 'Elément du Menu Sauvegarde', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CTMES_ChoseMenu', 'When adjust the sequence of small group in menu,maybe only choose item!', '当调整菜单块的小组的项目顺序，可能只选择项目!', 'When adjust the sequence of small group in menu,maybe only choose item!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CTMES_ClickMess', 'When click bar,can mix CTRL or SHIFT keys for multi chosen', '点击条目时，可以组合CTRL或SHIFT键进行多选', 'Appuyer Ctrl ou Shift pout une sélection Multiple', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CTMES_MeItems', 'Menu Shorcut Group Item', '菜单快捷组项目', 'Elément du Menu raccourci', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CTMES_SeAll', 'All Select', '全选', 'Sélectionner Tous', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CTMES_Select', 'Select', '选择', 'Sélectionner', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CTMES_Sorting', 'Sequence', '排序', 'Sequence', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CTPI_AccSafe', 'Account and Safety', '帐号与安全', 'Compte et Sécurité', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CTPI_CusDes', 'User-define Window', '自定义桌面', 'Fenêtre de définition', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CTPI_CuUser', 'Self-define operator group', '自定义用户组', 'Auto définition de Groupe d opérateur ', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CTPI_MeShot', 'Menu Shortcut', '菜单快捷组', 'Raccourci Menu', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CTPI_MoCom', 'My Account', '我的帐户', 'Mon compte', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CTPI_NiHead', 'Nickname and Avatar', '昵称与头像', 'Surnom et Avatar', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CTPI_PeMess', 'Personnal Information', '个人信息', 'Information Personnelle', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CTPI_PePro', 'Personnal Document', '个人资料', 'Document Personnel', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CTPI_PeURL', 'Personnal website', '个人网址', 'Site Web personnel', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CTPI_ReNT', 'Interface Setting', '界面设置', 'Interface de Configuration', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CTPI_RePsWd', 'Change password', '修改密码', 'Changer le mot de passe', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CTPI_SaJou', 'Safety Log', '安全日志', 'Log de sécurité', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CTPI_Title', 'Control Panel', '控制面板', 'Panneau de controle', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CTPI_Vista', 'Interface Subject', '界面主题', 'Interface Objet', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CTPI_WinShot', 'Windows shortcut group', 'Windows快捷组', 'Fenêtre de Raccourci', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CTPS_ChTime', 'Last amending time', '上次修改时间', 'Temps de dernière opération', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CTPS_NewAgps', 'Confirm new password', '确认新密码', 'Confirmer le nouveau mot de passe', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CTPS_Newps', 'New Password', '新密码', 'nouveau mot de passe', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CTPS_Oldps', 'Original Password', '原密码', 'Mot de passe Original', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'CTPS_PutSame', 'Please input the same password', '请输入相同的密码! ', 'SVP Entrer le même mot de passe', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'DEP_Address', 'Address', '联系地址', 'Adresse', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'DEP_AdminRange', 'Management Scope', '管理范围', 'Cadre de Gestion', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'DEP_ALL', 'Inherited', '继承', 'Hérité', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'DEP_Area', 'Region', '区域', 'Région', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'DEP_Cbumen', 'Current Department', '本部门', 'Département Courant', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'DEP_Defai', 'Delete the department failed!', '册除部门失败！', 'Echec de Suppression: Le département inclu des départements filles et ne peut pas être supprimé!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'DEP_Delete', 'Whether determind to delete current deparment?', '是否确认要删除当前部门？', 'Voulez-vous supprimer le département de base?', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'DEP_DeleteID', 'Whether determind to delete root note', '是否确认删除根节点', 'Whether determind to delete root note', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'DEP_DeparList', 'Department list', '部门列表', 'liste de département', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'DEP_DepartID', 'Please select a depatement,and then continue!', '请选择一个部门，然后继续！', 'SVP sélectionner un département puis continuer', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'DEP_FAX', 'Fax', '传真', 'Fax', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'DEP_head', 'Details of Department', '详细信息', 'Détails de Département', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'DEP_Manager', 'Supervisor', '管理者', 'Superviseur', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'DEP_SelArea', 'Select Region', '选择区域', 'Sélectionner Région', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'DEP_Telephone', 'Telephone', '联系电话', 'Téléphone', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'DIC_AddItem', 'Add data items', '数据新增', 'Ajouter élements de données', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'DIC_DeMainMessage', 'confirm deleting current chosen line or not?', '是否确认删除当前所选行？', 'confirm deleting current chosen line or not?', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'DIC_Maintitle', 'Data List', '数据列表', 'Liste de données', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'DIC_ModifyItem', 'modify data items', '数据修改', 'Modifier élements de données', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'fieldCode', 'Code', '编号', 'Code', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'fieldCurrency', 'Currency Symbol', '货币符号', 'Symbole monétaire', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'fieldDescription', 'Description', '描述', 'Description', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'fieldPrefix', 'Prefix', '前缀', 'Prefix', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'fieldRptHost', 'Report Server Host', '报表服务器地址', 'adresse du serveur rapport', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'fieldRptPort', 'Report Server Port', '报表服务器端口', 'Port du serveur rapport', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'fieldRptType', 'Report Type', '报表类型', 'Type rapport', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'fieldTimezone', 'Region', '时区', 'Région', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'LANG_ACTIVE', 'Actived  ', '激活  ', 'Active', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'LANG_ADD', 'Add Key Word ', '增加关键字 ', 'Ajouter mot clé', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'LANG_DEINFO', 'Cannot delete this language!', '不能删除这种语言！', 'Impossible de supprimer la langue!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'LANG_DEMES', 'Are you sure to delete this key word!', '您确定要删除这个关键字吗!', 'Etes-vous sur de vouloir supprimer ce mot clé?', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'LANG_Descrip', 'Description  ', '描述  ', 'Description', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'LANG_EMPTY', 'Empty  ', '空  ', 'Vide', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'LANG_EXPORT', 'Export  ', '导出  ', 'Exporter', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'LANG_FILE', 'File Name  ', '语言文件  ', 'Nom de Fichier', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'LANG_ID', 'Key Word  ', '关键字  ', 'Mot Clé', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'LANG_IMPORT', 'Import Language File  ', '语言文件操作  ', 'Importer le ficher de langue', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'LANG_IMPORTING', 'Import ', '导入 ', 'Importer', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'LANG_IsEmpty', 'Description Is Empty ?  ', '描述为空 ?  ', 'La description est vide?', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'LANG_ISO', 'ISO Code  ', '语言标号  ', 'Code ISO', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'LANG_Language', 'Language  ', '语言  ', 'Langue', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'LANG_LANID', 'ID  ', '编号  ', 'Code', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'LANG_LIST', 'Language List  ', '语言列表  ', 'Liste de langues', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'LANG_MATCH', 'Matching  ', '模糊查询  ', 'Correspondance', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'LANG_NAME', 'Name  ', '语言名  ', 'Nom', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'LANG_Package', 'Language Package  ', '语言包  ', 'Paquet de Langue', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'LANG_PROMPT', 'Add % can search widely!', '添加%可进行模糊查询！', 'Add % can search widely!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'LANG_REMOVE', 'Are you sure to delete this language ? ', '您确定要删除此语言吗 ？', 'Etes-vous sur de vouloir supprimer ce mot clé?', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'LANG_SMATCH', 'Accurate Matching ', '匹配查询 ', 'Correspondance précise', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'LANG_Warning', 'Please enter data!', '请填满选项！', 'SVP entrer les données!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_Account', 'Bank Account', '银行账号', 'Compte Bancaire', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_Address', 'Contact Address', '联系地址', 'Addresse du Contact', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_Bank', 'Bank', '开户银行', 'Banque', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_COMPANY', 'Company Name', '注册名称', 'Nom de l Entreprise', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_COPYRIGHT', 'Copyright', '版权', 'Copyright', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_CUSTOMERS', 'Allow Customers', '允许客户数', 'Autorisations Abonnées', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_DB', 'Database Version', '数据库版本', 'Version de base de données', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_Email', 'Email', '电子邮件', 'Email', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_Fax', 'Fax', '传真', 'Fax', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_FUNCS', 'Functions', '功能版本', 'Fonctions', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_KEY', 'Key', '系统码', 'clé', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_LICENCE', 'Licence', '注册码', 'Licence', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_Name', 'Company Name', '公司名称', 'Nom de l Entreprise', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_OPERATORS', 'Allow Operators', '允许用户数', 'Autorisations Opérateurs', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_Phone', 'Telephone', '电话号码', 'Téléphone', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_PostCode', 'Zip Code', '邮编', 'Code postal', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_TasksList', 'Tasks List', '任务列表', 'Liste de taches', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_TITLE_1', 'Key and Licence', '系统注册码', 'Clé et Licence', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_TITLE_2', 'Register Information', '注册信息', 'Information d enregistrement', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_TLActive', 'Try when failed', '失败后重试', 'ressayer apres échec', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_TLActMessage', 'Activate the selected task?', '你确定要激活选择的任务？', 'Activer la tache sélectionnée?', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_TLActMessage1', 'Try to restart after', '试着', 'Essayer de rédémarrer plus tard?', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_TLActMessage2', 'minutes.', '分钟后重新启动。', 'minutes.', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_TLAddTask', 'Add a New Task', '添加任务', 'Ajouter une nouvelle tache', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_TLBaseTime', 'Base Time', '基础时间', 'Base Time', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_TLCycle', 'Cycle', '周期', 'Cycle', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_TLDelMessage', 'Are you sure to delete the selected task?', '你确定要删除选择的任务？', 'Etes-vous sur de vouloir supprimer la tache sélectionnée?', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_TLDescription', 'Description', '描述', 'Description', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_TLID', 'ID', '编号', 'Code', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_TLInaMessage', 'Inactivate the selected task?', '你确定要停用选择的任务？', 'désactiver la tache sélectionnée?', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_TLModifyTask', 'Modify a Task', '修改任务', 'Modifier une tache', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_TLModuleFile', 'Module File', '模块文件', 'Fichier du Module', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_TLNextTime', 'Next Time', '下次执行时间', 'Next Time', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_TLParameters', 'Parameters', '参数', 'Parametres', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_TLType', 'Type', '类型', 'Type', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_VERSION', 'Version', '系统版本', 'Version', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'REG_WebSite', 'Website', '网站', 'Website', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'RL_DeRoMessage', 'Whether determined to delete chosen role?', '是否确认删除所选择角色？', 'Voulez-vous supprimer le role sélectionner?', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'RL_DeUsMessage', 'Whether remove shosen operator form role?', '是否从角色里移除所选用户?', 'Voulez-vous supprimer l opérateur?', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'RL_edName', 'Role Name', '角色名称', 'Nom de Role', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'RL_edNO', 'Sequence', '角色排序号', 'Sequence', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'RL_Functions', 'Functional Module', '功能模块', 'Module fonctionnel', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'RL_head', 'Role List', '角色列表', 'Liste des Roles', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'RL_Permiss', 'Permissions', '权限列表', 'Permissions', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'RL_Permission', 'Authority', '权限', 'Autorité', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'RL_ResetMessage', 'Whether recover default authority?', '是否恢复默认权限？', 'Voulez-vous restaurer les roles?', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'RL_Roles', 'Role', '角色', 'Role', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'RL_SMessage', '', '', '', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'RL_Uhead', 'Operators', '用户列表', 'Opérateurs', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_Amt', 'Amt', '金额', 'Amt', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_ClearAll', 'Clear All', '清空', 'effacer tout', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_Comm', 'Comm.', '佣金', 'Comm.', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_Content', 'Content', '内容', 'Contenue', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_DateFrom', 'Date From', '开始日期', 'Date depuis', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_DateTo', 'Date To', '结束日期', 'Date jusqu\'a', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_endTime', 'End Time', '结束时间', 'Date jusqu\'a', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_GatewayType', 'Gateway Type', '网关类型', 'Type de Porte', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_Info', 'SMS Info', '短信信息', 'Info SMS', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_kWh', 'kWh', '电量', 'kWh', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_MeterNum', 'Meter Num.', '表号', 'Numéro de compteur', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_ProcessedList', 'List of Processed SMS', '处理后的短信列表', 'Liste de SMS traités', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_ReceList', 'List of Received SMS', '接收短信列表', 'Liste de SMS recus', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_ResultCode', 'Result Code', '结果代码', 'Code Résultat', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_ScratchPin', 'Pin. Number', 'PIN号码', 'Pin. de Carte de Gratte', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_SendAgain', 'Whether send this record again?', '是否重新发送该短信？', 'voulez-vous renvoyer cet enregistrement?', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_SendAll', 'Sending', '正在发送', 'envoyer', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_SendClearMessage', 'Are you sure to delete all items', '你确定要删除所有项目？', 'Etes-vous sur de vouloir supprimer tous élémements?', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_SendCount', 'Send Count', '发送次数', 'nombre d envoi', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_SendDeleteErr', 'Please select items!', '请选择项目！', 'SVP sélectionner éléments!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_SendDeleteMessage', 'Are you sure to delete the item?', '你确定要删除选定的项目？', 'Etes-vous sur de vouloir supprimer l élémement?', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_SendFailed', 'Failed', '发送失败', 'échouer', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_SendingList', 'List of Sending SMS', '发送中的短信列表', 'Liste de SMS envoyés', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_SendList', 'List of Sent SMS', '发送短信列表', 'Liste de SMS envoyés', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_SendReplyDetails', 'Reply Details', '回复内容', 'Détails de réponse', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_SendResult', 'Result', '结果', 'Résultat', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_SendSendOneMessage', 'Whether to send messages to this mobile?', '是否将消息发送到该移动设备？', 'Voulez-vous envoyer le message a cette téléphone mobile?', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_SendSuccess', 'Send successfully!', '发送成功！', 'envoi résussi!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_SendSuccessful', 'Successful', '发送成功', 'réussi', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_SendVendingDetails', 'Vending Details', '短信内容', 'Détails de vente', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_SMSExample', 'SMS Example', '短信例子', 'SMS Example', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_startTime', 'Start Time', '开始时间', 'Date depuis', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_Token', 'Token', '充值码', 'Token', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SMS_VendList', 'List of Vending SMS', '售电短信列表', 'Liste de SMS de vente', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'STK_SumSucc', 'Save Success!', '提交成功！', 'succes d enregistrer!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SYSITFS_Caption', 'Title', '标题', 'Titre', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SYSITFS_HTIcon', 'Height of Top Icon', '顶部图标高度', 'Hauteur Icone Supérieur', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SYSITFS_MScr', 'Main Interface', '主界面', 'Page d accueil', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SYSITFS_Note', 'Displayed notice word when log out', '当退出登录时显示的提示文字。', 'Notification de déconnexion', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SYSITFS_NText', 'Notice text', '提示文字', 'Texte de Notification', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SYSITFS_SeNote', 'File format must be PNG,GIF,or PNG.', '文件格式必须是JPG、GIF或PNG！', 'le format de document doit etre JPG,GIF,ou PNG.', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SYSITFS_TCap', 'Top Title', '顶部标题', 'Titre Supérieur', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SYSITFS_TIc', 'Top Icon', '顶部图标', 'Icone Supérieur', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SYSITFS_title', 'IE explorer', 'IE 浏览器', 'IE explorer', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SYSITFS_ToBarIntfc', 'Status Bar Middle Words', '底部状态栏置中文字', 'Statut affiché sur la barre centrale', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SYSITFS_WTIcon', 'Width of Top Icon', '顶部图标宽度', 'Largeur Icone Supérieur', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SYSTIME_Conditions', 'Searching Condition', '查询条件', 'condition de recherche', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SYSTIME_EnFrDate', 'Import starting date here', '在此输入开始日期', 'Importer date de démarrage ici', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SYSTIME_EnToDate', 'Import ending date here', '在此输入结束日期', 'Importer date de fin ici', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SYSTIME_NDate', 'Date', '提示日期', 'Date', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SYS_Address', 'Address.', '联系地址', 'Adresse.', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SYS_CName', 'Contact Name', '联系人', 'nom de coordinateur', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SYS_DeMeSS', 'Whether delete chosen time period log data?', '是否删除所选时间段的日志数据？', 'Whether delete chosen time period log data?', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SYS_Evtitle', 'System Log', '系统日志', 'Log Systeme', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SYS_FaxNum', 'Fax', '传真号码', 'Fax', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SYS_Param', 'Parameters', '运行参数', 'Paramèters', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SYS_SafeDate', 'Time', '时间', 'Heure', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SYS_SafeIPadd', 'IP Address', 'IP地址', 'IP Adresse', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SYS_SafeRemarks', 'Remark', '备注', 'Remarque', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SYS_SafeType', 'Type', '类型', 'Type', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SYS_Systitle', 'Branch Information', '分支机构信息', 'Information de point de vente', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SYS_VS', 'Branch ', '分支机构', 'Point de vente', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'SYS_VSType', 'Branch Type', '分支机构类型', 'Type de point de vente', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'tbAREA', 'Area', '区域', 'région', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'tbBRANCHREASON', 'Cancellation Reason of Branch', '取消分支机构原因', 'Raison d annulation de branches', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'tbRMessage', 'Response Message', '回答消息', 'Message de réponse', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'tbSMSExample', 'SMS Example', '短信例子', 'SMS Example', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'tbSMSGType', 'SMS Gateway Type', '短信网关类型', 'Type de Porte de SMS', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'US_AutoDepartment', 'Auto-Department', '自动切换部门', 'Auto-Département', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'US_BindIP', 'Bind IP', '绑定IP', 'Lier IP', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'US_ClPsMessage', 'Whether determined to clear chosen password?', '是否确认清除所选用户的密码？', 'Etes-vous sur de vouloir supprimer le mot de passe sélectionné?', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'US_ClResult', 'Success in clrearing password!', '清除密码成功！', 'succes de change de mot de passe!', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'US_DeMessage', 'Whether determined to delete chosen operator? ', '是否确认删除所选用户?', 'Etes-vous sur de vouloir supprimer l opérateur sélectionné?', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'US_Department', 'Department', '所属部门', 'Département', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'US_Description', 'Description', '描述信息', 'Description', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'US_edARole', 'Append Role', '附加角色', 'Role secondaire', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'US_edControl', 'Access Contol', '访问控制', 'controle d Acces', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'US_edhead', 'Basic Information', '基本信息', 'Information Basique', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'US_edMRole', 'Main Role', '主要角色', 'Role principale', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'US_edNote', 'Remark: Left items is your roles. Append role is only to expand operator authority', '注：左边列表框是选择的角色。附加角色仅是增加用户的权限', 'Remarque: Les élements à gauche sont vos roles. Le role secondaire sert à extandre les Permissions de l opérateur', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'US_edPermission', 'Authority', '权限', 'Autorité', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'US_edSARole', 'Select a role', '指定一个角色', 'Sélectionner une role', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'US_EmPs', 'Change Password', '修改密码', 'Changer le mot de passe', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'US_head', 'Operator List', '用户列表', 'liste d Opérateur', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'US_IPAddress', 'IP Address', 'IP地址', 'IP Adresse', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'US_PSign', 'Login Disabled', '禁止登录', 'Désactiver l accès', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'US_PVUsList', 'Disable to examine operator list', '禁止查看用户列表', 'Désactiver pour voir la liste', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'US_Role', 'Role', '角色', 'Role', null, null, null, null, null, null, null);
INSERT INTO `sys_lang_package` VALUES ('SMARTvend_lang', 'VD_ReaCanoPer', 'Are you sure to cancel the current operation?', '是否确认取消当前操作？', 'Etes-vous sur de vouloir supprimer l opération courante?', null, null, null, null, null, null, null);

-- ----------------------------
-- Table structure for sys_region
-- ----------------------------
DROP TABLE IF EXISTS `sys_region`;
CREATE TABLE `sys_region` (
  `Code` varchar(30) NOT NULL DEFAULT '',
  `ParentCode` varchar(30) NOT NULL DEFAULT '',
  `Description` varchar(50) DEFAULT '' COMMENT '区域名称',
  `OrderNo` int(11) DEFAULT '0' COMMENT '排序号',
  `V1` varchar(100) DEFAULT NULL,
  `V2` varchar(100) DEFAULT NULL,
  `V3` varchar(100) DEFAULT NULL,
  `V4` varchar(100) DEFAULT NULL,
  `LevelNo` smallint(1) DEFAULT '0' COMMENT '级别',
  `UDT` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '时间截',
  PRIMARY KEY (`Code`),
  KEY `ix_region_pcode` (`ParentCode`,`OrderNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_region
-- ----------------------------

-- ----------------------------
-- Table structure for sys_roles
-- ----------------------------
DROP TABLE IF EXISTS `sys_roles`;
CREATE TABLE `sys_roles` (
  `Code` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) CHARACTER SET utf8 NOT NULL,
  `Description` varchar(100) CHARACTER SET utf8 NOT NULL,
  `AdminRange` varchar(1) COLLATE utf8_bin NOT NULL DEFAULT 'A' COMMENT '管理范围，A为全体; C为本部门;',
  `AdminDept` varchar(20) COLLATE utf8_bin DEFAULT NULL COMMENT '管理部门编号，为空为全体，不为空所指定的编号',
  `Permissions` text COLLATE utf8_bin,
  `Actions` text COLLATE utf8_bin,
  `OrderNo` int(10) unsigned NOT NULL DEFAULT '0',
  `DeptCode` varchar(20) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`Code`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Records of sys_roles
-- ----------------------------
INSERT INTO `sys_roles` VALUES ('2', 'administrator', 'administrator', 'A', null, 0x5B305D5B3030395D5B30303930305D5B30303930315D5B30303931305D5B3031315D5B30313130315D5B3031313031315D5B3031313031325D5B3031313031345D5B3031313031335D5B30313130345D5B303131303430315D5B303131303430345D5B303131303430355D5B303131303430365D5B30313131385D5B30313132305D5B30313132315D5B30313132325D5B315D5B3130305D5B31303030315D5B31303030325D5B31303030345D5B31303030395D5B3134305D5B31343030315D5B31343030325D5B31343030335D5B3135305D5B31353030315D5B31353030325D5B31353030335D5B31353030345D5B31353030355D, 0x5B30303930302D3030315D5B30303930302D3030345D5B30303930312D3030315D5B30303930312D3030335D5B30303930312D3030345D5B30303930312D3030355D5B30303931302D3030315D5B30303931302D3030335D5B30303931302D3030345D5B30303931302D3030355D5B3031313031312D3030315D5B3031313031312D3030345D5B3031313031322D3030315D5B3031313031322D3030335D5B3031313031322D3030345D5B3031313031322D3030355D5B3031313031342D3030315D5B3031313031342D3030335D5B3031313031342D3030345D5B3031313031342D3030355D5B3031313031332D3030315D5B3031313031332D3030335D5B3031313031332D3030345D5B3031313031332D3030355D5B3031313031332D3032345D5B303131303430312D3030315D5B303131303430312D3030345D5B303131303430342D3030315D5B303131303430342D3030335D5B303131303430342D3030345D5B303131303430342D3030355D5B303131303430352D3030315D5B303131303430352D3030335D5B303131303430352D3030345D5B303131303430352D3030355D5B303131303430362D3030315D5B303131303430362D3030335D5B303131303430362D3030345D5B303131303430362D3030355D5B30313131382D3030315D5B30313131382D3030355D5B30313132302D3030315D5B30313132312D3030315D5B30313132312D3030325D5B30313132312D3030335D5B30313132312D3030345D5B30313132312D3030355D5B30313132312D3032305D5B30313132322D3030315D5B30313132322D3030345D5B31303030312D3030315D5B31303030312D3030335D5B31303030312D3030365D5B31303030322D3030315D5B31303030322D3030325D5B31303030322D3030335D5B31303030322D3030345D5B31303030322D3030365D5B31303030322D3031315D5B31303030322D3031355D5B31303030342D3030315D5B31303030342D3030325D5B31303030342D3030335D5B31303030342D3030345D5B31303030342D3030355D5B31303030342D3032305D5B31303030392D3030315D5B31303030392D3030325D5B31303030392D3030335D5B31343030312D3030315D5B31343030312D3030325D5B31343030312D3030335D5B31343030322D3030315D5B31343030322D3030325D5B31343030322D3030355D5B31343030332D3030315D5B31343030332D3030325D5B31343030332D3030335D5B31343030332D3030355D5B31353030312D3030315D5B31353030312D3030325D5B31353030322D3030315D5B31353030322D3030325D5B31353030332D3030315D5B31353030332D3030325D5B31353030342D3030315D5B31353030342D3030325D5B31353030342D3030335D5B31353030352D3030315D5B31353030352D3030325D5B31353030352D3030335D, '0', '');

-- ----------------------------
-- Table structure for sys_task
-- ----------------------------
DROP TABLE IF EXISTS `sys_task`;
CREATE TABLE `sys_task` (
  `ID` varchar(20) NOT NULL,
  `Description` varchar(50) NOT NULL,
  `TaskType` smallint(4) NOT NULL DEFAULT '1' COMMENT '任务类型：1 一次性，2为周期性，3为服务程序',
  `Cycle` smallint(4) NOT NULL DEFAULT '0' COMMENT '周期',
  `CycleType` varchar(1) NOT NULL DEFAULT '0' COMMENT '周期类型（单位）：1：分，2：小时，3：天，4：月，5：年',
  `BaseTime` datetime DEFAULT NULL COMMENT '基本执行时间',
  `NextTime` datetime DEFAULT NULL COMMENT '下去执行时间，默认与BaseTime相同',
  `TryIt` varchar(1) NOT NULL COMMENT '失败后重试，值为Y和N',
  `TryTimes` smallint(4) NOT NULL DEFAULT '0',
  `TryCycle` smallint(4) NOT NULL DEFAULT '1',
  `ModuleFile` varchar(50) NOT NULL DEFAULT '' COMMENT '模块标识',
  `Params` text COMMENT '运行参数',
  `Active` varchar(1) NOT NULL COMMENT '是否激活',
  `COperator` varchar(20) NOT NULL,
  `CDate` datetime NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_task
-- ----------------------------
INSERT INTO `sys_task` VALUES ('GSMSVC', 'GSM Service', '3', '1', '4', '2014-04-17 00:18:10', '2014-12-06 23:10:30', 'N', '0', '1', 'GSMService.dll', '4,115200,,225,01,01,00*01,2,30,3,11', 'N', 'admin', '2014-12-11 18:12:44');
INSERT INTO `sys_task` VALUES ('SMPPSVC', 'SMS SMPP Service', '3', '1', '3', '2012-10-19 00:00:00', '2014-06-03 14:40:15', 'N', '0', '1', 'SMPPService.dll', '217.168.176.16,16000,az3rnerj,enerp@ss,0,1,00,2,30,30,SMPPAZERCELL,Y,03,00,Y,9842,Azerenerji,0,1,1,1,Y,3', 'N', 'admin', '2014-06-11 10:32:52');
INSERT INTO `sys_task` VALUES ('SMSSVC', 'SMS Service', '3', '1', '3', '2013-09-14 13:41:43', '2014-03-31 10:41:56', 'N', '0', '1', 'SMSService.dll', '30,9030,01', 'Y', 'admin', '2014-06-10 09:53:05');
INSERT INTO `sys_task` VALUES ('SMSVSVC', 'SMS Vending Service', '3', '1', '3', '2012-10-13 00:00:00', '2014-12-06 23:10:50', 'N', '0', '1', 'SMSVService.dll', '127.0.0.1:9000,SMS,1234,1234567890ABCDEF,5,1,01,5,6', 'N', 'admin', '2014-05-30 03:31:28');

-- ----------------------------
-- Table structure for sys_timezone
-- ----------------------------
DROP TABLE IF EXISTS `sys_timezone`;
CREATE TABLE `sys_timezone` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(32) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=561 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_timezone
-- ----------------------------
INSERT INTO `sys_timezone` VALUES ('1', 'Africa/Abidjan');
INSERT INTO `sys_timezone` VALUES ('2', 'Africa/Accra');
INSERT INTO `sys_timezone` VALUES ('3', 'Africa/Addis_Ababa');
INSERT INTO `sys_timezone` VALUES ('4', 'Africa/Algiers');
INSERT INTO `sys_timezone` VALUES ('5', 'Africa/Asmara');
INSERT INTO `sys_timezone` VALUES ('6', 'Africa/Asmera');
INSERT INTO `sys_timezone` VALUES ('7', 'Africa/Bamako');
INSERT INTO `sys_timezone` VALUES ('8', 'Africa/Bangui');
INSERT INTO `sys_timezone` VALUES ('9', 'Africa/Banjul');
INSERT INTO `sys_timezone` VALUES ('10', 'Africa/Bissau');
INSERT INTO `sys_timezone` VALUES ('11', 'Africa/Blantyre');
INSERT INTO `sys_timezone` VALUES ('12', 'Africa/Brazzaville');
INSERT INTO `sys_timezone` VALUES ('13', 'Africa/Bujumbura');
INSERT INTO `sys_timezone` VALUES ('14', 'Africa/Cairo');
INSERT INTO `sys_timezone` VALUES ('15', 'Africa/Casablanca');
INSERT INTO `sys_timezone` VALUES ('16', 'Africa/Ceuta');
INSERT INTO `sys_timezone` VALUES ('17', 'Africa/Conakry');
INSERT INTO `sys_timezone` VALUES ('18', 'Africa/Dakar');
INSERT INTO `sys_timezone` VALUES ('19', 'Africa/Dar_es_Salaam');
INSERT INTO `sys_timezone` VALUES ('20', 'Africa/Djibouti');
INSERT INTO `sys_timezone` VALUES ('21', 'Africa/Douala');
INSERT INTO `sys_timezone` VALUES ('22', 'Africa/El_Aaiun');
INSERT INTO `sys_timezone` VALUES ('23', 'Africa/Freetown');
INSERT INTO `sys_timezone` VALUES ('24', 'Africa/Gaborone');
INSERT INTO `sys_timezone` VALUES ('25', 'Africa/Harare');
INSERT INTO `sys_timezone` VALUES ('26', 'Africa/Johannesburg');
INSERT INTO `sys_timezone` VALUES ('27', 'Africa/Kampala');
INSERT INTO `sys_timezone` VALUES ('28', 'Africa/Khartoum');
INSERT INTO `sys_timezone` VALUES ('29', 'Africa/Kigali');
INSERT INTO `sys_timezone` VALUES ('30', 'Africa/Kinshasa');
INSERT INTO `sys_timezone` VALUES ('31', 'Africa/Lagos');
INSERT INTO `sys_timezone` VALUES ('32', 'Africa/Libreville');
INSERT INTO `sys_timezone` VALUES ('33', 'Africa/Lome');
INSERT INTO `sys_timezone` VALUES ('34', 'Africa/Luanda');
INSERT INTO `sys_timezone` VALUES ('35', 'Africa/Lubumbashi');
INSERT INTO `sys_timezone` VALUES ('36', 'Africa/Lusaka');
INSERT INTO `sys_timezone` VALUES ('37', 'Africa/Malabo');
INSERT INTO `sys_timezone` VALUES ('38', 'Africa/Maputo');
INSERT INTO `sys_timezone` VALUES ('39', 'Africa/Maseru');
INSERT INTO `sys_timezone` VALUES ('40', 'Africa/Mbabane');
INSERT INTO `sys_timezone` VALUES ('41', 'Africa/Mogadishu');
INSERT INTO `sys_timezone` VALUES ('42', 'Africa/Monrovia');
INSERT INTO `sys_timezone` VALUES ('43', 'Africa/Nairobi');
INSERT INTO `sys_timezone` VALUES ('44', 'Africa/Ndjamena');
INSERT INTO `sys_timezone` VALUES ('45', 'Africa/Niamey');
INSERT INTO `sys_timezone` VALUES ('46', 'Africa/Nouakchott');
INSERT INTO `sys_timezone` VALUES ('47', 'Africa/Ouagadougou');
INSERT INTO `sys_timezone` VALUES ('48', 'Africa/Porto-Novo');
INSERT INTO `sys_timezone` VALUES ('49', 'Africa/Sao_Tome');
INSERT INTO `sys_timezone` VALUES ('50', 'Africa/Timbuktu');
INSERT INTO `sys_timezone` VALUES ('51', 'Africa/Tripoli');
INSERT INTO `sys_timezone` VALUES ('52', 'Africa/Tunis');
INSERT INTO `sys_timezone` VALUES ('53', 'Africa/Windhoek');
INSERT INTO `sys_timezone` VALUES ('54', 'America/Adak');
INSERT INTO `sys_timezone` VALUES ('55', 'America/Anchorage ');
INSERT INTO `sys_timezone` VALUES ('56', 'America/Anguilla');
INSERT INTO `sys_timezone` VALUES ('57', 'America/Antigua');
INSERT INTO `sys_timezone` VALUES ('58', 'America/Araguaina');
INSERT INTO `sys_timezone` VALUES ('59', 'America/Argentina/Buenos_Aires');
INSERT INTO `sys_timezone` VALUES ('60', 'America/Argentina/Catamarca');
INSERT INTO `sys_timezone` VALUES ('61', 'America/Argentina/ComodRivadavia');
INSERT INTO `sys_timezone` VALUES ('62', 'America/Argentina/Cordoba');
INSERT INTO `sys_timezone` VALUES ('63', 'America/Argentina/Jujuy');
INSERT INTO `sys_timezone` VALUES ('64', 'America/Argentina/La_Rioja');
INSERT INTO `sys_timezone` VALUES ('65', 'America/Argentina/Mendoza');
INSERT INTO `sys_timezone` VALUES ('66', 'America/Argentina/Rio_Gallegos');
INSERT INTO `sys_timezone` VALUES ('67', 'America/Argentina/Salta');
INSERT INTO `sys_timezone` VALUES ('68', 'America/Argentina/San_Juan');
INSERT INTO `sys_timezone` VALUES ('69', 'America/Argentina/San_Luis');
INSERT INTO `sys_timezone` VALUES ('70', 'America/Argentina/Tucuman');
INSERT INTO `sys_timezone` VALUES ('71', 'America/Argentina/Ushuaia');
INSERT INTO `sys_timezone` VALUES ('72', 'America/Aruba');
INSERT INTO `sys_timezone` VALUES ('73', 'America/Asuncion');
INSERT INTO `sys_timezone` VALUES ('74', 'America/Atikokan');
INSERT INTO `sys_timezone` VALUES ('75', 'America/Atka');
INSERT INTO `sys_timezone` VALUES ('76', 'America/Bahia');
INSERT INTO `sys_timezone` VALUES ('77', 'America/Barbados');
INSERT INTO `sys_timezone` VALUES ('78', 'America/Belem');
INSERT INTO `sys_timezone` VALUES ('79', 'America/Belize');
INSERT INTO `sys_timezone` VALUES ('80', 'America/Blanc-Sablon');
INSERT INTO `sys_timezone` VALUES ('81', 'America/Boa_Vista');
INSERT INTO `sys_timezone` VALUES ('82', 'America/Bogota');
INSERT INTO `sys_timezone` VALUES ('83', 'America/Boise');
INSERT INTO `sys_timezone` VALUES ('84', 'America/Buenos_Aires');
INSERT INTO `sys_timezone` VALUES ('85', 'America/Cambridge_Bay');
INSERT INTO `sys_timezone` VALUES ('86', 'America/Campo_Grande');
INSERT INTO `sys_timezone` VALUES ('87', 'America/Cancun');
INSERT INTO `sys_timezone` VALUES ('88', 'America/Caracas');
INSERT INTO `sys_timezone` VALUES ('89', 'America/Catamarca');
INSERT INTO `sys_timezone` VALUES ('90', 'America/Cayenne');
INSERT INTO `sys_timezone` VALUES ('91', 'America/Cayman');
INSERT INTO `sys_timezone` VALUES ('92', 'America/Chicago');
INSERT INTO `sys_timezone` VALUES ('93', 'America/Chihuahua');
INSERT INTO `sys_timezone` VALUES ('94', 'America/Coral_Harbour');
INSERT INTO `sys_timezone` VALUES ('95', 'America/Cordoba');
INSERT INTO `sys_timezone` VALUES ('96', 'America/Costa_Rica');
INSERT INTO `sys_timezone` VALUES ('97', 'America/Cuiaba');
INSERT INTO `sys_timezone` VALUES ('98', 'America/Curacao');
INSERT INTO `sys_timezone` VALUES ('99', 'America/Danmarkshavn');
INSERT INTO `sys_timezone` VALUES ('100', 'America/Dawson');
INSERT INTO `sys_timezone` VALUES ('101', 'America/Dawson_Creek');
INSERT INTO `sys_timezone` VALUES ('102', 'America/Denver');
INSERT INTO `sys_timezone` VALUES ('103', 'America/Detroit');
INSERT INTO `sys_timezone` VALUES ('104', 'America/Dominica');
INSERT INTO `sys_timezone` VALUES ('105', 'America/Edmonton');
INSERT INTO `sys_timezone` VALUES ('106', 'America/Eirunepe');
INSERT INTO `sys_timezone` VALUES ('107', 'America/El_Salvador');
INSERT INTO `sys_timezone` VALUES ('108', 'America/Ensenada');
INSERT INTO `sys_timezone` VALUES ('109', 'America/Fort_Wayne');
INSERT INTO `sys_timezone` VALUES ('110', 'America/Fortaleza');
INSERT INTO `sys_timezone` VALUES ('111', 'America/Glace_Bay');
INSERT INTO `sys_timezone` VALUES ('112', 'America/Godthab');
INSERT INTO `sys_timezone` VALUES ('113', 'America/Goose_Bay');
INSERT INTO `sys_timezone` VALUES ('114', 'America/Grand_Turk');
INSERT INTO `sys_timezone` VALUES ('115', 'America/Grenada');
INSERT INTO `sys_timezone` VALUES ('116', 'America/Guadeloupe');
INSERT INTO `sys_timezone` VALUES ('117', 'America/Guatemala');
INSERT INTO `sys_timezone` VALUES ('118', 'America/Guayaquil');
INSERT INTO `sys_timezone` VALUES ('119', 'America/Guyana');
INSERT INTO `sys_timezone` VALUES ('120', 'America/Halifax');
INSERT INTO `sys_timezone` VALUES ('121', 'America/Havana');
INSERT INTO `sys_timezone` VALUES ('122', 'America/Hermosillo');
INSERT INTO `sys_timezone` VALUES ('123', 'America/Indiana/Indianapolis');
INSERT INTO `sys_timezone` VALUES ('124', 'America/Indiana/Knox');
INSERT INTO `sys_timezone` VALUES ('125', 'America/Indiana/Marengo');
INSERT INTO `sys_timezone` VALUES ('126', 'America/Indiana/Petersburg');
INSERT INTO `sys_timezone` VALUES ('127', 'America/Indiana/Tell_City');
INSERT INTO `sys_timezone` VALUES ('128', 'America/Indiana/Vevay');
INSERT INTO `sys_timezone` VALUES ('129', 'America/Indiana/Vincennes');
INSERT INTO `sys_timezone` VALUES ('130', 'America/Indiana/Winamac');
INSERT INTO `sys_timezone` VALUES ('131', 'America/Indianapolis');
INSERT INTO `sys_timezone` VALUES ('132', 'America/Inuvik');
INSERT INTO `sys_timezone` VALUES ('133', 'America/Iqaluit');
INSERT INTO `sys_timezone` VALUES ('134', 'America/Jamaica');
INSERT INTO `sys_timezone` VALUES ('135', 'America/Jujuy');
INSERT INTO `sys_timezone` VALUES ('136', 'America/Juneau');
INSERT INTO `sys_timezone` VALUES ('137', 'America/Kentucky/Louisville');
INSERT INTO `sys_timezone` VALUES ('138', 'America/Kentucky/Monticello');
INSERT INTO `sys_timezone` VALUES ('139', 'America/Knox_IN');
INSERT INTO `sys_timezone` VALUES ('140', 'America/La_Paz');
INSERT INTO `sys_timezone` VALUES ('141', 'America/Lima');
INSERT INTO `sys_timezone` VALUES ('142', 'America/Los_Angeles');
INSERT INTO `sys_timezone` VALUES ('143', 'America/Louisville');
INSERT INTO `sys_timezone` VALUES ('144', 'America/Maceio');
INSERT INTO `sys_timezone` VALUES ('145', 'America/Managua');
INSERT INTO `sys_timezone` VALUES ('146', 'America/Manaus');
INSERT INTO `sys_timezone` VALUES ('147', 'America/Marigot');
INSERT INTO `sys_timezone` VALUES ('148', 'America/Martinique');
INSERT INTO `sys_timezone` VALUES ('149', 'America/Mazatlan');
INSERT INTO `sys_timezone` VALUES ('150', 'America/Mendoza');
INSERT INTO `sys_timezone` VALUES ('151', 'America/Menominee');
INSERT INTO `sys_timezone` VALUES ('152', 'America/Merida');
INSERT INTO `sys_timezone` VALUES ('153', 'America/Mexico_City');
INSERT INTO `sys_timezone` VALUES ('154', 'America/Miquelon');
INSERT INTO `sys_timezone` VALUES ('155', 'America/Moncton');
INSERT INTO `sys_timezone` VALUES ('156', 'America/Monterrey');
INSERT INTO `sys_timezone` VALUES ('157', 'America/Montevideo');
INSERT INTO `sys_timezone` VALUES ('158', 'America/Montreal');
INSERT INTO `sys_timezone` VALUES ('159', 'America/Montserrat');
INSERT INTO `sys_timezone` VALUES ('160', 'America/Nassau');
INSERT INTO `sys_timezone` VALUES ('161', 'America/New_York');
INSERT INTO `sys_timezone` VALUES ('162', 'America/Nipigon');
INSERT INTO `sys_timezone` VALUES ('163', 'America/Nome');
INSERT INTO `sys_timezone` VALUES ('164', 'America/Noronha');
INSERT INTO `sys_timezone` VALUES ('165', 'America/North_Dakota/Center');
INSERT INTO `sys_timezone` VALUES ('166', 'America/North_Dakota/New_Salem');
INSERT INTO `sys_timezone` VALUES ('167', 'America/Panama');
INSERT INTO `sys_timezone` VALUES ('168', 'America/Pangnirtung');
INSERT INTO `sys_timezone` VALUES ('169', 'America/Paramaribo');
INSERT INTO `sys_timezone` VALUES ('170', 'America/Phoenix');
INSERT INTO `sys_timezone` VALUES ('171', 'America/Port-au-Prince');
INSERT INTO `sys_timezone` VALUES ('172', 'America/Port_of_Spain');
INSERT INTO `sys_timezone` VALUES ('173', 'America/Porto_Acre');
INSERT INTO `sys_timezone` VALUES ('174', 'America/Porto_Velho');
INSERT INTO `sys_timezone` VALUES ('175', 'America/Puerto_Rico');
INSERT INTO `sys_timezone` VALUES ('176', 'America/Rainy_River');
INSERT INTO `sys_timezone` VALUES ('177', 'America/Rankin_Inlet');
INSERT INTO `sys_timezone` VALUES ('178', 'America/Recife');
INSERT INTO `sys_timezone` VALUES ('179', 'America/Regina');
INSERT INTO `sys_timezone` VALUES ('180', 'America/Resolute');
INSERT INTO `sys_timezone` VALUES ('181', 'America/Rio_Branco');
INSERT INTO `sys_timezone` VALUES ('182', 'America/Rosario');
INSERT INTO `sys_timezone` VALUES ('183', 'America/Santarem');
INSERT INTO `sys_timezone` VALUES ('184', 'America/Santiago');
INSERT INTO `sys_timezone` VALUES ('185', 'America/Santo_Domingo');
INSERT INTO `sys_timezone` VALUES ('186', 'America/Sao_Paulo');
INSERT INTO `sys_timezone` VALUES ('187', 'America/Scoresbysund');
INSERT INTO `sys_timezone` VALUES ('188', 'America/Shiprock');
INSERT INTO `sys_timezone` VALUES ('189', 'America/St_Barthelemy');
INSERT INTO `sys_timezone` VALUES ('190', 'America/St_Johns');
INSERT INTO `sys_timezone` VALUES ('191', 'America/St_Kitts');
INSERT INTO `sys_timezone` VALUES ('192', 'America/St_Lucia');
INSERT INTO `sys_timezone` VALUES ('193', 'America/St_Thomas');
INSERT INTO `sys_timezone` VALUES ('194', 'America/St_Vincent');
INSERT INTO `sys_timezone` VALUES ('195', 'America/Swift_Current');
INSERT INTO `sys_timezone` VALUES ('196', 'America/Tegucigalpa');
INSERT INTO `sys_timezone` VALUES ('197', 'America/Thule');
INSERT INTO `sys_timezone` VALUES ('198', 'America/Thunder_Bay');
INSERT INTO `sys_timezone` VALUES ('199', 'America/Tijuana');
INSERT INTO `sys_timezone` VALUES ('200', 'America/Toronto');
INSERT INTO `sys_timezone` VALUES ('201', 'America/Tortola');
INSERT INTO `sys_timezone` VALUES ('202', 'America/Vancouver');
INSERT INTO `sys_timezone` VALUES ('203', 'America/Virgin');
INSERT INTO `sys_timezone` VALUES ('204', 'America/Whitehorse');
INSERT INTO `sys_timezone` VALUES ('205', 'America/Winnipeg');
INSERT INTO `sys_timezone` VALUES ('206', 'America/Yakutat');
INSERT INTO `sys_timezone` VALUES ('207', 'America/Yellowknife');
INSERT INTO `sys_timezone` VALUES ('208', 'Antarctica/Casey');
INSERT INTO `sys_timezone` VALUES ('209', 'Antarctica/Davis');
INSERT INTO `sys_timezone` VALUES ('210', 'Antarctica/DumontDUrville');
INSERT INTO `sys_timezone` VALUES ('211', 'Antarctica/Mawson');
INSERT INTO `sys_timezone` VALUES ('212', 'Antarctica/McMurdo');
INSERT INTO `sys_timezone` VALUES ('213', 'Antarctica/Palmer');
INSERT INTO `sys_timezone` VALUES ('214', 'Antarctica/Rothera');
INSERT INTO `sys_timezone` VALUES ('215', 'Antarctica/South_Pole');
INSERT INTO `sys_timezone` VALUES ('216', 'Antarctica/Syowa');
INSERT INTO `sys_timezone` VALUES ('217', 'Antarctica/Vostok');
INSERT INTO `sys_timezone` VALUES ('218', 'Arctic/Longyearbyen');
INSERT INTO `sys_timezone` VALUES ('219', 'Asia/Aden');
INSERT INTO `sys_timezone` VALUES ('220', 'Asia/Almaty');
INSERT INTO `sys_timezone` VALUES ('221', 'Asia/Amman');
INSERT INTO `sys_timezone` VALUES ('222', 'Asia/Anadyr');
INSERT INTO `sys_timezone` VALUES ('223', 'Asia/Aqtau');
INSERT INTO `sys_timezone` VALUES ('224', 'Asia/Aqtobe');
INSERT INTO `sys_timezone` VALUES ('225', 'Asia/Ashgabat');
INSERT INTO `sys_timezone` VALUES ('226', 'Asia/Ashkhabad');
INSERT INTO `sys_timezone` VALUES ('227', 'Asia/Baghdad');
INSERT INTO `sys_timezone` VALUES ('228', 'Asia/Bahrain');
INSERT INTO `sys_timezone` VALUES ('229', 'Asia/Baku');
INSERT INTO `sys_timezone` VALUES ('230', 'Asia/Bangkok');
INSERT INTO `sys_timezone` VALUES ('231', 'Asia/Beirut');
INSERT INTO `sys_timezone` VALUES ('232', 'Asia/Bishkek');
INSERT INTO `sys_timezone` VALUES ('233', 'Asia/Brunei');
INSERT INTO `sys_timezone` VALUES ('234', 'Asia/Calcutta');
INSERT INTO `sys_timezone` VALUES ('235', 'Asia/Choibalsan');
INSERT INTO `sys_timezone` VALUES ('236', 'Asia/Chongqing');
INSERT INTO `sys_timezone` VALUES ('237', 'Asia/Chungking');
INSERT INTO `sys_timezone` VALUES ('238', 'Asia/Colombo');
INSERT INTO `sys_timezone` VALUES ('239', 'Asia/Dacca');
INSERT INTO `sys_timezone` VALUES ('240', 'Asia/Damascus');
INSERT INTO `sys_timezone` VALUES ('241', 'Asia/Dhaka');
INSERT INTO `sys_timezone` VALUES ('242', 'Asia/Dili');
INSERT INTO `sys_timezone` VALUES ('243', 'Asia/Dubai');
INSERT INTO `sys_timezone` VALUES ('244', 'Asia/Dushanbe');
INSERT INTO `sys_timezone` VALUES ('245', 'Asia/Gaza');
INSERT INTO `sys_timezone` VALUES ('246', 'Asia/Harbin');
INSERT INTO `sys_timezone` VALUES ('247', 'Asia/Ho_Chi_Minh');
INSERT INTO `sys_timezone` VALUES ('248', 'Asia/Hong_Kong');
INSERT INTO `sys_timezone` VALUES ('249', 'Asia/Hovd');
INSERT INTO `sys_timezone` VALUES ('250', 'Asia/Irkutsk');
INSERT INTO `sys_timezone` VALUES ('251', 'Asia/Istanbul');
INSERT INTO `sys_timezone` VALUES ('252', 'Asia/Jakarta');
INSERT INTO `sys_timezone` VALUES ('253', 'Asia/Jayapura');
INSERT INTO `sys_timezone` VALUES ('254', 'Asia/Jerusalem');
INSERT INTO `sys_timezone` VALUES ('255', 'Asia/Kabul');
INSERT INTO `sys_timezone` VALUES ('256', 'Asia/Kamchatka');
INSERT INTO `sys_timezone` VALUES ('257', 'Asia/Karachi');
INSERT INTO `sys_timezone` VALUES ('258', 'Asia/Kashgar');
INSERT INTO `sys_timezone` VALUES ('259', 'Asia/Kathmandu');
INSERT INTO `sys_timezone` VALUES ('260', 'Asia/Katmandu');
INSERT INTO `sys_timezone` VALUES ('261', 'Asia/Kolkata');
INSERT INTO `sys_timezone` VALUES ('262', 'Asia/Krasnoyarsk');
INSERT INTO `sys_timezone` VALUES ('263', 'Asia/Kuala_Lumpur');
INSERT INTO `sys_timezone` VALUES ('264', 'Asia/Kuching');
INSERT INTO `sys_timezone` VALUES ('265', 'Asia/Kuwait');
INSERT INTO `sys_timezone` VALUES ('266', 'Asia/Macao');
INSERT INTO `sys_timezone` VALUES ('267', 'Asia/Macau');
INSERT INTO `sys_timezone` VALUES ('268', 'Asia/Magadan');
INSERT INTO `sys_timezone` VALUES ('269', 'Asia/Makassar');
INSERT INTO `sys_timezone` VALUES ('270', 'Asia/Manila');
INSERT INTO `sys_timezone` VALUES ('271', 'Asia/Muscat');
INSERT INTO `sys_timezone` VALUES ('272', 'Asia/Nicosia');
INSERT INTO `sys_timezone` VALUES ('273', 'Asia/Novosibirsk');
INSERT INTO `sys_timezone` VALUES ('274', 'Asia/Omsk');
INSERT INTO `sys_timezone` VALUES ('275', 'Asia/Oral');
INSERT INTO `sys_timezone` VALUES ('276', 'Asia/Phnom_Penh');
INSERT INTO `sys_timezone` VALUES ('277', 'Asia/Pontianak');
INSERT INTO `sys_timezone` VALUES ('278', 'Asia/Pyongyang');
INSERT INTO `sys_timezone` VALUES ('279', 'Asia/Qatar');
INSERT INTO `sys_timezone` VALUES ('280', 'Asia/Qyzylorda');
INSERT INTO `sys_timezone` VALUES ('281', 'Asia/Rangoon');
INSERT INTO `sys_timezone` VALUES ('282', 'Asia/Riyadh');
INSERT INTO `sys_timezone` VALUES ('283', 'Asia/Saigon');
INSERT INTO `sys_timezone` VALUES ('284', 'Asia/Sakhalin');
INSERT INTO `sys_timezone` VALUES ('285', 'Asia/Samarkand');
INSERT INTO `sys_timezone` VALUES ('286', 'Asia/Seoul');
INSERT INTO `sys_timezone` VALUES ('287', 'Asia/Shanghai');
INSERT INTO `sys_timezone` VALUES ('288', 'Asia/Singapore');
INSERT INTO `sys_timezone` VALUES ('289', 'Asia/Taipei');
INSERT INTO `sys_timezone` VALUES ('290', 'Asia/Tashkent');
INSERT INTO `sys_timezone` VALUES ('291', 'Asia/Tbilisi');
INSERT INTO `sys_timezone` VALUES ('292', 'Asia/Tehran');
INSERT INTO `sys_timezone` VALUES ('293', 'Asia/Tel_Aviv');
INSERT INTO `sys_timezone` VALUES ('294', 'Asia/Thimbu');
INSERT INTO `sys_timezone` VALUES ('295', 'Asia/Thimphu');
INSERT INTO `sys_timezone` VALUES ('296', 'Asia/Tokyo');
INSERT INTO `sys_timezone` VALUES ('297', 'Asia/Ujung_Pandang');
INSERT INTO `sys_timezone` VALUES ('298', 'Asia/Ulaanbaatar');
INSERT INTO `sys_timezone` VALUES ('299', 'Asia/Ulan_Bator');
INSERT INTO `sys_timezone` VALUES ('300', 'Asia/Urumqi');
INSERT INTO `sys_timezone` VALUES ('301', 'Asia/Vientiane');
INSERT INTO `sys_timezone` VALUES ('302', 'Asia/Vladivostok');
INSERT INTO `sys_timezone` VALUES ('303', 'Asia/Yakutsk');
INSERT INTO `sys_timezone` VALUES ('304', 'Asia/Yekaterinburg');
INSERT INTO `sys_timezone` VALUES ('305', 'Asia/Yerevan');
INSERT INTO `sys_timezone` VALUES ('306', 'Atlantic/Azores');
INSERT INTO `sys_timezone` VALUES ('307', 'Atlantic/Bermuda');
INSERT INTO `sys_timezone` VALUES ('308', 'Atlantic/Canary');
INSERT INTO `sys_timezone` VALUES ('309', 'Atlantic/Cape_Verde');
INSERT INTO `sys_timezone` VALUES ('310', 'Atlantic/Faeroe');
INSERT INTO `sys_timezone` VALUES ('311', 'Atlantic/Faroe');
INSERT INTO `sys_timezone` VALUES ('312', 'Atlantic/Jan_Mayen');
INSERT INTO `sys_timezone` VALUES ('313', 'Atlantic/Madeira');
INSERT INTO `sys_timezone` VALUES ('314', 'Atlantic/Reykjavik');
INSERT INTO `sys_timezone` VALUES ('315', 'Atlantic/South_Georgia');
INSERT INTO `sys_timezone` VALUES ('316', 'Atlantic/St_Helena');
INSERT INTO `sys_timezone` VALUES ('317', 'Atlantic/Stanley');
INSERT INTO `sys_timezone` VALUES ('318', 'Australia/ACT');
INSERT INTO `sys_timezone` VALUES ('319', 'Australia/Adelaide');
INSERT INTO `sys_timezone` VALUES ('320', 'Australia/Brisbane');
INSERT INTO `sys_timezone` VALUES ('321', 'Australia/Broken_Hill');
INSERT INTO `sys_timezone` VALUES ('322', 'Australia/Canberra');
INSERT INTO `sys_timezone` VALUES ('323', 'Australia/Currie');
INSERT INTO `sys_timezone` VALUES ('324', 'Australia/Darwin');
INSERT INTO `sys_timezone` VALUES ('325', 'Australia/Eucla');
INSERT INTO `sys_timezone` VALUES ('326', 'Australia/Hobart');
INSERT INTO `sys_timezone` VALUES ('327', 'Australia/LHI');
INSERT INTO `sys_timezone` VALUES ('328', 'Australia/Lindeman');
INSERT INTO `sys_timezone` VALUES ('329', 'Australia/Lord_Howe');
INSERT INTO `sys_timezone` VALUES ('330', 'Australia/Melbourne');
INSERT INTO `sys_timezone` VALUES ('331', 'Australia/North');
INSERT INTO `sys_timezone` VALUES ('332', 'Australia/NSW');
INSERT INTO `sys_timezone` VALUES ('333', 'Australia/Perth');
INSERT INTO `sys_timezone` VALUES ('334', 'Australia/Queensland');
INSERT INTO `sys_timezone` VALUES ('335', 'Australia/South');
INSERT INTO `sys_timezone` VALUES ('336', 'Australia/Sydney');
INSERT INTO `sys_timezone` VALUES ('337', 'Australia/Tasmania');
INSERT INTO `sys_timezone` VALUES ('338', 'Australia/Victoria');
INSERT INTO `sys_timezone` VALUES ('339', 'Australia/West');
INSERT INTO `sys_timezone` VALUES ('340', 'Australia/Yancowinna');
INSERT INTO `sys_timezone` VALUES ('341', 'Europe/Amsterdam');
INSERT INTO `sys_timezone` VALUES ('342', 'Europe/Andorra');
INSERT INTO `sys_timezone` VALUES ('343', 'Europe/Athens');
INSERT INTO `sys_timezone` VALUES ('344', 'Europe/Belfast');
INSERT INTO `sys_timezone` VALUES ('345', 'Europe/Belgrade');
INSERT INTO `sys_timezone` VALUES ('346', 'Europe/Berlin');
INSERT INTO `sys_timezone` VALUES ('347', 'Europe/Bratislava');
INSERT INTO `sys_timezone` VALUES ('348', 'Europe/Brussels');
INSERT INTO `sys_timezone` VALUES ('349', 'Europe/Bucharest');
INSERT INTO `sys_timezone` VALUES ('350', 'Europe/Budapest');
INSERT INTO `sys_timezone` VALUES ('351', 'Europe/Chisinau');
INSERT INTO `sys_timezone` VALUES ('352', 'Europe/Copenhagen');
INSERT INTO `sys_timezone` VALUES ('353', 'Europe/Dublin');
INSERT INTO `sys_timezone` VALUES ('354', 'Europe/Gibraltar');
INSERT INTO `sys_timezone` VALUES ('355', 'Europe/Guernsey');
INSERT INTO `sys_timezone` VALUES ('356', 'Europe/Helsinki');
INSERT INTO `sys_timezone` VALUES ('357', 'Europe/Isle_of_Man');
INSERT INTO `sys_timezone` VALUES ('358', 'Europe/Istanbul');
INSERT INTO `sys_timezone` VALUES ('359', 'Europe/Jersey');
INSERT INTO `sys_timezone` VALUES ('360', 'Europe/Kaliningrad');
INSERT INTO `sys_timezone` VALUES ('361', 'Europe/Kiev');
INSERT INTO `sys_timezone` VALUES ('362', 'Europe/Lisbon');
INSERT INTO `sys_timezone` VALUES ('363', 'Europe/Ljubljana');
INSERT INTO `sys_timezone` VALUES ('364', 'Europe/London');
INSERT INTO `sys_timezone` VALUES ('365', 'Europe/Luxembourg');
INSERT INTO `sys_timezone` VALUES ('366', 'Europe/Madrid');
INSERT INTO `sys_timezone` VALUES ('367', 'Europe/Malta');
INSERT INTO `sys_timezone` VALUES ('368', 'Europe/Mariehamn');
INSERT INTO `sys_timezone` VALUES ('369', 'Europe/Minsk');
INSERT INTO `sys_timezone` VALUES ('370', 'Europe/Monaco');
INSERT INTO `sys_timezone` VALUES ('371', 'Europe/Moscow');
INSERT INTO `sys_timezone` VALUES ('372', 'Europe/Nicosia');
INSERT INTO `sys_timezone` VALUES ('373', 'Europe/Oslo');
INSERT INTO `sys_timezone` VALUES ('374', 'Europe/Paris');
INSERT INTO `sys_timezone` VALUES ('375', 'Europe/Podgorica');
INSERT INTO `sys_timezone` VALUES ('376', 'Europe/Prague');
INSERT INTO `sys_timezone` VALUES ('377', 'Europe/Riga');
INSERT INTO `sys_timezone` VALUES ('378', 'Europe/Rome');
INSERT INTO `sys_timezone` VALUES ('379', 'Europe/Samara');
INSERT INTO `sys_timezone` VALUES ('380', 'Europe/San_Marino');
INSERT INTO `sys_timezone` VALUES ('381', 'Europe/Sarajevo');
INSERT INTO `sys_timezone` VALUES ('382', 'Europe/Simferopol');
INSERT INTO `sys_timezone` VALUES ('383', 'Europe/Skopje');
INSERT INTO `sys_timezone` VALUES ('384', 'Europe/Sofia');
INSERT INTO `sys_timezone` VALUES ('385', 'Europe/Stockholm');
INSERT INTO `sys_timezone` VALUES ('386', 'Europe/Tallinn');
INSERT INTO `sys_timezone` VALUES ('387', 'Europe/Tirane');
INSERT INTO `sys_timezone` VALUES ('388', 'Europe/Tiraspol');
INSERT INTO `sys_timezone` VALUES ('389', 'Europe/Uzhgorod');
INSERT INTO `sys_timezone` VALUES ('390', 'Europe/Vaduz');
INSERT INTO `sys_timezone` VALUES ('391', 'Europe/Vatican');
INSERT INTO `sys_timezone` VALUES ('392', 'Europe/Vienna');
INSERT INTO `sys_timezone` VALUES ('393', 'Europe/Vilnius');
INSERT INTO `sys_timezone` VALUES ('394', 'Europe/Volgograd');
INSERT INTO `sys_timezone` VALUES ('395', 'Europe/Warsaw');
INSERT INTO `sys_timezone` VALUES ('396', 'Europe/Zagreb');
INSERT INTO `sys_timezone` VALUES ('397', 'Europe/Zaporozhye');
INSERT INTO `sys_timezone` VALUES ('398', 'Europe/Zurich');
INSERT INTO `sys_timezone` VALUES ('399', 'Indian/Antananarivo');
INSERT INTO `sys_timezone` VALUES ('400', 'Indian/Chagos');
INSERT INTO `sys_timezone` VALUES ('401', 'Indian/Christmas');
INSERT INTO `sys_timezone` VALUES ('402', 'Indian/Cocos');
INSERT INTO `sys_timezone` VALUES ('403', 'Indian/Comoro');
INSERT INTO `sys_timezone` VALUES ('404', 'Indian/Kerguelen');
INSERT INTO `sys_timezone` VALUES ('405', 'Indian/Mahe');
INSERT INTO `sys_timezone` VALUES ('406', 'Indian/Maldives');
INSERT INTO `sys_timezone` VALUES ('407', 'Indian/Mauritius');
INSERT INTO `sys_timezone` VALUES ('408', 'Indian/Mayotte');
INSERT INTO `sys_timezone` VALUES ('409', 'Indian/Reunion');
INSERT INTO `sys_timezone` VALUES ('410', 'Pacific/Apia');
INSERT INTO `sys_timezone` VALUES ('411', 'Pacific/Auckland');
INSERT INTO `sys_timezone` VALUES ('412', 'Pacific/Chatham');
INSERT INTO `sys_timezone` VALUES ('413', 'Pacific/Easter');
INSERT INTO `sys_timezone` VALUES ('414', 'Pacific/Efate');
INSERT INTO `sys_timezone` VALUES ('415', 'Pacific/Enderbury');
INSERT INTO `sys_timezone` VALUES ('416', 'Pacific/Fakaofo');
INSERT INTO `sys_timezone` VALUES ('417', 'Pacific/Fiji');
INSERT INTO `sys_timezone` VALUES ('418', 'Pacific/Funafuti');
INSERT INTO `sys_timezone` VALUES ('419', 'Pacific/Galapagos');
INSERT INTO `sys_timezone` VALUES ('420', 'Pacific/Gambier');
INSERT INTO `sys_timezone` VALUES ('421', 'Pacific/Guadalcanal');
INSERT INTO `sys_timezone` VALUES ('422', 'Pacific/Guam');
INSERT INTO `sys_timezone` VALUES ('423', 'Pacific/Honolulu');
INSERT INTO `sys_timezone` VALUES ('424', 'Pacific/Johnston');
INSERT INTO `sys_timezone` VALUES ('425', 'Pacific/Kiritimati');
INSERT INTO `sys_timezone` VALUES ('426', 'Pacific/Kosrae');
INSERT INTO `sys_timezone` VALUES ('427', 'Pacific/Kwajalein');
INSERT INTO `sys_timezone` VALUES ('428', 'Pacific/Majuro');
INSERT INTO `sys_timezone` VALUES ('429', 'Pacific/Marquesas');
INSERT INTO `sys_timezone` VALUES ('430', 'Pacific/Midway');
INSERT INTO `sys_timezone` VALUES ('431', 'Pacific/Nauru');
INSERT INTO `sys_timezone` VALUES ('432', 'Pacific/Niue');
INSERT INTO `sys_timezone` VALUES ('433', 'Pacific/Norfolk');
INSERT INTO `sys_timezone` VALUES ('434', 'Pacific/Noumea');
INSERT INTO `sys_timezone` VALUES ('435', 'Pacific/Pago_Pago');
INSERT INTO `sys_timezone` VALUES ('436', 'Pacific/Palau');
INSERT INTO `sys_timezone` VALUES ('437', 'Pacific/Pitcairn');
INSERT INTO `sys_timezone` VALUES ('438', 'Pacific/Ponape');
INSERT INTO `sys_timezone` VALUES ('439', 'Pacific/Port_Moresby');
INSERT INTO `sys_timezone` VALUES ('440', 'Pacific/Rarotonga');
INSERT INTO `sys_timezone` VALUES ('441', 'Pacific/Saipan');
INSERT INTO `sys_timezone` VALUES ('442', 'Pacific/Samoa');
INSERT INTO `sys_timezone` VALUES ('443', 'Pacific/Tahiti');
INSERT INTO `sys_timezone` VALUES ('444', 'Pacific/Tarawa');
INSERT INTO `sys_timezone` VALUES ('445', 'Pacific/Tongatapu');
INSERT INTO `sys_timezone` VALUES ('446', 'Pacific/Truk');
INSERT INTO `sys_timezone` VALUES ('447', 'Pacific/Wake');
INSERT INTO `sys_timezone` VALUES ('448', 'Pacific/Wallis');
INSERT INTO `sys_timezone` VALUES ('449', 'Pacific/Yap');
INSERT INTO `sys_timezone` VALUES ('450', 'Brazil/Acre');
INSERT INTO `sys_timezone` VALUES ('451', 'Brazil/DeNoronha');
INSERT INTO `sys_timezone` VALUES ('452', 'Brazil/East');
INSERT INTO `sys_timezone` VALUES ('453', 'Brazil/West');
INSERT INTO `sys_timezone` VALUES ('454', 'Canada/Atlantic');
INSERT INTO `sys_timezone` VALUES ('455', 'Canada/Central');
INSERT INTO `sys_timezone` VALUES ('456', 'Canada/East-Saskatchewan');
INSERT INTO `sys_timezone` VALUES ('457', 'Canada/Eastern');
INSERT INTO `sys_timezone` VALUES ('458', 'Canada/Mountain');
INSERT INTO `sys_timezone` VALUES ('459', 'Canada/Newfoundland');
INSERT INTO `sys_timezone` VALUES ('460', 'Canada/Pacific');
INSERT INTO `sys_timezone` VALUES ('461', 'Canada/Saskatchewan');
INSERT INTO `sys_timezone` VALUES ('462', 'Canada/Yukon');
INSERT INTO `sys_timezone` VALUES ('463', 'CET');
INSERT INTO `sys_timezone` VALUES ('464', 'Chile/Continental');
INSERT INTO `sys_timezone` VALUES ('465', 'Chile/EasterIsland');
INSERT INTO `sys_timezone` VALUES ('466', 'CST6CDT');
INSERT INTO `sys_timezone` VALUES ('467', 'Cuba');
INSERT INTO `sys_timezone` VALUES ('468', 'EET');
INSERT INTO `sys_timezone` VALUES ('469', 'Egypt');
INSERT INTO `sys_timezone` VALUES ('470', 'Eire');
INSERT INTO `sys_timezone` VALUES ('471', 'EST');
INSERT INTO `sys_timezone` VALUES ('472', 'EST5EDT');
INSERT INTO `sys_timezone` VALUES ('473', 'Etc/GMT');
INSERT INTO `sys_timezone` VALUES ('474', 'Etc/GMT+0');
INSERT INTO `sys_timezone` VALUES ('475', 'Etc/GMT+1');
INSERT INTO `sys_timezone` VALUES ('476', 'Etc/GMT+10');
INSERT INTO `sys_timezone` VALUES ('477', 'Etc/GMT+11');
INSERT INTO `sys_timezone` VALUES ('478', 'Etc/GMT+12');
INSERT INTO `sys_timezone` VALUES ('479', 'Etc/GMT+2');
INSERT INTO `sys_timezone` VALUES ('480', 'Etc/GMT+3');
INSERT INTO `sys_timezone` VALUES ('481', 'Etc/GMT+4');
INSERT INTO `sys_timezone` VALUES ('482', 'Etc/GMT+5');
INSERT INTO `sys_timezone` VALUES ('483', 'Etc/GMT+6');
INSERT INTO `sys_timezone` VALUES ('484', 'Etc/GMT+7');
INSERT INTO `sys_timezone` VALUES ('485', 'Etc/GMT+8');
INSERT INTO `sys_timezone` VALUES ('486', 'Etc/GMT+9');
INSERT INTO `sys_timezone` VALUES ('487', 'Etc/GMT-0');
INSERT INTO `sys_timezone` VALUES ('488', 'Etc/GMT-1');
INSERT INTO `sys_timezone` VALUES ('489', 'Etc/GMT-10');
INSERT INTO `sys_timezone` VALUES ('490', 'Etc/GMT-11');
INSERT INTO `sys_timezone` VALUES ('491', 'Etc/GMT-12');
INSERT INTO `sys_timezone` VALUES ('492', 'Etc/GMT-13');
INSERT INTO `sys_timezone` VALUES ('493', 'Etc/GMT-14');
INSERT INTO `sys_timezone` VALUES ('494', 'Etc/GMT-2');
INSERT INTO `sys_timezone` VALUES ('495', 'Etc/GMT-3');
INSERT INTO `sys_timezone` VALUES ('496', 'Etc/GMT-4');
INSERT INTO `sys_timezone` VALUES ('497', 'Etc/GMT-5');
INSERT INTO `sys_timezone` VALUES ('498', 'Etc/GMT-6');
INSERT INTO `sys_timezone` VALUES ('499', 'Etc/GMT-7');
INSERT INTO `sys_timezone` VALUES ('500', 'Etc/GMT-8');
INSERT INTO `sys_timezone` VALUES ('501', 'Etc/GMT-9');
INSERT INTO `sys_timezone` VALUES ('502', 'Etc/GMT0');
INSERT INTO `sys_timezone` VALUES ('503', 'Etc/Greenwich');
INSERT INTO `sys_timezone` VALUES ('504', 'Etc/UCT');
INSERT INTO `sys_timezone` VALUES ('505', 'Etc/Universal');
INSERT INTO `sys_timezone` VALUES ('506', 'Etc/UTC');
INSERT INTO `sys_timezone` VALUES ('507', 'Etc/Zulu');
INSERT INTO `sys_timezone` VALUES ('508', 'Factory');
INSERT INTO `sys_timezone` VALUES ('509', 'GB');
INSERT INTO `sys_timezone` VALUES ('510', 'GB-Eire');
INSERT INTO `sys_timezone` VALUES ('511', 'GMT');
INSERT INTO `sys_timezone` VALUES ('513', 'GMT-0');
INSERT INTO `sys_timezone` VALUES ('514', 'GMT0');
INSERT INTO `sys_timezone` VALUES ('515', 'Greenwich');
INSERT INTO `sys_timezone` VALUES ('516', 'Hongkong');
INSERT INTO `sys_timezone` VALUES ('517', 'HST');
INSERT INTO `sys_timezone` VALUES ('518', 'Iceland');
INSERT INTO `sys_timezone` VALUES ('519', 'Iran');
INSERT INTO `sys_timezone` VALUES ('520', 'Israel');
INSERT INTO `sys_timezone` VALUES ('521', 'Jamaica');
INSERT INTO `sys_timezone` VALUES ('522', 'Japan');
INSERT INTO `sys_timezone` VALUES ('523', 'Kwajalein');
INSERT INTO `sys_timezone` VALUES ('524', 'Libya');
INSERT INTO `sys_timezone` VALUES ('525', 'MET');
INSERT INTO `sys_timezone` VALUES ('526', 'Mexico/BajaNorte');
INSERT INTO `sys_timezone` VALUES ('527', 'Mexico/BajaSur');
INSERT INTO `sys_timezone` VALUES ('528', 'Mexico/General');
INSERT INTO `sys_timezone` VALUES ('529', 'MST');
INSERT INTO `sys_timezone` VALUES ('530', 'MST7MDT');
INSERT INTO `sys_timezone` VALUES ('531', 'Navajo');
INSERT INTO `sys_timezone` VALUES ('532', 'NZ');
INSERT INTO `sys_timezone` VALUES ('533', 'NZ-CHAT');
INSERT INTO `sys_timezone` VALUES ('534', 'Poland');
INSERT INTO `sys_timezone` VALUES ('535', 'Portugal');
INSERT INTO `sys_timezone` VALUES ('536', 'PRC');
INSERT INTO `sys_timezone` VALUES ('537', 'PST8PDT');
INSERT INTO `sys_timezone` VALUES ('538', 'ROC');
INSERT INTO `sys_timezone` VALUES ('539', 'ROK');
INSERT INTO `sys_timezone` VALUES ('540', 'Singapore');
INSERT INTO `sys_timezone` VALUES ('542', 'UCT');
INSERT INTO `sys_timezone` VALUES ('543', 'Universal');
INSERT INTO `sys_timezone` VALUES ('544', 'US/Alaska');
INSERT INTO `sys_timezone` VALUES ('545', 'US/Aleutian');
INSERT INTO `sys_timezone` VALUES ('546', 'US/Arizona');
INSERT INTO `sys_timezone` VALUES ('547', 'US/Central');
INSERT INTO `sys_timezone` VALUES ('548', 'US/East-Indiana');
INSERT INTO `sys_timezone` VALUES ('549', 'US/Eastern');
INSERT INTO `sys_timezone` VALUES ('550', 'US/Hawaii');
INSERT INTO `sys_timezone` VALUES ('551', 'US/Indiana-Starke');
INSERT INTO `sys_timezone` VALUES ('552', 'US/Michigan');
INSERT INTO `sys_timezone` VALUES ('553', 'US/Mountain');
INSERT INTO `sys_timezone` VALUES ('554', 'US/Pacific');
INSERT INTO `sys_timezone` VALUES ('555', 'US/Pacific-New');
INSERT INTO `sys_timezone` VALUES ('556', 'US/Samoa');
INSERT INTO `sys_timezone` VALUES ('557', 'UTC');
INSERT INTO `sys_timezone` VALUES ('558', 'W-SU');
INSERT INTO `sys_timezone` VALUES ('559', 'WET');
INSERT INTO `sys_timezone` VALUES ('560', 'Zulu');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `Code` varchar(20) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `Description` varchar(150) DEFAULT NULL,
  `PWD` varchar(100) NOT NULL DEFAULT '',
  `PWDExpiry` datetime NOT NULL,
  `COperator` varchar(10) DEFAULT NULL,
  `CDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `RoleID` varchar(20) NOT NULL,
  `RoleIDOthers` text NOT NULL,
  `LastVisitTime` datetime DEFAULT NULL,
  `DeptID` varchar(20) NOT NULL,
  `DeptIDOthers` text NOT NULL,
  `NotLogin` char(1) NOT NULL DEFAULT 'N',
  `NotViewUser` char(1) NOT NULL DEFAULT 'N',
  `Theme` int(5) DEFAULT '1',
  `MenuImage` int(5) DEFAULT '0',
  `Shortcut` text,
  `MenuExpand` varchar(20) DEFAULT NULL,
  `CurrStatus` varchar(1) DEFAULT '1',
  `SessionNo` int(11) DEFAULT '0',
  `SessionDate` datetime DEFAULT NULL,
  `IpLimit` varchar(1) NOT NULL DEFAULT 'N' COMMENT 'IP 地址受限',
  `IpAddress` varchar(256) NOT NULL DEFAULT '' COMMENT '受限IP地址列表',
  `AutoDept` varchar(1) NOT NULL DEFAULT 'N' COMMENT '自动更换部门',
  PRIMARY KEY (`Code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES ('admin', 'Adminstrator', 'Adminstrator', 'f5ff84774c6eb980615bcb1e8c03cd5b', '2014-06-03 15:03:37', 'admin', '2014-12-21 02:29:44', '2', '', '2014-12-21 02:29:43', '', '', 'N', 'N', '1', '0', '[14001][14003]', '001', '1', '2', '2011-12-09 17:11:39', 'N', '', 'N');

-- ----------------------------
-- Table structure for sys_user_online
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_online`;
CREATE TABLE `sys_user_online` (
  `UCode` varchar(20) NOT NULL DEFAULT '',
  `LoginTime` int(11) DEFAULT NULL,
  `SID` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`UCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_user_online
-- ----------------------------

-- ----------------------------
-- Table structure for sys_user_session
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_session`;
CREATE TABLE `sys_user_session` (
  `Code` varchar(20) NOT NULL,
  `SessionNo` int(11) NOT NULL,
  `Transactions` int(10) NOT NULL,
  `SessionDate` datetime NOT NULL,
  `SessionContent` text,
  PRIMARY KEY (`Code`,`SessionNo`),
  CONSTRAINT `sys_user_session_ibfk_1` FOREIGN KEY (`Code`) REFERENCES `sys_user` (`Code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_user_session
-- ----------------------------

-- ----------------------------
-- Table structure for sys_version
-- ----------------------------
DROP TABLE IF EXISTS `sys_version`;
CREATE TABLE `sys_version` (
  `ID` varchar(20) NOT NULL COMMENT '版本标识：如1.1.1.140226',
  `UpgradeTime` datetime NOT NULL COMMENT '更新时间',
  `Notes` text COMMENT '备注：输入变动内容及相关SQL语句，与数据库文档保持一致',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_version
-- ----------------------------
INSERT INTO `sys_version` VALUES ('1.0.0.140304', '2014-03-04 13:38:32', '最初标准版本');
INSERT INTO `sys_version` VALUES ('1.0.1.140611', '2014-06-11 09:31:51', 'ALTER TABLE `sms_sending`\r\nADD COLUMN `TryTimes`  smallint(2) NOT NULL DEFAULT 0 AFTER `Status`;');
INSERT INTO `sys_version` VALUES ('1.0.2.141111', '2014-11-11 06:15:13', 'ALTER TABLE `sms_processed`\r\nADD COLUMN `PResultContent`  varchar(255) NOT NULL AFTER `PResult`;\r\n\r\nINSERT INTO `sys_dictionary` VALUES (\'RES_MSG\', \'\', \'010\', \'Name:[NAME],Meter:[MTNM],Balance : [BALANCE], Details : [DETAILS].\', 0, NULL, NULL, NULL, NULL, NULL, 0);\r\nINSERT INTO `sys_dictionary` VALUES (\'RES_MSG\', \'\', \'011\', \'Time:[TIME],Name:[NAME],Meter: [MTNM],Total:[CASH],StampTax:[STAMP],Commission:[COMM]\', 0, NULL, NULL, NULL, NULL, NULL, 0);\r\nINSERT INTO `sys_dictionary` VALUES (\'RES_MSG\', \'\', \'012\', \'Time:[TIME],Name:[NAME],Meter: [MTNM],Total:[CASH],StampTax:[STAMP],Commission:[COMM].(Reissue)\', 0, NULL, NULL, NULL, NULL, NULL, 0);\r\n');
INSERT INTO `sys_version` VALUES ('1.0.3.141115', '2014-11-15 18:21:35', 'DROP TABLE IF EXISTS `sms_number_policy`;\r\nCREATE TABLE `sms_number_policy` (\r\n  `Num` varchar(20) NOT NULL,\r\n  `RPolicy` smallint(2) NOT NULL DEFAULT \'0\',\r\n  `SPolicy` smallint(2) NOT NULL DEFAULT \'0\',\r\n  `Actived` varchar(1) NOT NULL DEFAULT \'N\',\r\n  PRIMARY KEY (`Num`)\r\n) ENGINE=InnoDB DEFAULT CHARSET=utf8;\r\n\r\nINSERT INTO `sys_dictionary` VALUES (\'RES_MSG\', \'\', \'013\', \'Dear customer, the amount you sent is invalid. Err. Code : 013\', 0, NULL, NULL, NULL, NULL, NULL, 0);\r\n');
INSERT INTO `sys_version` VALUES ('1.0.4.141206', '2014-12-07 01:54:10', 'INSERT INTO `sys_dictionary` VALUES (\'RES_MSG\', \'\', \'014\', \'Dear customer, your balance is [AMT], please keep your account available.\', 0, NULL, NULL, NULL, NULL, NULL, 0);\r\n');
INSERT INTO `sys_version` VALUES ('1.0.5.141208', '2014-12-08 20:30:56', 'INSERT INTO `sys_dictionary` VALUES (\'TABLES\', \'\', \'006\', \'Send SMS Example\', 0, \'SMSEXAMPLE\', \'FIELD\', \'maxLevel:1|opType:111|visible:Y\', NULL, \'tbSMSExample\', 0);\r\nINSERT INTO `sys_lang_package` VALUES (\'SMARTvend_lang\', \'SMS_SMSExample\', \'SMS Example\', \'短信例子\', \'SMS Example\', NULL, NULL, NULL, NULL, NULL, NULL, NULL);\r\nINSERT INTO `sys_lang_package` VALUES (\'SMARTvend_lang\', \'tbSMSExample\', \'SMS Example\', \'短信例子\', \'SMS Example\', NULL, NULL, NULL, NULL, NULL, NULL, NULL);\r\n');
INSERT INTO `sys_version` VALUES ('1.0.6.141222', '2014-12-22 16:01:38', 'INSERT INTO `sys_lang_package` VALUES (\'SMARTvend_lang\', \'BRC_Num\', \'(Num1;Num2)\', \'(号码1;号码2)\', \'(Numéro 1;Numéro 2)\', NULL, NULL, NULL, NULL, NULL, NULL, NULL);\r\n');

-- ----------------------------
-- Table structure for sys_zone
-- ----------------------------
DROP TABLE IF EXISTS `sys_zone`;
CREATE TABLE `sys_zone` (
  `id_zone` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `active` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `enabled` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_zone`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_zone
-- ----------------------------
INSERT INTO `sys_zone` VALUES ('1', 'Europe', '1', '1');
INSERT INTO `sys_zone` VALUES ('2', 'US', '1', '1');
INSERT INTO `sys_zone` VALUES ('3', 'Asia', '1', '1');
INSERT INTO `sys_zone` VALUES ('4', 'Africa', '1', '1');
INSERT INTO `sys_zone` VALUES ('5', 'Oceania', '1', '1');

-- ----------------------------
-- Table structure for tp_branch
-- ----------------------------
DROP TABLE IF EXISTS `tp_branch`;
CREATE TABLE `tp_branch` (
  `Code` varchar(5) NOT NULL COMMENT '分支机构编号',
  `DeptCode` varchar(20) NOT NULL COMMENT '上级分支机构编号',
  `Name` varchar(100) NOT NULL COMMENT '分支机构名称',
  `RegDate` date NOT NULL COMMENT '注册时间',
  `BranchType` varchar(2) NOT NULL COMMENT '分支机构类型：Owner, Agent',
  `Address` varchar(100) DEFAULT NULL COMMENT '地址',
  `Contact` varchar(50) DEFAULT NULL COMMENT '联系人',
  `Mobile` varchar(50) DEFAULT NULL COMMENT '联系手机',
  `Phone` varchar(50) DEFAULT NULL COMMENT '联系电话',
  `Fax` varchar(50) DEFAULT NULL COMMENT '传真',
  `Deposit` decimal(12,2) DEFAULT '0.00' COMMENT '保证金',
  `SellPower` varchar(1) NOT NULL COMMENT '是否允许售电',
  `AuthNum` int(11) DEFAULT '0' COMMENT '许可次数',
  `AuthDate` date DEFAULT NULL COMMENT '许可日期',
  `AuthContent` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '许可内容',
  `AccSellPower` varchar(1) NOT NULL DEFAULT 'N' COMMENT '开通账户购电功能',
  `AccBalance` decimal(12,4) NOT NULL DEFAULT '0.0000' COMMENT '账户余额',
  `AccNum` int(11) NOT NULL DEFAULT '0' COMMENT '账户余额顺序号',
  `CommPayer` varchar(1) NOT NULL DEFAULT 'O' COMMENT '拥金支付方式:C为客户支付,O为电力公司支付',
  `CommDetails` varchar(255) NOT NULL DEFAULT '' COMMENT '拥金计算阶梯内容:Value,Type(% or Fixed),Comm',
  `Actived` varchar(1) NOT NULL DEFAULT 'N' COMMENT '是否已使用',
  `KWH` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '累计售电电量:每次售电进行累加',
  `AMT` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '累计售电金额:每次售电进行累加',
  `CommAMT` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '累计的佣金金额',
  `Cancelled` varchar(1) NOT NULL DEFAULT 'N' COMMENT '是否已注销：Y或N',
  `COperator` varchar(20) DEFAULT NULL COMMENT '建立人员',
  `CDate` date DEFAULT NULL COMMENT '建立时间',
  PRIMARY KEY (`Code`),
  KEY `ix_code` (`Code`) USING BTREE,
  KEY `ix_parentCode` (`DeptCode`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='行政分支机构定义（网点）';

-- ----------------------------
-- Records of tp_branch
-- ----------------------------

-- ----------------------------
-- Table structure for tp_branch_account
-- ----------------------------
DROP TABLE IF EXISTS `tp_branch_account`;
CREATE TABLE `tp_branch_account` (
  `Code` varchar(20) NOT NULL COMMENT '售电点的编号',
  `ItemNo` int(11) NOT NULL COMMENT '记录业务编号',
  `BzDate` date NOT NULL COMMENT '业务日期 ',
  `RefType` varchar(5) NOT NULL COMMENT '关系类型：001为充值，002为购电支出',
  `RefCode` varchar(50) NOT NULL COMMENT '关系类型的编号',
  `IO` varchar(1) NOT NULL COMMENT '类型：I为充值,O为支出',
  `AMT` decimal(12,2) NOT NULL COMMENT '变动金额',
  `Invoice` varchar(20) NOT NULL COMMENT '票据号码',
  `Remarks` text,
  `Deleted` varchar(1) NOT NULL DEFAULT 'N' COMMENT '是否已删除',
  `Reverser` varchar(20) DEFAULT NULL COMMENT '取消人',
  `ReverseDate` date DEFAULT NULL COMMENT '取消日期',
  `ReverseReason` text,
  `COperator` varchar(20) DEFAULT NULL COMMENT '操作员',
  `CDate` datetime DEFAULT NULL COMMENT '操作日期',
  PRIMARY KEY (`Code`,`ItemNo`,`BzDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tp_branch_account
-- ----------------------------

-- ----------------------------
-- Table structure for tp_branch_auth
-- ----------------------------
DROP TABLE IF EXISTS `tp_branch_auth`;
CREATE TABLE `tp_branch_auth` (
  `Code` varchar(30) NOT NULL,
  `BranchCode` varchar(20) NOT NULL COMMENT '代理编号',
  `AuthNum` int(11) NOT NULL COMMENT '许可序号',
  `Description` varchar(100) NOT NULL COMMENT '描述信息',
  `ApplyDate` date NOT NULL COMMENT '申请时间',
  `ApplyCode` text NOT NULL COMMENT '授权申请码',
  `ApplyProposer` varchar(50) DEFAULT NULL,
  `AuthOperator` varchar(20) DEFAULT NULL,
  `AuthDate` date DEFAULT NULL,
  `AuthFrom` date DEFAULT NULL COMMENT '许可日期',
  `AuthDays` int(11) DEFAULT NULL COMMENT '许可天数',
  `AuthCredit` decimal(12,2) DEFAULT NULL COMMENT '授权的信用额度',
  `AuthTokenType` varchar(1) DEFAULT NULL,
  `AuthMaxToken` decimal(12,2) DEFAULT NULL COMMENT '最大售电金额',
  `AuthMinToken` decimal(12,2) DEFAULT NULL COMMENT '最小售电金额',
  `AuthContent` varchar(50) DEFAULT '' COMMENT '许可内容',
  `Remarks` text,
  `COperator` varchar(20) DEFAULT NULL COMMENT '建立人员',
  `CDate` datetime DEFAULT NULL COMMENT '建立时间',
  PRIMARY KEY (`Code`),
  KEY `ix_branch_authnum` (`BranchCode`,`AuthNum`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='代理许可授权表';

-- ----------------------------
-- Records of tp_branch_auth
-- ----------------------------

-- ----------------------------
-- Table structure for tp_branch_cancel
-- ----------------------------
DROP TABLE IF EXISTS `tp_branch_cancel`;
CREATE TABLE `tp_branch_cancel` (
  `Code` varchar(15) NOT NULL COMMENT '取消代理编号',
  `ExecDate` date NOT NULL COMMENT '取消日期',
  `ReasonCode` varchar(5) NOT NULL COMMENT '取消原因',
  `AccBalance` decimal(12,2) NOT NULL,
  `DepositAMT` decimal(12,2) NOT NULL COMMENT '退还押金',
  `AMT` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '返还总金额',
  `PayMode` varchar(5) NOT NULL COMMENT '支付方式',
  `BankCode` varchar(5) DEFAULT NULL COMMENT '支付银行',
  `Agency` varchar(30) DEFAULT NULL COMMENT '代理处, 行销处, 代理, 中介',
  `ChequeNo` varchar(30) DEFAULT NULL COMMENT '支付号码',
  `Remarks` text NOT NULL COMMENT '备注',
  `COperator` varchar(10) NOT NULL COMMENT '提交用户',
  `CDate` datetime NOT NULL COMMENT '提交时间',
  PRIMARY KEY (`Code`),
  KEY `AK_Key_1` (`Code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='代理取消表';

-- ----------------------------
-- Records of tp_branch_cancel
-- ----------------------------

-- ----------------------------
-- Table structure for tp_branch_client
-- ----------------------------
DROP TABLE IF EXISTS `tp_branch_client`;
CREATE TABLE `tp_branch_client` (
  `Code` varchar(20) NOT NULL COMMENT 'the client code(IP address)',
  `BranchCode` varchar(5) NOT NULL COMMENT 'Branch Code',
  `Description` varchar(50) NOT NULL COMMENT 'Description for this client',
  `LastTime` datetime DEFAULT NULL COMMENT 'Last Login Time',
  `LastUser` varchar(20) DEFAULT NULL COMMENT 'Last Login User',
  `Remarks` text COMMENT 'Remark for this client',
  `Active` varchar(1) NOT NULL COMMENT '是否激活',
  `COperator` varchar(20) NOT NULL COMMENT 'Create User',
  `CDate` datetime NOT NULL COMMENT 'Creation Date',
  PRIMARY KEY (`Code`),
  KEY `ix_branchclient_code` (`BranchCode`,`Code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tp_branch_client
-- ----------------------------

-- ----------------------------
-- Table structure for tp_branch_trans
-- ----------------------------
DROP TABLE IF EXISTS `tp_branch_trans`;
CREATE TABLE `tp_branch_trans` (
  `BranchCode` varchar(10) NOT NULL,
  `TransID` varchar(30) NOT NULL,
  `TransTime` int(11) NOT NULL COMMENT '请求时间记数',
  `AMT` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT '金额',
  PRIMARY KEY (`BranchCode`,`TransID`),
  KEY `ix_tp_trans_time` (`TransTime`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tp_branch_trans
-- ----------------------------
