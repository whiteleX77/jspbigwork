package bean;

public class Review {
    private int reviewId;
    private int rating;         // 打分 (1-5星)
    private String content;     // 评价文字内容
    private String createTime;  // 评价时间
    private String username;    // 评价人的账号名 (连表查询展示用)

    public int getReviewId() { return reviewId; }
    public void setReviewId(int reviewId) { this.reviewId = reviewId; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getCreateTime() { return createTime; }
    public void setCreateTime(String createTime) { this.createTime = createTime; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
}