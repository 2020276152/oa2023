package com.powernode.crm.commons.utils;

import org.apache.poi.hssf.usermodel.HSSFCell;

/**
 * 无论cell类中的内容是什么类型，通一转换成String类型返回，在需要其他类型的时候，可以主动转换。
 */
public class HSSFUtils {
    private HSSFUtils(){}
    public static String getCellValueForStr(HSSFCell cell){
        String ret = "";
        if (cell.getCellType()==HSSFCell.CELL_TYPE_STRING){
            ret = cell.getStringCellValue();
        }else if (cell.getCellType()==HSSFCell.CELL_TYPE_NUMERIC){
            ret = Double.toString(cell.getNumericCellValue());
        }else if(cell.getCellType()==HSSFCell.CELL_TYPE_BOOLEAN){
            ret = Boolean.toString(cell.getBooleanCellValue());
        }else if(cell.getCellType()==HSSFCell.CELL_TYPE_FORMULA){
            ret = cell.getCellFormula();
        }
        return ret;
    }
}
