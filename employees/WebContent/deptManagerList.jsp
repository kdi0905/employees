<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>dept_manager</title>
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
	<%
		int currentPage = 1;
	if (request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 10;
	%>
	<h1>dept_manager 테이블 목록</h1>
	<%
		Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1004");
	String sql = "select * from dept_manager order by dept_no asc limit ?,?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, (currentPage - 1) * rowPerPage);
	stmt.setInt(2, rowPerPage);
	ResultSet rs = stmt.executeQuery();
	%>
	<table border="1">
		<thead>
			<tr>
				<td>dept_no</td>
				<td>emp_no</td>
				<td>from_date</td>
				<td>to_date</td>
			</tr>
		</thead>
		<tbody>
			<%
				while (rs.next()) {
			%>
			<tr>
				<td><%=rs.getString("dept_no")%></td>
				<td><%=rs.getString("emp_no")%></td>
				<td><%=rs.getString("from_date")%></td>
				<td><%=rs.getString("to_date")%></td>
			</tr>
			<%
				}
			%>
		</tbody>
	</table>
	<%
		//첫번째 나오는 숫자
	int showpage;
	if (currentPage % rowPerPage == 0) {//끝자리수가 0일때
		showpage = (currentPage - rowPerPage) / rowPerPage * rowPerPage + 1;
	} else {
		showpage = currentPage / rowPerPage * rowPerPage + 1;
	}

	if (currentPage > rowPerPage) {
	%>
	<!-- 페이지 숫자가 첫번째로 표시되는 페이지로 이동 -->
	<a href="./deptManagerList.jsp?currentPage=<%=1%>">처음</a>
	<a
		href="./deptManagerList.jsp?currentPage=<%= showpage - rowPerPage%>">이전</a>
	<%
		} else if (currentPage <= 10 && currentPage > 1) { //페이지 숫자가 10 밑이면 첫번째 페이지로 이동
	%>


	<a href="./deptManagerList.jsp?currentPage=<%= showpage%>">이전</a>
	<%
		} else {
	%>이전<%
		}
	//1부터 10까지 출력
	//11부터 20까지 출력
	//  이슈: 마지막 페이지는 더이상 다음이라는 링크가 존재 x -->
	//rs.getInt("count(*)") -->전체행 개수 	
	//괄과물로 전체 행의 수를 알수 있다.
	//select count(*) from employees
	String sql2 = "select count(*) from dept_manager";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	ResultSet rs2 = stmt2.executeQuery();
	int totalCount = 0;
	if (rs2.next()) {
	totalCount = rs2.getInt("count(*)");
	}
	int lastPage = totalCount / rowPerPage;
	if (totalCount % rowPerPage != 0) //나머지가 존재 한다면 나머지를 보여주기 위해서 하나의 페이지가 더 필요하다
	{
	lastPage = lastPage + 1;
	}

	for (int i = 0; i < rowPerPage; i++) {
	if (currentPage <= lastPage) {
	%>
	<!-- 첫번째 숫자 부터 10개 출력 -->

	<a href="./deptManagerList.jsp?currentPage=<%=showpage + i%>"><%=showpage + i%></a>&nbsp;
	<%
		currentPage++;
	}
	}
	%>


	<!-- 첫번째 숫자 다음페이지 -->
	<%
		if (currentPage < lastPage) {
	%>
	<a href="./deptManagerList.jsp?currentPage=<%=showpage + rowPerPage%>">다음</a>
	<%
		} else {
	%>
	다음
	<%
		}
	%>
	
	<a href="./deptManagerList.jsp?currentPage=<%=lastPage%>">마지막</a>
</body>
</html>