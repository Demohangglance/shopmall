/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 50737
 Source Host           : localhost:3306
 Source Schema         : bxm_mall

 Target Server Type    : MySQL
 Target Server Version : 50737
 File Encoding         : 65001

 Date: 26/10/2025 13:38:51
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for address
-- ----------------------------
DROP TABLE IF EXISTS `address`;
CREATE TABLE `address`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '收货人',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '收货地址',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系方式',
  `userid` int(11) NULL DEFAULT NULL COMMENT '创建人id',
  `isdefault` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '否' COMMENT '是否默认',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '公告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of address
-- ----------------------------
INSERT INTO `address` VALUES (1, '小李', '江苏省南京市浦口区旭日上城', '15098765321', 1, '否');
INSERT INTO `address` VALUES (2, '霜霜', '江苏省南京市秦淮区紫杨佳园', '15098765321', 1, '是');
INSERT INTO `address` VALUES (3, '汤姆', '江苏省南京市浦口区天润城', '15098765321', 2, '是');
INSERT INTO `address` VALUES (4, '小霜霜', '江苏省南京市浦口区旭日上城', '15098765321', 3, '否');
INSERT INTO `address` VALUES (5, '汤姆', '江苏省南京市秦淮区新街口', '15098765321', 3, '是');

-- ----------------------------
-- Table structure for carousel
-- ----------------------------
DROP TABLE IF EXISTS `carousel`;
CREATE TABLE `carousel`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '标题',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图片',
  `goodsid` int(11) NULL DEFAULT NULL COMMENT '商品ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '轮播图表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of carousel
-- ----------------------------
INSERT INTO `carousel` VALUES (1, '真维斯（JEANSWEST）外套女连帽开衫卫衣女装春秋冬季新款宽松休闲潮流韩版学生上衣服', 'http://localhost:9999/file/download/1757163266207_bg1.png', 9);
INSERT INTO `carousel` VALUES (2, '小米15Ultra 徕卡2亿超级长焦', 'http://localhost:9999/file/download/1757163220074_小米bg.png', 4);
INSERT INTO `carousel` VALUES (3, 'REDMI Turbo 4 Pro', 'http://localhost:9999/file/download/红米bg.png', 8);

-- ----------------------------
-- Table structure for cart
-- ----------------------------
DROP TABLE IF EXISTS `cart`;
CREATE TABLE `cart`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `goodsid` int(11) NULL DEFAULT NULL COMMENT '商品ID',
  `num` int(11) NULL DEFAULT NULL COMMENT '数量',
  `userid` int(11) NULL DEFAULT NULL COMMENT '用户ID',
  `shopid` int(11) NULL DEFAULT NULL COMMENT '店铺ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '购物车表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of cart
-- ----------------------------
INSERT INTO `cart` VALUES (23, 8, 1, 2, 4);
INSERT INTO `cart` VALUES (24, 8, 1, 1, 4);
INSERT INTO `cart` VALUES (25, 17, 1, 1, 5);
INSERT INTO `cart` VALUES (26, 10, 1, 1, 5);

-- ----------------------------
-- Table structure for collect
-- ----------------------------
DROP TABLE IF EXISTS `collect`;
CREATE TABLE `collect`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `userid` int(11) NULL DEFAULT NULL COMMENT '用户ID',
  `goodsid` int(11) NULL DEFAULT NULL COMMENT '商品ID',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '收藏表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of collect
-- ----------------------------
INSERT INTO `collect` VALUES (1, 1, 16, '2025-10-25 16:10:45');
INSERT INTO `collect` VALUES (2, 2, 8, '2025-10-25 23:36:06');

