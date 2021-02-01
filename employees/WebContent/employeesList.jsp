<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>employees</title>
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
	<!-- employees 테이블 목록 -->

	<div class="text-center" style="font-size: 30px;"><h1>employees 테이블 목록</h1></div>
	<%
		request.setCharacterEncoding("UTF-8");
	int currentPage = 1;
	if (request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 10;

	//값 불러오기 
	String searchGender = "선택안함";
	if (request.getParameter("searchGender") != null) {
		searchGender = request.getParameter("searchGender");
	}
	System.out.println(searchGender);
	String name = "";
	if (request.getParameter("name") != null) {
		name = request.getParameter("name");
	}

	//1. mariadb(sw)를 사용할 수 있게
	Class.forName("org.mariadb.jdbc.Driver");

	//2. mariadb접속(주소+포트번호+db이름,DB계정,DB계정암호)
	Connection conn = DriverManager.getConnection("jdbc:mariadb://kdi0905.kro.kr/employees", "root", "java1004");
	System.out.println(conn + "<-conn");

	//3. conn안에 쿼리(sql)를 만든다
	//order by 정렬,limit 제한 걸기기 ex) limit 시작번호, (보여지는 개수)
	String sql = "";
	PreparedStatement stmt = null;
	//검색시 마지막 페이지
	int totalList = 0;
	int lastPage = 0;
	String sql2 = "";
	PreparedStatement stmt2 = null;

	// Gender = x, name x
	if (searchGender.equals("선택안함") && name.equals("")) {
		sql = "select emp_no , birth_date , first_name , last_name , gender ,hire_date from employees limit ?,?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, (currentPage - 1) * rowPerPage);
		stmt.setInt(2, rowPerPage);
		
		//총 개수 구하기
		sql2 ="select count(*) from employees";
		stmt2= conn.prepareStatement(sql2);
	

		//gender = o , name x
	} else if (!searchGender.equals("선택안함") && name.equals("")) {
		sql = "select emp_no , birth_date , first_name , last_name , gender ,hire_date from employees where gender =? limit ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, searchGender);
		stmt.setInt(2, (currentPage - 1) * rowPerPage);
		stmt.setInt(3, rowPerPage);

		//총 개수 구하기
		sql2 = " select count(*) from employees where gender =?";
		stmt2 = conn.prepareStatement(sql2);
		stmt2.setString(1, searchGender);
	
		//gender =x , name =o
	} else if (!searchGender.equals("선택안함") && !name.equals("")) {
		sql = "select emp_no , birth_date , first_name , last_name , gender ,hire_date from employees where first_name like ? or last_name like ? limit ?,?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%" + name + "%");
		stmt.setString(2, "%" + name + "%");
		stmt.setInt(3, (currentPage - 1) * rowPerPage);
		stmt.setInt(4, rowPerPage);

		//마지막 페이지
		sql2 = " select count(*) from employees  where first_name like ? or last_name like ?";
		stmt2 = conn.prepareStatement(sql2);
		stmt2.setString(1, "%" + name + "%");
		stmt2.setString(2, "%" + name + "%");

		//gender = o , name =o
	} else {
		sql = "select emp_no , birth_date , first_name , last_name , gender ,hire_date from employees where gender = ? and (first_name like ? or last_name like ?) limit ?,?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, searchGender);
		stmt.setString(2, "%" + name + "%");
		stmt.setString(3, name);
		stmt.setInt(4, (currentPage - 1) * rowPerPage);
		stmt.setInt(5, rowPerPage);

		//마지막페이지 
		sql2 = "select count(*) from employees where gender = ? and (first_name like ? or last_name like ?)";
		stmt2 = conn.prepareStatement(sql2);
		stmt2.setString(1, searchGender);
		stmt2.setString(2, "%" + name + "%");
		stmt2.setString(3, name);


	}

	//4. 쿼리(실행)의 결과물을 가지고 온다

	ResultSet rs = stmt.executeQuery();
	//마지막 페이지 구하기
		ResultSet rs2 = stmt2.executeQuery();
		if(rs2.next()){
			totalList = rs2.getInt("count(*)");
		}
	lastPage = totalList / rowPerPage;

	if (totalList % rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
	%>
	<table class="table table-bordered table-hover table-striped text-center ">
		<thead>
			<tr>
				<td class="text-light">emp_no</td>
				<td class="text-light">birth_date</td>
				<td class="text-light">age</td>
				<td class="text-light">first_name</td>
				<td class="text-light">last_name</td>
				<td class="text-light">gender</td>
				<td class="text-light">hire_date</td>
			</tr>
		</thead>
		<tbody>
			<%
				while (rs.next()) {
			%>
			<tr>
				<td><%=rs.getString("emp_no")%></td>
				<td><%=rs.getString("birth_date")%></td>
				<td>
					<%
						String age = rs.getString("birth_date");
					age = age.substring(0, 4);
					Calendar cal = Calendar.getInstance();
					int nowYear = cal.get(Calendar.YEAR);
					int ageInt = nowYear - Integer.parseInt(age);
					%><%=ageInt%></td>
				<td><%=rs.getString("first_name")%></td>
				<td><%=rs.getString("last_name")%></td>
				<td>
					<%
						String gender2 = rs.getString("gender");
					if (gender2.equals("M")) {
					%>남자 <%
						} else {
					%>여자 <%
						}
					%>
				</td>
				<td><%=rs.getString("hire_date")%></td>
			</tr>
			<%
				}
			%>
		</tbody>
	</table>
	<!-- 검색기능 -->
	<div class="text-center col-9" style="margin: auto;">
		<form method="post" action="./employeesList.jsp">
			<div class="input-group">
			<span style="font-size: 20px;">	gender : &nbsp;</span> <select class="form-control" name="searchGender">
					<%
						if (searchGender.equals("선택안함")) {
					%><option value="선택안함" selected="selected">선택안함</option>
					<%
						} else {
					%><option value="선택안함">선택안함
						<%
						}
					%>
						<%
							if (searchGender.equals("M")) {
						%>
					
					<option value="M" selected="selected">남</option>
					<%
						} else {
					%><option value="M">남
						<%
						}
					%>
						<%
							if (searchGender.equals("F")) {
						%>
					
					<option value="F" selected="selected">여</option>
					<%
						} else {
					%><option value="F">여
						<%
						}
					%>
					
				</select>
				
				
				<span style="font-size: 20px; margin-left: 30px;">name : &nbsp;</span> <input class="form-control" type="text" name="name" value="<%=name%>">
				
				<div class="input-group-append">
					<button type="submit"  class="btn btn-primary">선택</button>
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
	<a class="btn btn-info"
		href="./employeesList.jsp?currentPage=<%=1%>&searchGender=<%=searchGender%>&name=<%=name%>">처음</a>
	<a class="btn btn-info"
		href="./employeesList.jsp?currentPage=<%=showpage - rowPerPage%>&searchGender=<%=searchGender%>&name=<%=name%>">이전</a>
	<%
		
		}
	System.out.println(lastPage);
	//1부터 10까지 출력
	//11부터 20까지 출력
	//  이슈: 마지막 페이지는 더이상 다음이라는 링크가 존재 x -->
	//rs.getInt("count(*)") -->전체행 개수 	
	//결과물로 전체 행의 수를 알수 있다.
	//select count(*) from employees

	for (int i = 0; i < rowPerPage; i++) {
	if (showpage + i <= lastPage) {
	%>
	<!-- 첫번째 숫자 부터 10개 출력 -->

	<a class="btn btn-info"
		href="./employeesList.jsp?currentPage=<%=showpage + i%>&searchGender=<%=searchGender%>&name=<%=name%>"><%=showpage + i%></a>&nbsp;
	<%
		}
	}
	%>


	<!-- 첫번째 숫자 다음페이지 -->
	<%
		if (currentPage < lastPage) {
	%>
	<a class="btn btn-info"
		href="./employeesList.jsp?currentPage=<%=showpage + rowPerPage%>&searchGender=<%=searchGender%>&name=<%=name%>">다음</a>
	<%
		} 
	System.out.println(searchGender);
	if(currentPage != lastPage){
	%>
	
	<a class="btn btn-info"
		href="./employeesList.jsp?currentPage=<%=lastPage%>&searchGender=<%=searchGender%>&name=<%=name%>">마지막</a>
	<%} %>
	</div>
	</div>
</body>
</html>