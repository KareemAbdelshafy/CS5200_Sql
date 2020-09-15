package sentbot.model;


public class Comment extends Source {
	protected String CommentText;	
	protected String Ticker;

//Comment constructor
public Comment(int SourceKey, String Sentiment, Sector Sector, String CommentText, String Ticker) {
	super(SourceKey, Sentiment, Sector);
	this.CommentText = CommentText;
	this.Ticker = Ticker;
}

//Of Course, not all comments apply to tickers
public Comment(int SourceKey, String Sentiment, Sector Sector, String CommentText) {
	super(SourceKey, Sentiment, Sector);
	this.CommentText = CommentText;
}

//Getters and Setter
public String getCommentText() {
	return CommentText;
}

public void setCommentText(String CommentText) {
	this.CommentText = CommentText;
}

public String getTicker() {
	return Ticker;
}

public void setTicker(String ticker) {
	this.Ticker = ticker;
}

}