-- ----------------------------
-- Table structure for goods
-- ----------------------------
DROP TABLE IF EXISTS `goods`;
CREATE TABLE `goods`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '描述',
  `price` double(10, 2) NULL DEFAULT NULL COMMENT '价格',
  `unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '单位',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '商品图片',
  `nums` int(11) NULL DEFAULT NULL COMMENT '库存',
  `sales` int(11) NULL DEFAULT 0 COMMENT '销量',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '上架日期',
  `state` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '0' COMMENT '状态（0-上架 1-下架）',
  `typeid` int(11) NULL DEFAULT NULL COMMENT '分类id',
  `recommend` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '是' COMMENT '是否推荐',
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '商品编码',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '商品详情',
  `imgs` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '轮播图',
  `discount` double(10, 2) NULL DEFAULT 1.00 COMMENT '折扣',
  `shopid` int(11) NULL DEFAULT NULL COMMENT '店铺ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '商品表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of goods
-- ----------------------------
INSERT INTO `goods` VALUES (1, 'Apple/苹果 iPhone 16（A3288）256GB 白色 支持移动联通电信5G 双卡双待手机', 'Apple/苹果 iPhone 16（A3288）256GB 白色 支持移动联通电信5G 双卡双待手机', 5399.00, '件', 'http://localhost:9999/file/download/1756915198318_苹果2.png', 99, 0, '2025-08-31 15:23:35', '0', 1, '是', 'G-001', '<nav><p><br/></p></nav><main><section><p><picture><source><source><source><source><source><img src=\"https://www.apple.com.cn/iphone-16/images/overview/welcome/hero_endframe__dtznvlokjeeu_xlarge.png\" alt=\"\" width=\"100%\"/><img src=\"https://www.apple.com.cn/v/iphone-16/f/images/overview/media-card/chip__fq1lz7wdahme_xlarge.jpg\" alt=\"iPhone 16 的 A18 芯片\" style=\"font-size: 14px;\" width=\"100%\"/><img src=\"https://www.apple.com.cn/iphone-16/images/overview/media-card/highlights_camera_control_endframe__fkyhpzyubp2e_xlarge.jpg\" alt=\"iPhone 16 展示相机控制功能，画面中右手手指沿机身侧边滑动，调整相机设置。\" width=\"100%\" style=\"font-size: 14px;\"/><img src=\"https://www.apple.com.cn/iphone-16/images/overview/media-card/battery__b14ff4que1yq_xlarge.jpg\" alt=\"图形密集型游戏展示 iPhone 16 持久的电池续航。\" style=\"font-size: 14px;\" width=\"100%\"/><img src=\"https://www.apple.com.cn/v/iphone-16/f/images/overview/media-card/camera__ddblbuegsi4i_xlarge.jpg\" alt=\"螳螂的特写照片，展示超广角摄像头的拍摄效果。\" style=\"font-size: 14px;\" width=\"100%\"/><img src=\"https://www.apple.com.cn/v/iphone-16/f/images/overview/media-card/highlights_apple_intelligence_endframe__cb03eqws1r7m_xlarge.jpg\" alt=\"一只手拿着群青色 iPhone 16，展示全面屏、靠近屏幕顶部居中的灵动岛，以及圆角机身。\" style=\"font-size: 14px;\" width=\"100%\"/></picture></p></section><section><p><picture><source><source><source><source><source><img src=\"https://www.apple.com.cn/iphone-16/images/overview/product-viewer/iphone/all_colors__flhn5cmb1t26_xlarge.jpg\" alt=\"全部五款颜色的 iPhone 16，以背面视图展示黑色、白色、粉色、深青色和群青色外观，同时还有群青色 iPhone 16，展示正面视图。\"/></picture></p><p><picture><source><source><source><source><source><img src=\"https://www.apple.com.cn/iphone-16/images/overview/product-viewer/iphone/blue__cevjmd4i0xsi_xlarge.jpg\" alt=\"群青色 6.7 英寸 iPhone 16 Plus 和 6.1 英寸 iPhone 16\" width=\"100%\"/><img src=\"https://www.apple.com.cn/iphone-16/images/overview/product-viewer/iphone/black__db5x9xocv1me_xlarge.jpg\" alt=\"黑色 6.7 英寸 iPhone 16 Plus 和 6.1 英寸 iPhone 16\" width=\"100%\"/></picture></p></section><section><section><h3>A18 芯片，</h3><h4>第二代 3 纳米来袭。</h4><p><picture><source><source><source><source><img src=\"https://www.apple.com.cn/v/iphone-16/f/images/overview/chip/hero_chip_endframe__e48wzm1ey9ua_xlarge.jpg\" alt=\"\" width=\"100%\"/><picture><img src=\"https://www.apple.com.cn/v/iphone-16/f/images/overview/product-stories/camera-control/ANIM/camera_control_hero_endframe__ddlyskscfy6a_xlarge.jpg\" alt=\"一只手指在相机控制按钮上滑动，进行变焦调整。\" width=\"100%\"/></picture><picture><img src=\"https://www.apple.com.cn/v/iphone-16/f/images/overview/product-stories/camera-control/ANIM/camera_control_hero_startframe__b17mpjl7z3v6_xlarge.jpg\" alt=\"\"/></picture></picture></p></section><section><p><br/></p></section></section></main>', '[{\"name\":\"苹果4.jpg\",\"url\":\"http://localhost:9999/file/download/苹果4.jpg\"},{\"name\":\"苹果1.jpg\",\"url\":\"http://localhost:9999/file/download/苹果1.jpg\"},{\"name\":\"苹果2.jpg\",\"url\":\"http://localhost:9999/file/download/苹果2.jpg\"},{\"name\":\"苹果3.png\",\"url\":\"http://localhost:9999/file/download/苹果3.png\"},{\"name\":\"苹果2.png\",\"url\":\"http://localhost:9999/file/download/苹果2.png\"}]', 1.00, 4);
INSERT INTO `goods` VALUES (2, 'Apple/苹果 iPhone 16 Plus（A3288）256GB 白色 支持移动联通电信5G 双卡双待手机', 'Apple/苹果 iPhone 16（A3288）256GB 白色 支持移动联通电信5G 双卡双待手机', 5999.00, '件', 'http://localhost:9999/file/download/苹果.jpg', 99, 1, '2025-08-31 15:23:35', '0', 1, '是', 'G-002', '<nav><p><br/></p></nav><main><section><p><picture><source><source><source><source><source><img src=\"https://www.apple.com.cn/iphone-16/images/overview/welcome/hero_endframe__dtznvlokjeeu_xlarge.png\" alt=\"\" width=\"100%\"/><img src=\"https://www.apple.com.cn/v/iphone-16/f/images/overview/media-card/chip__fq1lz7wdahme_xlarge.jpg\" alt=\"iPhone 16 的 A18 芯片\" style=\"font-size: 14px;\" width=\"100%\"/><img src=\"https://www.apple.com.cn/iphone-16/images/overview/media-card/highlights_camera_control_endframe__fkyhpzyubp2e_xlarge.jpg\" alt=\"iPhone 16 展示相机控制功能，画面中右手手指沿机身侧边滑动，调整相机设置。\" width=\"100%\" style=\"font-size: 14px;\"/><img src=\"https://www.apple.com.cn/iphone-16/images/overview/media-card/battery__b14ff4que1yq_xlarge.jpg\" alt=\"图形密集型游戏展示 iPhone 16 持久的电池续航。\" style=\"font-size: 14px;\" width=\"100%\"/><img src=\"https://www.apple.com.cn/v/iphone-16/f/images/overview/media-card/camera__ddblbuegsi4i_xlarge.jpg\" alt=\"螳螂的特写照片，展示超广角摄像头的拍摄效果。\" style=\"font-size: 14px;\" width=\"100%\"/><img src=\"https://www.apple.com.cn/v/iphone-16/f/images/overview/media-card/highlights_apple_intelligence_endframe__cb03eqws1r7m_xlarge.jpg\" alt=\"一只手拿着群青色 iPhone 16，展示全面屏、靠近屏幕顶部居中的灵动岛，以及圆角机身。\" style=\"font-size: 14px;\" width=\"100%\"/></picture></p></section><section><p><picture><source><source><source><source><source><img src=\"https://www.apple.com.cn/iphone-16/images/overview/product-viewer/iphone/all_colors__flhn5cmb1t26_xlarge.jpg\" alt=\"全部五款颜色的 iPhone 16，以背面视图展示黑色、白色、粉色、深青色和群青色外观，同时还有群青色 iPhone 16，展示正面视图。\"/></picture></p><p><picture><source><source><source><source><source><img src=\"https://www.apple.com.cn/iphone-16/images/overview/product-viewer/iphone/blue__cevjmd4i0xsi_xlarge.jpg\" alt=\"群青色 6.7 英寸 iPhone 16 Plus 和 6.1 英寸 iPhone 16\" width=\"100%\"/><img src=\"https://www.apple.com.cn/iphone-16/images/overview/product-viewer/iphone/black__db5x9xocv1me_xlarge.jpg\" alt=\"黑色 6.7 英寸 iPhone 16 Plus 和 6.1 英寸 iPhone 16\" width=\"100%\"/></picture></p></section><section><section><h3>A18 芯片，</h3><h4>第二代 3 纳米来袭。</h4><p><picture><source><source><source><source><img src=\"https://www.apple.com.cn/v/iphone-16/f/images/overview/chip/hero_chip_endframe__e48wzm1ey9ua_xlarge.jpg\" alt=\"\" width=\"100%\"/><picture><img src=\"https://www.apple.com.cn/v/iphone-16/f/images/overview/product-stories/camera-control/ANIM/camera_control_hero_endframe__ddlyskscfy6a_xlarge.jpg\" alt=\"一只手指在相机控制按钮上滑动，进行变焦调整。\" width=\"100%\"/></picture><picture><img src=\"https://www.apple.com.cn/v/iphone-16/f/images/overview/product-stories/camera-control/ANIM/camera_control_hero_startframe__b17mpjl7z3v6_xlarge.jpg\" alt=\"\"/></picture></picture></p></section><section><p><br/></p></section></section></main>', '[{\"name\":\"苹果4.jpg\",\"url\":\"http://localhost:9999/file/download/苹果4.jpg\"},{\"name\":\"苹果1.jpg\",\"url\":\"http://localhost:9999/file/download/苹果1.jpg\"},{\"name\":\"苹果2.jpg\",\"url\":\"http://localhost:9999/file/download/苹果2.jpg\"},{\"name\":\"苹果3.png\",\"url\":\"http://localhost:9999/file/download/苹果3.png\"},{\"name\":\"苹果2.png\",\"url\":\"http://localhost:9999/file/download/苹果2.png\"}]', 1.00, 4);
INSERT INTO `goods` VALUES (3, 'Xiaomi Civi 5 Pro', 'Xiaomi Civi 5 Pro', 2999.00, '件', 'http://localhost:9999/file/download/Xiaomi Civi 5-1.png', 100, 0, '2025-08-31 15:23:35', '0', 1, '是', 'G-003', '<nav><p><img src=\"http://localhost:9999/file/download/1756914069450_image.png\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"http://localhost:9999/file/download/1756914084012_image.png\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"http://localhost:9999/file/download/1756914092667_image.png\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"http://localhost:9999/file/download/1756914106681_image.png\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"http://localhost:9999/file/download/1756914119707_image.png\" style=\"max-width:100%;\" contenteditable=\"false\"/></p></nav>', '[{\"name\":\"1756914134677_Xiaomi Civi 5-1.png\",\"url\":\"http://localhost:9999/file/download/1756914134677_Xiaomi Civi 5-1.png\"},{\"name\":\"Xiaomi Civi 5-2.png\",\"url\":\"http://localhost:9999/file/download/Xiaomi Civi 5-2.png\"},{\"name\":\"Xiaomi Civi 5-4.png\",\"url\":\"http://localhost:9999/file/download/Xiaomi Civi 5-4.png\"},{\"name\":\"Xiaomi Civi 5-3.png\",\"url\":\"http://localhost:9999/file/download/Xiaomi Civi 5-3.png\"},{\"name\":\"Xiaomi Civi 5-5.png\",\"url\":\"http://localhost:9999/file/download/Xiaomi Civi 5-5.png\"}]', 1.00, 4);
INSERT INTO `goods` VALUES (4, '小米15Ultra 徕卡2亿超级长焦', '小米15Ultra 徕卡2亿超级长焦', 6999.00, '件', 'http://localhost:9999/file/download/小米15ultra-1.png', 99, 1, '2025-08-31 15:23:35', '0', 1, '是', 'G-004', '<nav><p><img src=\"http://localhost:9999/file/download/1756913581708_image.png\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"http://localhost:9999/file/download/1756913604453_image.png\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"http://localhost:9999/file/download/1756913620443_image.png\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"http://localhost:9999/file/download/1756913645176_image.png\" style=\"max-width:100%;\" contenteditable=\"false\"/></p></nav>', '[{\"name\":\"小米15ultra-2.png\",\"url\":\"http://localhost:9999/file/download/小米15ultra-2.png\"},{\"name\":\"1756913548075_小米15ultra-1.png\",\"url\":\"http://localhost:9999/file/download/1756913548075_小米15ultra-1.png\"},{\"name\":\"小米15ultra-5.png\",\"url\":\"http://localhost:9999/file/download/小米15ultra-5.png\"},{\"name\":\"小米15ultra-4.png\",\"url\":\"http://localhost:9999/file/download/小米15ultra-4.png\"},{\"name\":\"小米15ultra-3.png\",\"url\":\"http://localhost:9999/file/download/小米15ultra-3.png\"}]', 1.00, 4);
INSERT INTO `goods` VALUES (5, '小米15Pro 徕卡光学Summilux高速镜头 骁龙8至尊版', '小米15Pro 徕卡光学Summilux高速镜头 骁龙8至尊版', 4999.00, '件', 'http://localhost:9999/file/download/小米15-1.png', 92, 4, '2025-08-31 15:23:35', '0', 1, '是', 'G-005', '<nav><p><img src=\"https://cdn.cnbj1.fds.api.mi-img.com/product-images/xiaomi-15-pro_199288/images/4.jpg\"/><br/></p><p><img src=\"http://localhost:9999/file/download/1756912617785_image.png\" style=\"max-width:100%;\" contenteditable=\"false\"/><br/></p><p><img src=\"http://localhost:9999/file/download/1756913315324_image.png\" style=\"max-width:100%;\" contenteditable=\"false\"/><img src=\"http://localhost:9999/file/download/1756913352838_image.png\" style=\"max-width:100%;\" contenteditable=\"false\"/><img src=\"http://localhost:9999/file/download/1756913385943_image.png\" style=\"max-width:100%;\" contenteditable=\"false\"/></p></nav>', '[{\"name\":\"1756912334145_小米15-1.png\",\"url\":\"http://localhost:9999/file/download/1756912334145_小米15-1.png\"},{\"name\":\"小米15-2.png\",\"url\":\"http://localhost:9999/file/download/小米15-2.png\"},{\"name\":\"小米15-4.png\",\"url\":\"http://localhost:9999/file/download/小米15-4.png\"},{\"name\":\"小米15-3.png\",\"url\":\"http://localhost:9999/file/download/小米15-3.png\"},{\"name\":\"小米15-5.png\",\"url\":\"http://localhost:9999/file/download/小米15-5.png\"}]', 1.00, 4);
INSERT INTO `goods` VALUES (6, 'Xiaomi 14 徕卡光学镜头 光影猎人900 徕卡75mm浮动长焦 骁龙8Gen3 ', 'Xiaomi 14 徕卡光学镜头 光影猎人900 徕卡75mm浮动长焦 骁龙8Gen3 ', 3499.00, '件', 'http://localhost:9999/file/download/1756911870006_小米14-1.png', 94, 6, '2025-08-31 15:23:35', '0', 1, '是', 'G-006', '<nav><p><img src=\"http://localhost:9999/file/download/1756913018867_image.png\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"http://localhost:9999/file/download/1756913042546_image.png\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"http://localhost:9999/file/download/1756913054903_image.png\" style=\"max-width:100%;\" contenteditable=\"false\"/><img src=\"http://localhost:9999/file/download/1756913066174_image.png\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"http://localhost:9999/file/download/1756913081420_image.png\" style=\"max-width:100%;\" contenteditable=\"false\"/><br/></p><p><img src=\"http://localhost:9999/file/download/1756913145225_image.png\" style=\"max-width:100%;\" contenteditable=\"false\"/></p></nav>', '[{\"name\":\"1756911875072_小米14-1.png\",\"url\":\"http://localhost:9999/file/download/1756911875072_小米14-1.png\"},{\"name\":\"小米14-3.png\",\"url\":\"http://localhost:9999/file/download/小米14-3.png\"},{\"name\":\"1756911875072_小米14-2.png\",\"url\":\"http://localhost:9999/file/download/1756911875072_小米14-2.png\"},{\"name\":\"小米14-5.png\",\"url\":\"http://localhost:9999/file/download/小米14-5.png\"},{\"name\":\"小米14-4.png\",\"url\":\"http://localhost:9999/file/download/小米14-4.png\"}]', 1.00, 4);
INSERT INTO `goods` VALUES (7, 'Redmi Note 13 Pro', 'Redmi Note 13 Pro', 1149.00, '件', 'http://localhost:9999/file/download/Redmi Note 13 Pro-1.png', 91, 8, '2025-08-31 15:23:35', '0', 1, '是', 'G-007', '<nav><p><img src=\"http://localhost:9999/file/download/1756914315530_image.png\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"http://localhost:9999/file/download/1756914327804_image.png\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"http://localhost:9999/file/download/1756914347246_image.png\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"http://localhost:9999/file/download/1756914362331_image.png\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"http://localhost:9999/file/download/1756914375517_image.png\" style=\"max-width:100%;\" contenteditable=\"false\"/></p></nav>', '[{\"name\":\"1756914294637_Redmi Note 13 Pro-1.png\",\"url\":\"http://localhost:9999/file/download/1756914294637_Redmi Note 13 Pro-1.png\"},{\"name\":\"Redmi Note 13 Pro-2.png\",\"url\":\"http://localhost:9999/file/download/Redmi Note 13 Pro-2.png\"},{\"name\":\"Redmi Note 13 Pro-3.png\",\"url\":\"http://localhost:9999/file/download/Redmi Note 13 Pro-3.png\"},{\"name\":\"Redmi Note 13 Pro-4.png\",\"url\":\"http://localhost:9999/file/download/Redmi Note 13 Pro-4.png\"},{\"name\":\"Redmi Note 13 Pro-5.png\",\"url\":\"http://localhost:9999/file/download/Redmi Note 13 Pro-5.png\"}]', 0.90, 4);
INSERT INTO `goods` VALUES (8, 'REDMI Turbo 4 Pro', 'REDMI Turbo 4 Pro', 2399.00, '件', 'http://localhost:9999/file/download/REDMI Note 15 Pro+-1.png', 93, 7, '2025-08-31 15:23:35', '0', 1, '是', 'G-008', '<nav><p><img src=\"http://localhost:9999/file/download/1757162766297_image.png\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"http://localhost:9999/file/download/1757162791178_image.png\" style=\"max-width:100%;\" contenteditable=\"false\"/><img src=\"http://localhost:9999/file/download/1757162815442_image.png\" style=\"max-width:100%;\" contenteditable=\"false\"/></p></nav>', '[{\"name\":\"1756914632355_REDMI Note 15 Pro+-1.png\",\"url\":\"http://localhost:9999/file/download/1756914632355_REDMI Note 15 Pro+-1.png\"},{\"name\":\"REDMI Note 15 Pro+-2.png\",\"url\":\"http://localhost:9999/file/download/REDMI Note 15 Pro+-2.png\"},{\"name\":\"REDMI Note 15 Pro+-3.png\",\"url\":\"http://localhost:9999/file/download/REDMI Note 15 Pro+-3.png\"},{\"name\":\"REDMI Note 15 Pro+-4.png\",\"url\":\"http://localhost:9999/file/download/REDMI Note 15 Pro+-4.png\"},{\"name\":\"REDMI Note 15 Pro+-5.png\",\"url\":\"http://localhost:9999/file/download/REDMI Note 15 Pro+-5.png\"}]', 1.00, 4);
INSERT INTO `goods` VALUES (9, '真维斯（JEANSWEST）外套女连帽开衫卫衣女装春秋冬季新款宽松休闲潮流韩版学生上衣服', '真维斯（JEANSWEST）外套女连帽开衫卫衣女装春秋冬季新款宽松休闲潮流韩版学生上衣服', 75.91, '件', 'http://localhost:9999/file/download/女装1-1.jpg_.avif', 100, 0, '2025-09-04 00:04:39', '0', 2, '是', 'G-009', '<p><img src=\"https://img30.360buyimg.com/popWareDetail/jfs/t1/100991/26/42508/52586/65406eceF94d8a2d6/a2646fc9416907a6.jpg.avif\"/><img src=\"http://localhost:9999/file/download/1756915445524_image.png\" contenteditable=\"false\" style=\"font-size: 14px; max-width: 100%;\"/></p><p><img src=\"https://img10.360buyimg.com/imgzone/jfs/t1/224459/28/16895/177086/662f5afaFe2158013/2b7cf9d18d60f8e3.jpg.avif\"/></p><p><img src=\"https://img30.360buyimg.com/popWareDetail/jfs/t1/235822/10/1248/83980/65406ecfF68af94bf/f5de290b8078117c.jpg.avif\"/><img src=\"http://localhost:9999/file/download/1756915458263_image.png\" style=\"max-width:100%;\" contenteditable=\"false\"/><br/><img src=\"http://localhost:9999/file/download/1756915430961_image.png\" contenteditable=\"false\" style=\"font-size: 14px; max-width: 100%;\"/></p><br/>', '[{\"name\":\"女装1-1.jpg\",\"url\":\"http://localhost:9999/file/download/女装1-1.jpg\"},{\"name\":\"女装1-5.jpg\",\"url\":\"http://localhost:9999/file/download/女装1-5.jpg\"},{\"name\":\"女装1-6.jpg\",\"url\":\"http://localhost:9999/file/download/女装1-6.jpg\"},{\"name\":\"女装1-3.jpg\",\"url\":\"http://localhost:9999/file/download/女装1-3.jpg\"},{\"name\":\"女装1-2.jpg\",\"url\":\"http://localhost:9999/file/download/女装1-2.jpg\"}]', 1.00, 5);
INSERT INTO `goods` VALUES (10, '黑色小香风外套女秋冬新款小个子法式气质圆领短款修身上衣', '黑色小香风外套女秋冬新款小个子法式气质圆领短款修身上衣', 276.90, '件', 'http://localhost:9999/file/download/女装2-1.jpg', 99, 1, '2025-09-06 20:58:19', '0', 2, '是', 'G-010', '<p><img src=\"https://img.alicdn.com/imgextra/i3/2200540022844/O1CN014pac6W1WsbOAEWoPv_!!2200540022844.gif\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><img src=\"https://img.alicdn.com/imgextra/i1/2200540022844/O1CN01fTMvCU1WsbO1H8sXs_!!2200540022844.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/><p><img src=\"https://img.alicdn.com/imgextra/i3/2200540022844/O1CN01YHJjSr1WsbO8E0k49_!!2200540022844.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"https://img.alicdn.com/imgextra/i4/2200540022844/O1CN01SmYE0O1WsbO8M1Sot_!!2200540022844.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/></p>', '[{\"name\":\"1757163495354_女装2-1.jpg\",\"url\":\"http://localhost:9999/file/download/1757163495354_女装2-1.jpg\"},{\"name\":\"女装2-2.jpg\",\"url\":\"http://localhost:9999/file/download/女装2-2.jpg\"},{\"name\":\"女装2-3.jpg\",\"url\":\"http://localhost:9999/file/download/女装2-3.jpg\"},{\"name\":\"女装2-4.jpg\",\"url\":\"http://localhost:9999/file/download/女装2-4.jpg\"},{\"name\":\"女装2-6.jpg\",\"url\":\"http://localhost:9999/file/download/女装2-6.jpg\"}]', 1.00, 5);
INSERT INTO `goods` VALUES (11, '秋冬季女装茶系穿搭新年过年衣服一整套森系搭配连衣裙', '秋冬季女装茶系穿搭新年过年衣服一整套森系搭配连衣裙', 99.00, '件', 'http://localhost:9999/file/download/1757164835904_女装3-1.jpg', 100, 0, '2025-09-06 21:20:44', '0', 2, '是', 'G-011', '<p><img src=\"http://localhost:9999/file/download/1757164781635_image.png\" style=\"max-width:100%;\" contenteditable=\"false\"/><br/><img src=\"http://localhost:9999/file/download/女装3-1.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"http://localhost:9999/file/download/女装3-5.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/></p>', '[{\"name\":\"1757164883088_女装3-1.jpg\",\"url\":\"http://localhost:9999/file/download/1757164883088_女装3-1.jpg\"},{\"name\":\"女装3-2.jpg\",\"url\":\"http://localhost:9999/file/download/女装3-2.jpg\"},{\"name\":\"女装3-4.jpg\",\"url\":\"http://localhost:9999/file/download/女装3-4.jpg\"},{\"name\":\"女装3-3.jpg\",\"url\":\"http://localhost:9999/file/download/女装3-3.jpg\"},{\"name\":\"1757164883107_女装3-5.jpg\",\"url\":\"http://localhost:9999/file/download/1757164883107_女装3-5.jpg\"}]', 1.00, 5);
INSERT INTO `goods` VALUES (12, 'Moromoro圣诞费尔岛手绣针织开衫女软糯半高领毛衣外套', 'Moromoro圣诞费尔岛手绣针织开衫女软糯半高领毛衣外套', 188.00, '件', 'http://localhost:9999/file/download/女装4-1.jpg', 99, 1, '2025-09-06 21:25:37', '0', 2, '是', 'G-012', '<p><img src=\"http://localhost:9999/file/download/1757165019205_image.png\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><br/></p><p><img src=\"http://localhost:9999/file/download/1757165029250_image.png\" contenteditable=\"false\" style=\"font-size: 14px; max-width: 100%;\"/></p><img src=\"https://img.alicdn.com/imgextra/i4/2209825745321/O1CN01owOFNN1pB4UDXvJvU_!!2209825745321.jpg\"/><p><img src=\"https://img.alicdn.com/imgextra/i4/2209825745321/O1CN01bmeLRq1pB4UDkpIR5_!!2209825745321.jpg\"/><br/></p><p><img src=\"https://img.alicdn.com/imgextra/i4/2209825745321/O1CN01e7ZkyN1pB4UGpPvOA_!!2209825745321.jpg\"/><br/></p><p><img src=\"https://img.alicdn.com/imgextra/i4/2209825745321/O1CN01e7ZkyN1pB4UGpPvOA_!!2209825745321.jpg\"/><br/></p><p><img src=\"https://img.alicdn.com/imgextra/i1/2209825745321/O1CN01VgPYpT1pB4UFq7q38_!!2209825745321.jpg\"/><br/></p><p><img src=\"https://img.alicdn.com/imgextra/i1/2209825745321/O1CN01pOPBQn1pB4UHPyivT_!!2209825745321.jpg\"/><br/></p>', '[{\"name\":\"女装4-2.jpg\",\"url\":\"http://localhost:9999/file/download/女装4-2.jpg\"},{\"name\":\"1757165132642_女装4-1.jpg\",\"url\":\"http://localhost:9999/file/download/1757165132642_女装4-1.jpg\"},{\"name\":\"女装4-4.jpg\",\"url\":\"http://localhost:9999/file/download/女装4-4.jpg\"},{\"name\":\"女装4-3.jpg\",\"url\":\"http://localhost:9999/file/download/女装4-3.jpg\"},{\"name\":\"女装4-5.jpg\",\"url\":\"http://localhost:9999/file/download/女装4-5.jpg\"}]', 1.00, 5);
INSERT INTO `goods` VALUES (13, '藏蓝色连帽卫衣女2025新款爆款加绒厚秋冬上衣春秋季薄款早春外套', '藏蓝色连帽卫衣女2025新款爆款加绒厚秋冬上衣春秋季薄款早春外套', 89.90, '件', 'http://localhost:9999/file/download/女装5-1.jpg', 97, 3, '2025-09-07 22:11:51', '0', 2, '是', 'G-013', '<p><br/></p><p><br/></p><p><img src=\"http://localhost:9999/file/download/1757254133950_image.png\" contenteditable=\"false\" style=\"font-size: 14px; max-width: 100%;\"/></p>&nbsp;<img src=\"https://img.alicdn.com/imgextra/i1/2212041197236/O1CN01WM4gch23K8ueptjEb_!!2212041197236.jpg\" contenteditable=\"false\" style=\"max-width: 100%;\"/><p><img src=\"https://img.alicdn.com/imgextra/i3/2212041197236/O1CN01rDuuep23K8ucp1IuQ_!!2212041197236.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"https://img.alicdn.com/imgextra/i3/2212041197236/O1CN01MDcAYf23K8vrbPFdx_!!2212041197236.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"https://img.alicdn.com/imgextra/i2/2212041197236/O1CN01cXUGSL23K8ug1d7gQ_!!2212041197236.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"https://img.alicdn.com/imgextra/i2/2212041197236/O1CN014D9rqM23K8ue4oNtL_!!2212041197236.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/></p>', '[{\"name\":\"女装5-3.jpg\",\"url\":\"http://localhost:9999/file/download/女装5-3.jpg\"},{\"name\":\"女装5-4.jpg\",\"url\":\"http://localhost:9999/file/download/女装5-4.jpg\"},{\"name\":\"1757254306055_女装5-1.jpg\",\"url\":\"http://localhost:9999/file/download/1757254306055_女装5-1.jpg\"},{\"name\":\"女装5-5.jpg\",\"url\":\"http://localhost:9999/file/download/女装5-5.jpg\"},{\"name\":\"女装5-2.jpg\",\"url\":\"http://localhost:9999/file/download/女装5-2.jpg\"}]', 1.00, 5);
INSERT INTO `goods` VALUES (14, '真维斯藏青色连帽卫衣女款春秋冬2025新款宽松薄款外套开衫上衣', '真维斯藏青色连帽卫衣女款春秋冬2025新款宽松薄款外套开衫上衣', 67.90, '件', 'http://localhost:9999/file/download/女装6-1.jpg', 100, 0, '2025-09-07 22:15:45', '0', 2, '是', 'G-014', '<p><img src=\"https://img.alicdn.com/imgextra/i1/2216455906211/O1CN01s5aVxd1vkgx3wXfCD_!!2216455906211.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"https://img.alicdn.com/imgextra/i1/2216455906211/O1CN01LAza8c1vkgx4QHhyF_!!2216455906211.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"https://img.alicdn.com/imgextra/i1/2216455906211/O1CN01QcgauQ1vkgx6PVdMo_!!2216455906211.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"https://img.alicdn.com/imgextra/i4/2216455906211/O1CN017JeqHo1vkgx5BpKRg_!!2216455906211.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"https://img.alicdn.com/imgextra/i3/2216455906211/O1CN01fvTMMY1vkgx3p5v6f_!!2216455906211.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/></p>', '[{\"name\":\"1757254585764_女装6-1.jpg\",\"url\":\"http://localhost:9999/file/download/1757254585764_女装6-1.jpg\"},{\"name\":\"女装6-2.jpg\",\"url\":\"http://localhost:9999/file/download/女装6-2.jpg\"},{\"name\":\"女装6-3.jpg\",\"url\":\"http://localhost:9999/file/download/女装6-3.jpg\"},{\"name\":\"女装6-4.jpg\",\"url\":\"http://localhost:9999/file/download/女装6-4.jpg\"},{\"name\":\"女装6-5.jpg\",\"url\":\"http://localhost:9999/file/download/女装6-5.jpg\"}]', 1.00, 5);
INSERT INTO `goods` VALUES (15, '连帽卫衣女春秋新款2025冬季加绒加厚外套藏蓝色美式新款宽松上衣', '连帽卫衣女春秋新款2025冬季加绒加厚外套藏蓝色美式新款宽松上衣', 89.90, '件', 'http://localhost:9999/file/download/女装7-1.jpg', 99, 1, '2025-09-07 22:20:46', '0', 2, '是', 'G-015', '<p><img src=\"https://img.alicdn.com/imgextra/i2/2215903122239/O1CN01my6BJE1SPVqTbTDvW_!!2215903122239.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"https://img.alicdn.com/imgextra/i2/2215903122239/O1CN01GlLeyl1SPVney53hO_!!2215903122239.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"https://img.alicdn.com/imgextra/i1/2215903122239/O1CN01MtDdC21SPVngY3yDt_!!2215903122239.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"https://img.alicdn.com/imgextra/i2/2215903122239/O1CN01cn1SFT1SPVlzZaxhV_!!2215903122239.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"https://img.alicdn.com/imgextra/i4/2215903122239/O1CN019a9N5z1SPVn1QtO2P_!!2215903122239.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"https://img.alicdn.com/imgextra/i4/2215903122239/O1CN01m8fprv1SPVm0S6qd5_!!2215903122239.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/><br/></p><p><img src=\"https://img.alicdn.com/imgextra/i4/2215903122239/O1CN015AZ6Dc1SPVndo9JIU_!!2215903122239.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/></p>', '[{\"name\":\"1757254854428_女装7-1.jpg\",\"url\":\"http://localhost:9999/file/download/1757254854428_女装7-1.jpg\"},{\"name\":\"女装7-2.jpg\",\"url\":\"http://localhost:9999/file/download/女装7-2.jpg\"},{\"name\":\"女装7-3.jpg\",\"url\":\"http://localhost:9999/file/download/女装7-3.jpg\"},{\"name\":\"女装7-5.jpg\",\"url\":\"http://localhost:9999/file/download/女装7-5.jpg\"},{\"name\":\"女装7-4.jpg\",\"url\":\"http://localhost:9999/file/download/女装7-4.jpg\"}]', 1.00, 5);
INSERT INTO `goods` VALUES (16, 'ROSE同款拉链连帽卫衣女藏青色春秋冬季美式开衫外套上衣ins潮', 'ROSE同款拉链连帽卫衣女藏青色春秋冬季美式开衫外套上衣ins潮', 61.10, '件', 'http://localhost:9999/file/download/女装8-3.jpg', 98, 2, '2025-09-07 22:24:58', '0', 2, '是', 'G-016', '<p><img src=\"http://localhost:9999/file/download/1757255002450_image.png\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"https://img.alicdn.com/imgextra/i3/2214852760556/O1CN01TBr1Ld1Fyh4xJ7huV_!!2214852760556.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"https://img.alicdn.com/imgextra/i3/2214852760556/O1CN01dGNqLG1Fyh56VWITY_!!2214852760556.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/><br/><img src=\"https://img.alicdn.com/imgextra/i3/2214852760556/O1CN01zCZCPR1Fyh5IUAWAv_!!2214852760556.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"https://img.alicdn.com/imgextra/i3/2214852760556/O1CN01HIrj1j1Fyh6GbfVyp_!!2214852760556.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/></p>', '[{\"name\":\"女装8-1.jpg\",\"url\":\"http://localhost:9999/file/download/女装8-1.jpg\"},{\"name\":\"女装8-2.jpg\",\"url\":\"http://localhost:9999/file/download/女装8-2.jpg\"},{\"name\":\"1757255094322_女装8-3.jpg\",\"url\":\"http://localhost:9999/file/download/1757255094322_女装8-3.jpg\"},{\"name\":\"1757255094322_女装8-4.jpg\",\"url\":\"http://localhost:9999/file/download/1757255094322_女装8-4.jpg\"},{\"name\":\"女装8-5.jpg\",\"url\":\"http://localhost:9999/file/download/女装8-5.jpg\"}]', 1.00, 5);
INSERT INTO `goods` VALUES (17, 'King Prince美式复古皮毛一体外套女秋冬季羊羔毛双面穿机车服潮', 'King Prince美式复古皮毛一体外套女秋冬季羊羔毛双面穿机车服潮', 299.90, '件', 'http://localhost:9999/file/download/女装9-1.jpg', 92, 8, '2025-09-07 22:37:45', '0', 2, '是', 'G-017', '<p><img src=\"https://img.alicdn.com/imgextra/i1/2199858255/O1CN019dJrhg2AqqbvuCTPm_!!2199858255.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/><br/><img src=\"https://img.alicdn.com/imgextra/i4/2199858255/O1CN01CP98YY2Aqqbv097Ze_!!2199858255.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"https://img.alicdn.com/imgextra/i2/2199858255/O1CN01JyVAPA2AqqboBoauw_!!2199858255.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"https://img.alicdn.com/imgextra/i1/2199858255/O1CN0154S4BE2AqqbuwM517_!!2199858255.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/><img src=\"https://img.alicdn.com/imgextra/i1/2199858255/O1CN01UZGsyV2Aqqbv07uie_!!2199858255.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"https://img.alicdn.com/imgextra/i3/2199858255/O1CN01ygbo4s2AqqbuX2oGt_!!2199858255.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"https://img.alicdn.com/imgextra/i1/2199858255/O1CN016ZcFpF2Aqqbwfboa5_!!2199858255.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/></p><p><img src=\"https://img.alicdn.com/imgextra/i1/2199858255/O1CN01ZsUl3R2AqqblVkPZY_!!2199858255.jpg\" style=\"max-width:100%;\" contenteditable=\"false\"/></p>', '[{\"name\":\"1757255861692_女装9-1.jpg\",\"url\":\"http://localhost:9999/file/download/1757255861692_女装9-1.jpg\"},{\"name\":\"女装9-2.jpg\",\"url\":\"http://localhost:9999/file/download/女装9-2.jpg\"},{\"name\":\"女装9-3.jpg\",\"url\":\"http://localhost:9999/file/download/女装9-3.jpg\"},{\"name\":\"女装9-4.jpg\",\"url\":\"http://localhost:9999/file/download/女装9-4.jpg\"},{\"name\":\"女装9-5.jpg\",\"url\":\"http://localhost:9999/file/download/女装9-5.jpg\"}]', 0.80, 5);

-- ----------------------------
-- Table structure for notice
-- ----------------------------
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '内容',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '创建时间',
  `userid` int(11) NULL DEFAULT NULL COMMENT '创建人id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '公告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of notice
-- ----------------------------
INSERT INTO `notice` VALUES (1, '非常需要大家的一键三连（点赞 + 投币+ 收藏）！！！', '<h1><span style=\"background-color: rgb(249, 150, 59); font-weight: normal;\"><font color=\"#000000\">非常需要大家的一键三连（点赞 + 投币+ 收藏）！！！</font></span></h1>', '2023-12-02', 1);
INSERT INTO `notice` VALUES (2, '【周年庆典 感恩回馈】全场狂欢，福利派送中！', '<h3>一、 核心福利，惊喜直降</h3><ol><li><strong>全场折扣</strong>：活动期间，商城内百货、服饰、家居等全品类商品<strong>低至 5 折起</strong>，爆款好物直降到底，性价比拉满！</li><li><strong>满减叠加</strong>：单笔订单实付满 299 元减 50 元、满 599 元减 120 元、满 999 元减 200 元，折扣可与满减叠加使用，省钱更划算。</li><li><strong>限时秒杀</strong>：每日 10:00、15:00、20:00 开启三轮限时秒杀，10 元抢日用品、50 元抢小家电，数量有限，先到先得！</li></ol><h3>二、 专属礼遇，会员专享</h3><ul><li>活动期间新注册会员，立享<strong>10 元无门槛优惠券</strong>及 200 积分，积分可兑换超值礼品。</li><li>老会员尊享<strong>双倍积分</strong>，积分可直接抵扣现金（100 积分 = 1 元），更有会员专属折扣价商品。</li></ul><h3>三、 活动时间</h3><p>XXXX 年 XX 月 XX 日 00:00 — XXXX 年 XX 月 XX 日 23:59</p><h3>四、 温馨提示</h3><ol><li>优惠券及秒杀商品需在活动页面领取 / 抢购，具体使用规则可查看券面说明。</li><li>活动期间订单量较大，发货时效可能延迟 1-3 个工作日，敬请谅解。</li><li>如有疑问，可拨打客服热线：400-XXXX-XXX，或咨询商城在线客服。</li></ol><p>感恩相遇，狂欢不停！期待您的光临，把实惠与惊喜带回家～</p>', '2024-05-30 15:01:51', 1);

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单名称',
  `orderno` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '订单号',
  `num` int(11) NULL DEFAULT NULL COMMENT '购买数量',
  `total` double(10, 2) NULL DEFAULT NULL COMMENT '总价格',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '购买人',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '收货地址',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系电话',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '状态',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '下单时间',
  `userid` int(11) NULL DEFAULT NULL COMMENT '用户id',
  `goodsid` int(11) NULL DEFAULT NULL COMMENT '商品id',
  `ordertype` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付类型',
  `shopid` int(11) NULL DEFAULT NULL COMMENT '店铺ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '订单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (3, 'Redmi Note 13 Pro等1件商品', '20251025224359365', 1, 1034.10, '霜霜', '江苏省南京市秦淮区紫杨佳园', '15098765321', '待付款', '2025-10-25 22:43:59', 1, NULL, '支付宝', 4);
INSERT INTO `orders` VALUES (4, 'Moromoro圣诞费尔岛手绣针织开衫女软糯半高领毛衣外套等1件商品', '20251025224359178', 1, 188.00, '霜霜', '江苏省南京市秦淮区紫杨佳园', '15098765321', '待付款', '2025-10-25 22:43:59', 1, NULL, '支付宝', 5);
INSERT INTO `orders` VALUES (5, 'REDMI Turbo 4 Pro等1件商品', '20251025233502282', 1, 2399.00, '汤姆', '江苏省南京市浦口区天润城', '15098765321', '待付款', '2025-10-25 23:35:02', 2, NULL, '支付宝', 4);
INSERT INTO `orders` VALUES (6, '藏蓝色连帽卫衣女2025新款爆款加绒厚秋冬上衣春秋季薄款早春外套等1件商品', '20251025233502216', 1, 89.90, '汤姆', '江苏省南京市浦口区天润城', '15098765321', '待付款', '2025-10-25 23:35:02', 2, NULL, '支付宝', 5);
INSERT INTO `orders` VALUES (7, 'King Prince美式复古皮毛一体外套女秋冬季羊羔毛双面穿机车服潮', '20251026000502510', 1, 239.92, '霜霜', '江苏省南京市秦淮区紫杨佳园', '15098765321', '待发货', '2025-10-26 00:05:02', 1, 17, '支付宝', 5);
INSERT INTO `orders` VALUES (8, '黑色小香风外套女秋冬新款小个子法式气质圆领短款修身上衣', '20251026001014129', 1, 276.90, '霜霜', '江苏省南京市秦淮区紫杨佳园', '15098765321', '待付款', '2025-10-26 00:10:14', 1, 10, '支付宝', 5);

-- ----------------------------
-- Table structure for ordersitem
-- ----------------------------
DROP TABLE IF EXISTS `ordersitem`;
CREATE TABLE `ordersitem`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `goodsid` int(11) NULL DEFAULT NULL COMMENT '商品ID',
  `num` int(11) NULL DEFAULT NULL COMMENT '数量',
  `price` double(10, 2) NULL DEFAULT NULL COMMENT '价格',
  `userid` int(11) NULL DEFAULT NULL COMMENT '用户ID',
  `ordersid` int(11) NULL DEFAULT NULL COMMENT '订单ID',
  `comment` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '评价',
  `score` double(10, 2) NULL DEFAULT NULL COMMENT '评分',
  `commenttime` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '评价时间',
  `shopid` int(11) NULL DEFAULT NULL COMMENT '店铺ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订单商品关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ordersitem
-- ----------------------------
INSERT INTO `ordersitem` VALUES (3, 7, 1, 1034.10, 1, 3, NULL, NULL, NULL, 4);
INSERT INTO `ordersitem` VALUES (4, 12, 1, 188.00, 1, 4, NULL, NULL, NULL, 5);
INSERT INTO `ordersitem` VALUES (5, 8, 1, 2399.00, 2, 5, NULL, NULL, NULL, 4);
INSERT INTO `ordersitem` VALUES (6, 13, 1, 89.90, 2, 6, NULL, NULL, NULL, 5);
INSERT INTO `ordersitem` VALUES (7, 17, 1, 239.92, 1, 7, NULL, NULL, NULL, 5);
INSERT INTO `ordersitem` VALUES (8, 10, 1, 276.90, 1, 8, NULL, NULL, NULL, 5);

-- ----------------------------
-- Table structure for questions
-- ----------------------------
DROP TABLE IF EXISTS `questions`;
CREATE TABLE `questions`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '问题标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '问题内容',
  `userid` int(11) NULL DEFAULT NULL COMMENT '添加人',
  `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '添加时间',
  `goodsid` int(11) NULL DEFAULT NULL COMMENT '商品id',
  `shopid` int(11) NULL DEFAULT NULL COMMENT '店铺ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品问答表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of questions
