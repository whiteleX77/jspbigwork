<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, bean.OrderVO" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <title>我的订单 - 官方商城</title>
  <style>
    :root { --primary-color: #e4393c; --apple-blue: #0071e3; }

    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Microsoft YaHei', sans-serif;
      margin: 0; padding: 0; min-height: 100vh;
      background: linear-gradient(-45deg, #f5f5f7, #e2d1f9, #e5f0fb, #d4e4f7);
      background-size: 400% 400%;
      /* 🌟 核心合并动画 */
      animation: pageFadeIn 0.5s cubic-bezier(0.16, 1, 0.3, 1) forwards, fluidGradient 15s ease infinite;
      -webkit-font-smoothing: antialiased;
    }
    @keyframes fluidGradient { 0% { background-position: 0% 50%; } 50% { background-position: 100% 50%; } 100% { background-position: 0% 50%; } }
    @keyframes pageFadeIn { from { opacity: 0; transform: translateY(15px) scale(0.98); } to { opacity: 1; transform: translateY(0) scale(1); } }
    .page-fade-out { opacity: 0 !important; transform: translateY(-10px) scale(0.98) !important; transition: opacity 0.3s ease, transform 0.3s ease !important; }

    .navbar { background: rgba(255,255,255,0.7); backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px); padding: 15px 50px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); position: sticky; top: 0; z-index: 100;}
    .navbar a { text-decoration: none; color: #333; font-weight: bold; transition: 0.2s; }
    .navbar a:hover { color: var(--apple-blue); }

    .container { max-width: 900px; margin: 40px auto; }
    .page-title { font-size: 28px; font-weight: 700; color: #1d1d1f; margin-bottom: 30px; display: flex; align-items: center; gap: 10px;}

    .order-card { background: rgba(255,255,255,0.6); backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px); border-radius: 20px; padding: 25px; margin-bottom: 25px; border: 1px solid rgba(255,255,255,0.5); box-shadow: 0 10px 30px rgba(0,0,0,0.04); transition: 0.3s; }
    .order-card:hover { transform: translateY(-3px); box-shadow: 0 15px 40px rgba(0,0,0,0.06); }
    .order-header { display: flex; justify-content: space-between; border-bottom: 1px solid rgba(0,0,0,0.05); padding-bottom: 12px; margin-bottom: 20px; font-size: 13px; color: #86868b; font-weight: 600; }
    .order-body { display: flex; align-items: center; gap: 20px; }
    .item-img { width: 110px; height: 110px; object-fit: cover; border-radius: 12px; border: 1px solid rgba(0,0,0,0.05); background: #fff; flex-shrink: 0;}
    .item-info { flex: 1; min-width: 200px; }
    .item-title { font-size: 18px; font-weight: 700; color: #1d1d1f; margin-bottom: 8px; }
    .item-merchant { font-size: 13px; color: #86868b; margin-bottom: 8px; font-weight: 600; }
    .item-price { color: #86868b; font-size: 14px; font-weight: 500; }
    .status-area { display: flex; flex-direction: column; align-items: flex-end; flex-shrink: 0; }
    .total-box { font-size: 18px; font-weight: 700; color: var(--primary-color); margin-bottom: 12px; }

    .badge { padding: 6px 14px; border-radius: 12px; font-size: 12px; font-weight: 600; display: inline-block; margin-bottom: 10px; text-align: center; }
    .btn-action { background: var(--apple-blue); color: #fff; border: none; padding: 8px 18px; border-radius: 12px; font-size: 13px; font-weight: 600; cursor: pointer; text-decoration: none; display: inline-block; box-shadow: 0 4px 10px rgba(0,113,227,0.2); transition: 0.2s;}
    .btn-action:hover { transform: translateY(-2px); box-shadow: 0 6px 15px rgba(0,113,227,0.3); }

    @keyframes popIn { from { opacity:0; transform: scale(0.9) translateY(15px); } to { opacity:1; transform: scale(1) translateY(0); } }
  </style>
</head>
<body>
<div class="navbar"><a href="IndexServlet">⬅ 返回商城大厅</a></div>

<div class="container">
  <div class="page-title">📦 我的购物清单</div>
  <%
    List<OrderVO> myOrders = (List<OrderVO>) request.getAttribute("myOrders");
    if (myOrders != null && !myOrders.isEmpty()) {
      for (OrderVO order : myOrders) {
  %>
  <div class="order-card">
    <div class="order-header">
      <span>订单流水号：<%= order.getOrderNo() != null ? order.getOrderNo() : order.getOrderId() %></span>
      <span>下单时间：<%= order.getOrderTime() != null ? order.getOrderTime() : "刚刚" %></span>
    </div>
    <div class="order-body">
      <img src="images/products/<%= order.getMainImage() %>" class="item-img" onerror="this.src='images/default.png'">
      <div class="item-info">
        <div class="item-title"><%= order.getProductName() %></div>
        <div class="item-merchant">🏬 店铺：<%= order.getMerchantName() != null ? order.getMerchantName() : "官方自营" %></div>
        <div class="item-price">单价 ￥<%= order.getBuyCount() > 0 ? (order.getTotalPrice() / order.getBuyCount()) : order.getTotalPrice() %> × <%= order.getBuyCount() > 0 ? order.getBuyCount() : 1 %> 件</div>
      </div>
      <div class="status-area">
        <div class="total-box">实付：￥<%= order.getTotalPrice() %></div>
        <% if(order.getLogisticsStatus() == 0) { %> <span class="badge" style="background:rgba(255,149,0,0.15); color:#ff9500;">⏳ 掌柜备货中</span>
        <% } else if(order.getLogisticsStatus() == 1) { %> <span class="badge" style="background:rgba(0,113,227,0.15); color:var(--apple-blue);">🚚 运输中</span> <a href="ConfirmReceiptServlet?orderId=<%= order.getOrderId() %>" class="btn-action">✅ 确认收货</a>
        <% } else if(order.getLogisticsStatus() == 2) { %> <span class="badge" style="background:rgba(52,199,89,0.15); color:#248a3d;">🎉 已签收</span> <button onclick="openReviewModal('<%= order.getOrderId() %>', '<%= order.getProductId() %>')" class="btn-action">✍️ 立即评价</button>
        <% } else if(order.getLogisticsStatus() == 3) { %> <span class="badge" style="background:rgba(142,142,147,0.15); color:#8e8e93;">⭐ 已完成 (已评价)</span> <% } %>
      </div>
    </div>
  </div>
  <% } } else { out.print("<div style='text-align:center; padding: 100px; background:rgba(255,255,255,0.6); backdrop-filter: blur(20px); border-radius:24px; color:#86868b; font-size:16px; border: 1px solid rgba(255,255,255,0.5);'>暂无订单记录~</div>"); } %>
</div>

<div id="reviewModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.4); backdrop-filter: blur(15px); -webkit-backdrop-filter: blur(15px); z-index: 9999; justify-content: center; align-items: center;">
  <div style="background: rgba(255,255,255,0.85); border: 1px solid rgba(255,255,255,0.5); width: 400px; padding: 35px; border-radius: 28px; box-shadow: 0 25px 60px rgba(0,0,0,0.15); animation: popIn 0.3s cubic-bezier(0.16, 1, 0.3, 1);">
    <h3 style="margin-top: 0; font-size: 22px; font-weight: 700; color: #1d1d1f; text-align: center;">分享您的购物体验</h3>
    <form action="SubmitReviewServlet" method="post">
      <input type="hidden" name="orderId" id="modalOrderId"><input type="hidden" name="productId" id="modalProductId">
      <div style="margin-bottom: 20px;">
        <label style="display:block; margin-bottom:10px; font-size:14px; font-weight:600;">综合星级打分</label>
        <select name="rating" required style="width: 100%; padding: 14px; border: 1px solid rgba(0,0,0,0.1); border-radius: 12px; background: #fff; font-size: 16px; outline:none; cursor: pointer;">
          <option value="5">⭐⭐⭐⭐⭐ 超出预期 (5分)</option><option value="4">⭐⭐⭐⭐ 总体满意 (4分)</option><option value="3">⭐⭐⭐ 感觉一般 (3分)</option><option value="2">⭐⭐ 比较失望 (2分)</option><option value="1">⭐ 极差体验 (1分)</option>
        </select>
      </div>
      <div style="margin-bottom: 25px;">
        <label style="display:block; margin-bottom:10px; font-size:14px; font-weight:600;">详细评价内容</label>
        <textarea name="content" required rows="4" placeholder="商品质量如何？掌柜服务态度怎么样？" style="width: 100%; padding: 14px; border: 1px solid rgba(0,0,0,0.1); border-radius: 12px; font-size: 14px; outline:none; box-sizing: border-box; resize: none;"></textarea>
      </div>
      <div style="display: flex; gap: 12px;">
        <button type="button" onclick="closeReviewModal()" style="flex:1; padding:14px; border:none; background:rgba(0,0,0,0.05); border-radius:12px; font-weight:600; cursor:pointer;">取消</button>
        <button type="submit" style="flex:2; padding:14px; border:none; background:var(--apple-blue); color:white; border-radius:12px; font-weight:600; cursor:pointer; box-shadow: 0 4px 12px rgba(0,113,227,0.2);">提交评价</button>
      </div>
    </form>
  </div>
</div>

<script>
  function openReviewModal(orderId, productId) { document.getElementById('modalOrderId').value = orderId; document.getElementById('modalProductId').value = productId; document.getElementById('reviewModal').style.display = 'flex'; }
  function closeReviewModal() { document.getElementById('reviewModal').style.display = 'none'; }

  // JS 过渡拦截器
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