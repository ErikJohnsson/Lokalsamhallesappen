package com.example.lokalsamhallesappen;

import android.annotation.TargetApi;
import android.content.res.AssetManager;
import android.text.Html;
import android.text.Spanned;
import android.widget.TextView;

import com.example.lokalsamhallesappen.politicalpogram.Chapter;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.openxml4j.opc.OPCPackage;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

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
    public static Spanned GetHtmlFormattedText(String unformattedString){
        return Html.fromHtml(unformattedString, Html.FROM_HTML_MODE_COMPACT);
    }

    public List<Chapter> getChapterData(
            Sheet sheet){
        DataFormatter dataFormatter = new DataFormatter();

        ArrayList<Chapter> chapters = new ArrayList<>();

        int chapter = 1;

        Iterator<Row> rowIterator = sheet.rowIterator();
        while (rowIterator.hasNext()) {
            Row row = rowIterator.next();
            Iterator<Cell> cellIterator = row.cellIterator();

            String chapterName = dataFormatter.formatCellValue(cellIterator.next());
            String chapterNameFull = chapter + ". " + chapterName;
            if(chapterName.equals("")){
                break;
            }

            //Extracts the "about" section
            Cell cell = cellIterator.next();
            cell = cellIterator.next();
            String aboutChapter = dataFormatter.formatCellValue(cell);

            ArrayList<Chapter> subChapters = new ArrayList<>();
            int subChapter = 1;
            boolean foundEmpty = false;
            while (cellIterator.hasNext() && !foundEmpty) {
                cell = cellIterator.next();
                String title = dataFormatter.formatCellValue(cell);
                if(title.equals("")){
                    foundEmpty = true;
                }
                else {
                    String subChapterName = chapter + "." + subChapter + " " + title;
                    subChapter++;

                    cell = cellIterator.next();
                    String text = dataFormatter.formatCellValue(cell);

                    Chapter newSubChapter = new Chapter(subChapterName, null, text);
                    subChapters.add(newSubChapter);
                }
            }

            chapters.add(new Chapter(chapterNameFull, subChapters, aboutChapter));
            chapter++;
        }

        return chapters;
    }
}
