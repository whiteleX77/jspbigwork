<%--
  Created by IntelliJ IDEA.
  User: WHITE
  Date: 2026/5/31
  Time: 19:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  // 🚨 严格安检：不是商家，绝对不让进进货后台！
  String role = (String) session.getAttribute("userRole");
  if (role == null || !"merchant".equals(role)) {
    response.sendRedirect("login.jsp");
    return;
  }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <title>上架新商品 - 卖家工作台</title>
  <style>
    :root { --apple-blue: #0071e3; --text-main: #1d1d1f; --text-sec: #86868b; --glass-bg: rgba(255, 255, 255, 0.65); --glass-border: 1px solid rgba(255, 255, 255, 0.4); --glass-blur: blur(25px); }
    body { font-family: -apple-system, BlinkMacSystemFont, sans-serif; background-color: #f5f5f7; background-image: radial-gradient(at 0% 0%, #e5f0fb 0px, transparent 50%), radial-gradient(at 100% 100%, #e2d1f9 0px, transparent 50%); background-attachment: fixed; margin: 0; padding: 60px 20px; color: var(--text-main); -webkit-font-smoothing: antialiased; }

    .navbar { background: var(--glass-bg); backdrop-filter: var(--glass-blur); -webkit-backdrop-filter: var(--glass-blur); border: var(--glass-border); width: calc(100% - 40px); max-width: 900px; margin: -20px auto 40px; padding: 15px 30px; border-radius: 50px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 10px 30px rgba(0,0,0,0.05); position: sticky; top: 20px; z-index: 100; }
    .navbar a { text-decoration: none; color: var(--text-sec); font-weight: 600; font-size: 15px; transition: 0.2s; }
    .navbar a:hover { color: var(--apple-blue); }

    .publish-card { background: var(--glass-bg); backdrop-filter: var(--glass-blur); -webkit-backdrop-filter: var(--glass-blur); border: var(--glass-border); max-width: 800px; margin: 0 auto; padding: 50px; border-radius: 32px; box-shadow: 0 20px 50px rgba(0,0,0,0.06); }
    .page-title { font-size: 32px; font-weight: 700; margin-bottom: 40px; letter-spacing: -0.5px; display: flex; align-items: center; gap: 12px; }

    .form-group { margin-bottom: 25px; }
    .form-group label { display: block; margin-bottom: 10px; font-weight: 600; font-size: 14px; }
    .form-control { width: 100%; padding: 16px 20px; background: rgba(255, 255, 255, 0.5); border: 1px solid rgba(0,0,0,0.05); border-radius: 16px; box-sizing: border-box; font-size: 15px; transition: 0.3s; outline: none; font-family: inherit; }
    .form-control:focus { background: #fff; border-color: var(--apple-blue); box-shadow: 0 0 0 4px rgba(0,113,227,0.15); }

    select.form-control { appearance: none; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" stroke="%2386868b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M6 9l6 6 6-6"/></svg>'); background-repeat: no-repeat; background-position: right 20px center; }
    .grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }

    .file-upload-box { background: rgba(255, 255, 255, 0.4); border: 2px dashed rgba(0,0,0,0.1); padding: 30px; text-align: center; border-radius: 16px; transition: 0.3s; margin-top: 10px; }
    .file-upload-box:hover { border-color: var(--apple-blue); background: rgba(0,113,227,0.03); }

    .btn-submit { background: var(--apple-blue); color: #fff; border: none; padding: 18px; width: 100%; border-radius: 18px; font-size: 17px; font-weight: 600; cursor: pointer; transition: 0.3s; margin-top: 30px; box-shadow: 0 4px 15px rgba(0,113,227,0.2); }
    .btn-submit:hover { background: #0077ed; transform: translateY(-2px); box-shadow: 0 8px 25px rgba(0,113,227,0.3); }
  </style>
</head>
<body>

<div class="navbar">
  <a href="MerchantDashboardServlet">⬅ 返回卖家工作台</a>
  <span style="font-weight: 700; color: #1d1d1f;">📦 商家进货与上架中心</span>
</div>

<div class="publish-card">
  <div class="page-title">录入新商品信息</div>

  <form action="MerchantAddProductServlet" method="post" enctype="multipart/form-data">

    <div class="form-group">
      <label>商品名称 (Name)</label>
      <input type="text" name="name" class="form-control" placeholder="请输入完整、吸引人的商品名称" required>
    </div>

    <div class="grid-2">
      <div class="form-group">
        <label>商品分类 (Category)</label>
        <select name="category" class="form-control" required>
          <option value="电子数码">📱 电子数码</option>
          <option value="图书音像">📚 图书音像</option>
          <option value="日用百货">📦 日用百货</option>
          <option value="服饰箱包">👗 服饰箱包</option>
          <option value="食品生鲜">🍎 食品生鲜</option>
        </select>
      </div>
      <div class="form-group">
        <label>品牌 (Brand)</label>
        <input type="text" name="brand" class="form-control" placeholder="如：Apple、华为 (选填)">
      </div>
    </div>

    <div class="grid-2">
      <div class="form-group">
        <label>零售单价 (Price - ￥)</label>
        <input type="number" step="0.01" name="price" class="form-control" placeholder="0.00" required>
      </div>
      <div class="form-group">
        <label>初始入库数量 (Stock)</label>
        <input type="number" name="stock" class="form-control" placeholder="请输入实际库存数量" required>
      </div>
    </div>

    <div class="form-group">
      <label>商品图文描述 (Description)</label>
      <textarea name="description" class="form-control" rows="4" placeholder="请输入详细的商品参数、卖点及售后说明..."></textarea>
    </div>

    <div class="form-group">
      <label>商品主图上传 (Main Image)</label>
      <div class="file-upload-box">
        <input type="file" name="mainImage" accept="image/*" required style="font-size: 14px; color: var(--text-sec);">
        <div style="font-size: 12px; color: var(--text-sec); margin-top: 10px;">建议上传 800x800 像素的高清白底图片</div>
      </div>
    </div>

    <button type="submit" class="btn-submit">💾 确认上架并开始售卖</button>
  </form>
</div>

</body>
</html>