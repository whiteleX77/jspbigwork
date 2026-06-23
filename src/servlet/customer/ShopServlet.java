package servlet.customer;

import bean.Product;
import bean.User;
import dao.ProductDao;
import dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/ShopServlet")
public class ShopServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("merchantId");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("IndexServlet");
            return;
        }

        int merchantId = Integer.parseInt(idStr);
        User shop = new UserDao().getUserById(merchantId);
        List<Product> products = new ProductDao().getOnSaleProductsByMerchant(merchantId);

        if (shop != null) {
            request.setAttribute("shop", shop);
            request.setAttribute("products", products);
            request.getRequestDispatcher("shop.jsp").forward(request, response);
        } else {
            response.sendRedirect("IndexServlet");
        }
    }
}