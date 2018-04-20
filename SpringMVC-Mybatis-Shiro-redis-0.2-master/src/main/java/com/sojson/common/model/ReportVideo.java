package com.sojson.common.model;

import java.io.Serializable;
import net.sf.json.JSONObject;

public class ReportVideo implements Serializable {


    public String getFull_name() {
        return full_name;
    }

    public void setFull_name(String full_name) {
        this.full_name = full_name;
    }

    public String getVideoname() {
        return videoname;
    }

    public void setVideoname(String videoname) {
        this.videoname = videoname;
    }

    public String getUploaddate() {
        return uploaddate;
    }

    public void setUploaddate(String uploaddate) {
        this.uploaddate = uploaddate;
    }

    public String getPlaytime() {
        return playtime;
    }

    public void setPlaytime(String playtime) {
        this.playtime = playtime;
    }

    public String getSkb() {
        return skb;
    }

    public void setSkb(String skb) {
        this.skb = skb;
    }

    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public Long getPromulgatorid() {
        return promulgatorid;
    }

    public void setPromulgatorid(Long promulgatorid) {
        this.promulgatorid = promulgatorid;
    }

    public String getEndtime() {
        return endtime;
    }

    public void setEndtime(String endtime) {
        this.endtime = endtime;
    }

    //用户名
    private String full_name;
    /**视频名称*/
    private String videoname;
    /**视频名称上传时间*/
    private String uploaddate;
    /**播放时间*/
    private String playtime;
    /**短链接*/
    private String skb;
    /**总计*/
    private String price;

    public String getVideocount() {
        return videocount;
    }

    public void setVideocount(String videocount) {
        this.videocount = videocount;
    }

    /**播放次数*/
    private String videocount;
    /**视频id*/
    private Long promulgatorid;
    /**0：开始时间*/
    private String starttime;

    public String getStarttime() {
        return starttime;
    }

    public void setStarttime(String starttime) {
        this.starttime = starttime;
    }

    /**结束时间*/

    private String endtime;


    public String toString(){
        return JSONObject.fromObject(this).toString();
    }

}
