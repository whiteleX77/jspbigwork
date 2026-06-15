package util;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.Random;
import javax.imageio.ImageIO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ImageServlet")
public class ImageServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("image/jpeg");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Cache-Control", "no-cache");
        response.setDateHeader("Expires", 0);

        int width = 100, height = 35;
        BufferedImage bim = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        Graphics g = bim.getGraphics();
        Random rm = new Random();

        // 背景色
        g.setColor(new Color(rm.nextInt(50) + 200, rm.nextInt(50) + 200, rm.nextInt(50) + 200));
        g.fillRect(0, 0, width, height);

        // 纯英文和数字的字符池
        String baseChars = "23456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz";
        StringBuffer sbf = new StringBuffer("");
        g.setFont(new Font("Arial", Font.BOLD | Font.ITALIC, 22));

        for (int i = 0; i < 4; i++) {
            int index = rm.nextInt(baseChars.length());
            char c = baseChars.charAt(index);
            sbf.append(c);
            g.setColor(new Color(rm.nextInt(120), rm.nextInt(120), rm.nextInt(120)));
            g.drawString(String.valueOf(c), i * 20 + 10, 26);
        }

        // 存入 Session
        HttpSession session = request.getSession(true);
        session.setAttribute("piccode", sbf.toString().toLowerCase()); // 统一转小写，方便比对

        ImageIO.write(bim, "JPG", response.getOutputStream());
        response.getOutputStream().close();
    }
}