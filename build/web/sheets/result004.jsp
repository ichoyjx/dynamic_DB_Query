<%-- 
    Document   : result001.jsp
    Created on : 2011-10-23, 23:17:35
    Author     : Icho
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../GetInfo.jspf" %>
<!DOCTYPE html>
<%request.setCharacterEncoding("gb2312"); %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=GB2312">
        <title>联结查询结果</title>
    </head>
    <body>
    <center>联结查询结果<br></br>
        <%
            String QueryStr = "SELECT FROM WHERE";
            String[] Jchoice = (String[]) session.getAttribute("Jchoice");
            String Join_OpResult = request.getParameter("JoinChoiceSelect"); // 获取联结类型
            if (!Join_OpResult.equals("nochoice")) {
                String select = "SELECT *";
                String from = "FROM " + Jchoice[0] + Join_OpResult + Jchoice[1]; // from 语句到此完整
                String on = " ON ";

                ////////////////////////////////////////////////////////////////
                //找到两个表在数据结构中的位置
                int[] pos = new int[2];
                for (int k = 0; k < 2; k++) {
                    for (int i = 0; i < tables.size(); i++) { // 获取数据结构中的表
                        if (tables.get(i).tableName.equals(Jchoice[k])) {
                            pos[k] = i;
                        }
                    }
                }//结束后 pos[] 里存放的是当前选择的表在数据库中的位置

                int t = 0;
                // 循环输出第一张张表的每个字段作为表格最左一列

                t = pos[0]; //第一张表
                for (int j = 0; j < tables.get(t).field.size(); j++) { //// 复用的sheet004.jsp的代码，稍作修改
                    String field_name = Jchoice[0] + "." + tables.get(t).field.get(j).name;
                    int field_type = tables.get(t).field.get(j).Type;

                    //获取 on语句
                    String Para_Select = tables.get(t).field.get(j).name + "SelectZhi";
                    String ParaResult = request.getParameter(Para_Select); // 获取了第二张表的联结字段

                    if (!ParaResult.equals("nochoice")) { // 如果有选择，就提取出字段名                    
                        on = on + field_name + " = " + ParaResult;
                    }
                }
                out.print(select + "<br>" + from + on + "<br>");
                QueryStr = select + from + on;
            } else {
                out.print("未选择联结类型导致查询失败！<br>");
            }


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
                out.print("<br> 查询无结果！<br>");
            }
        %>
    </center>
</body>
</html>