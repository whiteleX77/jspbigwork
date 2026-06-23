package servlet.admin;

import bean.Product;
import bean.User;
import bean.OrderVO;
import dao.ProductDao;
import dao.UserDao;
import dao.OrderDao;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/AdminDashboardServlet")
public class AdminDashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("userRole");

        // 绝对控制：如果未登录或者角色不是管理员，强制拦截
        if (role == null || !"admin".equals(role)) {
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().print("<script>alert('非法访问！您不是管理员。'); location.href='login.jsp';</script>");
            return;
        }

        // 1. 调用数据层抓取用户和商品队列
        UserDao userDao = new UserDao();
        List<User> userList = userDao.getAllUsers();

        ProductDao productDao = new ProductDao();
        List<Product> productList = productDao.getAllProductsForAdmin();

        // 🌟 统一使用新写的带 JOIN 连表查询的方法，确保能查出图文和买卖双方名字
        OrderDao orderDao = new OrderDao();
        List<OrderVO> allOrders = orderDao.getAllOrders();

        // 2. 绑定数据上下文，保留你原本的 itemList 命名习惯
        request.setAttribute("userList", userList);
        request.setAttribute("itemList", productList);
        request.setAttribute("totalUsers", userList.size());
        request.setAttribute("totalItems", productList.size());

        // 🌟 双向兼容：既输出给咱们新改的 admin.jsp (allOrders / orderCount)
        // 也兼容你代码里可能残留的旧变量名 (orderList / totalOrders)
        request.setAttribute("allOrders", allOrders);
        request.setAttribute("orderCount", allOrders.size());
        request.setAttribute("orderList", allOrders);
        request.setAttribute("totalOrders", allOrders.size());

        // 3. 转发到控制面板
        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }
}