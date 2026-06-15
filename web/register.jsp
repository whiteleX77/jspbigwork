<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>加入商城 - 注册</title>
    <style>
        :root {
            --apple-blue: #0071e3;
            --apple-text: #1d1d1f;
            --glass-bg: rgba(255, 255, 255, 0.65);
            --glass-border: 1px solid rgba(255, 255, 255, 0.4);
            --glass-blur: blur(25px);
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
        .reg-card {
            background: var(--glass-bg); backdrop-filter: var(--glass-blur); border: var(--glass-border);
            width: 100%; max-width: 420px; padding: 45px; border-radius: 32px; box-shadow: 0 20px 50px rgba(0,0,0,0.06);
            animation: scaleIn 0.5s cubic-bezier(0.16, 1, 0.3, 1); box-sizing: border-box;
        }
        @keyframes scaleIn { from { opacity: 0; transform: scale(0.95) translateY(10px); } to { opacity: 1; transform: scale(1) translateY(0); } }
        .logo { font-size: 24px; font-weight: 700; margin-bottom: 30px; text-align: center; letter-spacing: -0.5px; }

        .form-group { margin-bottom: 18px; }
        .form-control {
            width: 100%; padding: 15px 18px; background: rgba(255,255,255,0.5); border: 1px solid rgba(0,0,0,0.05);
            border-radius: 14px; box-sizing: border-box; font-size: 14px; transition: 0.3s; outline: none; font-family: inherit;
        }
        .form-control:focus { background: #fff; border-color: var(--apple-blue); box-shadow: 0 0 0 4px rgba(0,113,227,0.15); }

        select.form-control {
            appearance: none; background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" stroke="%2386868b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M6 9l6 6 6-6"/></svg>');
            background-repeat: no-repeat; background-position: right 18px center; font-weight: 600; color: var(--apple-blue);
        }

        .btn-submit {
            background: var(--apple-blue); color: #fff; border: none; padding: 16px; width: 100%; border-radius: 14px;
            font-size: 16px; font-weight: 600; cursor: pointer; transition: 0.3s; margin-top: 10px; box-shadow: 0 4px 15px rgba(0,113,227,0.2);
        }
        .btn-submit:hover { background: #0077ed; transform: translateY(-2px); box-shadow: 0 8px 25px rgba(0,113,227,0.3); }

        .links { margin-top: 25px; font-size: 13px; text-align: center; }
        .links a { color: #86868b; text-decoration: none; transition: 0.2s; }
        .links a:hover { color: var(--apple-blue); }
    </style>
</head>
<body>
<div class="reg-card">
    <div class="logo">创建您的商城通行证</div>
    <form action="RegisterServlet" method="post">
        <div class="form-group">
            <input type="text" name="username" class="form-control" placeholder="设置登录账号 (必填)" required>
        </div>
        <div class="form-group">
            <input type="password" name="password" class="form-control" placeholder="设置安全密码 (必填)" required>
        </div>
        <div class="form-group">
            <input type="text" name="realName" class="form-control" placeholder="真实姓名 / 店铺名称 (必填)" required>
        </div>
        <div class="form-group">
            <input type="text" name="phone" class="form-control" placeholder="联系手机号 (必填)" required>
        </div>
        <div class="form-group">
            <select name="role" class="form-control" required>
                <option value="customer">身份：我是买家 (Customer)</option>
                <option value="merchant">身份：我要开店入驻 (Merchant)</option>
            </select>
        </div>
        <button type="submit" class="btn-submit">立即注册</button>
    </form>
    <div class="links">
        <a href="login.jsp">已有账号？返回登录</a>
    </div>
</div>
</body>
</html>