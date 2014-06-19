<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="functions.*" %>
<%@ include file="twitter.jsp" %>

<%!
// 쿠키 호출 메서드
private void search(String str) {
	
}

private String removePunctuations(String str) {
    return str.replaceAll("\\p{Punct}|\\p{Digit}", "");
}

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






<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Twitter 데이터 마이닝 엔진 - result : <%=fncDeCode((String)session.getAttribute("keyword")) %></title>

<script>
function formSubmit(key){
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
    
    fm.action="search.jsp"; 
    fm.method="post";
    
    fm.submit();
}


</script>

</head>
<body>
<div align="center">
<font style="font-size:30pt">Twitter 데이터 마이닝 엔진</font>
<br><br>
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
검색한 키워드 리스트 : <%=session.getAttribute("keywordList") %>

<%
	request.setCharacterEncoding("EUC-KR");
	int MINIMUM_WORD_COUNT = 2;
	@SuppressWarnings("unchecked")
	ArrayList<WordCount> result = (ArrayList<WordCount>)session.getAttribute("result");
	@SuppressWarnings("unchecked")
	List<Status> tweets = (List<Status>)session.getAttribute("tweets");
	
	%><table border='1' align="center" width='1000'>
	<tr width='1000'><td width='1000'><%
	
	for (WordCount wc : result) {
		if (wc.n < MINIMUM_WORD_COUNT) break;
		
		%> <font style="font-size:<%=wc.n%>pt">
		<a href='#' onclick='formSubmit("<%=wc.word%>")'><%=wc.word%></a></font>　<%
	
		
	}
	
	%> 
	</td></tr>
	</table>
	
	<br><br><br> </div> <div align="left">
	
	
	<table border='1' align="center" width='1000'>
	<%
	
	
	
	
	
	
	

	for (Status tweet : tweets) {
		
		%> <tr width='1000'>
		<td width='150' align='center'><img src= <%=tweet.getUser().getProfileImageURL()%> border=0><br>
		<font style="font-weight: bold;"> @<%=tweet.getUser().getScreenName()%></font>
		</td>
		<td width='850'>
		<%
		out.println(tweet.getText());
		%><br><font style="font-size: 8pt;"><%
		out.println(tweet.getUser().getLocation());
		%><br>
		<%=tweet.getCreatedAt()%>
		<br><%
		out.println(" " + tweet.getUser().getDescription());	 
		%></font></td> </tr><%
	}
	
%>


</table>
</div>
</body>
</html>