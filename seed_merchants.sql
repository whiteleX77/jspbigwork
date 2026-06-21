-- ============================================================
-- 种子数据：新增 5 个热门数码商家及其商品
-- 编码统一 utf8mb4；商品 merchant_id 用子查询按 username 关联
-- 回滚见文件末尾注释
-- ============================================================
SET NAMES utf8mb4;

-- ---------- 1. 商家（role = merchant）----------
INSERT INTO user (username, password, real_name, phone, role) VALUES
('dji_official', 'dji123',    '大疆DJI官方旗舰店',      '4006700700', 'merchant'),
('insta360',     'insta123',  '影石Insta360官方旗舰店', '4001183360', 'merchant'),
('sony_store',   'sony123',   '索尼Sony官方旗舰店',     '4008109000', 'merchant'),
('gopro_store',  'gopro123',  'GoPro官方旗舰店',        '4006208600', 'merchant'),
('xiaomi_store', 'xiaomi123', '小米Xiaomi官方旗舰店',   '4001005678', 'merchant');

-- ---------- 2. 商品（category 统一为“电子数码”）----------

-- 大疆 DJI
INSERT INTO product (merchant_id, name, category, brand, price, stock, description, main_image, status) VALUES
((SELECT user_id FROM user WHERE username='dji_official'), '大疆 DJI Mini 4 Pro 航拍无人机 全能套装', '电子数码', '大疆DJI', 4788.00, 50, '249g 轻量化机身免登记，4K/60fps HDR 广角夜景，全向避障，新手航拍首选。', 'seed_dji_1.jpg', 'on_sale'),
((SELECT user_id FROM user WHERE username='dji_official'), '大疆 DJI Osmo Pocket 3 一英寸口袋云台相机', '电子数码', '大疆DJI', 3499.00, 60, '1英寸 CMOS，三轴机械增稳，2英寸旋转触屏，Vlog 神器随身带。', 'seed_dji_2.jpg', 'on_sale'),
((SELECT user_id FROM user WHERE username='dji_official'), '大疆 DJI Air 3S 双摄航拍无人机', '电子数码', '大疆DJI', 6988.00, 35, '双焦段相机 + 前视激光雷达夜间避障，续航 45 分钟，进阶航拍利器。', 'seed_dji_3.jpg', 'on_sale'),
((SELECT user_id FROM user WHERE username='dji_official'), '大疆 DJI RS 4 单反相机手持稳定器', '电子数码', '大疆DJI', 2599.00, 40, '自动轴锁，二代下竖拍模式，承重 3kg，专业运镜随心拍。', 'seed_dji_4.jpg', 'on_sale');

-- 影石 Insta360
INSERT INTO product (merchant_id, name, category, brand, price, stock, description, main_image, status) VALUES
((SELECT user_id FROM user WHERE username='insta360'), '影石 Insta360 X4 8K 全景运动相机', '电子数码', '影石Insta360', 3198.00, 55, '8K 全景拍摄，子弹时间，隐形自拍杆，防抖防水，运动玩家首选。', 'seed_insta_1.jpg', 'on_sale'),
((SELECT user_id FROM user WHERE username='insta360'), '影石 Insta360 Ace Pro 2 运动相机', '电子数码', '影石Insta360', 2998.00, 50, '徕卡联合影像系统，8K30fps，2.5英寸翻转屏，弱光更纯净。', 'seed_insta_2.jpg', 'on_sale'),
((SELECT user_id FROM user WHERE username='insta360'), '影石 Insta360 GO 3S 拇指防抖相机', '电子数码', '影石Insta360', 2188.00, 45, '38g 拇指大小，第一视角磁吸穿戴，4K 防抖，记录灵感瞬间。', 'seed_insta_3.jpg', 'on_sale'),
((SELECT user_id FROM user WHERE username='insta360'), '影石 Insta360 Flow 2 Pro AI 手机云台', '电子数码', '影石Insta360', 999.00, 70, '内置 AI 追踪芯片，三轴增稳，自带补光与三脚架，直播 Vlog 神器。', 'seed_insta_4.jpg', 'on_sale');

