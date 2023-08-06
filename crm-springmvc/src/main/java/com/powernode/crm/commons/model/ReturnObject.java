package com.powernode.crm.commons.model;

import java.util.Objects;

public class ReturnObject {
    private String code;// 1----成功 ，0----失败
    private String msg; //提示信息
    private Object retData; //其他数据

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Object getRetData() {
        return retData;
    }

    public void setRetData(Object retData) {
        this.retData = retData;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ReturnObject that = (ReturnObject) o;
        return Objects.equals(code, that.code) && Objects.equals(msg, that.msg) && Objects.equals(retData, that.retData);
    }

    @Override
    public int hashCode() {
        return Objects.hash(code, msg, retData);
    }

    @Override
    public String toString() {
        return "ReturnObject{" +
                "code='" + code + '\'' +
                ", msg='" + msg + '\'' +
                ", retData=" + retData +
                '}';
    }
}
