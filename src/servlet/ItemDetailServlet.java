package servlet;

import bean.Product;
import bean.User;
import bean.Review;
import dao.ProductDao;
import dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/ItemDetailServlet")
public class ItemDetailServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("IndexServlet");
            return;
        }

        int productId = Integer.parseInt(idStr);
        ProductDao productDao = new ProductDao();
        UserDao userDao = new UserDao();

        // 1. 获取当前商品详细信息
        Product product = productDao.getProductById(productId);

        if (product != null) {
            // 2. 🌟 抓取该商品背后的“掌柜/店铺”信息
            User merchant = userDao.getUserById(product.getMerchantId());

            // 3. 🌟 抓取本店的其他商品（排除当前正在看的这件）
            List<Product> shopProducts = productDao.getShopOtherProducts(product.getMerchantId(), productId);

            // 4. 🌟 抓取该商品的全部评价历史
            List<Review> reviews = productDao.getReviewsByProduct(productId);

            // 5. 核心：打包所有数据，发往 JSP 页面！
            request.setAttribute("product", product);
            request.setAttribute("merchant", merchant); // 店铺信息
            request.setAttribute("shopProducts", shopProducts); // 同店推荐
            request.setAttribute("reviews", reviews); // 评价列表

            request.getRequestDispatcher("detail.jsp").forward(request, response);
        } else {
            response.sendRedirect("IndexServlet");
        }
    }
}