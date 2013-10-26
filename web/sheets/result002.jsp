<%-- 
    Document   : result002
    Created on : 2011-10-22, 20:58:30
    Author     : Icho
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../GetInfo.jspf" %>
<!DOCTYPE html>
<%request.setCharacterEncoding("gb2312"); %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=GB2312">
        <title>多表查询结果</title>
    </head>
    <body>
    <center>多表查询结果<br></br>
        <%
            String QueryStr = "SELECT FROM WHERE";
            String select = "SELECT ";
            String[] Mchoice = (String[]) session.getAttribute("Mchoice");
            String from = "FROM " + Mchoice[0];
            for (int i = 1; i < Mchoice.length; i++) {
                from = from + ", " + Mchoice[i];
            } // from 语句到此完整
            String where = "WHERE ";

            ////////////////////////////////////////////////////////////////
            //找到各个表在数据结构中的位置
            int[] pos = new int[Mchoice.length];
            for (int k = 0; k < Mchoice.length; k++) {
                for (int i = 0; i < tables.size(); i++) { // 获取数据结构中的表
                    if (tables.get(i).tableName.equals(Mchoice[k])) {
                        pos[k] = i;
                    }
                }
            }//结束后 pos[] 里存放的是当前选择的表在数据库中的位置

            int t = 0;
            // 循环输出每张表的每个字段
            for (int p = 0; p < Mchoice.length; p++) { //每张表
                t = pos[p]; //第一张表
                for (int j = 0; j < tables.get(t).field.size(); j++) { //这张表里的每个字段
                    String field_name = Mchoice[p] + "." + tables.get(t).field.get(j).name;
                    int field_type = tables.get(t).field.get(j).Type;
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
                    boolean format_flag = true;

                    if (!OpResult.equals("nochoice") && ZhiResult != "" && !ZhiResult.equals("nochoice")) { // 如果有选择，这行就提取公式                    
                        if (tables.get(t).field.get(j).Type == 2
                                || tables.get(t).field.get(j).Type == 4) { // 字符串型需要在前后加""

                            for (int x = 0; x < Mchoice.length; x++) { //如果是下拉列表里的值，则不需要加''
                                for (int y = 0; y < tables.get(pos[x]).field.size(); y++) {
                                    if (ZhiResult.equals(Mchoice[x] + "."
                                            + tables.get(pos[x]).field.get(y).name)) {
                                        format_flag = false;
                                    }
                                }
                            }
                            if (format_flag && tables.get(t).field.get(j).Type == 2) {
                                ZhiResult = "'" + ZhiResult + "'";
                            }
                            if (format_flag && tables.get(t).field.get(j).Type == 4) {
                                ZhiResult = "#" + ZhiResult + "#";
                            }                            
                        }
                        where = where + field_name; // 1.属性名
                        where = where + OpResult; // 2.操作value
                        if (OpResult.equals(" LIKE ") && format_flag) {
                            ZhiResult = "'%" + ZhiResult.substring(1, ZhiResult.length() - 1) + "%'";
                        }
                        where = where + ZhiResult; // 3.值value               
                        where = where + " AND "; // 默认条件 之间是并列的

                        if (tables.get(t).field.get(j).Type == 1 || tables.get(t).field.get(j).Type == 4) {

                            String Query_Select1 = field_name + "1Select"; // 第二个范围操作value
                            String OpResult1 = request.getParameter(Query_Select1);
                            String Query_Value1 = field_name + "1Zhi"; // 第二个值value
                            String ZhiResult1 = request.getParameter(Query_Value1);

                            if (!OpResult1.equals("nochoice") && (ZhiResult != ""
                                    || !ZhiResult.equals("nochoice"))) {// 如果有选择，这行就提取公式

                                format_flag = true;
                                for (int x = 0; x < Mchoice.length; x++) { //如果是下拉列表里的值，则不需要加''
                                    for (int y = 0; y < tables.get(pos[x]).field.size(); y++) {
                                        if (ZhiResult.equals(Mchoice[x] + "."
                                                + tables.get(pos[x]).field.get(y).name)) {
                                            format_flag = false;
                                        }
                                    }
                                }
                                if (format_flag && tables.get(t).field.get(j).Type == 4) {
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
                String[] bg = new String[size+1];
                out.print("<table width=\"70%\" border=\"0\"><tr>");
                for (int i = 1; i <= size; i++) { //字段名
                    bg [i] = RC.GetRandomColor();
                    out.print("<td align=\"center\" valign=\"middle\" bgcolor=\"" + bg[i] + "\">&nbsp&nbsp");
                    out.print(rsmd.getTableName(i)+'.'+rsmd.getColumnName(i));
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