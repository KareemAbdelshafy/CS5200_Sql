Use `sentbot`; 

-- Import Tables for external data
-- Covid Counts
DROP TABLE IF EXISTS `sentbot`.`DW_Daily_Counts` ;
CREATE TABLE `DW_Daily_Counts` (
  `date` date,
  `state` VARCHAR(30) DEFAULT NULL,
  `fips` INT DEFAULT NULL,
  `cases` INT DEFAULT NULL,
  `deaths` INT DEFAULT NULL
) ENGINE=InnoDB;

LOAD DATA INFILE './us-states-covid.csv' INTO TABLE DW_Daily_Counts FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES;

-- Spy
DROP TABLE IF EXISTS `sentbot`.`DW_SPY` ;
CREATE TABLE `DW_SPY` (
  `Date` date,
  `Open` double DEFAULT NULL,
  `High` double DEFAULT NULL,
  `Low` double DEFAULT NULL,
  `Close` double DEFAULT NULL,
  `Adj Close` bigint DEFAULT NULL,
  `Volume` int DEFAULT NULL
) ENGINE=InnoDB;

LOAD DATA INFILE './SPY.csv' INTO TABLE DW_SPY FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES;

LOAD DATA INFILE './commentSource.csv' INTO TABLE `Source` FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES;
LOAD DATA INFILE './commentComment.csv' INTO TABLE `Comment` FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES (SourceKey, CommentText);
LOAD DATA INFILE './headlineSource.csv' INTO TABLE `Source` FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES;
LOAD DATA INFILE './headlineHeadline.csv' INTO TABLE `NewsHeadline` FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES;

-- Transforms source tables data warehouse

Create Table dw_sentimenttransform as 
Select 
sum(CASE WHEN source.sentiment = "bullish" THEN 1 END) "bullish",
sum(CASE WHEN source.sentiment = "bearish" THEN 1 END) "bearish",
sum(CASE WHEN source.sentiment = "none" THEN 1 END) "nosentiment",
count(*) as "total",
case 
	when nh.sourcekey is not null then "newsheadline" 
	else "comment"
    end "Type",
    Source.DATE
from Source
left join Comment co
on co.sourcekey = Source.sourcekey
left join newsheadline nh
on nh.sourcekey = Source.sourcekey
group by Type,Date 
;
UPDATE dw_sentimenttransform SET bullish = 0 WHERE bullish IS NULL;
UPDATE dw_sentimenttransform SET bearish = 0 WHERE bearish IS NULL;
UPDATE dw_sentimenttransform SET nosentiment = 0 WHERE nosentiment IS NULL;

-- 5 queries and export statements

-- Overall Comments sentiment % per day vs % change in spy 
select * from 
(select spy.date, (spy.close-spy.open)/spy.open "SPY %change", 
dsent.bullish/(dsent.bullish + dsent.bearish + dsent.nosentiment) "bullishper",
dsent.bearish/(dsent.bullish + dsent.bearish + dsent.nosentiment) "bearishper",
dsent.nosentiment/(dsent.bullish + dsent.bearish + dsent.nosentiment) "neutralper"
from dw_sentimenttransform dsent
left join  dw_spy spy
on spy.date = dsent.date
where dsent.Type = "comment"
group by spy.date, dsent.bullish, dsent.bearish, dsent.nosentiment,spy.close,spy.open
order by spy.date) query1
where query1.date is not null
;

-- Overall newsheadlines sentiment vs % change in spy
select * from 
(select spy.date, (spy.close-spy.open)/spy.open "SPY %change", 
dsent.bullish/(dsent.bullish + dsent.bearish + dsent.nosentiment) "bullishper",
dsent.bearish/(dsent.bullish + dsent.bearish + dsent.nosentiment) "bearishper",
dsent.nosentiment/(dsent.bullish + dsent.bearish + dsent.nosentiment) "neutralper"
from dw_sentimenttransform dsent
left join  dw_spy spy
on spy.date = dsent.date
where dsent.Type = "newsheadline"
group by spy.date, dsent.bullish, dsent.bearish, dsent.nosentiment,spy.close,spy.open
order by spy.date) query2
where query2.date is not null
;

--  % change in spy vs % of each sentiment type per day
select * from (
With daily_total AS (
	select date, sum(bullish) as bullish
    , sum(bearish) as bearish
    , sum(nosentiment) as nosentiment
    from dw_sentimenttransform
    group by date
)
select spy.date, (spy.close-spy.open)/spy.open "SPY %change", 
dt.bullish/(dt.bullish + dt.bearish + dt.nosentiment) "bullishper",
dt.bearish/(dt.bullish + dt.bearish + dt.nosentiment) "bearishper",
dt.nosentiment/(dt.bullish + dt.bearish + dt.nosentiment) "neutralper"
from daily_total dt
left join  dw_spy spy
on spy.date = dt.date
group by spy.date, dt.bullish, dt.bearish, dt.nosentiment,spy.close,spy.open
order by spy.date) query3
where query3.date is not null
;

--  total covid cases and death cases in US vs % of each sentiment type
select * from (
select covid.date, sum(covid.cases) "covid cases", sum(covid.deaths) "deaths cases", 
dsent.bullish/(dsent.bullish + dsent.bearish + dsent.nosentiment) "bullishper",
dsent.bearish/(dsent.bullish + dsent.bearish + dsent.nosentiment) "bearishper",
dsent.nosentiment/(dsent.bullish + dsent.bearish + dsent.nosentiment) "neutralper"
from dw_sentimenttransform dsent
left join  DW_Daily_Counts covid
on covid.date = dsent.date
group by covid.date,dsent.bullish, dsent.bearish, dsent.nosentiment
order by covid.date) query4
where query4.date is not null
;

--  prevailing sentiment each day with the death cases to confirmed cases ratio each day

WITH daily_total AS (
	select date, sum(bullish) as bullish
    , sum(bearish) as bearish
    from dw_sentimenttransform
    group by date
)
select dt.date,sum(covid.deaths)/sum(covid.cases) "death to confirmed ratio",
case 
when dt.bullish > dt.bearish  THEN "Bullish"
when dt.bearish > dt.bullish THEN "Bearish"
else "None prevailing" end as PrevailingSentiment
from daily_total dt
left join  DW_Daily_Counts covid
on covid.date = dt.date
where covid.deaths is not null
group by dt.date, dt.bullish, dt.bearish
order by dt.date
;



