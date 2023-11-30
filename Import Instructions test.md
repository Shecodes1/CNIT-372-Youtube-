## Part A:

Use the following code to create the three tables for this database.
Copy and paste this code into SQL Developer and run the script.

+-----------------------------------------------------------------------+
| CREATE TABLE YOUTUBERINFO (                                           |
|                                                                       |
| rank NUMBER,                                                          |
|                                                                       |
| rank_in_country NUMBER,                                               |
|                                                                       |
| youtuber VARCHAR2(255),                                               |
|                                                                       |
| category VARCHAR2(255),                                               |
|                                                                       |
| uploads NUMBER,                                                       |
|                                                                       |
| Country VARCHAR2(255),                                                |
|                                                                       |
| channel_type VARCHAR(255),                                            |
|                                                                       |
| created_date DATE,                                                    |
|                                                                       |
| PRIMARY KEY (youtuber)                                                |
|                                                                       |
| );                                                                    |
|                                                                       |
| CREATE TABLE COUNTRYSTATS (                                           |
|                                                                       |
| countryID NUMBER,                                                     |
|                                                                       |
| Country VARCHAR2(255),                                                |
|                                                                       |
| population NUMBER,                                                    |
|                                                                       |
| PRIMARY KEY (Country)                                                 |
|                                                                       |
| );                                                                    |
|                                                                       |
| CREATE TABLE CHANNEL_STATS (                                          |
|                                                                       |
| CHANNEL_ID NUMBER PRIMARY KEY,                                        |
|                                                                       |
| RANK NUMBER,                                                          |
|                                                                       |
| YOUTUBER VARCHAR2(255),                                               |
|                                                                       |
| SUBSCRIBERS NUMBER,                                                   |
|                                                                       |
| VIDEO_VIEWS NUMBER,                                                   |
|                                                                       |
| LOWEST_YEARLY_EARNINGS NUMBER,                                        |
|                                                                       |
| HIGHEST_YEARLY_EARNINGS NUMBER,                                       |
|                                                                       |
| Country VARCHAR2(255),                                                |
|                                                                       |
| FOREIGN KEY (YOUTUBER) REFERENCES YOUTUBERINFO(youtuber),             |
|                                                                       |
| FOREIGN KEY (Country) REFERENCES COUNTRYSTATS(Country)                |
|                                                                       |
| );                                                                    |
+=======================================================================+
+-----------------------------------------------------------------------+

##  

## Part B:

1.  Create Tables:

-   Run above queries to create tables

-   Right click "Tables" under "CNIT372 Connection" tab and click
    "refresh" to display the tables created

-   Create YouTuberInfo first, Country_stats, and ChannelStats last.

    -   This order is important to ensure the Primary Keys are
        established correctly

2.  Import Data from Worksheets:

-   Right click the table in the Connections Tab and click "Import
    Data..."

```{=html}
<!-- -->
```
-   Locate the data file from your computer by clicking the "Browse"
    button

-   Select the corresponding sheet (e.g. the YouTuber_Info sheet should
    be imported into the YouTuberInfo table).

-   Click "Next" and fill out the remaining information as needed.

-   Repeat this step for each worksheet/table.

![](./media/image1.png){width="3.960264654418198in"
height="4.6370188101487315in"}

Right clicking the table for "Import Data..."

![](./media/image2.png){width="6.5in" height="3.8194444444444446in"}

In the "Worksheet" dropdown, select the correct worksheet for the
corresponding table being created.
