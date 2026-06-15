<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="bean.OrderVO, java.util.List" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>我的订单 - 自营商城</title>
    <style>
        :root { --apple-blue: #0071e3; }
        /* 🌟 Apple 流态渐变呼吸背景 */
        body {
            font-family: -apple-system, BlinkMacSystemFont, sans-serif;
            margin: 0; padding: 0; min-height: 100vh;
            background: linear-gradient(-45deg, #f5f5f7, #e2d1f9, #e5f0fb, #d4e4f7);
            background-size: 400% 400%;
            animation: fluidGradient 15s ease infinite;
            -webkit-font-smoothing: antialiased;
        }
        @keyframes fluidGradient { 0% { background-position: 0% 50%; } 50% { background-position: 100% 50%; } 100% { background-position: 0% 50%; } }

        .navbar { background: rgba(255,255,255,0.7); backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px); padding: 15px 50px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); position: sticky; top: 0; z-index: 100;}
        .navbar a { text-decoration: none; color: #333; font-weight: bold; }

        .container { max-width: 900px; margin: 40px auto; }
        .page-title { font-size: 28px; font-weight: 700; color: #1d1d1f; margin-bottom: 30px; display: flex; align-items: center; gap: 10px;}

        /* 订单卡片设计 */
        .order-card { background: rgba(255,255,255,0.6); backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px); border: 1px solid rgba(255,255,255,0.5); border-radius: 24px; padding: 25px; margin-bottom: 25px; display: flex; gap: 25px; box-shadow: 0 10px 30px rgba(0,0,0,0.04); transition: 0.3s;}
        .order-card:hover { transform: translateY(-3px); box-shadow: 0 15px 40px rgba(0,0,0,0.06); }
        .order-img { width: 140px; height: 140px; border-radius: 16px; object-fit: cover; flex-shrink: 0; background: #fff; box-shadow: 0 4px 10px rgba(0,0,0,0.03);}

        .order-info { flex-grow: 1; display: flex; flex-direction: column; justify-content: center;}
        .order-info h4 { margin: 0 0 10px 0; font-size: 18px; color: #1d1d1f; }
        .order-info p { margin: 0 0 15px 0; font-size: 14px; color: #86868b; font-weight: 500;}

        .badge { padding: 6px 14px; border-radius: 12px; font-size: 13px; font-weight: 600; display: inline-block; }
        .btn-action { background: var(--apple-blue); color: #fff; border: none; padding: 8px 18px; border-radius: 12px; font-size: 13px; font-weight: 600; cursor: pointer; text-decoration: none; display: inline-block; margin-left: 10px; box-shadow: 0 4px 10px rgba(0,113,227,0.2); transition: 0.2s;}
        .btn-action:hover { transform: translateY(-2px); box-shadow: 0 6px 15px rgba(0,113,227,0.3); }
    </style>
</head>
<body>

<div class="navbar"><a href="IndexServlet">⬅ 返回大厅</a></div>

<div class="container">
    <div class="page-title">📦 我的购物清单</div>

    <%
        // 🌟 这就是解决报错的核心：拿到 Servlet 发过来的列表，然后写 for 循环！
        List<OrderVO> orders = (List<OrderVO>) request.getAttribute("myOrders");
        if(orders != null && !orders.isEmpty()) {
            for(OrderVO o : orders) {
    %>
    <div class="order-card">
        <img src="images/products/<%= o.getMainImage() %>" class="order-img" onerror="this.src='images/default.png'">
        <div class="order-info">
            <h4><%= o.getProductName() %></h4>
            <p>订单号: <%= o.getOrderNo() %> | 卖家: <%= o.getMerchantName() %> | 实付: <strong style="color:#e4393c;">￥<%= o.getTotalPrice() %></strong></p>

            <div style="display: flex; align-items: center;">
                <% if(o.getLogisticsStatus() == 0) { %>
                <span class="badge" style="background:rgba(255,149,0,0.15); color:#ff9500;">⏳ 掌柜备货中</span>
                <% } else if(o.getLogisticsStatus() == 1) { %>
                <span class="badge" style="background:rgba(0,113,227,0.15); color:var(--apple-blue);">🚚 运输中 (物流飞奔中)</span>
                <a href="ConfirmReceiptServlet?orderId=<%= o.getOrderId() %>" class="btn-action">✅ 确认收货</a>
                <% } else if(o.getLogisticsStatus() == 2) { %>
                <span class="badge" style="background:rgba(52,199,89,0.15); color:#248a3d;">🎉 已签收</span>
                <button onclick="alert('即将开发评价弹窗！')" class="btn-action">✍️ 立即评价</button>
                <% } else { %>
                <span class="badge" style="background:rgba(142,142,147,0.15); color:#8e8e93;">⭐ 订单已完成 (已评价)</span>
                <% } %>
            </div>
        </div>
    </div>
    <%
            }
        } else {
            out.print("<div style='text-align:center; padding: 100px 0; color:#86868b; font-size:16px;'>暂无订单，快去大厅逛逛吧~</div>");
        }
    %>
</div>

</body>
</html>