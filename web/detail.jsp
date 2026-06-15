<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="bean.Product, bean.User, bean.Review, java.util.List" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <title>商品详情 - 自营商城</title>
  <style>
    :root { --primary-color: #e4393c; --apple-blue: #0071e3; --bg-color: #f5f5f7; }
    /* 🌟 新增：全局开启丝滑滚动模式 */
    html { scroll-behavior: smooth; }

    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Microsoft YaHei', sans-serif;
      margin: 0; padding: 0; min-height: 100vh;
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

    /* 导航栏 */
    .navbar { background: rgba(255,255,255,0.8); backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px); padding: 15px 50px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); position: sticky; top: 0; z-index: 100;}
    .navbar a { text-decoration: none; color: #333; font-weight: bold; transition: 0.2s; }
    .navbar a:hover { color: var(--apple-blue); }

    /* 🌟 修复：主容器防挤压 (加上 flex-wrap 和 align-items) */
    .container { max-width: 1000px; margin: 30px auto; display: flex; flex-wrap: wrap; gap: 40px; align-items: flex-start; background: rgba(255,255,255,0.7); backdrop-filter: blur(20px); padding: 40px; border-radius: 24px; box-shadow: 0 10px 30px rgba(0,0,0,0.04); border: 1px solid rgba(255,255,255,0.5); }

    /* 🌟 修复：图片绝对禁止缩小 (flex-shrink: 0) */
    .main-image { width: 400px; height: 400px; flex-shrink: 0; object-fit: cover; border-radius: 16px; border: 1px solid rgba(0,0,0,0.05); background: #fff; box-shadow: 0 4px 15px rgba(0,0,0,0.02); }

    /* 🌟 修复：信息面板强制垂直排列，且设置最小宽度防止被压碎 */
    .info-panel { flex: 1; min-width: 350px; display: flex; flex-direction: column; }

    .item-title { font-size: 22px; font-weight: bold; margin-bottom: 15px; color: #1d1d1f; line-height: 1.4; letter-spacing: -0.5px; }
    .price-box { background: rgba(255,255,255,0.5); border-radius: 12px; padding: 15px 20px; margin-bottom: 20px; border: 1px solid rgba(0,0,0,0.03); }
    .price-text { color: var(--primary-color); font-size: 28px; font-weight: bold; }

    .info-row { display: flex; margin-bottom: 12px; font-size: 14px; }
    .info-label { width: 70px; color: #86868b; font-weight: 600; }
    .info-value { flex: 1; color: #1d1d1f; font-weight: 500; }

    .btn-buy { background: var(--apple-blue); color: white; border: none; padding: 15px 40px; font-size: 16px; font-weight: 600; border-radius: 12px; cursor: pointer; transition: 0.3s; margin-top: 20px; width: 100%; box-shadow: 0 4px 15px rgba(0,113,227,0.2); }
    .btn-buy:hover { background: #0077ed; transform: translateY(-2px); box-shadow: 0 8px 25px rgba(0,113,227,0.3); }
    .disabled { background: #ccc !important; box-shadow: none !important; cursor: not-allowed; transform: none !important; }

    @keyframes popIn { from { opacity:0; transform: scale(0.9) translateY(15px); } to { opacity:1; transform: scale(1) translateY(0); } }
  </style>
</head>
<body>

<div class="navbar"><a href="IndexServlet">⬅ 返回商城大厅</a></div>

<%
  Product p = (Product) request.getAttribute("product");
  User shop = (User) request.getAttribute("merchant");
  if(p != null) {
%>
<div class="container">
  <img src="images/products/<%= p.getMainImage() %>" class="main-image" onerror="this.src='images/default.png'">

  <div class="info-panel">
    <div class="item-title">
      <%= p.getName() %>
    </div>

    <div class="price-box">
      <span style="color:#86868b; font-weight: 600;">专享价：</span><span class="price-text">￥<%= p.getPrice() %></span>
    </div>

    <% if(shop != null && shop.getRealName() != null) { %>
    <div style="width: 100%; box-sizing: border-box; background: rgba(0, 113, 227, 0.05); border: 1px solid rgba(0, 113, 227, 0.1); border-radius: 16px; padding: 15px 20px; margin: 20px 0; display: flex; align-items: center; gap: 15px; overflow: hidden;">
      <div style="flex-shrink: 0; width: 42px; height: 42px; background: var(--apple-blue); color: white; border-radius: 50%; display: flex; justify-content: center; align-items: center; font-size: 20px; font-weight: bold; box-shadow: 0 4px 10px rgba(0,113,227,0.2);">
        <%= shop.getRealName().length() > 0 ? shop.getRealName().substring(0, 1) : "店" %>
      </div>
      <div style="flex-grow: 1; min-width: 100px;">
        <div style="font-size: 12px; color: #86868b; font-weight: 600; margin-bottom: 2px;">提供本商品的店铺</div>
        <div style="font-size: 16px; font-weight: 700; color: #1d1d1f; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><%= shop.getRealName() %> 的专营店</div>
      </div>
      <a href="ShopServlet?merchantId=<%= shop.getUserId() %>" style="flex-shrink: 0; background: #fff; border: 1px solid rgba(0,0,0,0.05); padding: 8px 16px; border-radius: 20px; font-size: 13px; font-weight: 600; color: var(--apple-blue); box-shadow: 0 4px 10px rgba(0,0,0,0.03); cursor: pointer; text-decoration: none; display: inline-block;">
        进店逛逛
      </a>
    </div>
    <% } %>

    <div class="info-row"><div class="info-label">品牌</div><div class="info-value"><%= p.getBrand() != null ? p.getBrand() : "暂无" %></div></div>
    <div class="info-row"><div class="info-label">库存</div><div class="info-value"><%= p.getStock() %> 件</div></div>

    <div style="margin-top: 25px; border-top: 1px solid rgba(0,0,0,0.05); padding-top: 20px; color: #1d1d1f; font-size: 14px; line-height: 1.8;">
      <strong style="color: #86868b;">商品描述：</strong><br><%= p.getDescription() != null ? p.getDescription().replace("\n", "<br>") : "暂无描述" %>
    </div>

    <form id="purchaseForm" action="BuyServlet" method="post" style="background: rgba(255,255,255,0.6); border: 1px solid rgba(255,255,255,0.8); padding: 25px; border-radius: 20px; margin-top: 30px; box-shadow: 0 4px 15px rgba(0,0,0,0.02);">
      <input type="hidden" name="productId" value="<%= p.getProductId() %>">
      <input type="hidden" name="price" value="<%= p.getPrice() %>">

      <h4 style="margin-top: 0; color: #1d1d1f; border-bottom: 1px solid rgba(0,0,0,0.05); padding-bottom: 12px; font-weight: 700;">🚚 填写收货与派送信息</h4>

      <div style="margin-bottom: 15px;">
        <label style="display:block; margin-bottom:8px; font-size:13px; font-weight:600; color:#86868b;">收货手机号</label>
        <input type="text" name="buyerPhone" required placeholder="请输入您的11位手机号码" style="width: 100%; padding: 14px; border: 1px solid rgba(0,0,0,0.1); border-radius: 12px; background: #fff; box-sizing: border-box; outline:none; font-family: inherit;">
      </div>

      <div style="margin-bottom: 20px;">
        <label style="display:block; margin-bottom:8px; font-size:13px; font-weight:600; color:#86868b;">收货详细地址</label>
        <input type="text" name="shippingAddress" required placeholder="请填写详细的派送签收住址" style="width: 100%; padding: 14px; border: 1px solid rgba(0,0,0,0.1); border-radius: 12px; background: #fff; box-sizing: border-box; outline:none; font-family: inherit;">
      </div>

      <% if(p.getStock() > 0) { %>
      <button type="button" class="btn-buy" onclick="openPayModal()">确认收货信息并选择付款</button>
      <% } else { %>
      <button type="button" class="btn-buy disabled" disabled>该商品已售罄</button>
      <% } %>
    </form>
  </div>
</div>

<div style="max-width: 1000px; margin: 30px auto;">
  <div style="background: rgba(255,255,255,0.6); backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px); border: 1px solid rgba(255,255,255,0.5); padding: 35px; border-radius: 24px; box-shadow: 0 10px 30px rgba(0,0,0,0.04);">
    <h3 style="margin-top: 0; font-size: 20px; font-weight: 700; color: #1d1d1f; border-bottom: 1px solid rgba(0,0,0,0.05); padding-bottom: 15px; margin-bottom: 25px; display: flex; justify-content: space-between; align-items: center;">
      <span>💬 买家真实评价 (<%= p.getReviewCount() %>)</span>

      <% if(p.getReviewCount() == 0) { %>
      <span style="font-size: 14px; color: #86868b; font-weight: 500;">暂无买家打分</span>
      <% } else { %>
      <span style="font-size: 16px; color: #ff9500;">综合星级: ⭐ <%= p.getRating() %></span>
      <% } %>
    </h3>

    <% List<Review> reviews = (List<Review>) request.getAttribute("reviews"); %>
    <% if(reviews != null && !reviews.isEmpty()) { %>
    <div style="display: flex; flex-direction: column; gap: 20px;">
      <% for(Review r : reviews) { %>
      <div style="border-bottom: 1px solid rgba(0,0,0,0.05); padding-bottom: 15px;">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
          <div style="font-size: 14px; font-weight: 600; color: #1d1d1f; display: flex; align-items: center; gap: 8px;">
            <div style="width: 28px; height: 28px; background: #e5e5ea; border-radius: 50%; display: flex; justify-content: center; align-items: center; font-size: 12px; color: #86868b;"><%= r.getUsername().substring(0,1) %></div>
            <%= r.getUsername().substring(0,1) %>***
          </div>
          <div style="color: #ff9500; font-size: 14px; letter-spacing: 2px;">
            <% for(int i=0; i<r.getRating(); i++) out.print("★"); %>
            <% for(int i=0; i<5-r.getRating(); i++) out.print("☆"); %>
          </div>
        </div>
        <div style="font-size: 15px; color: #333; line-height: 1.6; margin-bottom: 8px;"><%= r.getContent() %></div>
        <div style="font-size: 12px; color: #999;"><%= r.getCreateTime() %></div>
      </div>
      <% } %>
    </div>
    <% } else { %>
    <div style="text-align: center; color: #86868b; padding: 40px 0; font-size: 15px;">暂无买家评价，赶快下单成为第一个评价的人吧！</div>
    <% } %>
  </div>
</div>

<div id="shop-items-section" style="max-width: 1000px; margin: 0 auto 50px;">
  <% List<Product> shopItems = (List<Product>) request.getAttribute("shopProducts"); %>
  <% if(shopItems != null && !shopItems.isEmpty()) { %>
  <div style="background: rgba(255,255,255,0.6); backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px); border: 1px solid rgba(255,255,255,0.5); padding: 35px; border-radius: 24px; box-shadow: 0 10px 30px rgba(0,0,0,0.04);">
    <h3 style="margin-top: 0; font-size: 20px; font-weight: 700; color: #1d1d1f; border-bottom: 1px solid rgba(0,0,0,0.05); padding-bottom: 15px; margin-bottom: 25px; display: flex; align-items: center; gap: 8px;">
      🛍️ <%= shop != null ? shop.getRealName() : "本店" %> 还在卖
    </h3>

    <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 25px;">
      <% for(Product sp : shopItems) { %>
      <a href="ItemDetailServlet?id=<%= sp.getProductId() %>" style="text-decoration: none; background: rgba(255,255,255,0.8); border: 1px solid rgba(255,255,255,0.6); border-radius: 16px; overflow: hidden; transition: 0.3s; display: block; box-shadow: 0 4px 15px rgba(0,0,0,0.03);" onmouseover="this.style.transform='translateY(-5px)'; this.style.boxShadow='0 15px 30px rgba(0,0,0,0.08)';" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 4px 15px rgba(0,0,0,0.03)';">
        <div style="height: 200px; display: flex; justify-content: center; align-items: center; background: #fff; overflow: hidden;">
          <img src="images/products/<%= sp.getMainImage() %>" onerror="this.src='images/default.png'" style="width: 100%; height: 100%; object-fit: cover;">
        </div>
        <div style="padding: 18px;">
          <div style="color: var(--primary-color); font-size: 18px; font-weight: 700; margin-bottom: 8px;">￥<%= sp.getPrice() %></div>
          <div style="color: #1d1d1f; font-size: 14px; font-weight: 600; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><%= sp.getName() %></div>
        </div>
      </a>
      <% } %>
    </div>
  </div>
  <% } %>
</div>
<% } %>

<div id="payModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.3); backdrop-filter: blur(15px); -webkit-backdrop-filter: blur(15px); z-index: 9999; justify-content: center; align-items: center;">
  <div style="background: rgba(255,255,255,0.9); border: 1px solid rgba(255,255,255,0.5); width: 360px; padding: 35px; border-radius: 28px; text-align: center; box-shadow: 0 25px 60px rgba(0,0,0,0.15); animation: popIn 0.3s cubic-bezier(0.16, 1, 0.3, 1);">
    <h3 style="margin-top: 0; font-size: 20px; font-weight: 700; color: #1d1d1f;"> 收银台支付确认</h3>
    <p style="color: #86868b; font-size: 14px; margin-bottom: 25px;">应付总额：<strong style="color:#1d1d1f; font-size: 18px;">￥<%= p != null ? p.getPrice() : 0 %></strong></p>

    <div style="display: flex; gap: 12px; margin-bottom: 25px;">
      <div id="btnWx" onclick="switchPay('wx')" style="flex: 1; padding: 12px; border: 2px solid #0071e3; border-radius: 12px; cursor: pointer; font-weight: 600; font-size: 14px; transition: 0.2s; background: #fff; color: #1d1d1f;">微信支付</div>
      <div id="btnAli" onclick="switchPay('ali')" style="flex: 1; padding: 12px; border: 2px solid rgba(0,0,0,0.05); border-radius: 12px; cursor: pointer; font-weight: 600; font-size: 14px; transition: 0.2s; background: rgba(255,255,255,0.5); color: #86868b;">支付宝支付</div>
    </div>

    <div style="background: #fff; padding: 15px; width: 160px; height: 160px; margin: 0 auto 15px; border-radius: 16px; box-shadow: 0 4px 15px rgba(0,0,0,0.03); display: flex; justify-content: center; align-items: center; border: 1px solid rgba(0,0,0,0.02);">
      <img id="payQrCode" src="images/pay_wechat.png" style="width: 100%; height: 100%; object-fit: cover;" onerror="this.src='data:image/svg+xml;utf8,<svg xmlns=%22http://www.w3.org/2000/svg%22 width=%22150%22 height=%22150%22 viewBox=%220 0 100 100%22><rect width=%22100%22 height=%22100%22 fill=%22%2327c06d%22/><text x=%2250%22 y=%2255%22 font-size=%228%22 text-anchor=%22middle%22 fill=%22%23fff%22>微信收钱码占位</text></svg>'">
    </div>
    <p id="payTip" style="font-size: 12px; font-weight: 600; color: #27c06d; margin-bottom: 30px;">请使用微信扫码支付</p>

    <div style="display: flex; gap: 10px;">
      <button type="button" onclick="closePayModal()" style="flex:1; padding:12px; border:none; background:rgba(0,0,0,0.05); color:#86868b; border-radius:10px; font-weight:600; cursor:pointer;">取消订单</button>
      <button type="button" onclick="submitFinalForm()" style="flex:1.5; padding:12px; border:none; background:#0071e3; color:white; border-radius:10px; font-weight:600; cursor:pointer; box-shadow: 0 4px 10px rgba(0,113,227,0.2);">我已成功付款</button>
    </div>
  </div>
</div>

<script>
  function openPayModal() {
    var form = document.getElementById("purchaseForm");
    if (!form.checkValidity()) {
      form.reportValidity();
      return;
    }
    document.getElementById("payModal").style.display = "flex";
  }

  function closePayModal() {
    document.getElementById("payModal").style.display = "none";
  }

  function switchPay(type) {
    var btnWx = document.getElementById("btnWx");
    var btnAli = document.getElementById("btnAli");
    var qrImg = document.getElementById("payQrCode");
    var payTip = document.getElementById("payTip");

    if (type === 'wx') {
      btnWx.style.borderColor = "#0071e3"; btnWx.style.background = "#fff"; btnWx.style.color = "#1d1d1f";
      btnAli.style.borderColor = "rgba(0,0,0,0.05)"; btnAli.style.background = "rgba(255,255,255,0.5)"; btnAli.style.color = "#86868b";
      qrImg.src = "images/pay_wechat.png";
      payTip.innerText = "请使用微信扫码支付"; payTip.style.color = "#27c06d";
    } else {
      btnAli.style.borderColor = "#0071e3"; btnAli.style.background = "#fff"; btnAli.style.color = "#1d1d1f";
      btnWx.style.borderColor = "rgba(0,0,0,0.05)"; btnWx.style.background = "rgba(255,255,255,0.5)"; btnWx.style.color = "#86868b";
      qrImg.src = "images/pay_alipay.png";
      payTip.innerText = "请使用支付宝扫码支付"; payTip.style.color = "#108ee9";
    }
  }

  function submitFinalForm() {
    document.getElementById("purchaseForm").submit();
  }
</script>
</body>
</html>