package dao;

import bean.User;
import util.DBcon;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UserDao {

    // 1. 检查用户名是否存在 (注册防重名)
    public boolean checkUsernameExist(String username) {
        boolean exist = false;
        String sql = "SELECT user_id FROM user WHERE username = ?";
        DBcon db = new DBcon();
        try (Connection conn = db.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    exist = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return exist;
    }

    // 2. 插入新用户 (支持多角色注册)
    public boolean insertUser(User user) {
        // 🌟 新增了 role 字段的插入
        String sql = "INSERT INTO user (username, password, real_name, phone, role) VALUES (?, ?, ?, ?, ?)";
        util.DBcon db = new util.DBcon();
        try (java.sql.Connection conn = db.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getRealName());
            pstmt.setString(4, user.getPhone());
            pstmt.setString(5, user.getRole()); // 写入身份 (customer 或 merchant)

            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    // 3. 登录验证与智能角色抓取
    public User login(String username, String password) {
        User user = null;
        String sql = "SELECT * FROM user WHERE username = ? AND password = ?";
        DBcon db = new DBcon();
        try (Connection conn = db.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    // 🌟 最核心的一步：精准抓取 admin 或 customer 权限标识
                    user.setRole(rs.getString("role"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    // 4. (管理员专用) 获取全站所有用户信息，供 Apple 风格后台渲染
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM user ORDER BY create_time DESC";
        DBcon db = new DBcon();
        try (Connection conn = db.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setRealName(rs.getString("real_name"));
                u.setPhone(rs.getString("phone")); // 🌟 确保抓取手机号，后台才不会显示空
                u.setRole(rs.getString("role"));
                u.setCreateTime(rs.getString("create_time"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    // 🌟 根据 ID 获取用户/商家的完整信息
    public User getUserById(int userId) {
        User user = null;
        String sql = "SELECT * FROM user WHERE user_id = ?";
        util.DBcon db = new util.DBcon();
        try (java.sql.Connection conn = db.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (java.sql.ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setRealName(rs.getString("real_name")); // 我们把商家的 real_name 作为店铺名
                    user.setPhone(rs.getString("phone"));
                    user.setRole(rs.getString("role"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }
}