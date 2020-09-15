USE `mydb` ;
select * from users;
select * from GeopoliticalEvents;
select * from Watchlist;
select * from EventWatchList;


-- List all bullish geopolitical events?
Select Description as 'Bullish Geopolitical Events'
from GeopoliticalEvents
where Sentiment = 'bullish';

-- Count watches for each sentiment type for geopolitical events?
Select GE.Sentiment, count(WL.Users_UserName)
from GeopoliticalEvents GE
left join EventWatchList EWL
on GE.EventID = EWL.GeopoliticalEvents_EventID
left join Watchlist WL
on EWL.Watchlist_WatchlistID = WL.WatchlistID
group by GE.Sentiment;

-- What's the average number of geopolitical events being watched per user?
Select avg(u.eventcount)
from 
(select count(EWL.EventWatchlistID) eventcount
 from EventWatchList EWL
 left join Watchlist WL
 on EWL.Watchlist_WatchlistID = WL.WatchlistID
 group by WL.Users_UserName) as u
 
