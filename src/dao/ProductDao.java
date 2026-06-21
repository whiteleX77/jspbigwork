package dao;

import bean.Product;
import util.DBcon;
import java.sql.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import java.util.ArrayList;

public class ProductDao {

    /**
     * 发布新闲置商品，并返回数据库自动生成的主键 itemId
     */
    public int insertItemAndGetId(Product item) {
        int generatedId = -1;
        // 注意 SQL 语句对应 campus_secondhand 数据库的 item 表
        String sql = "INSERT INTO item (user_id, category_id, title, description, price, item_condition, campus_location, contact_way) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        DBcon db = new DBcon();
        try (Connection conn = db.getConnection();
             // 核心机制：Statement.RETURN_GENERATED_KEYS 允许我们在插入后拿回自增 ID
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, item.getUserId());
            pstmt.setInt(2, item.getCategoryId());
            pstmt.setString(3, item.getTitle());
            pstmt.setString(4, item.getDescription());
            pstmt.setDouble(5, item.getPrice());
            pstmt.setString(6, item.getItemCondition());
            pstmt.setString(7, item.getCampusLocation());
            pstmt.setString(8, item.getContactWay());

            // 执行插入
            pstmt.executeUpdate();

            // 掏出刚刚生成的 ID
            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    generatedId = rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return generatedId;
    }
    /**
     * 获取所有在售商品（用于首页展示）
     * 联表子查询：自动把 item_image 表里 sort_no 最小的那张图作为 mainImage 查出来
     */
    public java.util.List<Product> getAllActiveItems() {
        java.util.List<Product> list = new java.util.ArrayList<>();
        // 核心 SQL：查询在售商品，并关联取出第一张图
        String sql = "SELECT i.*, (SELECT image_url FROM item_image img WHERE img.item_id = i.item_id ORDER BY sort_no ASC LIMIT 1) as main_img " +
                "FROM item i WHERE i.status = 'active' ORDER BY i.publish_time DESC";

        util.DBcon db = new util.DBcon();
        try (java.sql.Connection conn = db.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(sql);
             java.sql.ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Product item = new Product();
                item.setItemId(rs.getInt("item_id"));
                item.setTitle(rs.getString("title"));
                item.setPrice(rs.getDouble("price"));
                item.setItemCondition(rs.getString("item_condition"));
                item.setCampusLocation(rs.getString("campus_location"));

                // 获取首图，如果没有图则使用默认图
                String img = rs.getString("main_img");
                item.setMainImage(img != null ? img : "default_item.png");

                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public Product getItemById(int itemId) {
        Product item = null;
        String sql = "SELECT * FROM item WHERE item_id = ?";
        util.DBcon db = new util.DBcon();
        try (java.sql.Connection conn = db.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, itemId);
            try (java.sql.ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    item = new Product();
                    item.setItemId(rs.getInt("item_id"));
                    item.setUserId(rs.getInt("user_id"));
                    item.setTitle(rs.getString("title"));
                    item.setDescription(rs.getString("description"));
                    item.setPrice(rs.getDouble("price"));
                    item.setItemCondition(rs.getString("item_condition"));
                    item.setCampusLocation(rs.getString("campus_location"));
                    item.setContactWay(rs.getString("contact_way"));
                    item.setStatus(rs.getString("status"));
                    item.setPublishTime(rs.getString("publish_time"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return item;
    }
    /**
     * (管理员专用) 获取全站所有商品（包括在售、已售、下架）
     */
    public java.util.List<Product> getAllItemsForAdmin() {
        java.util.List<Product> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM item ORDER BY publish_time DESC";
        util.DBcon db = new util.DBcon();
        try (java.sql.Connection conn = db.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(sql);
             java.sql.ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Product item = new Product();
                item.setItemId(rs.getInt("item_id"));
                item.setUserId(rs.getInt("user_id"));
                item.setTitle(rs.getString("title"));
                item.setPrice(rs.getDouble("price"));
                item.setStatus(rs.getString("status")); // active, sold, off
                item.setPublishTime(rs.getString("publish_time"));
                list.add(item);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    /**
     * (管理员专用) 更改商品状态 (例如强制下架: 'off')
     */
    public void changeItemStatus(int itemId, String newStatus) {
        String sql = "UPDATE item SET status = ? WHERE item_id = ?";
        util.DBcon db = new util.DBcon();
        try (java.sql.Connection conn = db.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newStatus);
            pstmt.setInt(2, itemId);
            pstmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
    /**
     * 根据特定用户ID，检索其发布过的所有商品历史（包含在售、已售、已下架）
     */
    public java.util.List<Product> getItemsByUserId(int userId) {
        java.util.List<Product> list = new java.util.ArrayList<>();
        // 核心联表 SQL：查询该用户的所有商品，并利用关联查询抽出其对应的首张图片作为 mainImage
        String sql = "SELECT i.*, (SELECT image_url FROM item_image img WHERE img.item_id = i.item_id ORDER BY sort_no ASC LIMIT 1) as main_img " +
                "FROM item i WHERE i.user_id = ? ORDER BY i.publish_time DESC";

        util.DBcon db = new util.DBcon();
        try (java.sql.Connection conn = db.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            try (java.sql.ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Product item = new Product();
                    item.setItemId(rs.getInt("item_id"));
                    item.setTitle(rs.getString("title"));
                    item.setPrice(rs.getDouble("price"));
                    item.setItemCondition(rs.getString("item_condition"));
                    item.setCampusLocation(rs.getString("campus_location"));
                    item.setStatus(rs.getString("status")); // 状态字段回显
                    item.setPublishTime(rs.getString("publish_time"));

                    String img = rs.getString("main_img");
                    item.setMainImage(img != null ? img : "default_item.png");

                    list.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    // 2. 🌟 改造：录入商品时强制打上商家思想钢印
    public boolean addProduct(Product p) {
        // SQL 新增了 merchant_id 的插入
        String sql = "INSERT INTO product (merchant_id, name, category, brand, description, price, stock, main_image) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        util.DBcon db = new util.DBcon();
        try (java.sql.Connection conn = db.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, p.getMerchantId()); // 核心：从 Session 抓取的商家 ID
            pstmt.setString(2, p.getName());
            pstmt.setString(3, p.getCategory());
            pstmt.setString(4, p.getBrand());
            pstmt.setString(5, p.getDescription());
            pstmt.setDouble(6, p.getPrice());
            pstmt.setInt(7, p.getStock());
            pstmt.setString(8, p.getMainImage());
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 2. 【查】获取所有上架商品（供前台大厅使用）
    public List<Product> getAllOnSaleProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM product WHERE status = 'on_sale' ORDER BY publish_time DESC";
        util.DBcon db = new util.DBcon();
        try (Connection conn = db.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Product p = new Product();
                p.setProductId(rs.getInt("product_id"));
                p.setName(rs.getString("name"));
                p.setPrice(rs.getDouble("price"));
                p.setMainImage(rs.getString("main_image"));
                p.setStock(rs.getInt("stock"));
                list.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
    // 3. 【查】根据 ID 查单件商品详情
    public Product getProductById(int productId) {
        Product p = null;
        String sql = "SELECT * FROM product WHERE product_id = ?";
        util.DBcon db = new util.DBcon();
        try (java.sql.Connection conn = db.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, productId);
            try (java.sql.ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    p = new Product();
                    p.setProductId(rs.getInt("product_id"));
                    p.setName(rs.getString("name"));
                    p.setCategory(rs.getString("category"));
                    p.setBrand(rs.getString("brand"));
                    p.setPrice(rs.getDouble("price"));
                    p.setStock(rs.getInt("stock"));
                    p.setDescription(rs.getString("description"));
                    p.setMainImage(rs.getString("main_image"));
                    p.setStatus(rs.getString("status"));

                    // 🌟 B2B2C 升级后补充抓取的新字段：
                    p.setMerchantId(rs.getInt("merchant_id"));
                    p.setRating(rs.getDouble("rating"));
                    p.setReviewCount(rs.getInt("review_count"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return p;
    }
    /**
     * (管理员专用) 获取全站所有商品（包括上架、下架）
     */
    public java.util.List<bean.Product> getAllProductsForAdmin() {
        java.util.List<bean.Product> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM product ORDER BY publish_time DESC";
        util.DBcon db = new util.DBcon();
        try (java.sql.Connection conn = db.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(sql);
             java.sql.ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                bean.Product p = new bean.Product();
                p.setProductId(rs.getInt("product_id"));
                p.setName(rs.getString("name"));
                p.setCategory(rs.getString("category"));
                p.setBrand(rs.getString("brand"));
                p.setPrice(rs.getDouble("price"));
                p.setStock(rs.getInt("stock"));
                p.setStatus(rs.getString("status")); // on_sale 或 off_sale
                p.setPublishTime(rs.getString("publish_time"));
                list.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    /**
     * (管理员专用) 更改商品上架/下架状态
     */
    public void changeProductStatus(int productId, String newStatus) {
        String sql = "UPDATE product SET status = ? WHERE product_id = ?";
        util.DBcon db = new util.DBcon();
        try (java.sql.Connection conn = db.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newStatus);
            pstmt.setInt(2, productId);
            pstmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
    /**
     * (管理员专用) 更新现有的商品信息与库存
     */
    public boolean updateProduct(Product p) {
        // 覆盖除了 product_id 和 publish_time 之外的所有核心字段
        String sql = "UPDATE product SET name=?, category=?, brand=?, price=?, stock=?, description=?, main_image=? WHERE product_id=?";
        util.DBcon db = new util.DBcon();
        try (java.sql.Connection conn = db.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, p.getName());
            pstmt.setString(2, p.getCategory());
            pstmt.setString(3, p.getBrand());
            pstmt.setDouble(4, p.getPrice());
            pstmt.setInt(5, p.getStock());
            pstmt.setString(6, p.getDescription());
            pstmt.setString(7, p.getMainImage());
            pstmt.setInt(8, p.getProductId()); // 关键：指定更新哪个商品

            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    /**
     * (前台大厅专用) 根据分类和关键词动态检索上架商品
     */
    public List<Product> getProductsByCondition(String keyword, String category) {
        List<Product> list = new java.util.ArrayList<>();

        // 1. 基础 SQL：只查上架的商品
        StringBuilder sql = new StringBuilder("SELECT * FROM product WHERE status = 'on_sale'");
        List<Object> params = new java.util.ArrayList<>();

        // 2. 动态拼接关键词条件 (模糊查询 LIKE)
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND name LIKE ?");
            params.add("%" + keyword.trim() + "%");
        }

        // 3. 动态拼接分类条件
        if (category != null && !category.trim().isEmpty() && !"全部".equals(category)) {
            sql.append(" AND category = ?");
            params.add(category.trim());
        }

        // 4. 追加排序逻辑：最新发布的在前面
        sql.append(" ORDER BY publish_time DESC");

        util.DBcon db = new util.DBcon();
        try (java.sql.Connection conn = db.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            // 5. 动态绑定参数
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }

            try (java.sql.ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setProductId(rs.getInt("product_id"));
                    p.setName(rs.getString("name"));
                    p.setPrice(rs.getDouble("price"));
                    p.setStock(rs.getInt("stock"));
                    p.setMainImage(rs.getString("main_image"));
                    list.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    //新增：商家专属数据隔离查询 (只查自己的货)
    public List<Product> getProductsByMerchant(int merchantId) {
        List<Product> list = new java.util.ArrayList<>();
        // 核心：WHERE merchant_id = ? 实现了物理级别的数据隔离
        String sql = "SELECT * FROM product WHERE merchant_id = ? ORDER BY product_id DESC";
        util.DBcon db = new util.DBcon();
        try (java.sql.Connection conn = db.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, merchantId);
            try (java.sql.ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setProductId(rs.getInt("product_id"));
                    p.setMerchantId(rs.getInt("merchant_id")); // 绑定商家身份
                    p.setName(rs.getString("name"));
                    p.setCategory(rs.getString("category"));
                    p.setPrice(rs.getDouble("price"));
                    p.setStock(rs.getInt("stock"));
                    p.setStatus(rs.getString("status"));
                    p.setRating(rs.getDouble("rating")); // 读取评分
                    list.add(p);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
    // 🌟 获取该商家的其他商品（排除当前正在查看的商品，最多推荐 4 个）
    public java.util.List<Product> getShopOtherProducts(int merchantId, int excludeProductId) {
        java.util.List<Product> list = new java.util.ArrayList<>();
        // 🌟 核心拦截：加上 status = 'on_sale'，绝对不推荐已下架的商品！
        String sql = "SELECT * FROM product WHERE merchant_id = ? AND product_id != ? AND status = 'on_sale' ORDER BY product_id DESC LIMIT 4";
        util.DBcon db = new util.DBcon();
        try (java.sql.Connection conn = db.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, merchantId);
            pstmt.setInt(2, excludeProductId);
            try (java.sql.ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setProductId(rs.getInt("product_id"));
                    p.setName(rs.getString("name"));
                    p.setPrice(rs.getDouble("price"));
                    p.setMainImage(rs.getString("main_image"));
                    list.add(p);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
    // 🌟 获取某件商品的所有买家评价
    public java.util.List<bean.Review> getReviewsByProduct(int productId) {
        java.util.List<bean.Review> list = new java.util.ArrayList<>();
        // 连表查询：review 表关联 user 表获取买家账号
        String sql = "SELECT r.*, u.username FROM review r JOIN user u ON r.user_id = u.user_id WHERE r.product_id = ? ORDER BY r.create_time DESC";
        util.DBcon db = new util.DBcon();
        try (java.sql.Connection conn = db.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, productId);
            try (java.sql.ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    bean.Review r = new bean.Review();
                    r.setReviewId(rs.getInt("review_id"));
                    r.setRating(rs.getInt("rating"));
                    r.setContent(rs.getString("content"));
                    r.setCreateTime(rs.getString("create_time"));
                    r.setUsername(rs.getString("username")); // 获取买家名字
                    list.add(r);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
    // 🌟 获取某商家所有正在出售的商品 (用于店铺专属主页)
    public java.util.List<Product> getOnSaleProductsByMerchant(int merchantId) {
        java.util.List<Product> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM product WHERE merchant_id = ? AND status = 'on_sale' ORDER BY product_id DESC";
        util.DBcon db = new util.DBcon();
        try (java.sql.Connection conn = db.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, merchantId);
            try (java.sql.ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setProductId(rs.getInt("product_id"));
                    p.setName(rs.getString("name"));
                    p.setPrice(rs.getDouble("price"));
                    p.setMainImage(rs.getString("main_image"));
                    list.add(p);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
    // 🌟 1. 写入真实评价记录
    public boolean addReview(int productId, int userId, int orderId, int rating, String content) {
        String sql = "INSERT INTO review (product_id, user_id, order_id, rating, content) VALUES (?, ?, ?, ?, ?)";
        util.DBcon db = new util.DBcon();
        try (java.sql.Connection conn = db.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, productId);
            pstmt.setInt(2, userId);
            pstmt.setInt(3, orderId);
            pstmt.setInt(4, rating);
            pstmt.setString(5, content);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // 🌟 商家专用：在确保商品归属本商家的前提下修改库存（SQL 层物理级数据隔离）
    public boolean updateStockByMerchant(int productId, int newStock, int merchantId) {
        String sql = "UPDATE product SET stock = ? WHERE product_id = ? AND merchant_id = ?";
        util.DBcon db = new util.DBcon();
        try (java.sql.Connection conn = db.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, newStock);
            pstmt.setInt(2, productId);
            pstmt.setInt(3, merchantId); // 关键：别人的商品 product_id 在这里改不动
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // 🌟 商家专用：在确保商品归属本商家的前提下上架/下架自己的商品
    public boolean changeStatusByMerchant(int productId, String newStatus, int merchantId) {
        String sql = "UPDATE product SET status = ? WHERE product_id = ? AND merchant_id = ?";
        util.DBcon db = new util.DBcon();
        try (java.sql.Connection conn = db.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newStatus);
            pstmt.setInt(2, productId);
            pstmt.setInt(3, merchantId); // 关键：只能动自己名下的货
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // 🌟 2. 自动触发：重新计算并更新商品的平均星级和评价总数
    public void updateProductRating(int productId) {
        // 使用 SQL 聚合函数 COUNT 和 AVG 自动算分
        String sql = "UPDATE product SET review_count = (SELECT COUNT(*) FROM review WHERE product_id = ?), " +
                "rating = (SELECT AVG(rating) FROM review WHERE product_id = ?) WHERE product_id = ?";
        util.DBcon db = new util.DBcon();
        try (java.sql.Connection conn = db.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, productId);
            pstmt.setInt(2, productId);
            pstmt.setInt(3, productId);
            pstmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}
