package servlet;

import bean.Product;
import dao.ProductDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/MerchantDashboardServlet")
public class MerchantDashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        // 1. 严格的安全拦截：不是 merchant 绝对不允许进！
        String role = (String) session.getAttribute("userRole");
        if (role == null || !"merchant".equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. 获取当前登录商家的唯一 ID
        int merchantId = (int) session.getAttribute("userId");


        // 3. 查出当前商家的货
        ProductDao productDao = new ProductDao();
        List<Product> myProducts = productDao.getProductsByMerchant(merchantId);

        // 🌟 新增：查出当前商家收到的所有买家订单
        dao.OrderDao orderDao = new dao.OrderDao();
        List<bean.OrderVO> merchantOrders = orderDao.getOrdersByMerchantId(merchantId);

        // 4. 将数据推送到商家专属 JSP 视图
        request.setAttribute("myProducts", myProducts);
        request.setAttribute("merchantOrders", merchantOrders); // 推送订单数据
        request.getRequestDispatcher("merchant.jsp").forward(request, response);
    }
}