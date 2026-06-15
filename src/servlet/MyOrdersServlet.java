package servlet;

import bean.OrderVO;
import dao.OrderDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/MyOrdersServlet")
public class MyOrdersServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().print("<script>alert('请先登录！'); location.href='login.jsp';</script>");
            return;
        }

        OrderDao orderDao = new OrderDao();
        // 这里的 getOrdersByUserId 就是刚才咱们在 DAO 里升级过的连表查询方法
        List<OrderVO> myOrders = orderDao.getOrdersByUserId(userId);

        request.setAttribute("myOrders", myOrders);
        // 🌟 完美对接你原本的 jsp 文件名
        request.getRequestDispatcher("myOrders.jsp").forward(request, response);
    }
}