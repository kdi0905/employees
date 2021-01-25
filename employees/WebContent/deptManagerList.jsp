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
	<!-- �޴� -->
	<div>
		<table border="1">
			<tr>
				<td><a href="./index.jsp">Ȩ����</a></td>
				<td><a href="./departmentsList.jsp">departments ���̺� ���</a></td>
				<td><a href="./deptEmpList.jsp">dept_emp ���̺� ���</a></td>
				<td><a href="./deptManagerList.jsp">dept_manager ���̺� ���</a></td>
				<td><a href="./employeesList.jsp">employees ���̺� ���</a></td>
				<td><a href="./salariesList.jsp">salaries ���̺� ���</a></td>
				<td><a href="./titlesList.jsp">titles ���̺� ���</a></td>
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
	<h1>dept_manager ���̺� ���</h1>
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
	<a href="./deptManagerList.jsp?currentPage=<%=1%>">ó��</a>
	<a
		href="./deptManagerList.jsp?currentPage=<%= showpage - rowPerPage%>">����</a>
	<%
		} else if (currentPage <= 10 && currentPage > 1) { //������ ���ڰ� 10 ���̸� ù��° �������� �̵�
	%>


	<a href="./deptManagerList.jsp?currentPage=<%= showpage%>">����</a>
	<%
		} else {
	%>����<%
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
	if (currentPage <= lastPage) {
	%>
	<!-- ù��° ���� ���� 10�� ��� -->

	<a href="./deptManagerList.jsp?currentPage=<%=showpage + i%>"><%=showpage + i%></a>&nbsp;
	<%
		currentPage++;
	}
	}
	%>


	<!-- ù��° ���� ���������� -->
	<%
		if (currentPage < lastPage) {
	%>
	<a href="./deptManagerList.jsp?currentPage=<%=showpage + rowPerPage%>">����</a>
	<%
		} else {
	%>
	����
	<%
		}
	%>
	
	<a href="./deptManagerList.jsp?currentPage=<%=lastPage%>">������</a>
</body>
</html>