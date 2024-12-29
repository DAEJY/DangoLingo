<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8");%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%----------------------------------------------------------------------
	[HTML Page - 헤드 영역]
	--------------------------------------------------------------------------%>
	<%--<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">--%>
    <meta charset="UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
	<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate"/>
	<meta http-equiv="pragma" content="no-cache"/>
    <meta name="Description" content="검색 엔진을 위해 웹 페이지에 대한 설명을 명시"/>
    <meta name="keywords" content="검색 엔진을 위해 웹 페이지와 관련된 키워드 목록을 콤마로 구분해서 명시"/>
    <meta name="Author" content="문서의 저자를 명시"/>
	<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>JSP-Prototype Page</title>
	<%----------------------------------------------------------------------
	[HTML Page - 스타일쉬트 구현 영역]
	[외부 스타일쉬트 연결 : <link rel="stylesheet" href="Hello.css"/>]
	--------------------------------------------------------------------------%>
	<style type="text/css">
		/* -----------------------------------------------------------------
			HTML Page 스타일시트
		   ----------------------------------------------------------------- */
		.Body {
			margin: 100px auto; width: 700px;
		}
		
		.Title {
			color: blue; 
			font-size: 30px; font-weight: bold;
			text-align: center; text-shadow: 5px 5px 10px darkgray;
		}
					  
		.Line {
			border: 0px;  height: 3px;
			background-color: black;
			box-shadow: 5px 5px 10px gray;
		}
					  
		.Label {
			margin: 0px 120px;  height: 50px;
			color: teal;
			font-size: 24px; font-weight: bold; 
			text-shadow: 5px 5px 10px darkgray;
			align-content:center;
		}
					  
		.Data {
			font-size: 24px;
		}
		
		.Menu {
			height: 100px; width: 700px;
			text-align: center;
			align-content: center;
		}
					  
		.Button {
			font-size: 24px;
			box-shadow: 5px 5px 10px gray;
		}
		/* -----------------------------------------------------------------
			Modal 창 스타일시트
		   ----------------------------------------------------------------- */
        .Modal-Frame {
        	display: none;						/* 기본적으로 숨김 */
			position: fixed; z-index: 1;
			left: 0; top: 0;
			width: 100%; height: 100%;
			overflow: auto;
			background-color: rgba(0,0,0,0.3);	/* 배경 흐릿하게 처리 */
		}
		
        .Modal-Content {
        	margin: 10% auto; padding: 20px;
			width: 50%; height: 50%;
			border: 10px solid #555;
			background-color: #fefefe;
		}
		
        .Modal-Close {
        	float: right; color: #aaa;
            font-size: 30px; font-weight: bold;
		}
		
        .Modal-Close:hover,
        .Modal-Close:focus {
            color: black;
            cursor: pointer;
            text-decoration: none;
        }
        
        .Main-Background {
            filter: blur(5px);					/* 모달 창 아래 메인 배경 흐리게 처리 */
        }
        /* ----------------------------------------------------------------- */
	</style>
	<%----------------------------------------------------------------------
	[HTML Page - 자바스크립트 구현 영역]
	[외부 자바스크립트 연결 : <script type="text/javascript" src="Hello.js"/>]
	--------------------------------------------------------------------------%>
	<script type="text/javascript">
		// -----------------------------------------------------------------
		// [브라우저 갱신 완료 시 호출 할 이벤트 핸들러 연결 - 필수]
		// -----------------------------------------------------------------
		// window.onload = DocumentInit(InitMsg);
		// -----------------------------------------------------------------
		// [브라우저 갱신 완료 및 초기화 구현 함수 - 필수]
		// -----------------------------------------------------------------
		// 브라우저 갱신 완료 까지 기다리는 함수 - 필수
		// 일반적인 방식 : setTimeout(()=>alert('페이지가 모두 로드되었습니다!'), 50);
		function DocumentInit(callback)
		{
			var IntervalID = setInterval(
				function (callback)
	            {
					var performanceTiming = window.performance.timing;
					var loadEventEnd = performanceTiming.loadEventEnd;
	               	
	                if (loadEventEnd > 0)
	                {
	                   	clearInterval(IntervalID);
	                   	
	                   	callback();
					}
	            }, 50, callback);
        }
		// 브라우저 갱신 완료 시 호출되는 콜백 함수 - 필수
		function InitMsg()
        {
            alert('페이지가 모두 로드되었습니다!');
        }
		// -----------------------------------------------------------------
		// [브라우저 모달 창 함수 및 로직 구현 - 필수]
		// -----------------------------------------------------------------
	    function ShowModalWindow()
	    {
	        let divModalMain = document.getElementById("divModalMain");	// 모달 창 아래 메인
	        let divModal = document.getElementById("divModal");			// 모달 창
	        let btnClose = document.getElementById("btnClose");			// 모달 창 내부 닫기 버튼
			
	     	// 모달 창 아래 메인 배경 흐리게 처리
	        divModalMain.classList.add("Main-Background");
	     	// 모달 창 열기
	        divModal.style.display = "block";
			
	     	// 모달 창 내부 닫기 버튼 이벤트 핸들러
	        btnClose.onclick = function()
	        {
	        	// 모달 창 아래 메인 배경 기본으로 처리
	        	divModalMain.classList.remove("Main-Background");
	        	// 모달 창 닫기
	        	divModal.style.display = "none";
	        }
		}
		// -----------------------------------------------------------------
		// [사용자 함수 및 로직 구현]
		// -----------------------------------------------------------------
		// 쿠키 등록
		function SetCookie(Name, Value)
		{
			document.cookie = Name + '=' + Value;
		}
		// Hello 메시지 출력 & 쿠키 등록 함수(예시)
		function HelloCookie()
		{
			SetCookie('user', 'hello');
			
			alert('Hello...Jsp! & Add Cookie!');
		}
		// -----------------------------------------------------------------
	</script>
