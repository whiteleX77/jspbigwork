package servlet;
import dao.OrderDao;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/ShipOrderServlet")
public class ShipOrderServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        // 卖家发货：把状态从 0 改成 1
        new OrderDao().updateOrderStatus(orderId, 1);
        response.sendRedirect("MerchantDashboardServlet"); // 刷新掌柜页面
    }
}