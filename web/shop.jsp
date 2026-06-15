<%--
  Created by IntelliJ IDEA.
  User: WHITE
  Date: 2026/5/31
  Time: 20:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="bean.Product, bean.User, java.util.List" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <title>店铺主页 - 自营商城</title>
  <style>
    :root { --apple-blue: #0071e3; --bg-color: #f5f5f7; }
    body { font-family: -apple-system, BlinkMacSystemFont, sans-serif; background-color: var(--bg-color); margin: 0; padding: 0; -webkit-font-smoothing: antialiased; }
    .navbar { background: rgba(255,255,255,0.8); backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px); padding: 15px 50px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); position: sticky; top: 0; z-index: 100;}
    .navbar a { text-decoration: none; color: #333; font-weight: bold; }

    .shop-header { max-width: 1000px; margin: 40px auto; background: #fff; border-radius: 24px; padding: 40px; text-align: center; box-shadow: 0 10px 30px rgba(0,0,0,0.04); }
    .shop-avatar { width: 80px; height: 80px; background: var(--apple-blue); color: white; border-radius: 50%; margin: 0 auto 15px; display: flex; justify-content: center; align-items: center; font-size: 36px; font-weight: bold; box-shadow: 0 10px 20px rgba(0,113,227,0.2); }

    .product-grid { max-width: 1000px; margin: 0 auto 50px; display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 25px; }
    .product-card { background: #fff; border-radius: 16px; overflow: hidden; text-decoration: none; display: block; box-shadow: 0 4px 15px rgba(0,0,0,0.03); transition: 0.3s; }
    .product-card:hover { transform: translateY(-5px); box-shadow: 0 15px 30px rgba(0,0,0,0.08); }
    .product-img { width: 100%; height: 220px; object-fit: cover; }
    .product-info { padding: 18px; }
  </style>
</head>

<body>

<div class="navbar"><a href="IndexServlet">⬅ 返回商城大厅</a></div>

<% User shop = (User) request.getAttribute("shop"); %>
<% if(shop != null) { %>
<div class="shop-header">
  <div class="shop-avatar"><%= shop.getRealName().substring(0, 1) %></div>
  <h1 style="margin:0; color:#1d1d1f; letter-spacing: -1px;"><%= shop.getRealName() %> 的专营店</h1>
  <p style="color:#86868b; margin-top:10px; font-weight: 600;">官方认证入驻商家</p>
</div>

<div class="product-grid">
  <% List<Product> products = (List<Product>) request.getAttribute("products"); %>
  <% if(products != null && !products.isEmpty()) {
    for(Product p : products) { %>
  <a href="ItemDetailServlet?id=<%= p.getProductId() %>" class="product-card">
    <img src="images/products/<%= p.getMainImage() %>" class="product-img" onerror="this.src='images/default.png'">
    <div class="product-info">
      <div style="color:#e4393c; font-size:20px; font-weight:bold; margin-bottom:8px;">￥<%= p.getPrice() %></div>
      <div style="color:#1d1d1f; font-size:15px; font-weight:600; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;"><%= p.getName() %></div>
    </div>
  </a>
  <% } } else { out.print("<div style='grid-column: 1/-1; text-align:center; color:#86868b; padding: 40px; font-size: 16px;'>该掌柜太懒了，暂无其他在售商品~</div>"); } %>
</div>
<% } %>

</body>
</html>