package servlet;

import bean.User;
import dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String realName = request.getParameter("realName");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role"); // 🌟 抓取用户选择的身份

        UserDao userDao = new UserDao();

        // 1. 防重名校验
        if (userDao.checkUsernameExist(username)) {
            response.getWriter().print("<script>alert('该账号已被注册，换一个试试吧！'); history.back();</script>");
            return;
        }

        // 2. 封装数据
        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setRealName(realName);
        user.setPhone(phone);
        user.setRole(role); // 🌟 写入身份

        // 3. 执行入库
        if (userDao.insertUser(user)) {
            response.getWriter().print("<script>alert('注册成功！请使用新账号登录。'); location.href='login.jsp';</script>");
        } else {
            response.getWriter().print("<script>alert('系统繁忙，注册失败，请稍后再试。'); history.back();</script>");
        }
    }
}