-- ----------------------------
INSERT INTO `questions` VALUES (1, 'REDMI Turbo 4 Pro 的性能表现如何，在游戏方面有怎样的优势？', '它是全球首发第四代骁龙 8s 处理器，采用台积电 4nm 工艺与全大核架构（1Cortex - X4 + 5Cortex - A720 + 2Cortex - A520） ，搭配 Adreno 800 系 GPU，存储为 LPDDR5X + UFS 4.0。安兔兔跑分超 211 万，3DMark Wild Life Extreme 得分 4060，Geekbench6 单核 2062 分、多核 6332 分 ，性能和骁龙 8 Gen3 不相上下。 游戏上，运行《和平精英》开启 90 帧，24 分钟整局平均帧率 89.7 帧；《王者荣耀》高画质 120 帧，平均帧率达 120 帧；《原神》开启高画质 60 帧，半小时平均帧率 59.7 帧 。还支持原生级 AI 插帧与超分技术，在《原神》中可实现 1.5K 超分辨率 + 90 帧 + 插帧至 120 帧的畅玩体验。同时配备 6000mm² 双环路 3D 冰封散热系统，结合高性能双翼石墨与 AI 智能控温，整机散热能力高达 68.1mA/℃，有效控制核心温度，减少降频，玩游戏时机身最高温度仅 43.5 摄氏度 。', 1, '2025-09-07 22:37:45', 8, 4);
INSERT INTO `questions` VALUES (2, '这款手机的屏幕素质怎么样，对眼睛的保护效果如何？', 'REDMI Turbo 4 Pro 配备 6.83 英寸 OLED 直屏，分辨率 2772×1280，PPI 达 447，支持 120Hz 高刷 + 480Hz 触控采样率，触控瞬时响应高达 2560Hz ，获得泰尔五星精准流畅触控认证。 屏幕亮度表现出色，阳光模式下可达 1800nits，高亮模式下在 25% APL 区域峰值亮度达 3200nits，支持 HDR10+、Dolby Vision 。护眼方面，支持 DC+3840Hz 高频 PWM 混合调光，并搭载小米青山护眼方案，通过多亮度原色校准与节律护眼 2.0 。该屏幕已通过莱茵低蓝光、无频闪、节律友好三重认证，并获得中国质量认证中心 “视觉健康友好度 S++” 认证 。', 1, '2025-09-07 22:37:45', 8, 4);
INSERT INTO `questions` VALUES (3, 'REDMI Turbo 4 Pro 的续航能力如何，充电速度快吗？', '内置 7550mAh 金沙江电池，采用高达 10% 硅含量的硅碳负极电芯，能量密度高达 831Wh/L，是目前市面能量密度最高的手机电池之一。理论使用寿命远超 4 年，并通过南德长寿命电池认证 。 支持 90W 有线快充，1% 充至 52% 仅需 25 分钟，完全充满需要 58 分钟。搭载增压芯片，支持 2.8V 低压关机，配合整机热管理系统，在低温环境下也能保持双倍耐用。而且还支持 22.5W 反向快充，可以给手表、音箱、耳机等设备充电 。', 1, '2025-09-07 22:37:45', 8, 4);
INSERT INTO `questions` VALUES (4, '手机的外观设计有什么特点，材质方面表现如何？', '外观上采用大 R 角设计，提供黑、白、绿三款配色，其中绿色为亮面玻璃，黑、白后盖为 AG 玻璃 。Turbo 4 Pro 一改前代塑料中框传统，采用航空铝合金材质的 CNC 精雕一体成型金属中框，再结合喷砂、阳极氧化等工艺，不仅视觉质感更为高级，整机刚性大幅提升，金属中框抗弯强度高达 700N 。', 1, '2025-09-07 22:37:45', 8, 4);
INSERT INTO `questions` VALUES (5, 'REDMI Turbo 4 Pro 的拍照能力怎么样，后置摄像头的配置参数是什么？', '后置采用 5000 万像素索尼 LYT - 600 主摄（F1.5）搭配 800 万像素超广角摄像头。白天拍摄色彩还原度高，细节丰富；超广角镜头畸变校正到位，适合大场景拍摄 。', 1, '2025-09-07 22:37:45', 8, 4);
INSERT INTO `questions` VALUES (6, '这款双面穿机车服的两面材质有什么区别？一面是羊羔毛，另一面是什么面料？会不会起球或掉毛？', '这款机车服双面材质做了差异化设计 —— 一面是 高密度仿羊羔毛，绒毛细腻蓬松，亲肤度高且经过抗掉毛处理，日常穿着不易大量掉毛（首次清洗建议单独冷水轻柔洗，减少浮毛残留）；另一面是 耐磨 PU 皮 / 斜纹棉（根据款式不同），PU 皮款自带复古机车光泽感，防水耐脏易打理，斜纹棉款则更透气软挺，适合喜欢低调质感的人群。两面均做了抗起球工艺，正常穿着下不易起球，长期摩擦部位（如袖口、衣摆）建议避免大力拉扯。', 1, '2025-09-13 11:12:56', 17, 5);
INSERT INTO `questions` VALUES (7, '小个子女生（155cm 左右）穿这款机车服会压身高吗？版型是宽松还是修身的？选码需要注意什么？', '小个子女生完全不用担心压身高！这款机车服特意做了 短款落肩版型，衣长控制在 60-65cm（不同尺码略有差异），刚好盖过胯部不遮臀部，搭配高腰裤 / 裙能自然拉长腰线，150cm 以上都能驾驭。版型属于 微宽松款，不紧绷但也不会过分肥大，内搭薄毛衣、卫衣都有富余空间。选码建议：按平时穿的上衣码数选即可，若想内搭厚外套（如厚毛衣）或喜欢 oversize 风格，可拍大 1 码；若偏爱利落合身感，选正常码（具体可参考详情页肩宽、胸围数据，或提供身高体重咨询客服）。', 1, '2025-09-13 11:13:12', 17, 5);
INSERT INTO `questions` VALUES (8, '秋冬穿这款双面穿机车服，保暖性够不够？零下几度能穿？南方和北方穿着场景有区别吗？', '保暖性针对秋冬日常场景完全够用！羊羔毛面的绒毛密度达 280g/㎡，能形成有效保暖层，锁住身体热量；另一面 PU 皮 / 斜纹棉也做了薄夹棉处理（部分加厚款夹棉厚度 5mm），整体保暖度相当于一件薄羽绒服。', 1, '2025-09-13 11:13:32', 17, 5);
INSERT INTO `questions` VALUES (9, '这款机车服的细节设计有哪些 “潮点”？比如五金配件、口袋、领口这些，会不会容易坏或不实用？', '用的是复古做旧铜色拉链 + 按扣，拉合顺滑不卡顿，按扣力度适中（既不易崩开也不费力），经过盐雾测试，长期使用不易生锈掉色；两侧做了斜插式大口袋（深 15cm），能轻松装下手机、钥匙，口袋边缘有羊羔毛包边（羊羔毛面）或皮质包边（另一面），耐磨且显质感；这些细节配件都经过 500 次以上耐用性测试，正常穿着下不易损坏，实用性拉满。', 1, '2025-09-13 11:14:14', 17, 5);
INSERT INTO `questions` VALUES (10, '双面穿的设计会不会容易变形？清洗的时候有什么注意事项？洗完后怎么保养能保持版型？', '这款机车服的双面拼接处用了双线车缝工艺（针距 3mm / 英寸），拼接牢固不易开裂变形，只要按正确方式清洗保养，穿 1-2 个季节都能保持版型。穿完后及时清除表面灰尘，不穿时挂在宽肩衣架上（避免肩线变形），存放于干燥通风处，避免潮湿环境（防止 PU 皮发霉、羊羔毛结块）。', 1, '2025-09-13 11:14:29', 17, 5);
INSERT INTO `questions` VALUES (11, '小米 15 Pro 的屏幕有哪些亮点？日常使用体验如何？', '屏幕是其核心优势之一，采用 6.73 英寸 2K 等深四曲屏，522PPI 搭配 3200nits 峰值亮度，强光下也能清晰显示内容。支持 1-120Hz LTPO 可变刷新率，兼顾流畅度与功耗，还配备全程 DC 调光和龙晶玻璃 2.0，护眼同时抗摔抗刮能力更强。特别值得一提的是全屏 AOD 显示功能，1Hz 低刷常亮显示消息，既省电又能及时获取提醒。', 1, '2025-09-21 15:31:46', 5, 4);
INSERT INTO `questions` VALUES (12, '影像系统配置怎么样？长焦拍摄能力突出吗？', '影像为其最大亮点，搭载三颗徕卡 Summilux 大光圈镜头，主摄采用光影猎人 900 传感器，光圈达ƒ/1.44，进光量充足，夜景拍摄纯净度高。长焦镜头是小米 14 Ultra 同款索尼 IMX858，支持 5 倍光学变焦和 10 倍无损变焦，配合 AI 计算摄影 2.0，20 倍以上变焦画面仍保持可用清晰度，拍远景或人像虚化效果都很出色。', 1, '2025-09-21 15:31:59', 5, 4);
INSERT INTO `questions` VALUES (13, '电池续航和充电速度能满足重度使用需求吗？', '续航表现亮眼，内置 6100mAh 超大容量电池，重度使用一天后剩余电量通常能维持在 25% 以上。充电支持 90W 有线快充和 50W 无线快充，实测有线充电 40 分钟左右可充满，无线充电 1 小时左右完成，彻底告别电量焦虑，应对通勤或出差场景毫无压力。', 1, '2025-09-21 15:32:09', 5, 4);
INSERT INTO `questions` VALUES (14, '搭载的骁龙 8 至尊版性能如何？玩大型游戏发热严重吗？', '搭载的骁龙 8 至尊版采用台积电 3nm 工艺，单核性能较上一代提升 44%，多核提升 38%，安兔兔跑分超 300 万分。运行《原神》全高画质可稳定满帧，配合优化的散热系统，机身最高温度约 45℃，不会出现明显烫手情况。多任务切换、大型应用加载均能秒响应，性能储备充足。', 1, '2025-09-21 15:32:22', 5, 4);
INSERT INTO `questions` VALUES (15, '澎湃 OS 2.0 有哪些优化？存在常见 bug 吗？', '澎湃 OS 2.0 动效更流畅，重构渲染机制后，下拉控制中心、多任务切换等操作无卡顿，还新增动态层次感锁屏等实用功能。目前已知 Beta 版本曾存在全面屏手势失灵、闪屏等问题，但官方已在 OS2.0.24.2 版本中优化了控制中心卡顿问题，后续正式版会持续修复剩余 bug，日常使用稳定性有保障。​\n', 1, '2025-09-21 15:32:34', 5, 4);

