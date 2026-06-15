<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, bean.Product" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <title>官方自营商城</title>
  <style>
    :root {
      --apple-blue: #0071e3;
      --apple-text: #1d1d1f;
      --apple-text-secondary: #86868b;
      --glass-bg: rgba(255, 255, 255, 0.65);
      --glass-border: 1px solid rgba(255, 255, 255, 0.4);
      --glass-blur: blur(25px);
      --webkit-glass-blur: blur(25px);
    }

    /* 🌟 核心修改：合并渐显动画与背景呼吸动画 */
    body {
      font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", "Helvetica Neue", sans-serif;
      margin: 0; padding: 0; min-height: 100vh;
      color: var(--apple-text, #1d1d1f);
      -webkit-font-smoothing: antialiased;
      background: linear-gradient(-45deg, #f5f5f7, #e2d1f9, #e5f0fb, #d4e4f7);
      background-size: 400% 400%;
      animation: pageFadeIn 0.5s cubic-bezier(0.16, 1, 0.3, 1) forwards, fluidGradient 15s ease infinite;
    }

    @keyframes fluidGradient {
      0% { background-position: 0% 50%; }
      50% { background-position: 100% 50%; }
      100% { background-position: 0% 50%; }
    }

    /* 页面载入渐显 */
    @keyframes pageFadeIn {
      from { opacity: 0; transform: translateY(15px) scale(0.98); }
      to { opacity: 1; transform: translateY(0) scale(1); }
    }

    /* 页面离开渐隐 */
    .page-fade-out {
      opacity: 0 !important;
      transform: translateY(-10px) scale(0.98) !important;
      transition: opacity 0.3s ease, transform 0.3s ease !important;
    }

    a { text-decoration: none; color: inherit; transition: 0.3s cubic-bezier(0.4, 0, 0.2, 1); }

    .navbar {
      background: var(--glass-bg); backdrop-filter: var(--glass-blur); -webkit-backdrop-filter: var(--webkit-glass-blur); border: var(--glass-border);
      width: calc(100% - 60px); max-width: 1200px; margin: 25px auto; padding: 15px 35px; border-radius: 50px;
      display: flex; justify-content: space-between; align-items: center; box-shadow: 0 10px 40px rgba(0,0,0,0.06);
      position: sticky; top: 25px; z-index: 1000; transition: 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    }
    .navbar:hover { transform: scale(1.01); box-shadow: 0 15px 45px rgba(0,0,0,0.1); }
    .logo { font-size: 20px; font-weight: 700; display: flex; align-items: center; gap: 8px; letter-spacing: -0.5px; }
    .nav-links { display: flex; gap: 25px; align-items: center; font-size: 14px; font-weight: 600; }
    .nav-links a { color: var(--apple-text-secondary); }
    .nav-links a:hover { color: var(--apple-text); }
    .btn-admin { background: rgba(0,0,0,0.05); padding: 8px 16px; border-radius: 20px; color: var(--apple-text) !important; }
    .btn-admin:hover { background: rgba(0,0,0,0.1); }

    .container { max-width: 1200px; margin: 40px auto; padding: 0 20px; }
    .search-panel {
      background: var(--glass-bg); backdrop-filter: var(--glass-blur); -webkit-backdrop-filter: var(--glass-blur); border: var(--glass-border);
      padding: 20px 30px; border-radius: 24px; box-shadow: 0 10px 30px rgba(0,0,0,0.04); margin-bottom: 40px; display: flex; justify-content: space-between; align-items: center;
    }
    .search-form { display: flex; gap: 15px; width: 100%; max-width: 800px; margin: 0 auto; }
    .search-select, .search-input {
      padding: 14px 20px; border: 1px solid rgba(0,0,0,0.05); border-radius: 16px; font-size: 15px; background: rgba(255,255,255,0.5); outline: none; transition: 0.3s; color: var(--apple-text); font-family: inherit;
    }
    .search-select:focus, .search-input:focus { background: #fff; border-color: var(--apple-blue); box-shadow: 0 0 0 4px rgba(0,113,227,0.15); }
    .search-input { flex: 1; }
    select.search-select {
      appearance: none; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" stroke="%2386868b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M6 9l6 6 6-6"/></svg>');
      background-repeat: no-repeat; background-position: right 15px center; padding-right: 40px; font-weight: 500;
    }
    .search-btn {
      background: var(--apple-blue); color: white; border: none; padding: 14px 30px; border-radius: 16px; font-size: 15px; font-weight: 600; cursor: pointer; transition: 0.3s; box-shadow: 0 4px 15px rgba(0,113,227,0.2);
    }
    .search-btn:hover { background: #0077ed; transform: translateY(-2px); box-shadow: 0 8px 25px rgba(0,113,227,0.3); }

    .section-title { font-size: 28px; font-weight: 700; margin-bottom: 30px; letter-spacing: -0.5px; }
    .item-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 30px; }
    .item-card {
      background: rgba(255, 255, 255, 0.4); backdrop-filter: blur(15px); -webkit-backdrop-filter: blur(15px); border: 1px solid rgba(255, 255, 255, 0.5); border-radius: 24px; overflow: hidden; transition: 0.4s cubic-bezier(0.4, 0, 0.2, 1); box-shadow: 0 10px 30px rgba(0,0,0,0.04);
    }
    .item-card:hover { transform: translateY(-8px) scale(1.02); background: rgba(255, 255, 255, 0.8); box-shadow: 0 20px 40px rgba(0,0,0,0.1); }
    .item-img-box { width: 100%; height: 260px; display: flex; justify-content: center; align-items: center; background: rgba(255,255,255,0.3); overflow: hidden; }
    .item-img-box img { width: 100%; height: 100%; object-fit: cover; transition: 0.6s cubic-bezier(0.4, 0, 0.2, 1); }
    .item-card:hover .item-img-box img { transform: scale(1.06); }
    .item-info { padding: 22px; }
    .item-price { color: var(--apple-text); font-size: 24px; font-weight: 700; margin-bottom: 10px; letter-spacing: -0.5px; }
    .item-price::before { content: '¥'; font-size: 16px; margin-right: 2px; font-weight: 600; }
    .item-title { font-size: 16px; font-weight: 600; color: var(--apple-text); height: 44px; overflow: hidden; margin-bottom: 12px; line-height: 1.4; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; }
    .item-title::before { content: '自营'; background: rgba(0,0,0,0.05); color: var(--apple-text-secondary); font-size: 11px; font-weight: 700; padding: 3px 6px; border-radius: 6px; margin-right: 6px; vertical-align: middle; }
    .item-stock { font-size: 13px; color: var(--apple-text-secondary); font-weight: 600; }
  </style>
</head>
<body>

<div class="navbar">
  <div class="logo">自营商城</div>
  <div class="nav-links">
    <a href="IndexServlet">刷新大厅</a>
    <a href="support.jsp" style="color: var(--apple-text-secondary); transition: 0.2s;" onmouseover="this.style.color='var(--apple-blue)'" onmouseout="this.style.color='var(--apple-text-secondary)'">👩‍💻 售后服务</a>
    <% if(session.getAttribute("userName") == null) { %>
    <a href="login.jsp" style="background: var(--apple-text); color: white; padding: 8px 18px; border-radius: 20px;">登录/注册</a>
    <% } else { %>
    <span style="color: var(--apple-text-secondary);">Hi, <%= session.getAttribute("userName") %></span>
    <% if("admin".equals(session.getAttribute("userRole"))) { %>
    <a href="AdminDashboardServlet" class="btn-admin">进入后台中枢</a>
    <% } %>
    <a href="MyOrdersServlet" style="color: var(--apple-blue);">我的订单</a>
    <a href="LogoutServlet" style="color: #ff3b30;" onclick="return confirm('确定要退出登录吗？')">退出</a>
    <% } %>
  </div>
</div>

<div class="container">
  <div class="search-panel">
    <%
      String currentKeyword = (String) request.getAttribute("keyword");
      String currentCategory = (String) request.getAttribute("category");
    %>
    <form action="IndexServlet" method="get" class="search-form">
      <select name="category" class="search-select">
        <option value="全部" <%= "全部".equals(currentCategory) ? "selected" : "" %>>所有分类</option>
        <option value="电子数码" <%= "电子数码".equals(currentCategory) ? "selected" : "" %>>电子数码</option>
        <option value="图书音像" <%= "图书音像".equals(currentCategory) ? "selected" : "" %>>图书音像</option>
      </select>
      <input type="text" name="keyword" class="search-input" placeholder="输入您想找的商品名称..." value="<%= currentKeyword != null ? currentKeyword : "" %>">
      <button type="submit" class="search-btn">开始搜索</button>
    </form>
  </div>

  <div class="section-title">为你推荐</div>

  <div class="item-grid">
    <%
      List<Product> productList = (List<Product>) request.getAttribute("productList");
      if(productList != null && !productList.isEmpty()) {
        for(Product p : productList) {
    %>
    <a href="ItemDetailServlet?id=<%= p.getProductId() %>" class="item-card">
      <div class="item-img-box">
        <img src="images/products/<%= p.getMainImage() %>" onerror="this.src='images/default.png'">
      </div>
      <div class="item-info">
        <div class="item-price"><%= p.getPrice() %></div>
        <div class="item-title"><%= p.getName() %></div>
        <div class="item-stock">剩余 <%= p.getStock() %> 件</div>
      </div>
    </a>
    <% } } else {
      out.print("<div style='grid-column: 1/-1; text-align:center; padding: 100px 0; color: #86868b; font-size: 16px; font-weight: 500;'>未找到匹配的商品，请更换关键词试试</div>");
    }
    %>
  </div>
</div>

<script>
  document.addEventListener("DOMContentLoaded", function() {
    // 排除掉自带 onclick 动作的链接（如确认退出框），防止 JS 冲突
    const links = document.querySelectorAll('a[href]:not([target="_blank"]):not([onclick])');
    links.forEach(link => {
      link.addEventListener('click', function(e) {
        const targetUrl = this.getAttribute('href');
        // 排除锚点和无效链接
        if(targetUrl && !targetUrl.startsWith('#') && !targetUrl.startsWith('javascript:')) {
          e.preventDefault();
          document.body.classList.add('page-fade-out'); // 触发淡出
          setTimeout(() => { window.location.href = targetUrl; }, 300); // 等待淡出完成后跳转
        }
      });
    });
  });
</script>
</body>
</html>