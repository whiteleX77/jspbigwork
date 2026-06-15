<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <title>登录 - 官方自营商城</title>
  <style>
    /* ===========================================================
       Apple Glassmorphism Style for Login Page
    =========================================================== */
    :root {
      --apple-blue: #0071e3;
      --apple-text: #1d1d1f;
      --apple-text-secondary: #86868b;
      --glass-bg: rgba(255, 255, 255, 0.65);
      --glass-border: 1px solid rgba(255, 255, 255, 0.4);
      --glass-blur: blur(25px);
      --webkit-glass-blur: blur(25px);
    }

    body {
      font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", "Helvetica Neue", sans-serif;
      margin: 0; padding: 0; height: 100vh;
      display: flex; justify-content: center; align-items: center; /* 锁死卡片在屏幕正中央 */
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
    a { text-decoration: none; color: inherit; transition: 0.3s; }

    /* 🌟 居中悬浮玻璃登录卡片 */
    .login-card {
      background: var(--glass-bg);
      backdrop-filter: var(--glass-blur);
      -webkit-backdrop-filter: var(--webkit-glass-blur);
      border: var(--glass-border);
      width: 100%;
      max-width: 380px;
      padding: 50px 40px;
      border-radius: 32px;
      box-shadow: 0 20px 50px rgba(0,0,0,0.06);
      text-align: center;
      animation: scaleIn 0.6s cubic-bezier(0.16, 1, 0.3, 1);
    }

    @keyframes scaleIn {
      from { opacity: 0; transform: scale(0.95) translateY(15px); }
      to { opacity: 1; transform: scale(1) translateY(0); }
    }

    .logo {
      font-size: 26px;
      font-weight: 700;
      margin-bottom: 35px;
      letter-spacing: -0.5px;
      display: flex;
      justify-content: center;
      align-items: center;
      color: var(--apple-text);
    }

    .form-group {
      margin-bottom: 20px;
      text-align: left;
    }

    /* 🌟 Apple 质感输入框 */
    .form-control {
      width: 100%;
      padding: 16px 20px;
      background: rgba(255, 255, 255, 0.5);
      border: 1px solid rgba(0,0,0,0.05);
      border-radius: 16px;
      box-sizing: border-box;
      font-size: 15px;
      transition: 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      color: var(--apple-text);
      font-family: inherit;
      outline: none;
    }
    .form-control:focus {
      background: #fff;
      border-color: var(--apple-blue);
      box-shadow: 0 0 0 4px rgba(0,113,227,0.15);
    }

    /* 验证码同行排版 */
    .captcha-group {
      display: flex;
      gap: 15px;
      align-items: center;
    }
    .captcha-group input { flex: 1; }
    .captcha-img {
      height: 52px;
      border-radius: 12px;
      cursor: pointer;
      border: 1px solid rgba(0,0,0,0.05);
      transition: 0.2s;
      background: #fff;
    }
    .captcha-img:hover { opacity: 0.8; }

    /* 🌟 极致丝滑的登录按钮 */
    .btn-submit {
      background: var(--apple-blue);
      color: #fff;
      border: none;
      padding: 16px;
      width: 100%;
      border-radius: 16px;
      font-size: 17px;
      font-weight: 600;
      cursor: pointer;
      transition: 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      margin-top: 15px;
      box-shadow: 0 4px 15px rgba(0,113,227,0.2);
      letter-spacing: 1px;
    }
    .btn-submit:hover {
      background: #0077ed;
      transform: translateY(-2px);
      box-shadow: 0 8px 25px rgba(0,113,227,0.3);
    }
    .btn-submit:active { transform: translateY(1px); background: #0069d2; }

    /* 底部链接 */
    .links {
      margin-top: 30px;
      font-size: 14px;
      display: flex;
      justify-content: center;
      gap: 25px;
      font-weight: 500;
    }
    .links a { color: var(--apple-text-secondary); }
    .links a:hover { color: var(--apple-blue); }
  </style>
</head>
<body>

<div class="login-card">
  <div class="logo">自营商城登录</div>

  <form action="LoginServlet" method="post">
    <div class="form-group">
      <input type="text" name="username" class="form-control" placeholder="账号 (Username)" required>
    </div>

    <div class="form-group">
      <input type="password" name="password" class="form-control" placeholder="密码 (Password)" required>
    </div>

    <div class="form-group captcha-group">
      <input type="text" name="code" class="form-control" placeholder="请输入右侧验证码" required autocomplete="off">
      <img src="ImageServlet" class="captcha-img" title="看不清？点击刷新" onclick="this.src='ImageServlet?time='+new Date().getTime()">
    </div>

    <button type="submit" class="btn-submit">登 录</button>
  </form>

  <div class="links">
    <a href="register.jsp">没有账号？去注册</a>
    <a href="IndexServlet">返回大厅</a>
  </div>
</div>

</body>
</html>