-- ----------------------------
-- Table structure for type
-- ----------------------------
DROP TABLE IF EXISTS `type`;
CREATE TABLE `type`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '类别名称',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图标',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品分类表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of type
-- ----------------------------
INSERT INTO `type` VALUES (1, '数码 / 手机 / 家用电器', '数码 / 手机 / 家用电器', 'http://localhost:9999/file/download/手机.png');
INSERT INTO `type` VALUES (2, '女装 / 男装 / 童装', '女装 / 男装 / 童装', 'http://localhost:9999/file/download/女装内衣.png');
INSERT INTO `type` VALUES (3, '女鞋 / 男鞋 / 箱包', '女鞋 / 男鞋 / 箱包', 'http://localhost:9999/file/download/shoe.png');
INSERT INTO `type` VALUES (4, '家具 / 家装 / 厨具', '家具 / 家装 / 厨具', 'http://localhost:9999/file/download/家具.png');
INSERT INTO `type` VALUES (5, '美妆 / 个护清洁 ', '美妆 / 个护清洁 ', 'http://localhost:9999/file/download/美妆.png');
INSERT INTO `type` VALUES (6, '母婴 / 玩具', '母婴 / 玩具', 'http://localhost:9999/file/download/母婴.png');
INSERT INTO `type` VALUES (7, '零食 / 进口食品', '零食 / 进口食品', 'http://localhost:9999/file/download/零食.png');
INSERT INTO `type` VALUES (8, '汽车 / 配件', '汽车 / 配件', 'http://localhost:9999/file/download/汽车.png');
INSERT INTO `type` VALUES (9, '用品家纺 / 家饰 / 鲜花', '用品家纺 / 家饰 / 鲜花', 'http://localhost:9999/file/download/鲜花.png');
INSERT INTO `type` VALUES (10, '图书音像', '图书音像', 'http://localhost:9999/file/download/影音.png');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '密码',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '姓名',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '电话',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '地址',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像',
  `sex` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '性别',
  `age` int(11) NULL DEFAULT NULL COMMENT '年龄',
  `infos` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '个人介绍',
  `role` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '角色',
  `account` double(10, 2) NULL DEFAULT 0.00 COMMENT '余额',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', '123', '管理员', '13677889988', 'admin@xxx.com', '南京', 'http://localhost:9999/file/download/1756829622452_bg2.png', '男', 24, '我是管理员', 'ADMIN', 160739.99);
INSERT INTO `user` VALUES (2, 'tom', '123', '汤姆', '13988776699', 'jerry@163.com', '北京', 'http://localhost:9999/file/download/1758291901789_bg1.png', '男', 24, '我爱你，亲爱的姑娘', 'USER', 983692.97);
INSERT INTO `user` VALUES (3, 'jerry', '123', '杰瑞', '15098765321', 'tom@163.com', '上海', 'http://localhost:9090/file/download/wh.jpg', '男', 25, '我爱你，亲爱的姑娘', 'USER', 0.00);
INSERT INTO `user` VALUES (4, 'xiaomi', '123', '小米旗舰专卖店', '15098765321', 'xiaomi@163.com', '潍坊', 'http://localhost:9999/file/download/小米.png', '男', NULL, '我爱北京天安门！！！', 'SHOP', 0.00);
INSERT INTO `user` VALUES (5, 'shuangshuang', '123', '霜霜轻奢女装店', '15098765321', '霜霜@163.com', '南京', 'http://localhost:9999/file/download/女装.png', '男', NULL, '我爱北京天安门！！！', 'SHOP', 0.00);

SET FOREIGN_KEY_CHECKS = 1;
