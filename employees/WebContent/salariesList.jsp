<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>salaries</title>
</head>
<body>
	<!-- 메뉴 -->
	<div>
		<table border="1">
			<tr>
				<td><a href="./index.jsp">홈으로</a></td>
				<td><a href="./departmentsList.jsp">departments 테이블 목록</a></td>
				<td><a href="./deptEmpList.jsp">dept_emp 테이블 목록</a></td>
				<td><a href="./deptManagerList.jsp">dept_manager 테이블 목록</a></td>
				<td><a href="./employeesList.jsp">employees 테이블 목록</a></td>
				<td><a href="./salariesList.jsp">salaries 테이블 목록</a></td>
				<td><a href="./titlesList.jsp">titles 테이블 목록</a></td>
			</tr>
		</table>
	</div>
	<h1>salaries 테이블 목록</h1>
	<% //한글로 변환
		request.setCharacterEncoding("UTF-8");
	int currentPage = 1; //현재 페이지
	if (request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 10; //게시판 리스트 검색
	int totalCount = 0; // 리스트 개수 
	int beginSalary = 0; // 시작연봉 찾기
	int endSalary = 0; // 마지막 연봉 찾기
	int maxSalary = 0; // 가장 높은 연봉 찾기
	if (request.getParameter("beginSalary") != null) {
		beginSalary = Integer.parseInt(request.getParameter("beginSalary"));
	}
	//db접속
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1004");
	String sql = "";	// 처음 sql
	String sql2 = ""; // 마지막 페이지 sql
	//max 값 구하기
	String maxSql = "select max(salary) from salaries"; //max값 구하기
	PreparedStatement maxstmt = conn.prepareStatement(maxSql);
	ResultSet maxrs = maxstmt.executeQuery();
	
	if (maxrs.next()) {
		maxSalary = maxrs.getInt("max(salary)");
		endSalary = maxSalary;
	}
	//endSalary의 값이 있다면 넣기
	if (request.getParameter("endSalary") != null) {
		endSalary = Integer.parseInt(request.getParameter("endSalary"));
	}
	// ?부터 ?사이의 연봉 찾기
	sql = "select emp_no, salary, from_date,to_date from salaries where salary between ? and ? limit ?,?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, beginSalary);
	stmt.setInt(2, endSalary);
	stmt.setInt(3, (currentPage - 1) * rowPerPage);
	stmt.setInt(4, rowPerPage);
	
	// 마지막 리스트 숫자 찾기
	sql2 = "select count(*) from salaries where salary between ? and ? ";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt2.setInt(1, beginSalary);
	stmt2.setInt(2, endSalary);
	//stmt.setInt(1, (currentPage - 1) * rowPerPage);
	//stmt.setInt(2, rowPerPage);
	System.out.println(beginSalary);
	System.out.println(endSalary);
	ResultSet rs = stmt.executeQuery();
	// 마지막 페이지 값 넣기
	ResultSet rs2 = stmt2.executeQuery();

	if (rs2.next()) {
		totalCount = rs2.getInt("count(*)");
	}
	int lastPage = totalCount / rowPerPage;
	if (totalCount % rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
	%>
	<!-- 테이블 생성 -->
	<table border="1">
		<thead>
			<tr>
				<td>emp_no</td>
				<td>salary</td>
				<td>from_date</td>
				<td>to_date</td>
			</tr>
		</thead>
		<tbody>
			<%
				while (rs.next()) {
			%>
			<tr>
				<td><%=rs.getString("emp_no")%></td>
				<td><%=rs.getString("salary")%></td>
				<td><%=rs.getString("from_date")%></td>
				<td><%=rs.getString("to_date")%></td>
			</tr>
			<%
				}
			%>
		</tbody>
	</table>
	<!-- 연봉검색  -->
	<form method="post" action="./salariesList.jsp">
		<select name="beginSalary">
			<%//연봉 검색을 만단위로 표시	
				for (int i = 0; i < maxSalary; i = i + 10000) {
				if (beginSalary == i) {
			%>
			<option value=<%=i%> selected="selected"><%=beginSalary%></option>
			<%
				} else {
			%>
			<option value=<%=i%>><%=i%></option>
			<%
				}
			}
			%>

		</select>
		~ 
		<!-- ~까지 연봉 검색 -->
		<select name="endSalary">
			<%	
				for (int i = maxSalary; i >= 0; i = i - 10000) {
					//연봉 검색을 만단위로 표시	
					if(i>=maxSalary-10000){
						%><option value=<%=i%>><%=i%></option><%
						i=i/10000*10000;
					}
				if (endSalary == i) {
			%>
			<option value=<%=i%> selected="selected"><%=endSalary%></option>
			<%
				} else {
			%>
			<option value=<%=i%>><%=i%></option>
			<%
				}
				if(i>=maxSalary-10000){
					i=i/10000*10000;
				}
			}
			%>
		</select>
		<button type="submit">검색</button>
	</form>
	<%
		
	int showpage; //페이지의 첫번째 나오는 숫자구하기
	int showpageCount=10; //페이지 숫자 개수
	if (currentPage % showpageCount == 0) {//끝자리수가 0일때
		showpage = (currentPage - showpageCount) /showpageCount * showpageCount + 1;
	} else {
		showpage = currentPage / showpageCount * showpageCount + 1;
	}
	if (currentPage != 1) {
	%>
	<!-- 처음으로 이동 -->
	<a
		href="./salariesList.jsp?currentPage=<%=1%>&beginSalary=<%=beginSalary%>&endSalary=<%=endSalary%>">처음</a>
	<%
		}
	if (currentPage > showpageCount) {
	%>
	<!-- 페이지 숫자가 첫번째로 표시되는 페이지로 이동 -->
	<a
	
		href="./salariesList.jsp?currentPage=<%=showpage - rowPerPage%>&beginSalary=<%=beginSalary%>&endSalary=<%=endSalary%>">이전</a>
	<%
		} else if (currentPage <= 10 && currentPage > 1) { //페이지 숫자가 10 밑이면 첫번째 페이지로 이동
	%>


	<a
		href="./salariesList.jsp?currentPage=<%=showpage%>&beginSalary=<%=beginSalary%>&endSalary=<%=endSalary%>">이전</a>
	<%
		}
	%>
	<%
		for (int i = 0; i < showpageCount; i++) {
		if (showpage + i <= lastPage) {
	%>
	<!-- 페이지 첫번째 숫자 부터 10개 출력 -->

	<a
		href="./salariesList.jsp?currentPage=<%=showpage + i%>&beginSalary=<%=beginSalary%>&endSalary=<%=endSalary%>"><%=showpage + i%></a>&nbsp;
	<%
		}
	}
	%>


	<!-- 첫번째 숫자 다음페이지로 이동 -->
	<%
		if (currentPage < lastPage) {
	%>
	<a
		href="./salariesList.jsp?currentPage=<%=showpage + rowPerPage%>&beginSalary=<%=beginSalary%>&endSalary=<%=endSalary%>">다음</a>
	<%
		}
	// 마지막 페이지로 이동
	if (currentPage != lastPage) {
	%>
	<a
		href="./salariesList.jsp?currentPage=<%=lastPage%>&beginSalary=<%=beginSalary%>&endSalary=<%=endSalary%>">마지막</a>
	<%
		}
	%>
</body>
</html>