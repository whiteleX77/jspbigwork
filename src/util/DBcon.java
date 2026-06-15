package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBcon {
    // 根据你的实际环境修改密码，注意时区配置
    private String driver = "com.mysql.cj.jdbc.Driver";
    private String url = "jdbc:mysql://localhost:3306/campus_secondhand?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai";
    private String user = "root";
    private String password = "589964544gjh"; // 替换为你的 MySQL 密码

    public Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName(driver);
            conn = DriverManager.getConnection(url, user, password);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            System.out.println("数据库连接失败，请检查配置！");
        }
        return conn;
    }
}