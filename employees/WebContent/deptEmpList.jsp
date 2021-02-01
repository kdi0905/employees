<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>dept_emp</title>
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
	<!-- dept_emp 테이블 목록 -->
	<div class="text-center" style="font-size: 30px;"><h1>dept_emp 테이블 목록</h1></div>
	<%
		//페이지 번호
	request.setCharacterEncoding("UTF-8");
	int currentPage = 1;

	if (request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}

	// 값 가져오기
	String check = "no";
	if (request.getParameter("check") != null) {
		check = request.getParameter("check");
	}
	String deptNo = "선택안함";
	if (request.getParameter("deptNo") != null) {
		deptNo = request.getParameter("deptNo");
	}
	//페이지 보여주는 개수
	int rowPerPage = 10;
	//1. mariadb(sw)를 사용할 수 있게
	Class.forName("org.mariadb.jdbc.Driver");

	//2. mariadb접속(주소+포트번호+db이름,DB계정,DB계정암호)
	Connection conn = DriverManager.getConnection("jdbc:mariadb://kdi0905.kro.kr/employees", "root", "java1004");
	System.out.println(conn + "<-conn");

	//3. conn안에 쿼리(sql)를 만든다
	//order by 정렬,limit 제한 걸기기 ex) limit 시작번호, (보여지는 개수)

	//sql쿼리
	String sql = "";
	String sql2 = ""; //마지막페이지
	String sql3 = ""; // 검색

	PreparedStatement stmt = null;
	PreparedStatement stmt2 = null; //마지막페이지
	PreparedStatement stmt3 = null; //검색

	// deptNo 검색 찾기 
	sql3 = "select dept_no from departments";
	stmt3 = conn.prepareStatement(sql3);
	ResultSet search = stmt3.executeQuery();
	//총합리스트 초기화
	int totalList = 0;
	//마지막 페이지 초기화
	int lastPage = 0;
	// 재직중 = x , deptNo = x
	if (check.equals("no") && deptNo.equals("선택안함")) {
		sql = "select emp_no, dept_no, from_date, to_date from dept_emp limit ?,?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, (currentPage - 1) * rowPerPage);
		stmt.setInt(2, rowPerPage);

		//총 리스트 구하기
		sql2 = "select count(*) from dept_emp ";
		stmt2 = conn.prepareStatement(sql2);

		// 재직중 = x ,deptNo = o
	} else if (check.equals("no") && !deptNo.equals("선택안함")) {
		sql = "select emp_no, dept_no, from_date, to_date from dept_emp where dept_no =? limit ?,?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, deptNo);
		stmt.setInt(2, (currentPage - 1) * rowPerPage);
		stmt.setInt(3, rowPerPage);

		//총 리스트 구하기
		sql2 = "select count(*) from dept_emp where dept_no =?";
		stmt2 = conn.prepareStatement(sql2);
		stmt2.setString(1, deptNo);

		// 재직중 = o , deptNo = x
	} else if (!check.equals("no") && deptNo.equals("선택안함")) {
		sql = "select emp_no, dept_no, from_date, to_date from dept_emp where to_date = '9999-01-01' limit ?,?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, (currentPage - 1) * rowPerPage);
		stmt.setInt(2, rowPerPage);

		//총 리스트 구하기
		sql2 = "select count(*) from dept_emp  where to_date = '9999-01-01'";
		stmt2 = conn.prepareStatement(sql2);

		//재직중 = o , deptNo =o
	} else {
		sql = "select emp_no, dept_no, from_date, to_date from dept_emp where to_date = '9999-01-01' and dept_No =? limit ?,?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, deptNo);
		stmt.setInt(2, (currentPage - 1) * rowPerPage);
		stmt.setInt(3, rowPerPage);

		//총 리스트 구하기
		sql2 = "select count(*) from dept_emp where to_date = '9999-01-01' and dept_No =?";
		stmt2 = conn.prepareStatement(sql2);
		stmt2.setString(1, deptNo);
	}
	// 마지막페이지 결과물
	ResultSet rs2 = stmt2.executeQuery();
	if (rs2.next()) {
		totalList = rs2.getInt("count(*)");
	}
	lastPage = totalList / rowPerPage;
	if (totalList % rowPerPage != 0) {
		lastPage = lastPage + 1;
	}

	//4. 쿼리(실행)의 결과물을 가지고 온다
	ResultSet rs = stmt.executeQuery();

	%>
	<table class="table table-bordered table-hover table-striped text-center ">
		<thead>
			<tr>
				<td class="text-light">emp_no</td>
				<td class="text-light">dept_no</td>
				<td class="text-light">from_date</td>
				<td class="text-light">to_date</td>
			</tr>
		</thead>
		<tbody>
			<%
				while (rs.next()) {
			%>
			<tr>
				<td><%=rs.getString("emp_no")%></td>
				<td><%=rs.getString("dept_no")%></td>
				<td><%=rs.getString("from_date")%></td>
				<td><%=rs.getString("to_date")%></td>
			</tr>
			<%
				}
			%>
		</tbody>
	</table>
	<div class="text-center col-6" style="margin: auto;">
		<form method="post" action="./deptEmpList.jsp">
			<div class="input-group" >
				<%
					if (check.equals("yes")) {
				%>
				<input type="checkbox" name="check" value="yes" checked="checked">재직 중
				<%
					} else {
				%><input type="checkbox" name="check" value="yes" ><span style="font-size: 20px;">재직 중</span> <%
					}
				%>
				<select class="form-control" name="deptNo">
		
					<option  value="선택안함">선택안함</option>
					<%
						while (search.next()) {
						if (deptNo.equals(search.getString("dept_no"))) {
					%>
		
					<option value='<%=search.getString("dept_no")%>' selected="selected"><%=search.getString("dept_no")%>
					</option>
					<%
						} else {
					%><option value='<%=search.getString("dept_no")%>'><%=search.getString("dept_no")%>
					</option>
					<%
						}
					}
					%>
				</select>
				<div class="input-group-append">
					<button type="submit" class="btn btn-primary">검색</button>
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
	
	<a class="btn btn-info" href="./deptEmpList.jsp?currentPage=<%=1%>&check=<%=check%>&deptNo=<%=deptNo%>">처음</a>
	<a class="btn btn-info" href="./deptEmpList.jsp?currentPage=<%=showpage - rowPerPage%>&check=<%=check%>&deptNo=<%=deptNo%>">이전</a>
	<%
		
		}

	//1부터 10까지 출력
	//11부터 20까지 출력
	//  이슈: 마지막 페이지는 더이상 다음이라는 링크가 존재 x -->
	//rs.getInt("count(*)") -->전체행 개수 	
	//괄과물로 전체 행의 수를 알수 있다.
	//select count(*) from employees

	System.out.println(currentPage);
	System.out.println(lastPage);
	for (int i = 0; i < rowPerPage; i++) {
	if (showpage + i <= lastPage) {
	%>
	<!-- 첫번째 숫자 부터 10개 출력 -->

	<a class="btn btn-info" href="./deptEmpList.jsp?currentPage=<%=showpage + i%>&check=<%=check%>&deptNo=<%=deptNo%>"><%=showpage + i%></a>&nbsp;

	<%
		}

	}
	%>

	<!-- 첫번째 숫자 다음페이지 -->
	<%
		if (currentPage < lastPage) {
	%>
	<a class="btn btn-info" href="./deptEmpList.jsp?currentPage=<%=showpage + rowPerPage%>&check=<%=check%>&deptNo=<%=deptNo%>">다음</a>
	<%
		}
	if (currentPage != lastPage) {
	%>

	<a class="btn btn-info" href="./deptEmpList.jsp?currentPage=<%=lastPage%>&check=<%=check%>&deptNo=<%=deptNo%>">마지막</a>
	<%
		}
	%>
	</div>
	</div>
</body>
</html>