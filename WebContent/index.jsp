<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>

<%@ page import="twitter4j.*" %>
<%@ page import="twitter4j.conf.*" %>
<%@ page import="twitter4j.auth.*" %>
<%@ page import="functions.*" %>
<%@ include file="twitter.jsp" %>
    
<%

ConfigurationBuilder cb = new ConfigurationBuilder();
cb.setDebugEnabled(true)
  .setOAuthConsumerKey("P2ODm5hwh3iCE3pPU1TtFQ")
  .setOAuthConsumerSecret("IRrvPNwvrW8LbLubZqiyT8E3Tq9o6R9HoGRyf5g")
  .setOAuthAccessToken("597128010-r7YjO2GJK9Isukys2h9UXOGU1PrzFqaSobg1kCFw")
  .setOAuthAccessTokenSecret("yM6bBQdbNj5uYjArkPp1aTuNIdWiBdCr0TbYN9ebSGSYr");
TwitterFactory tf = new TwitterFactory(cb.build());
Twitter twitter = tf.getInstance();
	
	
%>
	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Twitter 데이터 마이닝 엔진</title>

<script>
function formSubmit(key){
	//var a=document.createElement('form');
	//a.method='post';
	//a.action='search.jsp';
	//var b=document.createElement('input');
	//b.name='keyword';
	//b.value=fncEnCode(key);
	//a.appendChild(b);
	//a.submit();
	
	var fm=document.frm;
	frm.keyword.value=fncEnCode(key);
	fm.action='search.jsp'; 
    fm.method='post';
    
    fm.submit();
} 

function fncEnCode(param)
{
	var encode = '';
	
	for(i=0; i<param.length; i++)
	{
		var len  = ''+param.charCodeAt(i);
		var token = '' + len.length;
		encode  += token + param.charCodeAt(i);
	}
	
	return encode;
}

function fncSubmit()
{
    var fm=document.frm;
    
    //var keyword=document.createElement("input");
    //keyword.name="keyword";
    frm.keyword.value=fncEnCode(frm.keyword_box.value);
	//fm.appendChild(keyword);
    
    fm.action='search.jsp'; 
    fm.method='post';
    
    fm.submit();
}
</script>
</head>
<body>
<div align="center">
<font style="font-size:30pt">Twitter 데이터 마이닝 엔진</font>
<br><br>
<%
	session.setAttribute("keyword", "유대균");
%>

<!-- <a href=<%=response.encodeURL("search.jsp") %> >검색</a> -->
<form name="frm" method="post" onKeydown="javascript:if(event.keyCode == 13) fncSubmit();">
	검색어 : 
	<input type="text" size="50" name="keyword_box"><br>
	<input type='submit' name="Search" value="트위터 검색" onclick='javascript:fncSubmit();'>
	<select name="lang">
		<option value="ko">한국어</option>
		<option value="en">영어</option>
	</select>
	<input type="hidden" name="keyword">
	
</form>
<br><br>
<%

if(session.getAttribute("keywordList")!=null) {
	
	%>
	 검색한 키워드 : <%=session.getAttribute("keywordList") %>
<%
}




%>

<br><br>



<a href='#' onclick='javascript:formSubmit("세월호")'>세월호</a> 
<a href='#' onclick='javascript:formSubmit("유병언")'>유병언</a> 
<a href='#' onclick='javascript:formSubmit("안철수")'>안철수</a> 
<a href='#' onclick='javascript:formSubmit("유대균")'>유대균</a> 
<a href='#' onclick='javascript:formSubmit("금수원")'>금수원</a> 
<a href='#' onclick='javascript:formSubmit("밀양송전탑")'>밀양송전탑</a> 
<a href='#' onclick='javascript:formSubmit("문창극")'>문창극</a>
 
 
 <br><br>
 yesCNU 트위터 Contents
 <br>
 
<table border='1' align="center" width='1000'>
	<tr width='1000'><td width='1000'>
 <%
 
 ArrayList<WordCount> words = new ArrayList<WordCount>();
 String str = "";
 try {
 	
 	//List<Status> tweets = twitter.getUserTimeline(twitter.verifyCredentials().getId());
 	List<Status> tweets = twitter.getUserTimeline("yesCNU");
    
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
       
     
        
 } catch (TwitterException te) {
    te.printStackTrace();
    System.out.println("Failed to search tweets: " + te.getMessage());
    //System.exit(-1);
    
 }
 
 for (WordCount wc : words) {
	 
	int MINIMUM_WORD_COUNT = 2;
	if (wc.n < MINIMUM_WORD_COUNT) break;
	
	%><font style="font-size:<%=wc.n%>pt">
	<a href='#' onclick='formSubmit("<%=wc.word%>")'><%=wc.word%></a></font>　<%

	
	}
 
 %>
 </td>
 </tr>
 </table>

</div>
</body>
</html>





<%
	
	
	
	
	








%>
 
<%!
// 쿠키 호출 메서드
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