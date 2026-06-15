<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, bean.User, bean.Product, bean.OrderVO" %>
<%
  if (!"admin".equals(session.getAttribute("userRole"))) {
    response.sendRedirect("login.jsp");
    return;
  }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>商品信息管理系统 - 总后台</title>
  <style>
    :root {
      --apple-blue: #0071e3; --glass-bg: rgba(255, 255, 255, 0.65);
      --glass-border: 1px solid rgba(255, 255, 255, 0.4); --glass-blur: blur(20px);
      --text-main: #1d1d1f; --text-sec: #86868b;
    }

    body {
      font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", "Helvetica Neue", sans-serif;
      margin: 0; padding: 0; min-height: 100vh;
      display: flex; /* 保留侧边栏 Flex 布局 */
      color: var(--text-main);
      -webkit-font-smoothing: antialiased;
      background: linear-gradient(-45deg, #f5f5f7, #e2d1f9, #e5f0fb, #d4e4f7);
      background-size: 400% 400%;
      animation: pageFadeIn 0.5s cubic-bezier(0.16, 1, 0.3, 1) forwards, fluidGradient 15s ease infinite;
    }

    @keyframes fluidGradient { 0% { background-position: 0% 50%; } 50% { background-position: 100% 50%; } 100% { background-position: 0% 50%; } }
    @keyframes pageFadeIn { from { opacity: 0; transform: translateY(15px) scale(0.98); } to { opacity: 1; transform: translateY(0) scale(1); } }
    .page-fade-out { opacity: 0 !important; transform: translateY(-10px) scale(0.98) !important; transition: opacity 0.3s ease, transform 0.3s ease !important; }

    .sidebar { width: 250px; background: rgba(255, 255, 255, 0.5); backdrop-filter: var(--glass-blur); -webkit-backdrop-filter: var(--glass-blur); border-right: var(--glass-border); min-height: 100vh; padding: 30px 0; position: fixed; z-index: 10; box-shadow: 2px 0 20px rgba(0,0,0,0.02); }
    .sidebar h2 { text-align: center; font-weight: 700; color: var(--text-main); margin-bottom: 30px; letter-spacing: -0.5px; }
    .menu-item { padding: 15px 30px; display: block; color: var(--text-sec); text-decoration: none; font-size: 15px; font-weight: 600; transition: 0.3s cubic-bezier(0.4, 0, 0.2, 1); margin: 0 15px; border-radius: 12px; }
    .menu-item:hover, .menu-item.active { background: rgba(255,255,255,0.8); color: var(--apple-blue); box-shadow: 0 4px 10px rgba(0,0,0,0.03); transform: scale(1.02); }

    .main-content { flex: 1; padding: 40px; margin-left: 250px; overflow-x: hidden; }
    .stat-cards { display: flex; gap: 20px; margin-bottom: 30px; }
    .card { background: var(--glass-bg); backdrop-filter: var(--glass-blur); -webkit-backdrop-filter: var(--glass-blur); border: var(--glass-border); padding: 25px; border-radius: 24px; flex: 1; box-shadow: 0 10px 30px rgba(0,0,0,0.04); transition: 0.4s cubic-bezier(0.4, 0, 0.2, 1); }
    .card:hover { transform: translateY(-5px); background: rgba(255,255,255,0.8); box-shadow: 0 15px 35px rgba(0,0,0,0.08); }
    .card h3 { margin: 0 0 10px 0; color: var(--text-sec); font-size: 14px; font-weight: 600; }
    .card .num { font-size: 32px; font-weight: 700; color: var(--text-main); letter-spacing: -1px; }

    .data-panel { background: var(--glass-bg); backdrop-filter: var(--glass-blur); -webkit-backdrop-filter: var(--glass-blur); border: var(--glass-border); padding: 35px; border-radius: 28px; box-shadow: 0 10px 30px rgba(0,0,0,0.04); margin-bottom: 30px; overflow-x: auto; }
    .data-panel h3 { margin-top: 0; color: var(--text-main); font-size: 20px; font-weight: 700; margin-bottom: 25px; letter-spacing: -0.5px; }

    table { width: 100%; border-collapse: separate; border-spacing: 0; margin-top: 10px; }
    th, td { padding: 18px 15px; text-align: left; border-bottom: 1px solid rgba(0,0,0,0.05); font-size: 14px; }
    th { color: var(--text-sec); font-weight: 600; text-transform: uppercase; font-size: 12px; letter-spacing: 0.5px; }
    tr:last-child td { border-bottom: none; }
    tr { transition: background 0.2s; }
    tr:hover td { background: rgba(255,255,255,0.4); }

    .btn-add-prod { float: right; background: var(--apple-blue); color: white; padding: 14px 28px; border-radius: 24px; text-decoration: none; font-size: 14px; font-weight: 600; box-shadow: 0 4px 15px rgba(0,113,227,0.3); transition: 0.3s; }
    .btn-add-prod:hover { background: #0077ed; transform: translateY(-2px) scale(1.02); box-shadow: 0 8px 20px rgba(0,113,227,0.4); }

    .badge { padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; letter-spacing: 0.2px; }
    .bg-green { background: rgba(52, 199, 89, 0.15); color: #248a3d; }
    .bg-red { background: rgba(255, 59, 48, 0.15); color: #c02a22; }
    .bg-blue { background: rgba(0, 113, 227, 0.1); color: var(--apple-blue); }
    .bg-purple { background: rgba(175, 82, 222, 0.15); color: #8e24aa; }

    .btn-blue { background: rgba(0,113,227,0.1); color: var(--apple-blue); padding: 8px 18px; border-radius: 14px; text-decoration: none; font-size: 13px; font-weight: 600; transition: 0.2s; margin-right: 5px; }
    .btn-blue:hover { background: var(--apple-blue); color: #fff; }
    .btn-danger { background: rgba(255,59,48,0.1); color: #ff3b30; padding: 8px 18px; border-radius: 14px; text-decoration: none; font-size: 13px; font-weight: 600; transition: 0.2s; }
    .btn-danger:hover { background: #ff3b30; color: #fff; }
  </style>
</head>
<body>

<div class="sidebar">
  <h2>⚙️ 自营系统后台</h2>
  <a href="#" class="menu-item active">📊 数据看板总览</a>
  <a href="IndexServlet" class="menu-item">⬅ 返回前台商城</a>
</div>

<div class="main-content">
  <div class="stat-cards">
    <div class="card">
      <h3>👥 平台注册会员总数</h3>
      <div class="num"><%= request.getAttribute("totalUsers") != null ? request.getAttribute("totalUsers") : 0 %> 人</div>
    </div>
    <div class="card" style="border-left-color: #2ecc71;">
      <h3>📦 在库商品货项总数</h3>
      <div class="num"><%= request.getAttribute("totalItems") != null ? request.getAttribute("totalItems") : 0 %> 项</div>
    </div>
    <div class="card" style="border-left-color: #e74c3c;">
      <h3>🧾 平台历史成交订单</h3>
      <div style="font-size: 32px; font-weight: 700; color: #1d1d1f;"><%= request.getAttribute("orderCount") != null ? request.getAttribute("orderCount") : 0 %> <span style="font-size: 16px; color: #86868b;">笔</span></div>
    </div>
  </div>

  <div class="data-panel">
    <h3>🚚 平台订单追踪与发货明细</h3>
    <table>
      <thead>
      <tr>
        <th>订单号 / 时间</th>
        <th>购买商品</th>
        <th>买卖双方</th>
        <th>收货信息</th>
        <th>成交金额</th>
        <th>物流与评价状态</th>
      </tr>
      </thead>
      <tbody>
      <%
        java.util.List<bean.OrderVO> allOrders = (java.util.List<bean.OrderVO>) request.getAttribute("allOrders");
        if(allOrders != null && !allOrders.isEmpty()) {
          for(bean.OrderVO o : allOrders) {
      %>
      <tr>
        <td style="font-size: 12px; color: #86868b; line-height: 1.6;"><strong><%= o.getOrderNo() %></strong><br><%= o.getOrderTime() %></td>
        <td style="display: flex; align-items: center; gap: 10px;">
          <img src="images/products/<%= o.getMainImage() %>" style="width: 45px; height: 45px; border-radius: 8px; object-fit: cover; border: 1px solid rgba(0,0,0,0.05);">
          <span style="font-weight: 600; font-size: 13px;"><%= o.getProductName() %></span>
        </td>
        <td style="font-size: 13px; line-height: 1.6;">
          <span style="color:#0071e3; font-weight:bold;">买：</span><%= o.getBuyerName() %><br>
          <span style="color:#ff9500; font-weight:bold;">卖：</span><%= o.getMerchantName() %>
        </td>
        <td style="font-size: 12px; color: #86868b; line-height: 1.5; max-width: 150px;">📞 <%= o.getBuyerPhone() %><br>📍 <%= o.getShippingAddress() %></td>
        <td style="color:#e4393c; font-weight:bold; font-size: 15px;">￥<%= o.getTotalPrice() %></td>
        <td>
          <% if(o.getLogisticsStatus() == 0) { %> <span style="padding: 4px 10px; border-radius: 8px; background:rgba(255,149,0,0.15); color:#ff9500; font-size: 12px; font-weight: 600;">待发货</span>
          <% } else if(o.getLogisticsStatus() == 1) { %> <span style="padding: 4px 10px; border-radius: 8px; background:rgba(0,113,227,0.15); color:var(--apple-blue); font-size: 12px; font-weight: 600;">运输中</span>
          <% } else if(o.getLogisticsStatus() == 2) { %> <span style="padding: 4px 10px; border-radius: 8px; background:rgba(52,199,89,0.15); color:#248a3d; font-size: 12px; font-weight: 600;">已签收 (待评价)</span>
          <% } else { %> <span style="padding: 4px 10px; border-radius: 8px; background:rgba(142,142,147,0.15); color:#8e8e93; font-size: 12px; font-weight: 600;">已完成 (已评价)</span> <% } %>
        </td>
      </tr>
      <% } } else { out.print("<tr><td colspan='6' style='text-align:center; padding: 50px; color:#86868b;'>暂无流水</td></tr>"); } %>
      </tbody>
    </table>
  </div>

  <div class="data-panel">
    <h3>🔍 平台在库商品状态及库存维护</h3>
    <table>
      <thead><tr><th>商品ID</th><th>商品名称</th><th>分类</th><th>零售单价</th><th>在库库存</th><th>状态</th><th>管理操作</th></tr></thead>
      <tbody>
      <%
        List<Product> items = (List<Product>) request.getAttribute("itemList");
        if(items != null && !items.isEmpty()) {
          for(Product p : items) {
      %>
      <tr>
        <td>#<%= p.getProductId() %></td>
        <td><strong><%= p.getName() %></strong></td>
        <td><%= p.getCategory() %></td>
        <td style="color:#e67e22; font-weight:bold;">￥<%= p.getPrice() %></td>
        <td><% if(p.getStock() <= 5) { %> <span style="color:red; font-weight:bold;"><%= p.getStock() %> 件 (紧张)</span> <% } else { %> <span><%= p.getStock() %> 件</span> <% } %></td>
        <td><% if("on_sale".equals(p.getStatus())) { %> <span class="badge bg-green">正处于售中</span> <% } else { %> <span class="badge bg-red">违规已下架</span> <% } %></td>
        <td>
          <a href="AdminEditProductServlet?id=<%= p.getProductId() %>" class="btn-blue">✏️ 编辑</a>
          <% if("on_sale".equals(p.getStatus())) { %> <a href="AdminOffShelfServlet?productId=<%= p.getProductId() %>" class="btn-danger" onclick="return confirm('确定要强制下架该商品吗？');">🚫 下架</a>
          <% } else { %> <span style="color:#ccc; font-size:12px; margin-left: 5px;">已归档</span> <% } %>
        </td>
      </tr>
      <% } } else { out.print("<tr><td colspan='7' style='text-align:center; color:#999; padding: 30px;'>当前无商品</td></tr>"); } %>
      </tbody>
    </table>
  </div>
</div>

<script>
  document.addEventListener("DOMContentLoaded", function() {
    const links = document.querySelectorAll('a[href]:not([target="_blank"]):not([onclick])');
    links.forEach(link => {
      link.addEventListener('click', function(e) {
        const targetUrl = this.getAttribute('href');
        if(targetUrl && !targetUrl.startsWith('#') && !targetUrl.startsWith('javascript:')) {
          e.preventDefault();
          document.body.classList.add('page-fade-out');
          setTimeout(() => { window.location.href = targetUrl; }, 300);
        }
      });
    });
  });
</script>
</body>
</html>