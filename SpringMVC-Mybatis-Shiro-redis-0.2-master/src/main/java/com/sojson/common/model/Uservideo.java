package com.sojson.common.model;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;
import org.apache.commons.lang.builder.ToStringStyle;

import java.io.Serializable;


@SuppressWarnings("serial")
public class Uservideo implements Serializable {
	
	
	private Integer id;
	private String weixinNikename;
	
	private Integer videoId;
	
	private Integer userId;
	
	private Integer payments;
	private String onePaymentTime;
	
	private Long onePaymentPrice;
	private String secondPaymentTime;
	
	private Long secondPaymentPrice;
	private String by1;
	private String by2;
	private String by3;
	private String by4;
	private String by5;


	public void setId(Integer value) {
		this.id = value;
	}
	
	public Integer getId() {
		return this.id;
	}
	public void setWeixinNikename(String value) {
		this.weixinNikename = value;
	}
	
	public String getWeixinNikename() {
		return this.weixinNikename;
	}
	public void setVideoId(Integer value) {
		this.videoId = value;
	}
	
	public Integer getVideoId() {
		return this.videoId;
	}
	public void setUserId(Integer value) {
		this.userId = value;
	}
	
	public Integer getUserId() {
		return this.userId;
	}
	public void setPayments(Integer value) {
		this.payments = value;
	}
	
	public Integer getPayments() {
		return this.payments;
	}
	public void setOnePaymentTime(String value) {
		this.onePaymentTime = value;
	}
	
	public String getOnePaymentTime() {
		return this.onePaymentTime;
	}
	public void setOnePaymentPrice(Long value) {
		this.onePaymentPrice = value;
	}
	
	public Long getOnePaymentPrice() {
		return this.onePaymentPrice;
	}
	public void setSecondPaymentTime(String value) {
		this.secondPaymentTime = value;
	}
	
	public String getSecondPaymentTime() {
		return this.secondPaymentTime;
	}
	public void setSecondPaymentPrice(Long value) {
		this.secondPaymentPrice = value;
	}
	
	public Long getSecondPaymentPrice() {
		return this.secondPaymentPrice;
	}
	public void setBy1(String value) {
		this.by1 = value;
	}
	
	public String getBy1() {
		return this.by1;
	}
	public void setBy2(String value) {
		this.by2 = value;
	}
	
	public String getBy2() {
		return this.by2;
	}
	public void setBy3(String value) {
		this.by3 = value;
	}
	
	public String getBy3() {
		return this.by3;
	}
	public void setBy4(String value) {
		this.by4 = value;
	}
	
	public String getBy4() {
		return this.by4;
	}
	public void setBy5(String value) {
		this.by5 = value;
	}
	
	public String getBy5() {
		return this.by5;
	}

	public String toString() {
		return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
			.append("Id:",getId()+" ")
			.append("WeixinNikename:",getWeixinNikename()+" ")
			.append("VideoId:",getVideoId()+" ")
			.append("UserId:",getUserId()+" ")
			.append("Payments:",getPayments()+" ")
			.append("OnePaymentTime:",getOnePaymentTime()+" ")
			.append("OnePaymentPrice:",getOnePaymentPrice()+" ")
			.append("SecondPaymentTime:",getSecondPaymentTime()+" ")
			.append("SecondPaymentPrice:",getSecondPaymentPrice()+" ")
			.append("By1:",getBy1()+" ")
			.append("By2:",getBy2()+" ")
			.append("By3:",getBy3()+" ")
			.append("By4:",getBy4()+" ")
			.append("By5:",getBy5()+" ")
			.toString();
	}
	
	public int hashCode() {
		return new HashCodeBuilder().append(getId()).toHashCode();
	}
	
	public boolean equals(Object obj) {
		if(obj instanceof Uservideo == false) return false;
		if(this == obj) return true;
		Uservideo other = (Uservideo)obj;
		return new EqualsBuilder().append(getId(),other.getId()).isEquals();
	}
}

