<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="bean.Product" %>
<%
    if (!"admin".equals(session.getAttribute("userRole"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    Product p = (Product) request.getAttribute("product");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>修改商品信息 - 系统总后台</title>
    <style>
        :root { --primary-color: #1890ff; --bg-color: #f4f7f6; }
        body { font-family: 'Segoe UI', 'Microsoft YaHei', sans-serif; background-color: var(--bg-color); margin: 0; padding: 40px 20px; }
        .navbar { background: #fff; padding: 15px 50px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 8px rgba(0,0,0,0.05); position: fixed; top: 0; left: 0; right: 0; z-index: 100; }
        .navbar a { text-decoration: none; color: #555; font-weight: bold; font-size: 15px; }
        .publish-card { max-width: 800px; margin: 60px auto 0; background: #fff; padding: 40px; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); }
        .page-title { font-size: 22px; font-weight: bold; margin-bottom: 30px; border-bottom: 2px solid #f0f2f5; padding-bottom: 15px; color: #2c3e50; display: flex; align-items: center; }
        .page-title::before { content: ''; display: inline-block; width: 5px; height: 22px; background: var(--primary-color); margin-right: 10px; border-radius: 3px; }
        .form-group { margin-bottom: 25px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: bold; color: #555; font-size: 14px; }
        .form-control { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px; box-sizing: border-box; font-size: 14px; background: #fafafa; }
        .grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .btn-submit { background: var(--primary-color); color: #fff; border: none; padding: 15px; width: 100%; border-radius: 6px; font-size: 16px; font-weight: bold; cursor: pointer; margin-top: 10px; }
        .file-upload-box { border: 2px dashed #d9d9d9; padding: 30px; text-align: center; border-radius: 6px; background: #fafafa; }
    </style>
</head>
<body>

<div class="navbar">
    <a href="AdminDashboardServlet">⬅ 返回后台数据大盘</a>
    <span style="font-weight: bold; color: #333;">📦 修改在库商品数据</span>
</div>

<div class="publish-card">
    <div class="page-title">修改商品【#<%= p.getProductId() %>】</div>

    <form action="AdminEditProductServlet" method="post" enctype="multipart/form-data">
        <input type="hidden" name="productId" value="<%= p.getProductId() %>">
        <input type="hidden" name="oldImage" value="<%= p.getMainImage() %>">

        <div class="form-group">
            <label>商品名称 (Name)</label>
            <input type="text" name="name" class="form-control" value="<%= p.getName() %>" required>
        </div>

        <div class="grid-2">
            <div class="form-group">
                <label>商品分类 (Category)</label>
                <select name="category" class="form-control" required>
                    <option value="<%= p.getCategory() %>">当前：<%= p.getCategory() %></option>
                    <option value="电子数码">电子数码</option>
                    <option value="图书音像">图书音像</option>
                    <option value="日用百货">日用百货</option>
                    <option value="服饰箱包">服饰箱包</option>
                    <option value="食品生鲜">食品生鲜</option>
                </select>
            </div>
            <div class="form-group">
                <label>品牌 (Brand)</label>
                <input type="text" name="brand" class="form-control" value="<%= p.getBrand() != null ? p.getBrand() : "" %>">
            </div>
        </div>

        <div class="grid-2">
            <div class="form-group">
                <label>零售单价 (Price - ￥)</label>
                <input type="number" step="0.01" name="price" class="form-control" value="<%= p.getPrice() %>" required>
            </div>
            <div class="form-group">
                <label>修正库存数量 (Stock)</label>
                <input type="number" name="stock" class="form-control" value="<%= p.getStock() %>" required>
            </div>
        </div>

        <div class="form-group">
            <label>商品图文描述 (Description)</label>
            <textarea name="description" class="form-control" rows="5"><%= p.getDescription() != null ? p.getDescription() : "" %></textarea>
        </div>

        <div class="form-group">
            <label>修改主图 (选填，不选则保留原图)</label>
            <div class="file-upload-box">
                <div style="margin-bottom: 10px;">
                    <img src="images/products/<%= p.getMainImage() %>" style="width: 80px; height: 80px; object-fit: cover; border-radius: 4px; border: 1px solid #ddd;">
                </div>
                <div style="color: #888; font-size: 13px;">若需替换上方的原始图片，请点击下方选择新图。</div>
                <input type="file" name="mainImage" accept="image/*">
            </div>
        </div>

        <button type="submit" class="btn-submit">💾 确认保存修改</button>
    </form>
</div>

</body>
</html>