package servlet;

import bean.OrderVO;
import bean.Product;
import dao.OrderDao;
import dao.ProductDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/BuyServlet")
public class BuyServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();

        // 1. 安全校验：必须是登录用户才能买东西
        if (session.getAttribute("userId") == null) {
            response.getWriter().print("<script>alert('请先登录后再购买！'); location.href='login.jsp';</script>");
            return;
        }

        try {
            int buyerId = (int) session.getAttribute("userId");
            int productId = Integer.parseInt(request.getParameter("productId"));
            double price = Double.parseDouble(request.getParameter("price"));
            String buyerPhone = request.getParameter("buyerPhone");
            String shippingAddress = request.getParameter("shippingAddress");

            ProductDao productDao = new ProductDao();
            Product product = productDao.getProductById(productId);

            if (product != null && product.getStock() > 0) {
                // 2. 扣减库存
                product.setStock(product.getStock() - 1);
                productDao.updateProduct(product); // 假设你有 updateProduct 方法，如果没有可以先注释掉这行

                // 🌟 3. 封装 OrderVO 对象
                OrderVO order = new OrderVO();
                // 自动生成唯一流水号：ORD + 毫秒时间戳
                order.setOrderNo("ORD" + System.currentTimeMillis());
                order.setBuyerId(buyerId);
                // 核心：从查出来的商品身上，把它的卖家ID剥离出来，塞给订单！
                order.setMerchantId(product.getMerchantId());
                order.setProductId(productId);
                order.setTotalPrice(price);
                order.setBuyerPhone(buyerPhone);
                order.setShippingAddress(shippingAddress);

                // 🌟 4. 调用 Dao 将订单写入数据库
                OrderDao orderDao = new OrderDao();
                if (orderDao.createOrder(order)) {
                    // 付款成功后，直接把买家踢到“我的订单”页面去盯物流
                    response.getWriter().print("<script>alert('支付成功！掌柜正在快马加鞭为您备货！'); location.href='MyOrdersServlet';</script>");
                } else {
                    response.getWriter().print("<script>alert('订单生成失败，系统异常！'); history.back();</script>");
                }
            } else {
                response.getWriter().print("<script>alert('手慢了，该商品已售罄或下架！'); history.back();</script>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().print("<script>alert('系统繁忙，请稍后再试！'); history.back();</script>");
        }
    }
}