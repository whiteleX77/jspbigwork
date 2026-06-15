package bean;

public class OrderVO {
    private int orderId;
    private int productId;
    private String productName;
    private String mainImage;
    private int buyCount;
    private double totalPrice;
    private String orderTime;
    private String buyerName;       // 买家账号
    private String buyerPhone;      // 收货手机号
    private String shippingAddress; // 收货地址

    // 🌟 B2B2C 架构新增核心字段
    private String orderNo;         // 流水订单号 (如: ORD123456789)
    private int buyerId;            // 买家底层身份ID (防越权查看)
    private int merchantId;         // 卖家身份ID (让掌柜只能看到自己的订单)
    private int logisticsStatus;    // 物流状态: 0待发货, 1已发货, 2已签收, 3已评价

    public String getOrderNo() { return orderNo; }
    public void setOrderNo(String orderNo) { this.orderNo = orderNo; }

    public int getBuyerId() { return buyerId; }
    public void setBuyerId(int buyerId) { this.buyerId = buyerId; }

    public int getMerchantId() { return merchantId; }
    public void setMerchantId(int merchantId) { this.merchantId = merchantId; }

    public int getLogisticsStatus() { return logisticsStatus; }
    public void setLogisticsStatus(int logisticsStatus) { this.logisticsStatus = logisticsStatus; }

    private String merchantName; // 卖家店铺名称

    public String getMerchantName() { return merchantName; }
    public void setMerchantName(String merchantName) { this.merchantName = merchantName; }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getMainImage() {
        return mainImage;
    }

    public void setMainImage(String mainImage) {
        this.mainImage = mainImage;
    }

    public int getBuyCount() {
        return buyCount;
    }

    public void setBuyCount(int buyCount) {
        this.buyCount = buyCount;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getOrderTime() {
        return orderTime;
    }

    public void setOrderTime(String orderTime) {
        this.orderTime = orderTime;
    }

    public String getBuyerName() {
        return buyerName;
    }

    public void setBuyerName(String buyerName) {
        this.buyerName = buyerName;
    }

    public String getBuyerPhone() {
        return buyerPhone;
    }

    public void setBuyerPhone(String buyerPhone) {
        this.buyerPhone = buyerPhone;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }
}


