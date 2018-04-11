package com.sojson.common.model;

import net.sf.json.JSONObject;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

public class Video implements Serializable {


   //唯一id
    private Long ID;
    /**发布人id*/
    private Long PromulgatorID;
    /**视频名称*/
    private String VideoName;
    /**视频ftp地址*/
    private String VideoAddress;
    /**短链接*/
    private String SKB;
    /**二维码与视频名称（用时间戳+随机四位数）同个*/
    private String Alias;
    /**二维码ftp地址*/
    private String QRCodeAddress;
    /**0：随机价格 1：固定价格*/
    private Long IsFixedPrice;
    /**固定价格*/
    private BigDecimal FixedPrice;
    /**视频最低价格*/
    private BigDecimal MinPrice;
    /**视频最高价格*/
    private BigDecimal MaxPrice;
    /**修改时间*/
    private String UpdateTime;
    /**上传时间*/
    private  String UploadDate;
    /**0：未发布 1：已发布*/
    private Long Passed;
    /**发布时间*/
    private String PassedTiime;

    public Long getStatus() {
        return Status;
    }

    public void setStatus(Long status) {
        Status = status;
    }

    /**是否删除：1.未删除2.删除*/
    private Long Status;

    private String By1;
    private String By2;
    private String By3;
    private String By4;
    private String By5;

    public String getUserName() {
        return UserName;
    }

    public void setUserName(String userName) {
        UserName = userName;
    }

    private String UserName;

    public Video() {}

    public String getBy2() {
        return By2;
    }

    public void setBy2(String by2) {
        By2 = by2;
    }

    public String getBy3() {
        return By3;
    }

    public void setBy3(String by3) {
        By3 = by3;
    }

    public String getBy4() {
        return By4;
    }

    public void setBy4(String by4) {
        By4 = by4;
    }

    public String getBy5() {
        return By5;
    }

    public void setBy5(String by5) {
        By5 = by5;
    }

    public Video(Video video) {
        this.ID = video.getId();
        this.PromulgatorID = video.getPromulgatorID();
        this.VideoName = video.getVideoName();
        this.VideoAddress = video.getVideoAddress();
        this.SKB = video.getSKB();
        this.Alias = video.getAlias();
        this.QRCodeAddress = video.getQRCodeAddress();
        this.IsFixedPrice = video.getIsFixedPrice();
        this.FixedPrice = video.getFixedPrice();
        this.MinPrice = video.getMinPrice();
        this.MaxPrice = video.getMaxPrice();
        this.UpdateTime = video.getUpdateTime();
        this.UploadDate = video.getUploadDate();
        this.Passed = video.getPassed();
        this.PassedTiime = video.getPassedTiime();
        this.Status = video.getStatus();
        this.By1 = video.getBy1();
        this.By2 = video.getBy2();
        this.By3 = video.getBy3();

        this.By4 = video.getBy4();
        this.By5 = video.getBy5();



    }

    public Long getId() {
        return ID;
    }

    public void setId(Long id) {
        this.ID = id;
    }

    public Long getPromulgatorID() {
        return PromulgatorID;
    }

    public void setPromulgatorID(Long promulgatorID) {
        this.PromulgatorID = promulgatorID;
    }

    public String getVideoName() {
        return VideoName;
    }
    public void setVideoName(String videoName) {
        this.VideoName = videoName;
    }


    public String getVideoAddress() {
        return VideoAddress;
    }

    public void setVideoAddress(String videoAddress) {
        this.VideoAddress = videoAddress;
    }


    public String getSKB() {
        return SKB;
    }

    public void setSKB(String skb) {
        this.SKB = skb;
    }


    public String getAlias() {
        return Alias;
    }

    public void setAlias(String alias) {
        this.Alias = alias;
    }


    public String getQRCodeAddress() {
        return QRCodeAddress;
    }

    public void setQRCodeAddress(String qrCodeAddress) {
        this.QRCodeAddress = qrCodeAddress;
    }


    public Long getIsFixedPrice() {
        return IsFixedPrice;
    }

    public void setIsFixedPrice(Long isFixedPrice) {
        this.IsFixedPrice = isFixedPrice;
    }


    public BigDecimal getFixedPrice() {
        return FixedPrice;
    }

    public void setFixedPrice(BigDecimal fixedPrice) {
        this.FixedPrice = fixedPrice;
    }


    public BigDecimal getMinPrice() {
        return MinPrice;
    }

    public void setMinPrice(BigDecimal minPrice) {
        this.MinPrice = minPrice;
    }


    public BigDecimal getMaxPrice() {
        return MaxPrice;
    }

    public void setMaxPrice(BigDecimal maxPrice) {
        this.MaxPrice = maxPrice;
    }


    public String getUpdateTime() {
        return UpdateTime;
    }

    public void setUpdateTime(String updateTime) {
        this.UpdateTime = updateTime;
    }


    public String getUploadDate() {
        return UploadDate;
    }

    public void setUploadDate(String uploadDate) {
        this.UploadDate = uploadDate;
    }


    public Long getPassed() {
        return Passed;
    }

    public void setPassed(Long passed) {
        this.Passed = passed;
    }


    public String getPassedTiime() {
        return PassedTiime;
    }

    public void setPassedTiime(String passedTiime) {
        this.PassedTiime = passedTiime;
    }


    public String getBy1() {
        return By1;
    }

    public void setBy1(String by1) {
        this.By1 = by1;
    }



    public String toString(){
        return JSONObject.fromObject(this).toString();
    }
}