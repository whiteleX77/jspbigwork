<%--
  Created by IntelliJ IDEA.
  User: WHITE
  Date: 2026/5/31
  Time: 19:35
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, bean.Product" %>
<%
  if (!"merchant".equals(session.getAttribute("userRole"))) {
    response.sendRedirect("login.jsp"); return;
  }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>卖家工作台 - 官方商城</title>
  <style>
    :root { --apple-blue: #0071e3; --glass-bg: rgba(255, 255, 255, 0.65); --glass-border: 1px solid rgba(255, 255, 255, 0.4); --glass-blur: blur(25px); }
    body {
      font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", "Helvetica Neue", sans-serif;
      margin: 0; padding: 0; min-height: 100vh;
      color: var(--apple-text, #1d1d1f);
      -webkit-font-smoothing: antialiased;
      /* 🌟 替换为 Apple 流体动画背景 */
      background: linear-gradient(-45deg, #f5f5f7, #e2d1f9, #e5f0fb, #d4e4f7);
      background-size: 400% 400%;
      animation: fluidGradient 15s ease infinite;
    }
    @keyframes fluidGradient {
      0% { background-position: 0% 50%; }
      50% { background-position: 100% 50%; }
      100% { background-position: 0% 50%; }
    }

    .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
    .title { font-size: 28px; font-weight: 700; letter-spacing: -0.5px; }
    .btn-add { background: var(--apple-blue); color: white; padding: 12px 24px; border-radius: 20px; text-decoration: none; font-weight: 600; box-shadow: 0 4px 15px rgba(0,113,227,0.2); transition: 0.3s; }
    .btn-add:hover { background: #0077ed; transform: translateY(-2px); }

    .glass-panel { background: var(--glass-bg); backdrop-filter: var(--glass-blur); -webkit-backdrop-filter: var(--glass-blur); border: var(--glass-border); padding: 30px; border-radius: 28px; box-shadow: 0 10px 30px rgba(0,0,0,0.04); }

    table { width: 100%; border-collapse: separate; border-spacing: 0; }
    th, td { padding: 15px; text-align: left; border-bottom: 1px solid rgba(0,0,0,0.05); font-size: 14px; }
    th { color: #86868b; font-weight: 600; font-size: 12px; }
    tr:hover td { background: rgba(255,255,255,0.4); }

    .badge { padding: 6px 12px; border-radius: 12px; font-size: 12px; font-weight: 600; display: inline-block;}
    .badge-active { background: rgba(52, 199, 89, 0.15); color: #248a3d; }
    .badge-banned { background: rgba(255, 59, 48, 0.15); color: #d70015; }
  </style>
</head>
<body>

<div class="header">
  <div class="title">🏬 掌柜，欢迎回到卖家中心</div>
  <div>
    <a href="merchantAddProduct.jsp" class="btn-add">📦 立即上架新商品</a>
    <a href="LogoutServlet" style="margin-left: 20px; color: #ff3b30; text-decoration: none; font-weight: 600;">安全退出</a>
  </div>
</div>

<div class="glass-panel">
  <h3 style="margin-top:0;">我的在售商品库</h3>
  <table>
    <thead>
    <tr>
      <th>商品ID</th>
      <th>商品名称</th>
      <th>售价</th>
      <th>剩余库存</th>
      <th>商品评分</th>
      <th>状态</th>
      <th>操作</th>
    </tr>
    </thead>
    <tbody>
    <%
      List<Product> items = (List<Product>) request.getAttribute("myProducts");
      if(items != null && !items.isEmpty()) {
        for(Product p : items) {
    %>
    <tr>
      <td>#<%= p.getProductId() %></td>
      <td style="font-weight:600;"><%= p.getName() %></td>
      <td style="color:#ff9500; font-weight:600;">￥<%= p.getPrice() %></td>
      <td><%= p.getStock() %></td>
      <td style="color:#ffcc00; font-weight:bold;">⭐ <%= p.getRating() %></td>
      <td>
        <%
          String statusStr = p.getStatus() != null ? p.getStatus().trim() : "";

          // 🌟 精准暗号匹配：只要是 on_sale，就是正常出售！
          if ("on_sale".equals(statusStr)) {
        %>
        <span class="badge badge-active">出售中</span>
        <% } else { %>
        <span class="badge badge-banned">已下架 / 封禁</span>
        <% } %>
      </td>
      <td>
        <form action="MerchantUpdateStockServlet" method="post" style="display:inline-flex; align-items:center; gap:6px; margin-right:14px;">
          <input type="hidden" name="productId" value="<%= p.getProductId() %>">
          <input type="number" name="stock" value="<%= p.getStock() %>" min="0" style="width:64px; padding:6px 8px; border:1px solid rgba(0,0,0,0.1); border-radius:8px; font-size:13px; background:rgba(255,255,255,0.6);">
          <button type="submit" style="background:var(--apple-blue); color:#fff; border:none; padding:7px 14px; border-radius:8px; font-size:12px; font-weight:600; cursor:pointer;">保存库存</button>
        </form>
        <%
          String opStatus = p.getStatus() != null ? p.getStatus().trim() : "";
          if ("on_sale".equals(opStatus)) {
        %>
        <a href="MerchantChangeStatusServlet?productId=<%= p.getProductId() %>&status=off_sale" onclick="return confirm('确定要下架该商品吗？下架后买家将无法看到它。');" style="color:#ff3b30; text-decoration:none; font-weight:600;">下架</a>
        <% } else { %>
        <a href="MerchantChangeStatusServlet?productId=<%= p.getProductId() %>&status=on_sale" style="color:#248a3d; text-decoration:none; font-weight:600;">重新上架</a>
        <% } %>
      </td>
    </tr>
    <%
        }
      } else {
        out.print("<tr><td colspan='7' style='text-align:center; padding: 40px; color:#86868b;'>您还没有上架任何商品，赶快去发布吧！</td></tr>");
      }
    %>
    </tbody>
  </table>
</div>
<div class="glass-panel" style="margin-top: 40px;">
  <h3 style="margin-top:0; color: #1d1d1f;">📦 客户订单与发货管理</h3>
  <table>
    <thead>
    <tr>
      <th>订单号</th>
      <th>购买商品</th>
      <th>买家信息 (收件人)</th>
      <th>实收金额</th>
      <th>当前状态</th>
      <th>操作</th>
    </tr>
    </thead>
    <tbody>
    <%
      java.util.List<bean.OrderVO> orders = (java.util.List<bean.OrderVO>) request.getAttribute("merchantOrders");
      if(orders != null && !orders.isEmpty()) {
        for(bean.OrderVO o : orders) {
    %>
    <tr>
      <td style="font-size: 12px; color: #86868b;"><%= o.getOrderNo() %></td>
      <td style="display: flex; align-items: center; gap: 10px;">
        <img src="images/products/<%= o.getMainImage() %>" style="width: 40px; height: 40px; border-radius: 8px; object-fit: cover;">
        <span style="font-weight: 600; font-size: 13px;"><%= o.getProductName() %></span>
      </td>
      <td style="font-size: 13px; line-height: 1.5;">
        👤 <%= o.getBuyerName() %><br>
        📞 <%= o.getBuyerPhone() %><br>
        📍 <span style="color:#86868b;"><%= o.getShippingAddress() %></span>
      </td>
      <td style="color:#e4393c; font-weight:bold;">￥<%= o.getTotalPrice() %></td>
      <td>
        <% if(o.getLogisticsStatus() == 0) { %>
        <span class="badge" style="background:rgba(255,149,0,0.15); color:#ff9500;">等待您发货</span>
        <% } else if(o.getLogisticsStatus() == 1) { %>
        <span class="badge" style="background:rgba(0,113,227,0.15); color:var(--apple-blue);">已发货 (运输中)</span>
        <% } else { %>
        <span class="badge" style="background:rgba(52,199,89,0.15); color:#248a3d;">买家已签收</span>
        <% } %>
      </td>
      <td>
        <% if(o.getLogisticsStatus() == 0) { %>
        <a href="ShipOrderServlet?orderId=<%= o.getOrderId() %>" style="background: var(--apple-blue); color: #fff; padding: 6px 12px; border-radius: 8px; text-decoration: none; font-size: 12px; font-weight: 600; display: inline-block; transition: 0.2s; box-shadow: 0 2px 5px rgba(0,113,227,0.2);">🚀 立即发货</a>
        <% } else { %>
        <span style="color: #86868b; font-size: 12px; font-weight: 600;">无操作</span>
        <% } %>
      </td>
    </tr>
    <%
        }
      } else {
        out.print("<tr><td colspan='6' style='text-align:center; padding: 40px; color:#86868b;'>您的店铺暂时还没开张，等待买家下单哦~</td></tr>");
      }
    %>
    </tbody>
  </table>
</div>
</body>
</html>