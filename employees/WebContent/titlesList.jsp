<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>titles</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<style type="text/css">
body{
	background-color: #EAEAEA;
}
thead{
	background-color: #747474;
}
</style>
</head>
<body>
	<body>
	<!-- 메뉴 -->
	<div class="container">
		<div class= "row" style="margin-top: 20px;">
			<div class="col-3">
				<h1>employees</h1>
			</div>
			<div class="col-9">
				<table class="table table-borderless text-center">
					<tr>
						<td><a class="btn btn-outline-secondary" href="./index.jsp">home</a></td>
						<td><a class="btn btn-outline-secondary" href="./departmentsList.jsp">departments</a></td>
						<td><a class="btn btn-outline-secondary" href="./deptEmpList.jsp">dept_emp</a></td>
						<td><a class="btn btn-outline-secondary" href="./deptManagerList.jsp">dept_manager</a></td>
						<td><a class="btn btn-outline-secondary" href="./employeesList.jsp">employees</a></td>
						<td><a class="btn btn-outline-secondary" href="./salariesList.jsp">salaries</a></td>
						<td><a class="btn btn-outline-secondary" href="./titlesList.jsp">titles</a></td>
					</tr>
				</table>
			</div>
		</div>
		<div class="text-center" style="font-size: 30px;"><h1>titles 테이블 목록</h1></div>
	<%
	int currentPage= 1;
	if(request.getParameter("currentPage")!=null)
	{
		currentPage= Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage=10;
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mariadb://kdi0905.kro.kr/employees","root","java1004");
		String sql ="select * from titles order by emp_no limit ?,?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, (currentPage-1)*rowPerPage);
		stmt.setInt(2,rowPerPage);
		ResultSet rs = stmt.executeQuery();
		
	%>
	<table class="table table-bordered table-hover table-striped text-center ">
		<thead>
			<tr>
				<td class="text-light">emp_no</td>
				<td class="text-light">title</td>
				<td class="text-light">from_date</td>
				<td class="text-light">to_date</td>	
			</tr>
		</thead>
		<tbody>
			<%
				while(rs.next()){ 
			%>
					<tr>
						<td><%=rs.getString("emp_no") %></td>
						<td><%=rs.getString("title") %></td>
						<td><%=rs.getString("from_date") %></td>
						<td><%=rs.getString("to_date") %></td>			
					</tr>
				<%
				}
			%>
		</tbody>
	</table>
	<div class="text-center" style="margin-top: 30px;" >
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
	<a class="btn btn-info" href="./titlesList.jsp?currentPage=<%=1%>">처음</a>
	<a class="btn btn-info"
		href="./titlesList.jsp?currentPage=<%= showpage - rowPerPage%>">이전</a>
	<%
		
		}
	//1부터 10까지 출력
	//11부터 20까지 출력
	//  이슈: 마지막 페이지는 더이상 다음이라는 링크가 존재 x -->
	//rs.getInt("count(*)") -->전체행 개수 	
	//괄과물로 전체 행의 수를 알수 있다.
	//select count(*) from employees
	String sql2 = "select count(*) from titles";
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
	if (showpage+i <= lastPage) {
	%>
	<!-- 첫번째 숫자 부터 10개 출력 -->

	<a class="btn btn-info" href="./titlesList.jsp?currentPage=<%=showpage + i%>"><%=showpage + i%></a>&nbsp;
	<%
		
	}
	}
	%>


	<!-- 첫번째 숫자 다음페이지 -->
	<%
		if (currentPage < lastPage) {
	%>
	<a class="btn btn-info" href="./titlesList.jsp?currentPage=<%=showpage + rowPerPage%>">다음</a>
	<%
		} 
	if(currentPage == lastPage){
	
		}else {
			%>
				<a class="btn btn-info" href="./titlesList.jsp?currentPage=<%=lastPage%>">마지막</a>
			<%
		}
	%>
	</div>
	</div>
</body>
</html>