-- 索尼 Sony
INSERT INTO product (merchant_id, name, category, brand, price, stock, description, main_image, status) VALUES
((SELECT user_id FROM user WHERE username='sony_store'), '索尼 Sony Alpha 7 IV 全画幅微单相机', '电子数码', '索尼Sony', 16999.00, 25, '3300 万像素全画幅，4K60p 超采，实时眼部对焦，专业影像旗舰。', 'seed_sony_1.jpg', 'on_sale'),
((SELECT user_id FROM user WHERE username='sony_store'), '索尼 Sony WH-1000XM5 头戴式降噪耳机', '电子数码', '索尼Sony', 2499.00, 80, '业界领先智能降噪，30 小时续航，LDAC 高解析，旗舰静音体验。', 'seed_sony_2.jpg', 'on_sale'),
((SELECT user_id FROM user WHERE username='sony_store'), '索尼 Sony ZV-1 II Vlog 数码相机', '电子数码', '索尼Sony', 4699.00, 40, '18-50mm 等效广角，强力防抖，美肤拍摄，一键虚化，Vlog 专用。', 'seed_sony_3.jpg', 'on_sale'),
((SELECT user_id FROM user WHERE username='sony_store'), '索尼 Sony WF-1000XM5 真无线降噪耳机', '电子数码', '索尼Sony', 1499.00, 90, '全新降噪处理器，轻巧入耳，高音质通话，沉浸聆听。', 'seed_sony_4.jpg', 'on_sale');

-- GoPro
INSERT INTO product (merchant_id, name, category, brand, price, stock, description, main_image, status) VALUES
((SELECT user_id FROM user WHERE username='gopro_store'), 'GoPro HERO13 Black 运动相机', '电子数码', 'GoPro', 3198.00, 45, '5.3K60 超清，HB 防抖 6.0，磁吸快拆，自动云端备份，全能运动机。', 'seed_gopro_1.jpg', 'on_sale'),
((SELECT user_id FROM user WHERE username='gopro_store'), 'GoPro HERO12 Black 运动相机', '电子数码', 'GoPro', 2598.00, 50, '更长续航，10bit 色彩，HDR 视频，竖拍捕捉，性价比之选。', 'seed_gopro_2.jpg', 'on_sale'),
((SELECT user_id FROM user WHERE username='gopro_store'), 'GoPro MAX 360 全景运动相机', '电子数码', 'GoPro', 3998.00, 30, '360 度全景 + 单镜模式，6 麦克风收音，水平锁定，一机多用。', 'seed_gopro_3.jpg', 'on_sale');

-- 小米 Xiaomi
INSERT INTO product (merchant_id, name, category, brand, price, stock, description, main_image, status) VALUES
((SELECT user_id FROM user WHERE username='xiaomi_store'), '小米 Xiaomi 15 Pro 旗舰手机', '电子数码', '小米Xiaomi', 5299.00, 100, '骁龙 8 至尊版，徕卡光学，2K 全等深四曲屏，6100mAh 大电池。', 'seed_mi_1.jpg', 'on_sale'),
((SELECT user_id FROM user WHERE username='xiaomi_store'), '小米 Xiaomi 14 Ultra 影像旗舰', '电子数码', '小米Xiaomi', 6499.00, 60, '徕卡四摄，1 英寸大底主摄，可变光圈，专业摄影旗舰。', 'seed_mi_2.jpg', 'on_sale'),
((SELECT user_id FROM user WHERE username='xiaomi_store'), '小米 Redmi Note 14 Pro+ 5G 手机', '电子数码', '小米Xiaomi', 1999.00, 120, '2 亿像素影像，6.67 英寸 1.5K 屏，5110mAh，千元真香机。', 'seed_mi_3.jpg', 'on_sale'),
((SELECT user_id FROM user WHERE username='xiaomi_store'), '小米 Xiaomi Watch S4 智能手表', '电子数码', '小米Xiaomi', 999.00, 85, '蓝宝石玻璃，15 天续航，eSIM 独立通话，专业运动健康监测。', 'seed_mi_4.jpg', 'on_sale');

-- ============================================================
-- 回滚（如需撤销本次种子数据，执行下面两条）：
--   DELETE FROM product WHERE merchant_id IN
--     (SELECT user_id FROM user WHERE username IN
--       ('dji_official','insta360','sony_store','gopro_store','xiaomi_store'));
--   DELETE FROM user WHERE username IN
--     ('dji_official','insta360','sony_store','gopro_store','xiaomi_store');
-- ============================================================
