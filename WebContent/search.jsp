<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
 
<%@ page import="twitter4j.*" %>
<%@ page import="twitter4j.conf.*" %>
<%@ page import="twitter4j.auth.*" %>
<%@ page import="functions.*" %>
<%@ include file="twitter.jsp" %>



<%
/*
TwitterAPIs sns = new TwitterAPIs();
 
//String keyword = request.getParameter("keyword");
// �몄쐞�����앹꽦��諛쏆� �좏겙
sns.setConsumer_key("P2ODm5hwh3iCE3pPU1TtFQ");
sns.setConsumer_secret("IRrvPNwvrW8LbLubZqiyT8E3Tq9o6R9HoGRyf5g");
 
HashMap<String,String> mapCookie = (HashMap) setCookies(request.getCookies());
 
// �몄쬆諛쏆� �좏겙
String access_token = mapCookie.get("_MEI_TWITTER_ACCESS_TOKEN");
String access_tokensecret = mapCookie.get("_MEI_TWITTER_ACCESS_TOKENSECRET");
 
*/


ConfigurationBuilder cb = new ConfigurationBuilder();
cb.setDebugEnabled(true)
  .setOAuthConsumerKey("P2ODm5hwh3iCE3pPU1TtFQ")
  .setOAuthConsumerSecret("IRrvPNwvrW8LbLubZqiyT8E3Tq9o6R9HoGRyf5g")
  .setOAuthAccessToken("597128010-r7YjO2GJK9Isukys2h9UXOGU1PrzFqaSobg1kCFw")
  .setOAuthAccessTokenSecret("yM6bBQdbNj5uYjArkPp1aTuNIdWiBdCr0TbYN9ebSGSYr");
TwitterFactory tf = new TwitterFactory(cb.build());
Twitter twitter = tf.getInstance();


// �ъ씤利앹뿬遺�

	 
//out.println(sns.twitter.verifyCredentials().getId()); // �ъ슜���꾩븘��
//out.println(sns.twitter.verifyCredentials().getScreenName()); // �ъ슜���대쫫





//session.setAttribute("keyword", keyword);
//response.sendRedirect("search2.jsp");




%>
   
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Twitter 데이터 마이닝 엔진 - searching...</title>
</head>
<body>
<%=request.getParameter("keyword") %> searching...
<%	
	//request.setCharacterEncoding("EUC-KR");
	
	//int i = 0; 
	ArrayList<WordCount> words = new ArrayList<WordCount>();
	String str = "";
	//String keyword = (String)session.getAttribute("keyword");
	String keyword = (String)request.getParameter("keyword");
	
	String lang = (String)request.getParameter("lang");		
	
	session.setAttribute("keyword", keyword);
	
	//System.out.println(keyword + " " + lang + " ");
	
	keyword = fncDeCode(keyword);
	//keyword = new String(keyword.getBytes("8859_1"), "EUC-KR");
	System.out.println("트마엔 : " + keyword);
	
	
	if(session.getAttribute("keywordList")==null) {
		session.setAttribute("keywordList", "");
	}
	session.setAttribute("keywordList", ((String)session.getAttribute("keywordList")) + " " + keyword);


	
    try {
    	 
    	 Query query = new Query(keyword);
         query.setCount(200);	
         query.setLang(lang);
         
   
	         
        // query.
         QueryResult result;
        
         //List<Status> tweets = new ArrayList<Status>();
                
         //int r = 0;
         //do {
         
	         result = twitter.search(query);
	         //List<Status> tweetsb = result.getTweets();
	         
	         List<Status> tweets = result.getTweets();
	         
	         //tweets.addAll(tweetsb);
	         
	         //System.out.println("getLimit" + result.getRateLimitStatus().getLimit());
	         //System.out.println("getRemaining" + result.getRateLimitStatus().getRemaining());
	         //System.out.println("getResetTimeInSeconds" + result.getRateLimitStatus().getResetTimeInSeconds());
	         //System.out.println("getSecondsUntilReset" + result.getRateLimitStatus().getSecondsUntilReset());
	         
	        
	         //List<Status> tweets = twitter.getTimeline();
	         //r++;
	        // if(r < 2) break;
	         
	         
	         
         
         //} while ((query = result.nextQuery()) != null);
         
         for (Status tweet : tweets) {
        	 
        	//if(tweet.isRetweet() == true) continue;
         	//i++;
         	str+=tweet.getText() + "\n";
             //System.out.println(i + " @" + tweet.getUser().getScreenName() + " - " + tweet.getText());
         }
         
         Filtering filtering = new Filtering();
         
         Scanner scan = new Scanner(str);
         HashMap<String, Integer> count = new HashMap<String, Integer>();
         while (scan.hasNext()) {
             String word = removePunctuations(scan.next());
             if (Filtering.filteringList().contains(word)) continue;
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
         
         session.setAttribute("result", words);
         session.setAttribute("tweets", tweets);
            
    } catch (TwitterException te) {
        te.printStackTrace();
        System.out.println("Failed to search tweets: " + te.getMessage());
        //System.exit(-1);
    }

	
	// session.setAttribute("result", words);
	
	

	
%>
<jsp:forward page="result.jsp"/>
<a href=<%=response.encodeURL("result.jsp") %> >寃곌낵蹂닿린</a>
</body>
</html>

<%
	
	







%>
 
<%!
// 荑좏궎 �몄텧 硫붿꽌��
private HashMap setCookies(Cookie[] cookies) {
	HashMap mapRet = new HashMap();
 
	if(cookies != null){
		for (int i = 0; i < cookies.length; i++) {
			Cookie obj = cookies[i];
			mapRet.put(obj.getName(),obj.getValue());
		}
	}
 
	return mapRet;
}

private String removePunctuations(String str) {
    return str.replaceAll("\\p{Punct}|\\p{Digit}", "");
}
 
%>

<%!
public static String fncDeCode(String param)
{
	StringBuffer sb= new StringBuffer();
	int pos= 0;
	boolean flg= true;
	
	if(param!=null)
	{
		if(param.length()>1)
		{
			while(flg)
			{
			String sLen= param.substring(pos,++pos);
			int nLen= 0;
		
			try
			{
				nLen= Integer.parseInt(sLen);
			}
			catch(Exception e)
			{
				nLen= 0;
			}
	
			String code= "";
			if((pos+nLen)>param.length())
			code= param.substring(pos);
			else
			code= param.substring(pos,(pos+nLen));
	
			pos+= nLen;
	
			sb.append(((char) Integer.parseInt(code)));
	
			if(pos >= param.length())
			flg= false;
			}
		}
	}
	else
	{
		param= "";
	}
	
	return sb.toString();
}
%>