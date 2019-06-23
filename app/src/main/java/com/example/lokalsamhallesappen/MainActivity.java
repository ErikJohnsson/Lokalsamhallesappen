package com.example.lokalsamhallesappen;

import android.annotation.TargetApi;
import android.content.Context;
import android.graphics.Color;
import android.os.Bundle;

import androidx.appcompat.app.ActionBarDrawerToggle;
import androidx.appcompat.widget.Toolbar;
import androidx.core.view.GravityCompat;

import android.text.Editable;
import android.text.Html;
import android.text.Layout;
import android.text.TextWatcher;
import android.view.MenuItem;

import com.google.android.material.navigation.NavigationView;
import com.xeoh.android.texthighlighter.TextHighlighter;

import androidx.drawerlayout.widget.DrawerLayout;

import androidx.appcompat.app.AppCompatActivity;

import android.view.Menu;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ExpandableListView;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import org.apache.poi.ss.usermodel.Sheet;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static android.widget.ListPopupWindow.MATCH_PARENT;
import static android.widget.ListPopupWindow.WRAP_CONTENT;

public class MainActivity extends AppCompatActivity
        implements NavigationView.OnNavigationItemSelectedListener {

    private Map<String, String> subChaptersToContent = null;

    private ExpandableListAdapter listAdapter = null;
    private ExpandableListView expandableListView;
    private List<String> chapters = null;
    private HashMap<String, List<String>> chaptersToSubChapters = null;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        System.setProperty("org.apache.poi.javax.xml.stream.XMLInputFactory", "com.fasterxml.aalto.stax.InputFactoryImpl");
        System.setProperty("org.apache.poi.javax.xml.stream.XMLOutputFactory", "com.fasterxml.aalto.stax.OutputFactoryImpl");
        System.setProperty("org.apache.poi.javax.xml.stream.XMLEventFactory", "com.fasterxml.aalto.stax.EventFactoryImpl");
        setContentView(R.layout.activity_main);

        InitNavigationDrawer();
        InitNavigationList();
        switchToHomePage();
    }

    private void InitNavigationDrawer(){
        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        DrawerLayout drawer = findViewById(R.id.drawer_layout);
        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
                this, drawer, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close);
        drawer.addDrawerListener(toggle);
        toggle.syncState();
    }

    private void InitNavigationList(){
        if(chapters == null) {

            // Preparing list data
            chapters = new ArrayList<>();
            chaptersToSubChapters = new HashMap<>();
            subChaptersToContent = new HashMap<>();
            chapters.add("Start");

            ExcelSheetService excelSheetService = new ExcelSheetService();
            Sheet sheet = excelSheetService.GetSheet(getAssets());

            ExpandableListService service = new ExpandableListService();
            service.prepareListData(sheet, chapters, chaptersToSubChapters, subChaptersToContent);
        }
        // Setting list adapter
        // Gets the ExpandableListView
        expandableListView = findViewById(R.id.listViewExpandable);
        listAdapter = new ExpandableListAdapter(this, chapters, chaptersToSubChapters);
        expandableListView.setAdapter(listAdapter);
        expandableListView.setOnChildClickListener(new ExpandableListView.OnChildClickListener() {
            @Override
            public boolean onChildClick(ExpandableListView parent, View v, int groupPosition, int childPosition, long id) {
                return onSubChapterClicked(parent, v, groupPosition, childPosition, id);
            }
        });
        expandableListView.setOnGroupClickListener(new ExpandableListView.OnGroupClickListener() {
            @Override
            public boolean onGroupClick(ExpandableListView expandableListView, View view, int i, long l) {
                return onChapterClicked(expandableListView, view, i, l);
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

    private void switchToHomePage(){
        setContentView(R.layout.activity_main_homepage);
        InitNavigationDrawer();
        InitNavigationList();

        InitSearch();

        final LinearLayout chapterButtonLayout = findViewById(R.id.chaptersButtonLayout);
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

    private void InitSearch() {
        final EditText searchText = findViewById(R.id.searchText);
        final LinearLayout searchLayout = findViewById(R.id.searchLayout);
        searchLayout.setVisibility(View.GONE);

        searchText.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(final CharSequence charSequence, int i, int i1, int i2) {
                ChapterSearchService chapterSearchService = new ChapterSearchService();
                final ScrollView scrollView = findViewById(R.id.buttonScrollView);
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
                        resultView.setTextColor(getResources().getColor(R.color.colorPrimary));
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
                                .setBackgroundColor(getResources().getColor(R.color.colorAccent))
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

    private Button createChapterButton(String text, Context context){
        Button button = new Button(context);
        button.setText(text);
        button.setBackgroundColor(getResources().getColor(R.color.colorPrimary));
        button.setTextColor(getResources().getColor(R.color.white));
        return button;
    }

    @Override
    public void onBackPressed() {
        DrawerLayout drawer = findViewById(R.id.drawer_layout);
        if (drawer.isDrawerOpen(GravityCompat.START)) {
            drawer.closeDrawer(GravityCompat.START);
        } else {
            super.onBackPressed();
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    public boolean onSubChapterClicked(ExpandableListView parent, View v, int groupPosition, int childPosition, long id) {

        String item = chaptersToSubChapters.get(
                chapters.get(groupPosition)).get(
                childPosition);
        SwitchToSubChapter(item);


        DrawerLayout drawer = findViewById(R.id.drawer_layout);
        drawer.closeDrawer(GravityCompat.START);
        return true;
    }

    private void SwitchToSubChapter(String subChapter){
        setContentView(R.layout.activity_main);
        InitNavigationDrawer();
        InitNavigationList();

        String text = subChaptersToContent.get(subChapter);

        TextView textView = findViewById(R.id.TextViewPolitics);
        TextView titleTextView = findViewById(R.id.titlePolitics);

        titleTextView.setText(subChapter);

        if(getApplicationInfo().targetSdkVersion >= 24){
            textView.setText(ExcelSheetService.GetHtmlFormattedText(text));
        }else {
            // Sets the text un-formatted.
            textView.setText(text);
        }
    }

    private void SwitchToSubChapter(String subChapter, final String highlightedWord){
       SwitchToSubChapter(subChapter);
       final TextView textView = findViewById(R.id.TextViewPolitics);
       new TextHighlighter()
                .setBackgroundColor(getResources().getColor(R.color.colorAccent))
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
                ScrollView scrollView = findViewById(R.id.scrollviewContentPolitics);

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

    @Override
    public boolean onNavigationItemSelected(MenuItem item) {
        // Handle navigation view item clicks here.
        int id = item.getItemId();

        DrawerLayout drawer = findViewById(R.id.drawer_layout);
        drawer.closeDrawer(GravityCompat.START);
        return true;
    }
}
