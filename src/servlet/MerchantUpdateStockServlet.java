package servlet;

import dao.ProductDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/MerchantUpdateStockServlet")
public class MerchantUpdateStockServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        // 1. 严格鉴权：只有商家本人能改自己的库存
        String role = (String) session.getAttribute("userRole");
        if (role == null || !"merchant".equals(role)) {
            response.getWriter().print("<script>alert('非法访问！'); location.href='login.jsp';</script>");
            return;
        }

        try {
            int merchantId = (int) session.getAttribute("userId");
            int productId = Integer.parseInt(request.getParameter("productId"));
            int stock = Integer.parseInt(request.getParameter("stock"));

            if (stock < 0) {
                response.getWriter().print("<script>alert('库存不能为负数！'); location.href='MerchantDashboardServlet';</script>");
                return;
            }

            ProductDao dao = new ProductDao();
            // 核心：带 merchant_id 的更新，改不动别家商品
            if (dao.updateStockByMerchant(productId, stock, merchantId)) {
                response.getWriter().print("<script>alert('库存已更新为 " + stock + " 件！'); location.href='MerchantDashboardServlet';</script>");
            } else {
                response.getWriter().print("<script>alert('更新失败：该商品不存在或不属于您！'); location.href='MerchantDashboardServlet';</script>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().print("<script>alert('系统繁忙，请稍后再试！'); location.href='MerchantDashboardServlet';</script>");
        }
    }
}
