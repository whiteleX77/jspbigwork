<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <title>客户服务与售后支持 - 官方商城</title>
  <style>
    :root {
      --apple-blue: #0071e3;
      --apple-text: #1d1d1f;
      --apple-text-secondary: #86868b;
      --glass-bg: rgba(255, 255, 255, 0.65);
      --glass-border: 1px solid rgba(255, 255, 255, 0.4);
      --glass-blur: blur(25px);
    }

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

    a { text-decoration: none; color: var(--apple-blue); }

    /* 灵动岛悬浮导航 */
    .navbar {
      background: var(--glass-bg); backdrop-filter: var(--glass-blur); -webkit-backdrop-filter: var(--glass-blur); border: var(--glass-border);
      width: calc(100% - 40px); max-width: 900px; margin: 0 auto 40px; padding: 14px 30px;
      border-radius: 50px; display: flex; justify-content: space-between; align-items: center;
      box-shadow: 0 10px 30px rgba(0,0,0,0.05); position: sticky; top: 20px; z-index: 100;
    }
    .navbar .back-btn { font-weight: 600; font-size: 15px; color: var(--apple-text-secondary); transition: 0.2s; }
    .navbar .back-btn:hover { color: var(--apple-text); }

    .container { max-width: 960px; margin: 0 auto; display: grid; grid-template-columns: 1.6fr 1fr; gap: 30px; }

    /* 玻璃面板基底 */
    .glass-panel {
      background: var(--glass-bg); backdrop-filter: var(--glass-blur); -webkit-backdrop-filter: var(--glass-blur);
      border: var(--glass-border); padding: 40px; border-radius: 28px; box-shadow: 0 15px 45px rgba(0,0,0,0.05);
    }

    .panel-title { font-size: 24px; font-weight: 700; margin-top: 0; margin-bottom: 25px; letter-spacing: -0.5px; }

    /* 🌟 FAQ 原生折叠样式 */
    .faq-item { background: rgba(255, 255, 255, 0.4); border-radius: 16px; margin-bottom: 15px; border: 1px solid rgba(0,0,0,0.03); overflow: hidden; transition: 0.3s; }
    .faq-item summary { padding: 18px 22px; font-weight: 600; cursor: pointer; outline: none; display: flex; justify-content: space-between; align-items: center; list-style: none; }
    .faq-item summary::-webkit-details-marker { display: none; }
    .faq-item summary::after { content: '＋'; font-weight: bold; color: var(--apple-text-secondary); transition: 0.3s; }
    .faq-item[open] summary::after { transform: rotate(45deg); color: var(--apple-blue); }
    .faq-content { padding: 0 22px 22px; color: var(--apple-text-secondary); font-size: 14px; line-height: 1.6; border-top: 1px solid rgba(0,0,0,0.02); background: rgba(255,255,255,0.2); }

    /* 🌟 客服联系卡片 */
    .kefu-card { text-align: center; display: flex; flex-direction: column; align-items: center; }
    .phone-box { background: rgba(0, 113, 227, 0.08); width: 100%; padding: 20px; box-sizing: border-box; border-radius: 18px; margin-bottom: 25px; transition: 0.3s; border: 1px solid rgba(0,113,227,0.1); }
    .phone-box:hover { transform: translateY(-2px); background: rgba(0, 113, 227, 0.12); }
    .phone-label { font-size: 13px; font-weight: 600; color: var(--apple-text-secondary); margin-bottom: 5px; }
    .phone-num { font-size: 20px; font-weight: 700; color: var(--apple-blue); }

    .qr-box { background: #fff; padding: 15px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.04); border: 1px solid rgba(0,0,0,0.03); width: 160px; height: 160px; display: flex; justify-content: center; align-items: center; }
    .qr-box img { width: 100%; height: 100%; object-fit: cover; }
    .qr-tip { font-size: 13px; font-weight: 600; color: var(--apple-text-secondary); margin-top: 12px; }
  </style>
</head>
<body>

<div class="navbar">
  <a href="IndexServlet" class="back-btn">⬅ 返回商城大厅</a>
  <span style="font-weight: 700;">⚙️ 服务支持中心</span>
</div>

<div class="container">
  <div class="glass-panel">
    <h3 class="panel-title">🛠️ 常见问题自主解决方法</h3>

    <details class="faq-item" open>
      <summary>下单后一直显示“等待仓库发货”怎么办？</summary>
      <div class="faq-content">
        系统在支付成功后会自动转入排单流程。自营商品通常会在 24 小时内发出。若遇到超期未发货的情况，请直接拨打下方的人工客服电话提供您的订单流水号。
      </div>
    </details>

    <details class="faq-item">
      <summary>收到的商品存在破损或者质量问题如何申请退换？</summary>
      <div class="faq-content">
        请在收到商品后的 7 天内，使用微信扫描右侧的客服二维码，将商品破损处的实拍照片发送给官方在线客服。核对无误后，我们将为您提供免运费的退换货派送服务。
      </div>
    </details>

    <details class="faq-item">
      <summary>填错了收货地址或手机号，该怎么修改？</summary>
      <div class="faq-content">
        如果订单刚提交且官方尚未打包发货，请尽快致电官方热线进行人工拦截修正。如果包裹已经交由物流发出，我们将协助您联系派送员进行中途改签转寄。
      </div>
    </details>
  </div>

  <div class="glass-panel kefu-card">
    <h3 class="panel-title">🙋‍♂️ 人工联络通道</h3>

    <a href="tel:15818572963" class="phone-box">
      <div class="phone-label">官方 24H 服务热线</div>
      <div class="phone-num">📞 15818572963</div>
    </a>

    <div class="qr-box">
      <img src="images/kefu_qrcode.png" onerror="this.src='data:image/svg+xml;utf8,<svg xmlns=%22http://www.w3.org/2000/svg%22 width=%22150%22 height=%22150%22 viewBox=%220 0 100 100%22><rect width=%22100%22 height=%22100%22 fill=%22%23eee%22/><text x=%2250%22 y=%2255%22 font-size=%2210%22 text-anchor=%22middle%22 fill=%22%23aaa%22>微信二维码占位</text></svg>'">
    </div>
    <div class="qr-tip">使用微信扫一扫<br>添加官方在线人工客服</div>
  </div>
</div>

</body>
</html>