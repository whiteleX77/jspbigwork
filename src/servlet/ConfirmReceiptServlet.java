package servlet;
import dao.OrderDao;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/ConfirmReceiptServlet")
public class ConfirmReceiptServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        // 买家确认收货：把状态从 1 改成 2
        new OrderDao().updateOrderStatus(orderId, 2);
        response.sendRedirect("MyOrdersServlet"); // 刷新买家订单页
    }
}