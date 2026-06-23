package servlet.Merchant;

import dao.ProductDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/MerchantChangeStatusServlet")
public class MerchantChangeStatusServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        // 1. 严格鉴权：只有商家本人能上/下架自己的商品
        String role = (String) session.getAttribute("userRole");
        if (role == null || !"merchant".equals(role)) {
            response.getWriter().print("<script>alert('非法访问！'); location.href='login.jsp';</script>");
            return;
        }

        try {
            int merchantId = (int) session.getAttribute("userId");
            int productId = Integer.parseInt(request.getParameter("productId"));
            String status = request.getParameter("status");

            // 2. 白名单校验：只允许这两种合法状态，杜绝乱传
            if (!"on_sale".equals(status) && !"off_sale".equals(status)) {
                response.getWriter().print("<script>alert('非法的商品状态！'); location.href='MerchantDashboardServlet';</script>");
                return;
            }

            ProductDao dao = new ProductDao();
            // 核心：带 merchant_id 的更新，动不了别家商品
            dao.changeStatusByMerchant(productId, status, merchantId);

            response.sendRedirect("MerchantDashboardServlet");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().print("<script>alert('系统繁忙，请稍后再试！'); location.href='MerchantDashboardServlet';</script>");
        }
    }
}
