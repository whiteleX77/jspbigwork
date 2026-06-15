package servlet;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取当前已存在的会话对象，若不存在则不创建新会话
        HttpSession session = request.getSession(false);
        if (session != null) {
            // 彻底销毁当前 Session 会话，释放服务器内存，清除登录态凭证
            session.invalidate();
        }
        // 清洗完毕后，重定向并刷新整个首页大厅
        response.sendRedirect("IndexServlet");
    }
}