package com.example.lokalsamhallesappen;

import android.content.Context;
import android.graphics.Color;
import android.text.Editable;
import android.text.Html;
import android.text.Layout;
import android.text.TextWatcher;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ExpandableListView;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import androidx.appcompat.app.ActionBarDrawerToggle;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.core.view.GravityCompat;
import androidx.drawerlayout.widget.DrawerLayout;

import com.example.lokalsamhallesappen.politicalpogram.Chapter;
import com.xeoh.android.texthighlighter.TextHighlighter;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import static android.widget.ListPopupWindow.MATCH_PARENT;
import static android.widget.ListPopupWindow.WRAP_CONTENT;

public class InterfaceHandler {

    private AppCompatActivity activity;
    private Context context;

    private ExpandableListAdapter listAdapter = null;
    private ExpandableListView expandableListView;

    private List<Chapter> chapters;
    private HashMap<String, Chapter> titleToChapter = new HashMap<>();

    private List<String> chapterStrings;
    private HashMap<String, List<String>> chaptersToSubChapters;

    private Chapter parent  = null;


    public InterfaceHandler(AppCompatActivity activity,
                            Context context,
                            List<Chapter> chapters){
        this.activity = activity;
        this.context = context;
        this.chapters = chapters;

        for(Chapter c: chapters){
            titleToChapter.put(c.getTitle(), c);
        }

        chapterStrings = new ArrayList<>();
        chaptersToSubChapters = new HashMap<>();

        chapterStrings.add("Start");
        for(Chapter c: chapters){
            chapterStrings.add(c.getTitle());
            LinkedList<String> subChapters = new LinkedList<>();
            for(Chapter sc: c.getSubChapters()){
                subChapters.add(sc.getTitle());
            }

            chaptersToSubChapters.put(c.getTitle(), subChapters);
        }
    }

    public void switchToHomePage(){
        activity.setContentView(R.layout.activity_main_homepage);

        parent = null;

        InitNavigationDrawer();
        InitNavigationList();
        InitSearch();

        final LinearLayout chapterButtonLayout = activity.findViewById(R.id.subChaptersButtonLayout);

        final LinearLayout.LayoutParams buttonLayoutParams = new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT);
        buttonLayoutParams.setMargins(0, 0, 0, 20);

