<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="twitter.jsp" %>
 
<%
// 트위터에서 받은 인증토큰
String oauth_token = request.getParameter("oauth_token"); // request_token 토큰과 같은 값이여야 한다. (보안)
String oauth_verifier = request.getParameter("oauth_verifier"); // 트위터에서 인증요청하면서 생성한 토큰
 
// 세션에 저장했던 토큰
String request_token = (String) session.getAttribute("_MEI_TWITTER_REQUEST_TOKEN");
String request_tokensecret = (String) session.getAttribute("_MEI_TWITTER_REQUEST_TOKENSECRET");
 
// 보안상 토큰이 일치하는 지 비교.
if (request_token.equals(oauth_token)) {
 
TwitterAPIs sns = new TwitterAPIs();
sns.setConsumer_key("P2ODm5hwh3iCE3pPU1TtFQ");
sns.setConsumer_secret("IRrvPNwvrW8LbLubZqiyT8E3Tq9o6R9HoGRyf5g");
 
// 인증된 토큰 생성
sns.getAccessToken(request_token,request_tokensecret,oauth_verifier);
 
// 인증된 토큰을 변수에 담는다.
String access_token = sns.accessToken.getToken();
String access_tokensecret = sns.accessToken.getTokenSecret();
 
// 인증된 토큰을 쿠키에 저장. 다시 접속할 경우 로그인과정없애기 위해. 재인증.
Cookie cookie;
cookie = new Cookie("_MEI_TWITTER_ACCESS_TOKEN",access_token);
cookie.setMaxAge(60*60*24);    // 하루
response.addCookie(cookie);
 
cookie = new Cookie("_MEI_TWITTER_ACCESS_TOKENSECRET",access_tokensecret);
cookie.setMaxAge(60*60*24);    // 하루
response.addCookie(cookie);

%> 
<jsp:forward page="index.jsp"/>
<a href="http://168.131.153.169:8080/chlvlftjsrkqTest/index.jsp">로그인 완료! 클릭</a> <%

 
// 완료되면 생성한 세션 제거함.
 
}
 
%>