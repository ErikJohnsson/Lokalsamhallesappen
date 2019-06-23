package com.example.lokalsamhallesappen;

import com.example.lokalsamhallesappen.politicalpogram.Chapter;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

public class ChapterSearchService {

    /**
     *
     * @param charSequence The search phrase
     * @param chapters The political chapters.
     * @return A HashMap with Subchapter mapped to a string with the found word and words around it.
     */
    public Map<Chapter, String> GetResults(CharSequence charSequence, List<Chapter> chapters){
        Map<Chapter, String> result = new HashMap<>();

        for(Chapter c: chapters) {
            for (Chapter sc : c.getSubChapters()) {
                if (sc.getTitle().equals(charSequence)) {
                    result.put(sc, sc.getTitle());
                } else {
                    String content = sc.getContent();
                    content = ExcelSheetService.GetHtmlFormattedText(content).toString();
                    if (Pattern.compile(Pattern.quote(charSequence.toString()), Pattern.CASE_INSENSITIVE).matcher(content).find()) {
                        String lowerCaseContent = content.toLowerCase();
                        int index = lowerCaseContent.indexOf(charSequence.toString().toLowerCase());
                        int startIndex = index - 40;
                        int endIndex = index + 30;
                        if (endIndex > content.length()) {
                            endIndex = content.length();
                        }
                        if (startIndex < 0) {
                            startIndex = 0;
                        }

                        result.put(sc, content.substring(startIndex, endIndex));
                    }
                }
            }
        }

        return result;
    }
}
