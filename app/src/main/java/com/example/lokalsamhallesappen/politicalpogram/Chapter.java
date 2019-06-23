package com.example.lokalsamhallesappen.politicalpogram;

import java.util.List;

public class Chapter {
    private String title;
    private List<Chapter> subChapters;
    private String content;
    private Chapter parent;

    public Chapter(String title, List<Chapter> subChapters, String content){
        this.title = title;
        this.subChapters = subChapters;
        this.content = content;
        if(subChapters != null) {
            for (Chapter sc : subChapters) {
                sc.parent = this;
            }
        }
    }

    public String getTitle(){
        return title;
    }

    public List<Chapter> getSubChapters(){
        return subChapters;
    }

    public String getContent(){
        return content;
    }

    public Chapter getParent(){
        return parent;
    }

    public Chapter getSubChapter(String subChapterTitle){
        for(Chapter subChapter: subChapters){
            if(subChapterTitle.toLowerCase().equals(subChapter.title.toLowerCase())){
                return subChapter;
            }
        }

        return null;
    }
}
