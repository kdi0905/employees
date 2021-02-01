<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>dept_manager</title>
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
	<!-- �޴� -->
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
	<%
		int currentPage = 1;
	if (request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 10;
	%>
	<div class="text-center" style="font-size: 30px;"><h1>dept_manager ���̺� ���</h1></div>
	<%
		Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://kdi0905.kro.kr/employees", "root", "java1004");
	String sql = "select * from dept_manager order by dept_no asc limit ?,?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, (currentPage - 1) * rowPerPage);
	stmt.setInt(2, rowPerPage);
	ResultSet rs = stmt.executeQuery();
	%>
	<table class="table table-bordered table-hover table-striped text-center ">
		<thead>
			<tr>
				<td class="text-light">dept_no</td>
				<td class="text-light">emp_no</td>
				<td class="text-light">from_date</td>
				<td class="text-light">to_date</td>
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
	<div class="text-center" style="margin-top: 30px;" >
	<%
		//ù��° ������ ����
	int showpage;
	if (currentPage % rowPerPage == 0) {//���ڸ����� 0�϶�
		showpage = (currentPage - rowPerPage) / rowPerPage * rowPerPage + 1;
	} else {
		showpage = currentPage / rowPerPage * rowPerPage + 1;
	}

	if (currentPage > rowPerPage) {
	%>
	<!-- ������ ���ڰ� ù��°�� ǥ�õǴ� �������� �̵� -->
	<a class="btn btn-info" href="./deptManagerList.jsp?currentPage=<%=1%>">ó��</a>
	<a class="btn btn-info"
		href="./deptManagerList.jsp?currentPage=<%= showpage - rowPerPage%>">����</a>
	<%
		
		}
	//1���� 10���� ���
	//11���� 20���� ���
	//  �̽�: ������ �������� ���̻� �����̶�� ��ũ�� ���� x -->
	//rs.getInt("count(*)") -->��ü�� ���� 	
	//�������� ��ü ���� ���� �˼� �ִ�.
	//select count(*) from employees
	String sql2 = "select count(*) from dept_manager";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	ResultSet rs2 = stmt2.executeQuery();
	int totalCount = 0;
	if (rs2.next()) {
	totalCount = rs2.getInt("count(*)");
	}
	int lastPage = totalCount / rowPerPage;
	if (totalCount % rowPerPage != 0) //�������� ���� �Ѵٸ� �������� �����ֱ� ���ؼ� �ϳ��� �������� �� �ʿ��ϴ�
	{
	lastPage = lastPage + 1;
	}

	for (int i = 0; i < rowPerPage; i++) {
	if (showpage + i <= lastPage) {
	%>
	<!-- ù��° ���� ���� 10�� ��� -->

	<a class="btn btn-info" href="./deptManagerList.jsp?currentPage=<%=showpage + i%>"><%=showpage + i%></a>&nbsp;
	<%
		
		}
	}
	%>


	<!-- ù��° ���� ���������� -->
	<%
		if (currentPage < lastPage) {
	%>
	<a class="btn btn-info" href="./deptManagerList.jsp?currentPage=<%=showpage + rowPerPage%>">����</a>
	<%
		}
	if (currentPage != lastPage) {
	%>
	
	<a class="btn btn-info" href="./deptManagerList.jsp?currentPage=<%=lastPage%>">������</a>
	<%
		}
	%>
	</div>
	</div>
</body>
</html>