</head>
<%--------------------------------------------------------------------------
[JSP 전역 변수/함수 선언 영역 - 선언문 영역]
	- this 로 접근 가능 : 같은 페이지가 여러번 갱신 되더라도 변수/함수 유지 됨
	- 즉 현재 페이지가 여러번 갱신 되는 경우 선언문은 한번만 실행 됨
------------------------------------------------------------------------------%>
<%!
	// ---------------------------------------------------------------------
	// [JSP 전역 변수/함수 선언]
	// ---------------------------------------------------------------------
	
	// ---------------------------------------------------------------------
%>
<%--------------------------------------------------------------------------
[JSP 지역 변수 선언 및 로직 구현 영역 - 스크립트릿 영역]
	- this 로 접근 불가 : 같은 페이지가 여러번 갱신되면 변수/함수 유지 안 됨
	- 즉 현재 페이지가 여러번 갱신 될 때마다 스크립트릿 영역이 다시 실행되어 모두 초기화 됨
------------------------------------------------------------------------------%>
<%
	// ---------------------------------------------------------------------
	// [JSP 지역 변수 선언 : 웹 페이지 get/post 파라미터]
	// ---------------------------------------------------------------------
	String sData1 = request.getParameter("data1");
	String sData2 = request.getParameter("data2");
	String sData3 = request.getParameter("data3");
	// ---------------------------------------------------------------------
	// [JSP 지역 변수 선언 : 데이터베이스 파라미터]
	// ---------------------------------------------------------------------
	
	// ---------------------------------------------------------------------
	// [JSP 지역 변수 선언 : 일반 변수]
	// ---------------------------------------------------------------------
	Cookie[] oCookies = null;		// 쿠키 변수
	String IsCheck = null;			// 쿠키 헤더 Check
	String sCookieName = null;		// 쿠키 명
	String sCookieValue = null;		// 쿠키 값
	// ---------------------------------------------------------------------
	// [웹 페이지 get/post 파라미터 조건 필터링]
	// ---------------------------------------------------------------------
	sData1 = (sData1 == null) ? "" : sData1; 
	sData2 = (sData2 == null) ? "" : sData2;
	sData3 = (sData3 == null) ? "" : sData3;
	// ---------------------------------------------------------------------
	// [일반 변수 조건 필터링]
	// ---------------------------------------------------------------------
	// 쿠키 초기화
	IsCheck = request.getHeader("Cookie");
	
	if(IsCheck != null)
	{
		oCookies = request.getCookies();
		
		if (oCookies != null)
		{
		    for(Cookie cookie : oCookies)
		    {
		    	cookie.setMaxAge(0);
		        response.addCookie(cookie);
		    }
		}
	}
	// 쿠키 읽기
	oCookies = request.getCookies();

	if (oCookies != null)
	{		
		sCookieName = oCookies[0].getName();
		sCookieValue = oCookies[0].getValue();
	}
	// ---------------------------------------------------------------------
