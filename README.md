# CNIT-372-Youtube-
Youtube Data Analysis

Project Synopsis:
Being a content creator and Youtube channel star has become popular since the early 2000s, where creators can earn exponential income from creating videos. The purpose of the project is to analyze the Youtube dataset with stats regarding popular Youtubers, their earnings, and country ranking. New or potential creators can use this data to determine what would be the best content their channel should have based on their country and what type of potential earnings they could make from this channel. 

Instructions for Using Code:
Part A:
Use the following code to create the three tables for this database. Copy and paste this code into SQL Developer and run the script. Please create the tables in the exact order as provided below since the Channel_Stats table references Foreign Keys from the Youtuberinfo and Countrystats. 

CREATE TABLE YOUTUBERINFO (
    rank NUMBER,
    rank_in_country NUMBER,
    youtuber VARCHAR2(255),
    category VARCHAR2(255),
    uploads NUMBER, 
    Country VARCHAR2(255),
    channel_type VARCHAR(255),
    created_date DATE,
    PRIMARY KEY (youtuber)
);

CREATE TABLE COUNTRYSTATS (
    countryID NUMBER, 
    Country VARCHAR2(255),
    population NUMBER,
    PRIMARY KEY (Country)
);

CREATE TABLE CHANNEL_STATS (
    CHANNEL_ID NUMBER PRIMARY KEY,
    RANK NUMBER,
    YOUTUBER VARCHAR2(255),
    SUBSCRIBERS NUMBER,
    VIDEO_VIEWS NUMBER,
    LOWEST_YEARLY_EARNINGS NUMBER,
    HIGHEST_YEARLY_EARNINGS NUMBER,
    Country VARCHAR2(255),
    FOREIGN KEY (YOUTUBER) REFERENCES YOUTUBERINFO(youtuber),
    FOREIGN KEY (Country) REFERENCES COUNTRYSTATS(Country)
);



Part B:
Create Tables:
Run above queries to create tables
Right click “Tables” under “CNIT372 Connection” tab and click “refresh” to display the tables created 
Create YouTuberInfo first, Country_stats, and ChannelStats last.
This order is important to ensure the Primary Keys are established correctly

Import Data from Worksheets:
Right click the table in the Connections Tab and click “Import Data…”
Locate the data file from your computer by clicking the “Browse” button 
Select the corresponding sheet (e.g. the YouTuber_Info sheet should be imported into the YouTuberInfo table). 
Click “Next” and fill out the remaining information as needed. 
Repeat this step for each worksheet/table.

