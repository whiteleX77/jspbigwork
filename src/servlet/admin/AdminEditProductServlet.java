package servlet.admin;

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

@WebServlet("/AdminEditProductServlet")
@MultipartConfig(maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class AdminEditProductServlet extends HttpServlet {

    // 动作1：处理点击“编辑”按钮时的跳转，把旧数据查出来铺到页面上
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (!"admin".equals(session.getAttribute("userRole"))) return;

        int productId = Integer.parseInt(request.getParameter("id"));
        ProductDao dao = new ProductDao();
        Product product = dao.getProductById(productId);

        request.setAttribute("product", product);
        request.getRequestDispatcher("adminEditProduct.jsp").forward(request, response);
    }

    // 动作2：处理表单的修改提交
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        if (!"admin".equals(session.getAttribute("userRole"))) return;

        Product p = new Product();
        p.setProductId(Integer.parseInt(request.getParameter("productId"))); // 必须获取隐藏的ID
        p.setName(request.getParameter("name"));
        p.setCategory(request.getParameter("category"));
        p.setBrand(request.getParameter("brand"));
        p.setDescription(request.getParameter("description"));
        p.setPrice(Double.parseDouble(request.getParameter("price")));
        p.setStock(Integer.parseInt(request.getParameter("stock")));

        // 巧妙处理图片：如果管理员没选新图，就用隐藏域传过来的老图
        String oldImage = request.getParameter("oldImage");
        Part filePart = request.getPart("mainImage");

        if (filePart != null && filePart.getSize() > 0) {
            // 上传了新图，处理新图保存
            String originalName = filePart.getSubmittedFileName();
            String ext = originalName.substring(originalName.lastIndexOf("."));
            String newFileName = "prod_" + System.currentTimeMillis() + ext;
            String uploadPath = getServletContext().getRealPath("/") + "images" + File.separator + "products";
            File dir = new File(uploadPath);
            if (!dir.exists()) dir.mkdirs();
            filePart.write(uploadPath + File.separator + newFileName);

            p.setMainImage(newFileName); // 用新图
        } else {
            p.setMainImage(oldImage); // 没选新图，保留老图
        }

        ProductDao dao = new ProductDao();
        if (dao.updateProduct(p)) {
            response.getWriter().print("<script>alert('商品修改成功！'); location.href='AdminDashboardServlet';</script>");
        } else {
            response.getWriter().print("<script>alert('修改失败！'); history.back();</script>");
        }
    }
}