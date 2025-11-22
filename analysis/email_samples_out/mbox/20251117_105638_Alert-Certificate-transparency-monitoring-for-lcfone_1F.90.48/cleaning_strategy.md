# 清理策略

- 移除追蹤 UI 與按鈕：View this post / Read in app / Keep reading / Unsubscribe / Manage preferences
- 移除 <style>/<script>、隱藏元素、1x1 追蹤像素
- 轉換 <br>/<p> 為換行，壓縮連續空白
- HTML 實體解碼（&nbsp; &amp; 等）並刪除過多的連結參數
- Cloudflare 憑證監控：保留網域與事件時間，移除範本化版權與所有平台圖示
