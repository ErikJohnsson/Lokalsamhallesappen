package com.example.lokalsamhallesappen;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

public class ExpandableListService {
    public void prepareListData(
            Sheet sheet,
            List<String> chapters,
            Map<String, List<String>> chaptersToSubChapters,
            Map<String, String> subChaptersToContent){
        DataFormatter dataFormatter = new DataFormatter();

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

            chapters.add(chapterNameFull);
            chaptersToSubChapters.put(chapterNameFull, new LinkedList<String>());


            int subChapter = 1;
            boolean foundEmpty = false;
            while (cellIterator.hasNext() && !foundEmpty) {
                Cell cell = cellIterator.next();
                String title = dataFormatter.formatCellValue(cell);
                if(title.equals("")){
                    foundEmpty = true;
                }
                else {
                    String subChapterName = chapter + "." + subChapter + " " + title;
                    subChapter++;

                    cell = cellIterator.next();
                    String text = dataFormatter.formatCellValue(cell);

                    chaptersToSubChapters.get(chapterNameFull).add(subChapterName);
                    subChaptersToContent.put(subChapterName, text);
                }
            }

            chapter++;
        }
    }
}
