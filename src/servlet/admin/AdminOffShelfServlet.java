package servlet.admin;

import dao.ProductDao;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/AdminOffShelfServlet")
public class AdminOffShelfServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        // 鉴权防护
        if (!"admin".equals(session.getAttribute("userRole"))) {
            return;
        }

        int productId = Integer.parseInt(request.getParameter("productId"));
        ProductDao dao = new ProductDao();

        // 核心变更：将商品状态强制修改为 off_sale (下架)
        dao.changeProductStatus(productId, "off_sale");

        // 状态更新完毕后，重定向刷新管理大盘
        response.sendRedirect("AdminDashboardServlet");
    }
}