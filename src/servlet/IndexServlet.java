package servlet;

import bean.Product;
import dao.ProductDao;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/IndexServlet")
public class IndexServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 解决 GET 请求可能出现的中文搜索乱码
        request.setCharacterEncoding("UTF-8");

        // 1. 获取前端传来的查询条件
        String keyword = request.getParameter("keyword");
        String category = request.getParameter("category");

        // 2. 调用刚才写的动态查询方法
        ProductDao dao = new ProductDao();
        List<Product> productList = dao.getProductsByCondition(keyword, category);

        // 3. 将商品数据发送给前台
        request.setAttribute("productList", productList);

        // 🌟 UX 优化：把搜索条件也传回前端，这样页面刷新后，搜索框里还能保留用户刚才搜的字！
        request.setAttribute("keyword", keyword == null ? "" : keyword);
        request.setAttribute("category", category == null ? "全部" : category);

        // 4. 转发到首页视图
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    // 兼容 POST 请求，统一抛给 doGet 处理
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}