        for (final Chapter chapter: chapters){
            if(chapter.getTitle() != "Start") {
                Button button = createChapterButton(chapter.getTitle(), chapterButtonLayout.getContext());
                chapterButtonLayout.addView(button, buttonLayoutParams);
                button.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        switchToChapter(chapter);
                    }
                });
            }
        }
    }

    public void InitNavigationDrawer(){
        Toolbar toolbar = activity.findViewById(R.id.toolbar);
        activity.setSupportActionBar(toolbar);
        DrawerLayout drawer = activity.findViewById(R.id.drawer_layout);
        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
                activity, drawer, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close);
        drawer.addDrawerListener(toggle);
        toggle.syncState();
    }

    public void InitNavigationList(){

        // Setting list adapter
        // Gets the ExpandableListView
        ExpandableListView expandableListView = activity.findViewById(R.id.listViewExpandable);
        listAdapter = new ExpandableListAdapter(context, chapterStrings, chaptersToSubChapters);
        expandableListView.setAdapter(listAdapter);
        expandableListView.setOnChildClickListener(new ExpandableListView.OnChildClickListener() {
            @Override
            public boolean onChildClick(ExpandableListView parent, View v, int groupPosition, int childPosition, long id) {
                return onSubChapterClicked(parent, v, groupPosition, childPosition, id );
            }
        });
        expandableListView.setOnGroupClickListener(new ExpandableListView.OnGroupClickListener() {
            @Override
            public boolean onGroupClick(ExpandableListView expandableListView, View view, int i, long l) {
                return onChapterClicked(expandableListView, view, i, l);
            }
        });
    }

    private Button createChapterButton(String text, Context context){
        Button button = new Button(context);
        button.setText(text);
        button.setBackgroundColor(context.getResources().getColor(R.color.colorPrimary));
        button.setTextColor(context.getResources().getColor(R.color.white));
        return button;
    }

    private void switchToChapter(Chapter chapter){
        activity.setContentView(R.layout.activity_main_chapter);

        parent = new Chapter("Start", null,null);

        InitNavigationDrawer();
        InitNavigationList();

        LinearLayout subChaptersLayout = activity.findViewById(R.id.subChaptersButtonLayout);

        TextView aboutText = activity.findViewById(R.id.textViewAbout);
        aboutText.setText(ExcelSheetService.GetHtmlFormattedText(chapter.getContent()));

        TextView titleText = activity.findViewById(R.id.titleChapter);
        titleText.setText(chapter.getTitle());

        subChaptersLayout.removeAllViews();
        final LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT);
        layoutParams.setMargins(0, 0, 0, 20);

        for(final Chapter subChapter: chapter.getSubChapters()){
            Button button = createChapterButton(subChapter.getTitle(), subChaptersLayout.getContext());
            subChaptersLayout.addView(button, layoutParams);
            button.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    SwitchToSubChapter(subChapter);
                }
            });
        }
    }

    private void SwitchToSubChapter(Chapter subChapter){
        activity.setContentView(R.layout.activity_main_content);

        parent = subChapter.getParent();

        InitNavigationDrawer();
        InitNavigationList();

        String text = subChapter.getContent();

        TextView textView = activity.findViewById(R.id.textViewAbout);
        TextView titleTextView = activity.findViewById(R.id.titleChapter);

        titleTextView.setText(subChapter.getTitle());

        if(activity.getApplicationInfo().targetSdkVersion >= 24){
            textView.setText(ExcelSheetService.GetHtmlFormattedText(text));
        }else {
            // Sets the text un-formatted.
            textView.setText(text);
        }
    }

    private void SwitchToSubChapter(Chapter subChapter, final String highlightedWord){
        SwitchToSubChapter(subChapter);
        final TextView textView = activity.findViewById(R.id.textViewAbout);
        new TextHighlighter()
                .setBackgroundColor(context.getResources().getColor(R.color.colorAccent))
                .setForegroundColor(Color.WHITE)
                .setBold(true)
                .setItalic(true)
                .addTarget(textView)
                .highlight(highlightedWord, TextHighlighter.CASE_INSENSITIVE_MATCHER);


        // Have to listen to when the TreeViews layout is created or we get a nullPointerReference when calling getLayout()
        final ViewTreeObserver vto = textView.getViewTreeObserver();
        vto.addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override
            public void onGlobalLayout() {
                ScrollView scrollView = activity.findViewById(R.id.scrollviewContentPolitics);

                String lowerCaseContent = textView.getText().toString().toLowerCase();
                int startPos = lowerCaseContent.indexOf(highlightedWord.toLowerCase());

                Layout layout = textView.getLayout();

                int line = layout.getLineTop(layout.getLineForOffset(startPos));
                scrollView.scrollTo(0, line);

                // Removes the listener.
                vto.removeOnGlobalLayoutListener(this);
            }
        });

    }

    private void InitSearch() {
        final EditText searchText = activity.findViewById(R.id.searchText);
        final LinearLayout searchLayout = activity.findViewById(R.id.searchLayout);
        searchLayout.setVisibility(View.GONE);

        searchText.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(final CharSequence charSequence, int i, int i1, int i2) {
                ChapterSearchService chapterSearchService = new ChapterSearchService();
                final ScrollView scrollView = activity.findViewById(R.id.buttonChapterScrollView);
                searchLayout.removeAllViews();
                final LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT);
                layoutParams.setMargins(0, 0, 0, 10);
                if(searchText.getText().length() > 1) {
                    scrollView.setVisibility(View.GONE);
                    searchLayout.setVisibility(View.VISIBLE);

                    Map<Chapter, String> result = chapterSearchService.GetResults(searchText.getText().toString(), chapters);

                    int grayOrWhite = 0;
                    for (final Chapter subChapter : result.keySet()) {
                        grayOrWhite++;
                        TextView resultView = new TextView(searchLayout.getContext());
                        resultView.setTextColor(activity.getResources().getColor(R.color.colorPrimary));
                        resultView.setTextSize(14);

                        if(grayOrWhite%2 == 0){
                            resultView.setBackgroundColor(Color.LTGRAY);
                        }

                        if (subChapter.equals(result.get(subChapter))) {
                            resultView.setText(subChapter.getTitle());
                        } else {
                            resultView.setText("(" + subChapter.getTitle() + ") " + result.get(subChapter));
                        }
                        new TextHighlighter()
                                .setBackgroundColor(activity.getResources().getColor(R.color.colorAccent))
                                .setForegroundColor(Color.WHITE)
                                .setBold(true)
                                .setItalic(true)
                                .addTarget(resultView)
                                .highlight(charSequence.toString(), TextHighlighter.CASE_INSENSITIVE_MATCHER);

                        resultView.setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {
                                SwitchToSubChapter(subChapter, charSequence.toString());
                            }
                        });
                        searchLayout.addView(resultView, layoutParams);
                    }
                }else{
                    scrollView.setVisibility(View.VISIBLE);
                    searchLayout.setVisibility(View.GONE);
                }
            }

            @Override
            public void afterTextChanged(Editable editable) {

            }
        });
    }

    private boolean onChapterClicked(ExpandableListView expandableListView, View view, int i, long l) {
        if(chapterStrings.get(i) == "Start"){
            switchToHomePage();
            return true;
        }

        return false;
    }

    private boolean onSubChapterClicked(ExpandableListView parent, View v, int groupPosition, int childPosition, long id) {
        String subChapterName = chaptersToSubChapters.get(chapterStrings.get(groupPosition))
                .get(childPosition);

        Chapter chapter = titleToChapter.get(chapterStrings.get(groupPosition));
        Chapter subChapter = chapter.getSubChapter(subChapterName);
        SwitchToSubChapter(subChapter);


        DrawerLayout drawer = activity.findViewById(R.id.drawer_layout);
        drawer.closeDrawer(GravityCompat.START);
        return true;
    }

    public boolean goBack() {
        if(parent == null){
            return false;
        }else{
            if(parent.getTitle().equals("Start")){
                switchToHomePage();
            }else{
                switchToChapter(parent);
            }
        }
        return true;
    }
}
