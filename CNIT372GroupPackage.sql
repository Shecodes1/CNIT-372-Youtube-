create or replace trigger YouTuber_Deleted
    before delete on Channel_Stats
    for each row
begin
    dbms_output.put_line(rpad(:OLD.Rank, 15, ' ') || :OLD.YouTuber);
end;
/

CREATE OR REPLACE PACKAGE cnit372_group3_package IS
    PROCEDURE getcategorycounts;

    PROCEDURE findpopulargenres;

    PROCEDURE topranked;

    PROCEDURE top5eachcountry (
        country_choice IN VARCHAR2,
        numrows        IN NUMBER
    );

    PROCEDURE categoryavgearnings;

    PROCEDURE incomepercapita;

    PROCEDURE leastincomepercapita;

    PROCEDURE contentratio (
        usergenre IN VARCHAR2
    );

    PROCEDURE toprankedratio;

    PROCEDURE IncomeMinusOutliers (
        p_country IN VARCHAR2
    );

END cnit372_group3_package;
/

CREATE OR REPLACE PACKAGE BODY cnit372_group3_package IS

    PROCEDURE getcategorycounts AS
    BEGIN
        FOR category_rec IN (
            SELECT
                category,
                COUNT(*) AS category_count
            FROM
                youtuberinfo
            GROUP BY
                category
            ORDER BY
                category_count DESC
        ) LOOP
            dbms_output.put_line('Category: ' || category_rec.category);
            dbms_output.put_line('Count: ' || category_rec.category_count);
            dbms_output.put_line('');
        END LOOP;
    END getcategorycounts;

    PROCEDURE findpopulargenres AS
    BEGIN
        FOR country_rec IN (
            SELECT DISTINCT
                country
            FROM
                youtuberinfo
        ) LOOP
            DECLARE
                most_popular_category  VARCHAR2(255);
                least_popular_category VARCHAR2(255);
            BEGIN
                SELECT
                    category
                INTO most_popular_category
                FROM
                    youtuberinfo
                WHERE
                    country = country_rec.country
                ORDER BY
                    uploads DESC
                FETCH FIRST 1 ROWS ONLY;

                SELECT
                    category
                INTO least_popular_category
                FROM
                    youtuberinfo
                WHERE
                    country = country_rec.country
                ORDER BY
                    uploads ASC
                FETCH FIRST 1 ROWS ONLY;

                dbms_output.put_line('Country: ' || country_rec.country);
                dbms_output.put_line('Most Popular Category: ' || most_popular_category);
                dbms_output.put_line('Least Popular Category: ' || least_popular_category);
                dbms_output.put_line('---------------------------');
            EXCEPTION
                WHEN no_data_found THEN
                    dbms_output.put_line('No data found for Country: ' || country_rec.country);
                    dbms_output.put_line('---------------------------');
            END;
        END LOOP;
    END findpopulargenres;

    PROCEDURE topranked AS
    BEGIN
        FOR current_youtuber IN (
            SELECT
                channel_stats.youtuber,
                youtuberinfo.country,
                channel_type
            FROM
                     channel_stats
                INNER JOIN youtuberinfo ON channel_stats.youtuber = youtuberinfo.youtuber
            WHERE
                rank_in_country = '1'
        ) LOOP
            dbms_output.put_line('Youtuber: '
                                 || rpad(current_youtuber.youtuber, 50)
                                 || ' Country: '
                                 || rpad(current_youtuber.country, 30)
                                 || ' Channel Type: '
                                 || rpad(current_youtuber.channel_type, 30));
        END LOOP;
    END topranked;

    PROCEDURE top5eachcountry (
        country_choice IN VARCHAR2,
        numrows        IN NUMBER
    ) AS
        earnings NUMBER;
        lowest   NUMBER;
        highest  NUMBER;
    BEGIN
        FOR current_youtuber IN (
            SELECT
                youtuberinfo.youtuber,
                rank_in_country,
                youtuberinfo.country,
                ( ( channel_stats.lowest_yearly_earnings + channel_stats.highest_yearly_earnings ) / 2 ),
                channel_stats.lowest_yearly_earnings,
                channel_stats.highest_yearly_earnings
            FROM
                     youtuberinfo
                INNER JOIN channel_stats ON youtuberinfo.youtuber = channel_stats.youtuber
            WHERE
                    rank_in_country <= numrows + 1
                AND youtuberinfo.country IS NOT NULL
                AND youtuberinfo.country = country_choice
            ORDER BY
                channel_stats.country,
                rank_in_country
        ) LOOP
            lowest := current_youtuber.lowest_yearly_earnings;
            highest := current_youtuber.highest_yearly_earnings;
            earnings := ( lowest + highest ) / 2;
            dbms_output.put_line('Youtuber: '
                                 || rpad(current_youtuber.youtuber, 50)
                                 || ' Country: '
                                 || rpad(current_youtuber.country, 30)
                                 || ' Channel Rank: '
                                 || rpad(earnings, 30));

        END LOOP;
    END top5eachcountry;

    PROCEDURE categoryavgearnings AS

        CURSOR all_categories IS
        SELECT
            category,
            SUM(lowest_yearly_earnings) + SUM(highest_yearly_earnings) / ( 2 * COUNT(*) ) AS avgearnings,
            COUNT(*)                                                                      AS numincategory
        FROM
                 channel_stats stats
            INNER JOIN youtuberinfo info ON stats.youtuber = info.youtuber
        GROUP BY
            category
        ORDER BY
            avgearnings DESC;

    BEGIN
        dbms_output.put(rpad('Category', 25, ' '));
        dbms_output.put(lpad('AvgEarnings', 15, ' '));
        dbms_output.put_line(rpad(' NumInCategory', 15, ' '));
        dbms_output.put(rpad('-', 24, '-'));
        dbms_output.put(rpad(' ', 16, '-'));
        dbms_output.put_line(rpad(' ', 15, '-'));
        FOR current_category IN all_categories LOOP
            dbms_output.put(rpad(nvl(current_category.category, 'N/A'), 20, ' '));

            dbms_output.put(lpad(to_char(current_category.avgearnings, '$999,999,999,999'), 20, ' '));

            dbms_output.put_line(lpad(current_category.numincategory, 12, ' '));
        END LOOP;

    END categoryavgearnings;

    PROCEDURE incomepercapita AS
        average_income_capita NUMBER;
        most_popular_category VARCHAR2(255);
    BEGIN
        FOR country_rec IN (
            SELECT DISTINCT
                country
            FROM
                youtuberinfo
            ORDER BY
                country
        ) LOOP
            BEGIN
                SELECT
                    category
                INTO most_popular_category
                FROM
                    youtuberinfo
                WHERE
                    country = country_rec.country
                ORDER BY
                    uploads DESC,
                    category ASC
                FETCH FIRST 1 ROWS ONLY;

                SELECT
                    ( SUM(channel_stats.highest_yearly_earnings) / SUM(countrystats.population) )
                INTO average_income_capita
                FROM
                         youtuberinfo
                    INNER JOIN countrystats ON youtuberinfo.country = countrystats.country
                    INNER JOIN channel_stats ON youtuberinfo.youtuber = channel_stats.youtuber
                WHERE
                        youtuberinfo.country = country_rec.country
                    AND youtuberinfo.category = most_popular_category;

                dbms_output.put_line('Country: ' || country_rec.country);
                dbms_output.put_line('Most Popular Category: ' || most_popular_category);
                dbms_output.put_line('Average Income Per Capita: ' || to_char(average_income_capita, '$99999.9999999'));
                dbms_output.put_line('---------------------------');
            EXCEPTION
                WHEN no_data_found THEN
                    dbms_output.put_line('No data found for Country: ' || country_rec.country);
                    dbms_output.put_line('---------------------------');
                WHEN zero_divide THEN
                    dbms_output.put_line('No population or earnings were found for this country: ' || country_rec.country);
                    dbms_output.put_line('---------------------------');
            END;
        END LOOP;
    END incomepercapita;

    PROCEDURE leastincomepercapita AS
        average_income_capita  NUMBER;
        least_popular_category VARCHAR2(255);
    BEGIN
        FOR country_rec IN (
            SELECT DISTINCT
                country
            FROM
                youtuberinfo
            ORDER BY
                country
        ) LOOP
            BEGIN
                SELECT
                    category
                INTO least_popular_category
                FROM
                    youtuberinfo
                WHERE
                    country = country_rec.country
                ORDER BY
                    uploads ASC,
                    category DESC
                FETCH FIRST 1 ROWS ONLY;

                SELECT
                    ( SUM(channel_stats.lowest_yearly_earnings) / SUM(countrystats.population) )
                INTO average_income_capita
                FROM
                         youtuberinfo
                    INNER JOIN countrystats ON youtuberinfo.country = countrystats.country
                    INNER JOIN channel_stats ON youtuberinfo.youtuber = channel_stats.youtuber
                WHERE
                        youtuberinfo.country = country_rec.country
                    AND youtuberinfo.category = least_popular_category;

                dbms_output.put_line('Country: ' || country_rec.country);
                dbms_output.put_line('Least Popular Category: ' || least_popular_category);
                dbms_output.put_line('Average Income Per Capita: ' || to_char(average_income_capita, '$99999.9999999'));
                dbms_output.put_line('---------------------------');
            EXCEPTION
                WHEN no_data_found THEN
                    dbms_output.put_line('No data found for Country: ' || country_rec.country);
                    dbms_output.put_line('---------------------------');
                WHEN zero_divide THEN
                    dbms_output.put_line('No population or earnings were found for this country: ' || country_rec.country);
                    dbms_output.put_line('---------------------------');
            END;
        END LOOP;
    END leastincomepercapita;

    PROCEDURE contentratio (
        usergenre IN VARCHAR2
    ) AS
    BEGIN
        FOR current_youtuber IN (
            SELECT
                youtuberinfo.youtuber,
                category,
                ( uploads / subscribers ) AS ratio
            FROM
                     youtuberinfo
                INNER JOIN channel_stats ON youtuberinfo.youtuber = channel_stats.youtuber
            WHERE
                category = usergenre
        ) LOOP
            dbms_output.put_line('Youtuber: '
                                 || rpad(current_youtuber.youtuber, 50)
                                 || 'Ratio: '
                                 || rpad(round(current_youtuber.ratio, 10), 50));
        END LOOP;
    END contentratio;

    PROCEDURE toprankedratio AS
    BEGIN
        FOR current_youtuber IN (
            SELECT
                channel_stats.youtuber,
                youtuberinfo.country,
                channel_type,
                ( ( highest_yearly_earnings + lowest_yearly_earnings ) / 2 ) / video_views AS ratio
            FROM
                     channel_stats
                INNER JOIN youtuberinfo ON channel_stats.youtuber = youtuberinfo.youtuber
            WHERE
                rank_in_country = '1'
        ) LOOP
            dbms_output.put_line('Youtuber: '
                                 || rpad(current_youtuber.youtuber, 50)
                                 || ' 
    Country: '
                                 || rpad(current_youtuber.country, 30)
                                 || ' 
    Ratio: '
                                 || rpad(to_char(current_youtuber.ratio, '$999.9999999'), 30));
        END LOOP;
    END toprankedratio;

    PROCEDURE IncomeMinusOutliers (
        p_country IN VARCHAR2
    )
    AS
        Cursor Top_YouTubers is
            select * from Channel_Stats
            where Country = p_country
            order by rank asc;
        
        Cursor Bottom_YouTubers is
            select * from Channel_Stats
            where Country = p_country
            order by rank desc;    
        
        current_top_youtuber Channel_Stats%ROWTYPE;
        current_bottom_youtuber Channel_Stats%ROWTYPE;
        
        counter NUMBER := 0;
        CountryEarnings NUMBER;
    BEGIN
        select sum(lowest_Yearly_earnings) 
            into CountryEarnings
        from channel_stats
        where country = p_country;
        
        open Top_Youtubers;
        
        fetch Top_Youtubers into current_top_youtuber;
        
        dbms_output.put_line(rpad('Rank', 15, ' ') ||'Top YouTubers Removed');
        dbms_output.put_line(rpad('-', 40, '-'));
        while counter < 10 and Top_YouTubers%FOUND LOOP
            delete from CHANNEL_STATS where Youtuber = current_Top_YouTuber.YouTuber;
            fetch Top_Youtubers into current_top_youtuber;
            counter := counter + 1;
        end LOOP;
        
        close Top_YouTubers;
        dbms_output.put_line('');
        counter := 0;
        open Bottom_Youtubers;
        
        fetch Bottom_Youtubers into current_bottom_youtuber;
        
        dbms_output.put_line(rpad('Rank', 15, ' ') ||'Bottom YouTubers Removed');
        dbms_output.put_line(rpad('-', 40, '-'));
        
        while counter < 10 and Bottom_YouTubers%FOUND LOOP
            delete from CHANNEL_STATS where Youtuber = current_bottom_youtuber.YouTuber;
            fetch Bottom_Youtubers into current_bottom_youtuber;
            counter := counter + 1;
        end LOOP;
        
        close Bottom_YouTubers;
        
        dbms_output.put_line('');
        dbms_output.put_line('Earnings in country "'|| p_country || '" including top and lowest 10 in country: ' || countryEarnings);
        
        select sum(lowest_Yearly_earnings) 
            into CountryEarnings
        from debug_youtube
        where country = p_country;
        
        dbms_output.put_line('Earnings in country "'|| p_country || '" excluding top and lowest 10 in country: ' || countryEarnings);
        dbms_output.put_line('');
        
        counter := 0;
        open Top_Youtubers;
        
        fetch Top_Youtubers into current_top_youtuber;
        
        dbms_output.put_line(rpad('Rank', 15, ' ') ||'New Top YouTubers');
        dbms_output.put_line(rpad('-', 40, '-'));
        while counter < 10 and Top_YouTubers%FOUND LOOP
            dbms_output.put(rpad(current_top_youtuber.rank, 15, ' '));
            dbms_output.put_line(current_top_youtuber.YouTuber);
            fetch Top_YouTubers into current_top_youtuber;
            counter := counter + 1;
        end LOOP;
        
        close Top_YouTubers;
        dbms_output.put_line('');
        
        counter := 0;
        open Bottom_Youtubers;
        
        fetch Bottom_Youtubers into current_bottom_youtuber;
        
        dbms_output.put_line(rpad('Rank', 15, ' ') ||'New Bottom YouTubers');
        dbms_output.put_line(rpad('-', 40, '-'));
        while counter < 10 and Bottom_YouTubers%FOUND LOOP
            dbms_output.put(rpad(current_bottom_youtuber.rank, 15, ' '));
            dbms_output.put_line(current_bottom_youtuber.YouTuber);
            fetch Bottom_Youtubers into current_bottom_youtuber;
            counter := counter + 1;
        end LOOP;
        
        close Bottom_YouTubers;
        
    END IncomeMinusOutliers;
    
    
END cnit372_group3_package;
/

