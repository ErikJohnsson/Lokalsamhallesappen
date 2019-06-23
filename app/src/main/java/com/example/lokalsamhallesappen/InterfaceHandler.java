package com.example.lokalsamhallesappen;

import android.content.Context;
import android.graphics.Color;
import android.text.Editable;
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

import com.xeoh.android.texthighlighter.TextHighlighter;

import org.apache.poi.ss.usermodel.Sheet;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static android.widget.ListPopupWindow.MATCH_PARENT;
import static android.widget.ListPopupWindow.WRAP_CONTENT;

public class InterfaceHandler {

    private AppCompatActivity activity = null;
    private Context context = null;

    private ExpandableListAdapter listAdapter = null;
    private ExpandableListView expandableListView;

    private List<String> chapters = null;
    private HashMap<String, List<String>> chaptersToSubChapters = null;
    private Map<String, String> subChaptersToContent = null;

    public InterfaceHandler(AppCompatActivity activity,
                            Context context,
                            List<String> chapters,
                            HashMap<String, List<String>> chaptersToSubChapters,
                            Map<String, String> subChaptersToContent){
        this.activity = activity;
        this.context = context;
        this.chapters = chapters;
        this.chaptersToSubChapters = chaptersToSubChapters;
        this.subChaptersToContent = subChaptersToContent;

    }

    public void switchToHomePage(){
        activity.setContentView(R.layout.activity_main_homepage);

        InitNavigationDrawer();
        InitNavigationList();
        InitSearch();

        final LinearLayout chapterButtonLayout = activity.findViewById(R.id.chaptersButtonLayout);
        final LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT);
        layoutParams.setMargins(0, 0, 0, 20);
        for (final String chapter: chapters){
            if(chapter != "Start") {
                Button button = createChapterButton(chapter, chapterButtonLayout.getContext());
                chapterButtonLayout.addView(button, layoutParams);
                button.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        chapterButtonLayout.removeAllViews();
                        for(final String subChapter: chaptersToSubChapters.get(chapter)){
                            Button button = createChapterButton(subChapter, chapterButtonLayout.getContext());
                            chapterButtonLayout.addView(button, layoutParams);
                            button.setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View view) {
                                    SwitchToSubChapter(subChapter);
                                }
                            });
                        }
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
        if(chapters == null) {

            // Preparing list data
            chapters = new ArrayList<>();
            chaptersToSubChapters = new HashMap<>();
            subChaptersToContent = new HashMap<>();
            chapters.add("Start");

            ExcelSheetService excelSheetService = new ExcelSheetService();
            Sheet sheet = excelSheetService.GetSheet(context.getAssets());

            ExpandableListService service = new ExpandableListService();
            service.prepareListData(sheet, chapters, chaptersToSubChapters, subChaptersToContent);
        }
        // Setting list adapter
        // Gets the ExpandableListView
        ExpandableListView expandableListView = activity.findViewById(R.id.listViewExpandable);
        listAdapter = new ExpandableListAdapter(context, chapters, chaptersToSubChapters);
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

    public Button createChapterButton(String text, Context context){
        Button button = new Button(context);
        button.setText(text);
        button.setBackgroundColor(context.getResources().getColor(R.color.colorPrimary));
        button.setTextColor(context.getResources().getColor(R.color.white));
        return button;
    }


    public void SwitchToSubChapter(String subChapter){
        activity.setContentView(R.layout.activity_main);
        InitNavigationDrawer();
        InitNavigationList();

        String text = subChaptersToContent.get(subChapter);

        TextView textView = activity.findViewById(R.id.TextViewPolitics);
        TextView titleTextView = activity.findViewById(R.id.titlePolitics);

        titleTextView.setText(subChapter);

        if(activity.getApplicationInfo().targetSdkVersion >= 24){
            textView.setText(ExcelSheetService.GetHtmlFormattedText(text));
        }else {
            // Sets the text un-formatted.
            textView.setText(text);
        }
    }

    public void SwitchToSubChapter(String subChapter, final String highlightedWord){
        SwitchToSubChapter(subChapter);
        final TextView textView = activity.findViewById(R.id.TextViewPolitics);
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

    public void InitSearch() {
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
                final ScrollView scrollView = activity.findViewById(R.id.buttonScrollView);
                searchLayout.removeAllViews();
                final LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT);
                layoutParams.setMargins(0, 0, 0, 10);
                if(searchText.getText().length() > 1) {
                    scrollView.setVisibility(View.GONE);
                    searchLayout.setVisibility(View.VISIBLE);

                    Map<String, String> result = chapterSearchService.GetResults(searchText.getText().toString(), subChaptersToContent);

                    int grayOrWhite = 0;
                    for (final String subChapter : result.keySet()) {
                        grayOrWhite++;
                        TextView resultView = new TextView(searchLayout.getContext());
                        resultView.setTextColor(activity.getResources().getColor(R.color.colorPrimary));
                        resultView.setTextSize(14);

                        if(grayOrWhite%2 == 0){
                            resultView.setBackgroundColor(Color.LTGRAY);
                        }

                        if (subChapter.equals(result.get(subChapter))) {
                            resultView.setText(subChapter);
                        } else {
                            resultView.setText("(" + subChapter + ") " + result.get(subChapter));
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
        if(chapters.get(i) == "Start"){
            switchToHomePage();
            return true;
        }

        return false;
    }

    public boolean onSubChapterClicked(ExpandableListView parent, View v, int groupPosition, int childPosition, long id) {

        String item = chaptersToSubChapters.get(
                chapters.get(groupPosition)).get(
                childPosition);
        SwitchToSubChapter(item);


        DrawerLayout drawer = activity.findViewById(R.id.drawer_layout);
        drawer.closeDrawer(GravityCompat.START);
        return true;
    }
}
