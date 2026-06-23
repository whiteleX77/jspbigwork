package servlet.customer;

import dao.OrderDao;
import dao.ProductDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/SubmitReviewServlet")
public class SubmitReviewServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        if (session.getAttribute("userId") == null) {
            response.getWriter().print("<script>alert('请先登录！'); location.href='login.jsp';</script>");
            return;
        }

        try {
            int userId = (int) session.getAttribute("userId");
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            int productId = Integer.parseInt(request.getParameter("productId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String content = request.getParameter("content");

            ProductDao productDao = new ProductDao();
            OrderDao orderDao = new OrderDao();

            // 1. 存入评价表
            if (productDao.addReview(productId, userId, orderId, rating, content)) {
                // 2. 将订单状态修改为 3 (已评价)
                orderDao.updateOrderStatus(orderId, 3);
                // 3. 自动更新商品的平均星级
                productDao.updateProductRating(productId);

                response.getWriter().print("<script>alert('评价成功！感谢您的真实反馈！'); location.href='MyOrdersServlet';</script>");
            } else {
                response.getWriter().print("<script>alert('数据库繁忙，评价失败。'); history.back();</script>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().print("<script>alert('系统参数错误！'); history.back();</script>");
        }
    }
}