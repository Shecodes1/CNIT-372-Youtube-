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

CREATE TABLE channel_stats (
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

