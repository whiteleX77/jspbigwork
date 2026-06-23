package servlet.Merchant;

import bean.Product;
import dao.ProductDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

@WebServlet("/MerchantAddProductServlet")
@MultipartConfig // 🚨 必须加这个注解才能处理图片上传！
public class MerchantAddProductServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();

        // 1. 严格安检：确保只有 merchant 才能进货
        if (!"merchant".equals(session.getAttribute("userRole"))) {
            response.getWriter().print("<script>alert('非法操作！您不是入驻商家。'); location.href='login.jsp';</script>");
            return;
        }

        // 🌟 2. 核心：提取当前商家的 ID！(咱们系统里的 userId 就是 merchantId)
        int merchantId = (int) session.getAttribute("userId");

        try {
            // 3. 提取表单普通文字数据
            String name = request.getParameter("name");
            String category = request.getParameter("category");
            String brand = request.getParameter("brand");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));

            // 4. 处理图片上传
            Part filePart = request.getPart("mainImage");
            String fileName = "no_image.png"; // 默认兜底图

            if (filePart != null && filePart.getSize() > 0) {
                // 生成一个不重复的文件名防覆盖 (UUID + 原本的后缀名)
                String submittedFileName = filePart.getSubmittedFileName();
                String extension = submittedFileName.substring(submittedFileName.lastIndexOf("."));
                fileName = UUID.randomUUID().toString() + extension;

                // 获取 Tomcat 的运行目录下的 images/products/
                String uploadPath = getServletContext().getRealPath("/") + "images" + File.separator + "products";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                // 将图片写入服务器硬盘
                filePart.write(uploadPath + File.separator + fileName);
            }

            // 5. 封装进 JavaBean
            Product p = new Product();
            p.setMerchantId(merchantId); // 🌟 给商品打上商家的思想钢印！
            p.setName(name);
            p.setCategory(category);
            p.setBrand(brand);
            p.setDescription(description);
            p.setPrice(price);
            p.setStock(stock);
            p.setMainImage(fileName);

            // 6. 调用 DAO 入库
            ProductDao dao = new ProductDao();
            if (dao.addProduct(p)) {
                response.getWriter().print("<script>alert('商品上架成功！可以开始赚钱啦！'); location.href='MerchantDashboardServlet';</script>");
            } else {
                response.getWriter().print("<script>alert('数据库繁忙，上架失败，请重试。'); history.back();</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().print("<script>alert('系统遇到未知错误，请检查输入格式。'); history.back();</script>");
        }
    }
}