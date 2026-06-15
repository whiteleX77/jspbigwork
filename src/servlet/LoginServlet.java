package servlet;

import bean.User;
import dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 设置编码
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 2. 接收前端输入框的值
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String code = request.getParameter("code");

        // 3. 🌟 验证码校验与控制台断点追踪
        HttpSession session = request.getSession();
        String sessionCode = (String) session.getAttribute("piccode");

        // 🚀 【核心调试锚点】运行后请死盯 IDEA 下方的 Tomcat 控制台输出！
        System.out.println("================= 登录验证码追踪 =================");
        System.out.println("[前端传过来的验证码] code = " + code);
        System.out.println("[Session中存的验证码] sessionCode = " + sessionCode);
        System.out.println("=================================================");

        // 判空并且使用 equalsIgnoreCase 忽略大小写
        if (sessionCode == null || code == null || !sessionCode.equalsIgnoreCase(code)) {
            response.getWriter().print("<script>alert('验证码输入错误，请重新输入！'); history.back();</script>");
            return;
        }

        // 4. 智能身份识别逻辑
        UserDao userDao = new UserDao();
        User user = userDao.login(username, password);

        if (user != null) {
            // 核对成功！写入 Session
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userName", user.getUsername());
            session.setAttribute("userRole", user.getRole());

            // 🌟 智能三线分发路由
            if ("admin".equals(user.getRole())) {
                // 总管理员 -> 宏观数据大盘
                response.getWriter().print("<script>alert('欢迎回来，系统总管！'); location.href='AdminDashboardServlet';</script>");
            } else if ("merchant".equals(user.getRole())) {
                // 入驻商家 -> 商家专属工作台
                response.getWriter().print("<script>alert('欢迎掌柜回来！'); location.href='MerchantDashboardServlet';</script>");
            } else {
                // 普通客户 -> 前台购物大厅
                response.getWriter().print("<script>alert('登录成功！'); location.href='IndexServlet';</script>");
            }
        } else {
            response.getWriter().print("<script>alert('用户名或密码错误，请检查！'); history.back();</script>");
        }
    }
}