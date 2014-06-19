<%@ page contentType="text/html; charset=utf-8" %>
 
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>

<%@ page import="twitter4j.*" %>
<%@ page import="twitter4j.conf.*" %>
<%@ page import="twitter4j.auth.*" %>
<%@ page import="java.util.Map.*" %>
<%@ page import="functions.*" %>

<%!
/*
* Copyright (c) 2010, MEI By Seok Kyun. Choi. (최석균)
* http://syaku.tistory.com
*
* GNU Lesser General Public License
* http://www.gnu.org/licenses/lgpl.html
*/
 
public class TwitterAPIs {
 
	private String consumer_key;
	public void setConsumer_key(String consumer_key) {this.consumer_key = consumer_key; }
	private String consumer_secret;
	public void setConsumer_secret(String consumer_secret) {this.consumer_secret = consumer_secret; }
	 
	private RequestToken requestToken = null;
	private AccessToken accessToken = null;
	private Twitter twitter = null;
	 
	public TwitterAPIs() {
	twitter = new TwitterFactory().getInstance();
	}
	 
	// 인증 요청 토큰 생성
	public void getRequestToken() throws Exception{
	twitter.setOAuthConsumer(this.consumer_key, this.consumer_secret);
	requestToken = twitter.getOAuthRequestToken();
	}
	 
	// 인증된 토큰 생성
	public void getAccessToken(String request_token,String request_tokensecret,String oauth_verifier) throws Exception {
	try {
	twitter.setOAuthConsumer(this.consumer_key, this.consumer_secret);
	accessToken = twitter.getOAuthAccessToken(new RequestToken(request_token, request_tokensecret),oauth_verifier);
	} catch (TwitterException te) {
	System.out.println(" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"+ te);
	}
	 
	twitter.setOAuthAccessToken(accessToken);
	 
	System.out.println(twitter.verifyCredentials().getId()); // 사용자 아이디
	System.out.println("???????????????token : " + accessToken.getToken());
	System.out.println("???????????????tokenSecret : " + accessToken.getTokenSecret());
	}
	 
	// 재인증 처리
	public void SignIn(String access_token,String access_tokensecret) throws Exception {
	twitter.setOAuthConsumer(this.consumer_key, this.consumer_secret);
	 
	System.out.println("???????????????access_token : " + access_token);
	System.out.println("???????????????access_tokensecret : " + access_tokensecret);
	 
	twitter.setOAuthAccessToken(new AccessToken(access_token,access_tokensecret));
	// 사용자 아이디
	System.out.println("??????????????????" + twitter.verifyCredentials().getId());
	
	
	}
	
	
	
	ArrayList<WordCount> getMytimeline() {
		
		ArrayList<WordCount> words = new ArrayList<WordCount>();
		String str = "";
		try {
			
			List<Status> tweets = twitter.getUserTimeline();
		   
		    //List<Status> tweets = twitter.getTimeline();
		    for (Status tweet : tweets) {
		    	//i++;
		    	str+=tweet.getText() + "\n";
		        //System.out.println(i + " @" + tweet.getUser().getScreenName() + " - " + tweet.getText());
		    }
		    
		    
		    Scanner scan = new Scanner(str);
		    HashMap<String, Integer> count = new HashMap<String, Integer>();
		    while (scan.hasNext()) {
		        String word = removePunctuations(scan.next());
		       // if (filter.contains(word)) continue;
		        if (word.equals("")) continue;
		        Integer n = count.get(word);
		        count.put(word, (n == null) ? 1 : n + 1);
		    }
		    PriorityQueue<WordCount> pq = new PriorityQueue<WordCount>();
		    for (Entry<String, Integer> entry : count.entrySet()) {
		        pq.add(new WordCount(entry.getKey(), entry.getValue()));
		    }
		    words = new ArrayList<WordCount>();
		    while (!pq.isEmpty()) {
		        WordCount wc = pq.poll();
		        if (wc.word.length() > 2) words.add(wc);
		    }
		    
		    //session.setAttribute("result", words);
		    //session.setAttribute("tweets", tweets);
		    
		    return words;
		    
		    
		       
		} catch (TwitterException te) {
		   te.printStackTrace();
		   System.out.println("Failed to search tweets: " + te.getMessage());
		   //System.exit(-1);
		   
		   return words;
		}
		
		//return words;
	}
	
	private String removePunctuations(String str) {
	    return str.replaceAll("\\p{Punct}|\\p{Digit}", "");
	}

 
}


%>