package com.example.lokalsamhallesappen;

import android.annotation.TargetApi;
import android.content.res.AssetManager;
import android.text.Html;
import android.widget.TextView;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.openxml4j.opc.OPCPackage;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.IOException;
import java.io.InputStream;

public class ExcelSheetService {

    private static String FileName = "data.xlsx";

    public Sheet GetSheet(AssetManager assetManager){
        try
        {
            InputStream is = assetManager.open(FileName);
            OPCPackage pkg = OPCPackage.open(is);
            XSSFWorkbook workbook = new XSSFWorkbook(pkg);
            return workbook.getSheetAt(0);
        }
        catch (InvalidFormatException | IOException ex)
        {
            return null;
        }
    }


    @TargetApi(24)
    public static void SetTextViewTextFromHtml(TextView textView, String string)
    {
        textView.setText(Html.fromHtml(string, Html.FROM_HTML_MODE_COMPACT));
    }
}
