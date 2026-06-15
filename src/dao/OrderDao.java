package dao;

import bean.OrderVO;
import util.DBcon;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class OrderDao {
    /**
     * 客户查询自己的历史订单记录
     */
    // 🌟 查出该买家的所有订单 (连表查询商品名、图片和卖家名)
    public java.util.List<bean.OrderVO> getOrdersByUserId(int userId) {
        java.util.List<bean.OrderVO> list = new java.util.ArrayList<>();
        // 核心连表 SQL：订单表 连 商品表 连 用户(商家)表
        String sql = "SELECT o.*, p.name as product_name, p.main_image, u.real_name as merchant_name " +
                "FROM orders o " +
                "JOIN product p ON o.product_id = p.product_id " +
                "JOIN user u ON o.merchant_id = u.user_id " +
                "WHERE o.buyer_id = ? ORDER BY o.create_time DESC";
        util.DBcon db = new util.DBcon();
        try (java.sql.Connection conn = db.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (java.sql.ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    bean.OrderVO o = new bean.OrderVO();
                    o.setOrderId(rs.getInt("order_id"));
                    o.setOrderNo(rs.getString("order_no"));
                    o.setProductId(rs.getInt("product_id"));
                    o.setTotalPrice(rs.getDouble("price"));
                    o.setLogisticsStatus(rs.getInt("logistics_status"));
                    // 装载连表查出来的数据
                    o.setProductName(rs.getString("product_name"));
                    o.setMainImage(rs.getString("main_image"));
                    o.setMerchantName(rs.getString("merchant_name"));
                    list.add(o);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
    /**
     * (管理员专用) 获取平台所有交易订单及收货信息
     */
    public List<OrderVO> getAllOrdersForAdmin() {
        List<OrderVO> list = new ArrayList<>();
        // 三表联查：订单表(o) + 商品表(p) + 用户表(u)
        String sql = "SELECT o.order_id, o.product_id, o.buy_count, o.total_price, o.order_time, o.buyer_phone, o.shipping_address, " +
                "p.name, u.username as buyer_name " +
                "FROM orders o " +
                "JOIN product p ON o.product_id = p.product_id " +
                "JOIN user u ON o.user_id = u.user_id " +
                "ORDER BY o.order_time DESC";

        DBcon db = new DBcon();
        try (Connection conn = db.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                OrderVO vo = new OrderVO();
                vo.setOrderId(rs.getInt("order_id"));
                vo.setProductName(rs.getString("name"));
                vo.setBuyerName(rs.getString("buyer_name"));
                vo.setBuyCount(rs.getInt("buy_count"));
                vo.setTotalPrice(rs.getDouble("total_price"));
                vo.setBuyerPhone(rs.getString("buyer_phone"));
                vo.setShippingAddress(rs.getString("shipping_address"));
                vo.setOrderTime(rs.getString("order_time"));
                list.add(vo);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
    // 🌟 买家付款成功后，生成一条真实订单 (初始物流状态为 0: 待发货)
    public boolean createOrder(bean.OrderVO order) {
        String sql = "INSERT INTO orders (order_no, buyer_id, merchant_id, product_id, price, shipping_address, buyer_phone, logistics_status) VALUES (?, ?, ?, ?, ?, ?, ?, 0)";
        util.DBcon db = new util.DBcon();
        try (java.sql.Connection conn = db.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, order.getOrderNo());
            pstmt.setInt(2, order.getBuyerId());
            pstmt.setInt(3, order.getMerchantId());
            pstmt.setInt(4, order.getProductId());
            pstmt.setDouble(5, order.getTotalPrice());
            pstmt.setString(6, order.getShippingAddress());
            pstmt.setString(7, order.getBuyerPhone());
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    // 🌟 查出该买家的所有订单 (连表查询商品名、图片和卖家名)
    public java.util.List<bean.OrderVO> getOrdersByBuyer(int buyerId) {
        java.util.List<bean.OrderVO> list = new java.util.ArrayList<>();
        // 核心连表 SQL：订单表 连 商品表 连 用户(商家)表
        String sql = "SELECT o.*, p.name as product_name, p.main_image, u.real_name as merchant_name " +
                "FROM orders o " +
                "JOIN product p ON o.product_id = p.product_id " +
                "JOIN user u ON o.merchant_id = u.user_id " +
                "WHERE o.buyer_id = ? ORDER BY o.create_time DESC";
        util.DBcon db = new util.DBcon();
        try (java.sql.Connection conn = db.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, buyerId);
            try (java.sql.ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    bean.OrderVO o = new bean.OrderVO();
                    o.setOrderId(rs.getInt("order_id"));
                    o.setOrderNo(rs.getString("order_no"));
                    o.setProductId(rs.getInt("product_id"));
                    o.setTotalPrice(rs.getDouble("price"));
                    o.setLogisticsStatus(rs.getInt("logistics_status"));
                    // 装载连表查出来的数据
                    o.setProductName(rs.getString("product_name"));
                    o.setMainImage(rs.getString("main_image"));
                    o.setMerchantName(rs.getString("merchant_name"));
                    list.add(o);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
    // 🌟 1. 掌柜专用：查出本店被买家下过的所有订单
    public java.util.List<bean.OrderVO> getOrdersByMerchantId(int merchantId) {
        java.util.List<bean.OrderVO> list = new java.util.ArrayList<>();
        // 连表查询：查出商品长啥样，以及买家是谁
        String sql = "SELECT o.*, p.name as product_name, p.main_image, u.username as buyer_name " +
                "FROM orders o " +
                "JOIN product p ON o.product_id = p.product_id " +
                "JOIN user u ON o.buyer_id = u.user_id " +
                "WHERE o.merchant_id = ? ORDER BY o.create_time DESC";
        util.DBcon db = new util.DBcon();
        try (java.sql.Connection conn = db.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, merchantId);
            try (java.sql.ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    bean.OrderVO o = new bean.OrderVO();
                    o.setOrderId(rs.getInt("order_id"));
                    o.setOrderNo(rs.getString("order_no"));
                    o.setProductId(rs.getInt("product_id"));
                    o.setTotalPrice(rs.getDouble("price"));
                    o.setShippingAddress(rs.getString("shipping_address")); // 抓取收货地址
                    o.setBuyerPhone(rs.getString("buyer_phone"));           // 抓取收货电话
                    o.setLogisticsStatus(rs.getInt("logistics_status"));
                    o.setProductName(rs.getString("product_name"));
                    o.setMainImage(rs.getString("main_image"));
                    o.setBuyerName(rs.getString("buyer_name"));             // 抓取买家账号名
                    list.add(o);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 🌟 2. 核心状态机：修改订单的物流状态 (发货、收货通用)
    public boolean updateOrderStatus(int orderId, int newStatus) {
        String sql = "UPDATE orders SET logistics_status = ? WHERE order_id = ?";
        util.DBcon db = new util.DBcon();
        try (java.sql.Connection conn = db.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, newStatus);
            pstmt.setInt(2, orderId);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    // 🌟 3. 上帝视角：查出全平台所有订单 (系统管理员专用)
    public java.util.List<bean.OrderVO> getAllOrders() {
        java.util.List<bean.OrderVO> list = new java.util.ArrayList<>();
        // 终极连表查询：查出订单信息、商品图片、买家账号、卖家店名
        String sql = "SELECT o.*, p.name as product_name, p.main_image, " +
                "u1.username as buyer_name, u2.real_name as merchant_name " +
                "FROM orders o " +
                "JOIN product p ON o.product_id = p.product_id " +
                "JOIN user u1 ON o.buyer_id = u1.user_id " +
                "JOIN user u2 ON o.merchant_id = u2.user_id " +
                "ORDER BY o.create_time DESC";
        util.DBcon db = new util.DBcon();
        try (java.sql.Connection conn = db.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(sql);
             java.sql.ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                bean.OrderVO o = new bean.OrderVO();
                o.setOrderId(rs.getInt("order_id"));
                o.setOrderNo(rs.getString("order_no"));
                o.setProductId(rs.getInt("product_id"));
                o.setTotalPrice(rs.getDouble("price"));
                o.setShippingAddress(rs.getString("shipping_address"));
                o.setBuyerPhone(rs.getString("buyer_phone"));
                o.setLogisticsStatus(rs.getInt("logistics_status"));
                o.setOrderTime(rs.getString("create_time")); // 下单时间

                o.setProductName(rs.getString("product_name"));
                o.setMainImage(rs.getString("main_image"));
                o.setBuyerName(rs.getString("buyer_name"));       // 抓取买家名
                o.setMerchantName(rs.getString("merchant_name")); // 抓取卖家名
                list.add(o);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}