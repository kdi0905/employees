<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>departmentList</title>
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
	<!--내용 -->

	<div class="text-center" style="font-size: 30px;"><h1>departments 테이블 목록</h1></div>
	<%
		//값 받아오기
		request.setCharacterEncoding("UTF-8");
		String deptName = "";
		if (request.getParameter("deptName") != null) {
			deptName = request.getParameter("deptName");
		}
		//페이지 번호
		int currentPage = 1;
		if (request.getParameter("currentPage") != null) {
			currentPage = Integer.parseInt(request.getParameter("currentPage"));
		}

		int rowPerPage = 10;

		//1. mariadb(sw)를 사용할 수 있게
		Class.forName("org.mariadb.jdbc.Driver");

		//2. mariadb접속(주소+포트번호+db이름,DB계정,DB계정암호)
		Connection conn = DriverManager.getConnection("jdbc:mariadb://kdi0905.kro.kr/employees", "root", "java1004");
		System.out.println(conn + "<-conn");

		//3. conn안에 쿼리(sql)를 만든다
		//order by 정렬,limit 제한 걸기기 ex) limit 시작번호, (보여지는 개수)
		String sql = "select * from departments order by dept_no asc limit ?,?";
		PreparedStatement stmt = null;
		if (deptName.equals("")) {
			sql = "select dept_no ,dept_name from departments order by dept_no asc limit ?,?";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, (currentPage - 1) * rowPerPage);
			stmt.setInt(2, rowPerPage);
			//deptName = o
		} else {
			sql = "select dept_no ,dept_name from departments where dept_name like ? order by dept_no asc limit ?,?";
			stmt = conn.prepareStatement(sql);

			stmt.setString(1, "%" + deptName + "%");
			stmt.setInt(2, (currentPage - 1) * rowPerPage);
			stmt.setInt(3, rowPerPage);
		}
		System.out.println(stmt + "<-stmt");

		//4. 쿼리(실행)의 결과물을 가지고 온다
		ResultSet rs = stmt.executeQuery();
		System.out.println(rs + "<-rs");

		//5. 출력
	%>

		<!-- 출력 -->
		<table class="table table-bordered table-hover table-striped text-center ">
			<thead>
				<tr>
					<td class="text-light">dept_no</td>
					<td class="text-light">dept_name</td>
				</tr>
			</thead>
			<tbody>
				<%
					while (rs.next()) {
				%>
				<tr>
					<td><%=rs.getString("dept_no")%></td>
					<td><%=rs.getString("dept_name")%></td>
				</tr>
				<%
					}
				%>
	
	
			</tbody>
		</table>
		<%
			//검색
		%>
		<div class="text-center col-6" style="margin: auto;">
				
				<form method="post" action="./departmentsList.jsp">
					<div class="input-group">
						<span style="font-size: 20px;">이름  : &nbsp;</span> <span><input class="form-control"  type="text" name="deptName" value=<%=deptName%>></span>
						<div class="input-group-append">
							<button type="submit" class="btn btn-primary">제출</button>
						</div>
					</div>
				</form>
			
		</div>
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
		
		<a class="btn btn-info" href="./departmentsList.jsp?currentPage=<%=1%>">처음</a>
		<a class="btn btn-info" href="./departmentsList.jsp?currentPage=<%=showpage - rowPerPage%>">이전</a>
		<%
			
			}
	
		//1부터 10까지 출력
		//11부터 20까지 출력
		//  이슈: 마지막 페이지는 더이상 다음이라는 링크가 존재 x -->
		//rs.getInt("count(*)") -->전체행 개수 	
		//결과물로 전체 행의 수를 알수 있다.
		//select count(*) from employees
		String sql2 = "select count(*) from departments";
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
		if (showpage + i <= lastPage) {
		%>
		<!-- 첫번째 숫자 부터 10개 출력 -->
		<a class="btn btn-info" href="./departmentsList.jsp?currentPage=<%=showpage + i%>"><%=showpage + i%></a>&nbsp;
		<%
			}
		}
		%>
	
	
		<!-- 첫번째 숫자 다음페이지 -->
		<%
			if (currentPage < lastPage) {
		%>
		<a class="btn btn-info" href="./departmentsList.jsp?currentPage=<%=showpage + rowPerPage%>">다음</a>
		<%
			}
		System.out.println(currentPage);
		System.out.println(lastPage);
		if (currentPage != lastPage) {
		%>
		<a class="btn btn-info" href="./departmentsList.jsp?currentPage=<%=lastPage%>">마지막</a>
	
		<%
			}
		%>
		</div>
	</div>
</body>
</html>