%>
<%--------------------------------------------------------------------------
[Beans/DTO 선언 및 속성 지정 영역]
------------------------------------------------------------------------------%>
	<%----------------------------------------------------------------------
	Beans 객체 사용 선언	: id	- 임의의 이름 사용 가능(클래스 명 권장)
						: class	- Beans 클래스 명
 						: scope	- Beans 사용 기간을 request 단위로 지정 Hello.HelloDTO 
	------------------------------------------------------------------------
	<jsp:useBean id="HelloDTO" class="Hello.HelloDTO" scope="request"></jsp:useBean>
	--%>
	<%----------------------------------------------------------------------
	Beans 속성 지정 방법1	: Beans Property에 * 사용
						:---------------------------------------------------
						: name		- <jsp:useBean>의 id
						: property	- HTML 태그 입력양식 객체 전체
						:---------------------------------------------------
	주의사항				: HTML 태그의 name 속성 값은 소문자로 시작!
						: HTML 태그에서 데이터 입력 없는 경우 null 입력 됨!
	------------------------------------------------------------------------
	<jsp:setProperty name="HelloDTO" property="*"/>
	--%>
	<%----------------------------------------------------------------------
	Beans 속성 지정 방법2	: Beans Property에 HTML 태그 name 사용
						:---------------------------------------------------
						: name		- <jsp:useBean>의 id
						: property	- HTML 태그 입력양식 객체 name
						:---------------------------------------------------
	주의사항				: HTML 태그의 name 속성 값은 소문자로 시작!
						: HTML 태그에서 데이터 입력 없는 경우 null 입력 됨!
						: Property를 각각 지정 해야 함!
	------------------------------------------------------------------------
	<jsp:setProperty name="HelloDTO" property="data1"/>
	<jsp:setProperty name="HelloDTO" property="data2"/>
	--%>
	<%----------------------------------------------------------------------
	Beans 속성 지정 방법3	: Beans 메서드 직접 호출
						:---------------------------------------------------
						: Beans 메서드를 각각 직접 호출 해야함!
	--------------------------------------------------------------------------%>
<%
	// HelloDTO.setData1(request.getParameter("data1"));
%>
<%--------------------------------------------------------------------------
[Beans DTO 읽기 및 로직 구현 영역]
------------------------------------------------------------------------------%>
<%
	
