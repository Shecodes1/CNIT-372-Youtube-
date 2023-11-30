## <a name="_heading=h.gjdgxs"></a>Part A:
Use the following code to create the three tables for this database. Copy and paste this code into SQL Developer and run the script. 


|<p>CREATE TABLE YOUTUBERINFO (</p><p>`    `rank NUMBER,</p><p>`    `rank\_in\_country NUMBER,</p><p>`    `youtuber VARCHAR2(255),</p><p>`    `category VARCHAR2(255),</p><p>`    `uploads NUMBER, </p><p>`    `Country VARCHAR2(255),</p><p>`    `channel\_type VARCHAR(255),</p><p>`    `created\_date DATE,</p><p>`    `PRIMARY KEY (youtuber)</p><p>);</p><p></p><p>CREATE TABLE COUNTRYSTATS (</p><p>`    `countryID NUMBER, </p><p>`    `Country VARCHAR2(255),</p><p>`    `population NUMBER,</p><p>`    `PRIMARY KEY (Country)</p><p>);</p><p></p><p>CREATE TABLE CHANNEL\_STATS (</p><p>`    `CHANNEL\_ID NUMBER PRIMARY KEY,</p><p>`    `RANK NUMBER,</p><p>`    `YOUTUBER VARCHAR2(255),</p><p>`    `SUBSCRIBERS NUMBER,</p><p>`    `VIDEO\_VIEWS NUMBER,</p><p>`    `LOWEST\_YEARLY\_EARNINGS NUMBER,</p><p>`    `HIGHEST\_YEARLY\_EARNINGS NUMBER,</p><p>`    `Country VARCHAR2(255),</p><p>`    `FOREIGN KEY (YOUTUBER) REFERENCES YOUTUBERINFO(youtuber),</p><p>`    `FOREIGN KEY (Country) REFERENCES COUNTRYSTATS(Country)</p><p>);</p>|
| :- |

## <a name="_heading=h.30j0zll"></a>
## <a name="_heading=h.1fob9te"></a>Part B:
1. Create Tables:
- Run above queries to create tables
- Right click “Tables” under “CNIT372 Connection” tab and click “refresh” to display the tables created 
- Create YouTuberInfo first, Country\_stats, and ChannelStats last.
  - This order is important to ensure the Primary Keys are established correctly

1. Import Data from Worksheets:
- Right click the table in the Connections Tab and click “Import Data…”
- Locate the data file from your computer by clicking the “Browse” button 
- Select the corresponding sheet (e.g. the YouTuber\_Info sheet should be imported into the YouTuberInfo table). 
- Click “Next” and fill out the remaining information as needed. 
- Repeat this step for each worksheet/table.


Right clicking the table for “Import Data…” 

In the “Worksheet” dropdown, select the correct worksheet for the corresponding table being created. 




