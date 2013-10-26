<%-- 
    Document   : result001.jsp
    Created on : 2011-10-22, 15:03:44
    Author     : Icho
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../GetInfo.jspf" %>
<!DOCTYPE html>
<%request.setCharacterEncoding("gb2312");%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=GB2312">
        <title>单表查询结果</title>
    </head>
    <body>
    <center>单表查询结果<br></br>
        <%
            String QueryStr = "SELECT FROM WHERE";
            String select = "SELECT ";
            String choice = (String) session.getAttribute("choice");
            String from = "FROM " + choice; // from 语句到此完整
            String where = "WHERE ";

            int i; // 找到当前查询的是哪一张表
            for (i = 0; i < tables.size(); i++) { // 获取数据结构中的表
                if (tables.get(i).tableName.equals(choice)) {
                    break;
                }
            } // i 存放当前表的位置

            int j;
            for (j = 0; j < tables.get(i).field.size(); j++) {
                String field_name = tables.get(i).field.get(j).name;
                ////////////////////////////////////////////////////////////////
                //获取 select语句
                String Query_Checkbox = field_name + "Checkbox";
                String CheckBoxResult = request.getParameter(Query_Checkbox);
                if (CheckBoxResult != null && !CheckBoxResult.equals("no")) { // 选中
                    select = select + field_name + ", "; // select 语句到此完整
                }
                ////////////////////////////////////////////////////////////////
                //获取 where语句
                String Query_Select = field_name + "Select";
                String OpResult = request.getParameter(Query_Select);
                String Query_Value = field_name + "Zhi";
                String ZhiResult = request.getParameter(Query_Value);

                if (!OpResult.equals("nochoice") && ZhiResult != "") { // 如果有选择，这行就提取公式                    
                    if (tables.get(i).field.get(j).Type == 2) { // 字符串型需要在前后加""
                        ZhiResult = "'" + ZhiResult + "'";
                    }
                    if (tables.get(i).field.get(j).Type == 4) {
                        ZhiResult = "#" + ZhiResult + "#";
                    }
                    where = where + field_name; // 1.属性名
                    where = where + OpResult; // 2.操作value
                    if (OpResult.equals(" LIKE ")) {
                        ZhiResult = "'%" + ZhiResult.substring(1, ZhiResult.length() - 1) + "%'";
                    }
                    where = where + ZhiResult; // 3.值value               
                    where = where + " AND "; // 默认条件 之间是并列的

                    if (tables.get(i).field.get(j).Type == 1 || tables.get(i).field.get(j).Type == 4) {

                        String Query_Select1 = field_name + "1Select"; // 第二个范围操作value
                        String OpResult1 = request.getParameter(Query_Select1);
                        String Query_Value1 = field_name + "1Zhi"; // 第二个值value
                        String ZhiResult1 = request.getParameter(Query_Value1);

                        if (!OpResult1.equals("nochoice") && ZhiResult1 != "") {// 如果有选择，这行就提取公式

                            if (tables.get(i).field.get(j).Type == 2) { // 字符串型需要在前后加""
                                ZhiResult1 = "'" + ZhiResult1 + "'";
                            }
                            if (tables.get(i).field.get(j).Type == 4) {
                                ZhiResult1 = "#" + ZhiResult1 + "#";
                            }
                            where = where + field_name; // 1.属性名
                            where = where + OpResult1; //2.操作value
                            where = where + ZhiResult1; // 3.值value               
                            where = where + " AND "; // 默认条件 之间是并列的 
                        }
                    }
                }
            }
            if (!where.equals("WHERE ")) {
                where = where.substring(0, where.lastIndexOf(" AND "));
            } else {
                where = "";
            }

            if (!select.equals("SELECT ")) {
                select = select.substring(0, select.lastIndexOf(", "));
            } else {
                select = "SELECT *";
                if (where.equals("WHERE ")) {
                    where = "";
                }
            }
            
            QueryStr = select + " " + from + " " + where;
            out.print(select + "<br>");
            out.print(from + "<br>");
            out.print(where + "<br>");
        %>

        <%
            SQLQuery query = new SQLQuery(QueryStr, sqlConn, dbur1);
            ResultSet rs = query.getResult();
            if (rs != null) {
                ResultSetMetaData rsmd = rs.getMetaData();//总列数
                int size = rsmd.getColumnCount();
                RandomColor RC = new RandomColor();
                String[] bg = new String[size + 1];
                out.print("<table width=\"70%\" border=\"0\"><tr>");
                for (i = 1; i <= size; i++) { //字段名
                    bg[i] = RC.GetRandomColor();
                    out.print("<td align=\"center\" valign=\"middle\" bgcolor=\"" + bg[i] + "\">&nbsp&nbsp");
                    out.print(rsmd.getColumnName(i));
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
            }
        %>
    </center>
</body>
</html>