%>
<body class="Body">
	<%----------------------------------------------------------------------
	[HTML Page - FORM 디자인 영역]
	--------------------------------------------------------------------------%>
	<form name="form1" action="" method="post">
		<%------------------------------------------------------------------
			모달 창 아래 메인 페이지
		----------------------------------------------------------------------%>
		<div id="divModalMain">
			<%------------------------------------------------------------------
				타이틀
			----------------------------------------------------------------------%>
			<hr class="Line">
			<p  class="Title">Hello - ProtoType</p>
			<hr class="Line">
			<%------------------------------------------------------------------
				메인 페이지
			----------------------------------------------------------------------%>
			<ul>
				<li class="Label">데이터-1 <input class="Data" name="data1" type="text" value="<%=sData1 %>"></li>
				<li class="Label">데이터-2 <input class="Data" name="data2" type="text" value="<%=sData2 %>"></li>
				<li class="Label">데이터-3 <input class="Data" name="data3" type="text" value="<%=sData3 %>"></li>
			</ul>
			<hr class="Line">
			<div class="Menu" id="frameMain1">
				<input class="Button" type="submit" name="btnSubmit" value="화면갱신">&nbsp;&nbsp;
				<input class="Button" type="button" name="btnHelloCookie" value="메시지 출력" onclick="HelloCookie()">&nbsp;&nbsp;
				<input class="Button" type="button" name="btnShowModalWindow" value="모달 창 열기" onclick="ShowModalWindow()">
			</div>
			<hr class="Line">
	    </div>
		<%------------------------------------------------------------------
			모달 창 페이지
		----------------------------------------------------------------------%>
		<div class="Modal-Frame" id="divModal">
	        <div class="Modal-Content">
	            <span class="Modal-Close" id="btnClose">&times;</span>
	            <iframe src="ModalPopup.jsp" style="border:none; width:100%; height:100%;"></iframe>
	        </div>
        </div>
		<%------------------------------------------------------------------
		[JSP 페이지에서 바로 이동(바이패스)]
		----------------------------------------------------------------------%>
		<%------------------------------------------------------------------
		바이패스 방법1	: JSP forward 액션을 사용 한 페이지 이동
					:-------------------------------------------------------
					: page	- 이동 할 새로운 페이지 주소
					: name	- page 쪽에 전달 할 파라미터 명칭
					: value	- page 쪽에 전달 할 파라미터 데이터
					:		- page 쪽에서 request.getParameter("name1")로 읽음
					:-------------------------------------------------------
					: 이 방법은 기다리지 않고 바로 이동하기 때문에 현재 화면이 표시되지 않음
					: 브라우저 Url 주소는 현재 페이지로 유지 됨
		--------------------------------------------------------------------
		<jsp:forward page="Hello.jsp">
			<jsp:param name="name1" value='value1'/>
			<jsp:param name="name2" value='value2'/>
		</jsp:forward>
		--%>
		<%
		// -----------------------------------------------------------------
		//	바이패스 방법2	: RequestDispatcher을 사용 한 페이지 이동
		//				:---------------------------------------------------
		//				: sUrl	- 이동 할 새로운 페이지 주소
		//				:		- sUrl 페이지 주소에 GET 파라미터 전달 가능
		//				:		- sUrl 페이지가 갱신됨 즉,
		//				:		- sUrl 페이지 주소에 GET 파라미터 유무에 상관없이
		//				:		- sUrl 페이지 쪽에서 request.getParameter() 사용가능
		//				:-------------------------------------------------------
		//				: 이 방법은 기다리지 않고 바로 이동하기 때문에 현재 화면이 표시되지 않음
		//				: 브라우저 Url 주소는 현재 페이지로 유지 됨
		// -----------------------------------------------------------------
		// String sUrl = "Hello.jsp?name1=value1&name2=value2";
		//
		// RequestDispatcher dispatcher = request.getRequestDispatcher(sUrl);
		// dispatcher.forward(request, response);
		// -----------------------------------------------------------------
		//	바이패스 방법3	: response.sendRedirect을 사용 한 페이지 이동
		//				:---------------------------------------------------
		//				: sUrl	- 이동 할 새로운 페이지 주소
		//				:		- sUrl 페이지에 GET 파라미터만 전달 가능
		//				:		- sUrl 페이지 갱신 없음 즉,
		//				:		- sUrl 페이지 주소에 GET 파라미터 있는 경우만
		//				:		- sUrl 페이지 쪽에서 request.getParameter() 사용가능
		//				:-------------------------------------------------------
		//				: 이 방법은 기다리지 않고 바로 이동하기 때문에 현재 화면이 표시되지 않음
		//				: 브라우저의 Url 주소는 sUrl 페이지로 변경 됨
		// -----------------------------------------------------------------
		//String sUrl = "Hello.jsp?name1=value1&name2=value2";
		//
		//response.sendRedirect(sUrl);
		// -----------------------------------------------------------------
		%>
	</form>
	<%----------------------------------------------------------------------
	[HTML Page - END]
	--------------------------------------------------------------------------%>
</body>
</html>
