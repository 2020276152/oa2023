package com.powernode.crm.commons.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtils {
    private DateUtils(){}

    /**
     * 将字符串时间转换为毫秒数（1971-01-01）
     * pattern:yyyy-MM-dd HH:mm:ss
     * @param strDate
     * @return Long
     * @throws ParseException
     */
    public static Long strDateToMillis(String strDate) throws ParseException {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.parse(strDate).getTime();
    }

    /**
     * 将Date转换成"yyyy-MM-dd HH:mm:ss"格式的字符串日期信息
     * @param date
     * @return
     */
    public static String dateTimeToStr(Date date){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(date);
    }

    /**
     * 将Date转换成"yyyy-MM-dd"格式的字符串日期信息
     * @param date
     * @return
     */
    public static String dateToStr(Date date){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        return sdf.format(date);
    }
}
