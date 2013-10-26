<%-- 
    Document   : result001.jsp
    Created on : 2011-10-23, 21:18:20
    Author     : Icho
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../GetInfo.jspf" %>
<!DOCTYPE html>
<%request.setCharacterEncoding("gb2312"); %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=GB2312">
        <title>聚合查询结果</title>
    </head>
    <body>
    <center>聚合查询结果 <br></br>
        <%
            String QueryStr = "SELECT FROM WHERE";
            String select = "SELECT ";
            String Achoice = (String) session.getAttribute("Achoice");
            String from = "FROM " + Achoice; // from 语句到此完整

            tableInfo curr = new tableInfo();
            for (int i = 0; i < tables.size(); i++) { // 获取数据结构中的表
                if (tables.get(i).tableName.equals(Achoice)) {
                    curr = tables.get(i);
                    break;
                }
            } // i 存放当前表的位置

            ////////////////////////////////////////////////////////////////
            //获取 where语句
            String Para_Select = Achoice + "Select";
            String ParaResult = request.getParameter(Para_Select); // 字段
            String Op_Select = "AFSelect";
            String OpResult = request.getParameter(Op_Select); // 聚合函数

            if (!ParaResult.equals("nochoice") && !OpResult.equals("nochoice")) { // 如果有选择，这行就提取公式
                select = select + OpResult + " (" + ParaResult + ")";
            } else { // 防止空指针
            }

            if (select.equals("SELECT ")) {
                select = "SELECT *";
            }
            
            QueryStr = select + " " + from;
            out.print(select + "<br>");
            out.print(from + "<br>");
        %>
       
        <%
            SQLQuery query = new SQLQuery(QueryStr, sqlConn, dbur1);
            ResultSet rs = query.getResult();
            if (rs != null) {
                ResultSetMetaData rsmd = rs.getMetaData();//总列数
                RandomColor RC = new RandomColor();
                int size = rsmd.getColumnCount();
                String[] bg = new String[size + 1];
                out.print("<table width=\"70%\" border=\"0\"><tr>");
                for (int i = 1; i <= size; i++) { //字段名
                    bg[i] = RC.GetRandomColor();
                    out.print("<td align=\"center\" valign=\"middle\" bgcolor=\"" + bg[i] + "\">&nbsp&nbsp");
                    out.print(rsmd.getTableName(i) + '.' + rsmd.getColumnName(i));
                    out.print("&nbsp&nbsp</td>");
                }
                out.print("</tr>");

                while (rs.next()) {
                    out.print("<tr>");
                    for (int index = 1; index <= size; index++) { //字段值
                        out.print("<td align=\"center\" valign=\"middle\" bgcolor=\"" + bg[index] + "\">&nbsp&nbsp");
                        out.print(rs.getString(index));
                        out.print("&nbsp&nbsp</td>");
                    }
                    out.print("</tr>");
                }
                out.print("</table>");
            } else {
                out.print("<br>类型不匹配导致查询失败！ <br>");
            }

        %>
    </center>
</body>
</html>