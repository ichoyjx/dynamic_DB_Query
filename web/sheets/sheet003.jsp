<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../GetInfo.jspf" %>
<!DOCTYPE html>
<%response.setCharacterEncoding("gb2312");%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=GB2312">
        <title>聚合操作</title>
        <link rel=Stylesheet href=stylesheet.css>

        <script language="JavaScript">
            function fnUpdateTabs()
            {
                if (parent.window.g_iIEVer>=4) {
                    if (parent.document.readyState=="complete"
                        && parent.frames['frTabs'].document.readyState=="complete")
                        parent.fnSetActiveSheet(2);
                    else
                        window.setTimeout("fnUpdateTabs();",150);
                }
            }

            if (window.name!="frSheet")
                window.location.replace("../index.jsp");
            else
                fnUpdateTabs();
        </script>
    </head>

    <body link=blue vlink=purple>
    <center>
        <form name="Single" method="post" action="sheet003.jsp">
            <% // 如果数据库中没有表，则报错
                if (tables.size() == 0) {
                    out.println("数据库中无数据表，请检查数据库！");
                } else {
                    out.println("请选择将要操作的表名: <p />");
                }

                for (int i = 0; i < tables.size(); i++) {
                    out.println("<input name=\"AggregateChoice\" type=\"radio\" value=\"" + tables.get(i).tableName
                            + "\">" + tables.get(i).tableName);
                    if ((i + 1) % 10 == 0) {
                        out.print("<br>");
                    }
                }
                out.print("<br><br> <input name=\"submit1\" type=\"submit\" value=\"确定\">");
            %>
        </form>
        <hr></hr>
        当前表名 
        <%
            String choice = request.getParameter("AggregateChoice");
            session.setAttribute("Achoice", choice);
            if (choice == null) {
                out.print("无 <br>");
            } else {
                out.print(choice + "<p />");
                out.print("<form name=\"AggregateResult\" method=\"post\" action=\"result003.jsp\">");
                out.print("<table width=\"400\" border=\"0\">");
                ////////////////////////////////////////////////////////////////
                //输出抬头第一行
                out.print("<tr bgcolor =\"#CCFFFF\"> <td align=\"center\" valign=\"middle\">&nbsp&nbsp&nbsp&nbsp 属性选择 &nbsp&nbsp&nbsp&nbsp</td>");
                out.print("<td align=\"center\" valign=\"middle\">&nbsp&nbsp&nbsp&nbsp 操作选择 &nbsp&nbsp&nbsp&nbsp</td> </tr>");

                int i;
                for (i = 0; i < tables.size(); i++) { // 获取当前表在数据结构中的位置i
                    if (tables.get(i).tableName.equals(choice)) {
                        break;
                    }
                }
                ////////////////////////////////////////////////////////////////
                //输出第一个字段下拉列表
                out.print("<tr  bgcolor =\"#FFFF99\">");
                out.print("<td align=\"center\" valign=\"middle\">");
                out.print("<SELECT NAME =\"" + choice + "Select\">");
                out.print("<OPTION SELECTED value=\"nochoice\"> 请选择 </OPTION>");
                for (int j = 0; j < tables.get(i).field.size(); j++) {
                    String field_name = tables.get(i).field.get(j).name;
                    //输出 字段名的 SELECT 标签
                    out.print("<OPTION value=\"" + field_name + "\">" + field_name);
                    if (tables.get(i).field.get(j).Type == 1) {
                        out.print(" (数值)");
                    }
                    out.print("</OPTION>");
                }
                out.print("</SELECT> &nbsp&nbsp&nbsp&nbsp</td>");
                ////////////////////////////////////////////////////////////////
                //输出聚合函数操作下拉列表
                out.print("<td align=\"center\" valign=\"middle\">");
                out.print("<SELECT NAME =\"AFSelect\">");
                out.print("<OPTION SELECTED value=\"nochoice\"> 请选择 </OPTION>");
                out.print("<OPTION value=\"AVG\"> 平均值 (数值) </OPTION>");
                out.print("<OPTION value=\"SUM\"> 总和 (数值) </OPTION>");
                out.print("<OPTION value=\"COUNT\"> 记录个数 </OPTION>");
                out.print("<OPTION value=\"MAX\"> 最大值 </OPTION>");
                out.print("<OPTION value=\"MIN\"> 最小值 </OPTION>");
                ////////////////////////////////////////////////////////////////
                out.print("</tr></table>"); //表格结束
                out.print("<br> <input name=\"submit2\" type=\"submit\" value=\"查询\">");
                out.print("&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<input name=\"reset\" type=\"reset\" value=\"重置\">");
            }
        %>
    </center>
</body>

</html>
