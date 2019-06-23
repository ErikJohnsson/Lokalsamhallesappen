package com.example.lokalsamhallesappen;

import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

public class ChapterSearchService {

    /**
     *
     * @param charSequence The search phrase
     * @param subChapterToContent Subchapters mapped to their content.
     * @return A HashMap with Subchapter mapped to a string with the found word and words around it.
     */
    public Map<String, String> GetResults(CharSequence charSequence, Map<String, String> subChapterToContent){
        Map<String, String> result = new HashMap<>();

        for (String key: subChapterToContent.keySet()) {
            if(key.equals(charSequence)){
                result.put(key, key);
            }else{
                String content = subChapterToContent.get(key);
                content = ExcelSheetService.GetHtmlFormattedText(content).toString();
                if(Pattern.compile(Pattern.quote(charSequence.toString()),Pattern.CASE_INSENSITIVE).matcher(content).find()){
                    String lowerCaseContent = content.toLowerCase();
                    int index = lowerCaseContent.indexOf(charSequence.toString().toLowerCase());
                    int startIndex = index - 40;
                    int endIndex = index + 30;
                    if(endIndex > content.length()){
                        endIndex = content.length();
                    }
                    if(startIndex < 0){
                        startIndex = 0;
                    }

                    result.put(key, content.substring(startIndex, endIndex));
                }
            }
        }

        return result;
    }
}
