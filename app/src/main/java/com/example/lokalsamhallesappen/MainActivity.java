package com.example.lokalsamhallesappen;

import android.os.Bundle;

import android.view.SubMenu;

import androidx.appcompat.app.ActionBarDrawerToggle;
import androidx.appcompat.widget.Toolbar;
import androidx.core.view.GravityCompat;

import android.view.MenuItem;

import com.google.android.material.navigation.NavigationView;

import androidx.drawerlayout.widget.DrawerLayout;

import androidx.appcompat.app.AppCompatActivity;

import android.view.Menu;
import android.view.View;
import android.widget.ExpandableListView;
import android.widget.TextView;
import android.widget.Toast;

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

public class MainActivity extends AppCompatActivity
        implements NavigationView.OnNavigationItemSelectedListener {

    private Map<String, String> subHeadersToContent = new HashMap<>();

    private ExpandableListAdapter listAdapter;
    private ExpandableListView expandableListView;
    private List<String> listDataHeaders;
    private HashMap<String, List<String>> headersToSubHeaders;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        System.setProperty("org.apache.poi.javax.xml.stream.XMLInputFactory", "com.fasterxml.aalto.stax.InputFactoryImpl");
        System.setProperty("org.apache.poi.javax.xml.stream.XMLOutputFactory", "com.fasterxml.aalto.stax.OutputFactoryImpl");
        System.setProperty("org.apache.poi.javax.xml.stream.XMLEventFactory", "com.fasterxml.aalto.stax.EventFactoryImpl");
        setContentView(R.layout.activity_main);

        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        DrawerLayout drawer = findViewById(R.id.drawer_layout);
        NavigationView navigationView = findViewById(R.id.nav_view);
        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
                this, drawer, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close);
        drawer.addDrawerListener(toggle);
        toggle.syncState();
        navigationView.setNavigationItemSelectedListener(this);

        // Gets the ExpandableListView
        expandableListView = findViewById(R.id.listViewExpandable);

        // Preparing list data
        ExcelSheetService excelSheetService = new ExcelSheetService();
        Sheet sheet = excelSheetService.GetSheet(getAssets());
        PrepareListData(sheet);

        listAdapter = new ExpandableListAdapter(this, listDataHeaders, headersToSubHeaders);

        // Setting list adapter
        expandableListView.setAdapter(listAdapter);
        expandableListView.setOnChildClickListener(new ExpandableListView.OnChildClickListener() {
            @Override
            public boolean onChildClick(ExpandableListView parent, View v, int groupPosition, int childPosition, long id) {
                return onSubChapterClicked(parent, v, groupPosition, childPosition, id);
            }
        });
    }


    private void PrepareListData(Sheet sheet){
        listDataHeaders = new ArrayList<>();
        headersToSubHeaders = new HashMap<>();
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

            listDataHeaders.add(chapterNameFull);
            headersToSubHeaders.put(chapterNameFull, new LinkedList<String>());


            int subChapter = 1;
            boolean foundEmpty = false;
            while (cellIterator.hasNext() && !foundEmpty) {
                Cell cell = cellIterator.next();
                String title = dataFormatter.formatCellValue(cell);
                if(title.equals("")){
                    foundEmpty = true;
                }
                else {
                    String subChapterName = chapter + "." + subChapter + ". " + title;
                    subChapter++;

                    cell = cellIterator.next();
                    String text = dataFormatter.formatCellValue(cell);

                    headersToSubHeaders.get(chapterNameFull).add(subChapterName);
                    subHeadersToContent.put(subChapterName, text);
                }
            }

            chapter++;
        }
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

        String item = headersToSubHeaders.get(
                listDataHeaders.get(groupPosition)).get(
                childPosition);

        String text = subHeadersToContent.get(item);

        TextView textView = findViewById(R.id.TextViewPolitics);
        TextView titleTextView = findViewById(R.id.titlePolitics);

        titleTextView.setText(item);

        if(getApplicationInfo().targetSdkVersion >= 24){
            ExcelSheetService.SetTextViewTextFromHtml(textView, text);
        }else {
            // Adds the text un-formatted.
            textView.setText(text);
        }


        DrawerLayout drawer = findViewById(R.id.drawer_layout);
        drawer.closeDrawer(GravityCompat.START);
        return true;
    }

    @Override
    public boolean onNavigationItemSelected(MenuItem item) {
        // Handle navigation view item clicks here.
        int id = item.getItemId();

        TextView textView = findViewById(R.id.TextViewPolitics);
        if(getApplicationInfo().targetSdkVersion >= 24){
            ExcelSheetService.SetTextViewTextFromHtml(textView, subHeadersToContent.get(item));
        }else {
            // Adds the text un-formatted.
            textView.setText(subHeadersToContent.get(item));
        }


        DrawerLayout drawer = findViewById(R.id.drawer_layout);
        drawer.closeDrawer(GravityCompat.START);
        return true;
    }
}
