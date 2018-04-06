package com.sojson.common.utils;

import java.io.Serializable;

public abstract class BaseResponse  implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -6038831966630987155L;

	public Object getData() {
		return data;
	}
	public void setData(Object data) {
		this.data = data;
	}
	public String getResultCode() {
		return resultCode;
	}
	public void setResultCode(String resultCode) {
		this.resultCode = resultCode;
	}
	public String getResultMessage() {
		return resultMessage;
	}
	public void setResultMessage(String resultMessage) {
		this.resultMessage = resultMessage;
	}
	
	/**
	 * 把data转换成对象
	 * @param clazz
	 * @return
	 */
	public abstract String toJSON();
	
	protected String resultCode;
	protected String resultMessage;
	protected Object data;
}
