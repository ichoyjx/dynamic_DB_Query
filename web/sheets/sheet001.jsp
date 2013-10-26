<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../GetInfo.jspf" %>
<!DOCTYPE html>
<%response.setCharacterEncoding("gb2312");%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=GB2312">
        <title>单表查询</title>
        <link rel=Stylesheet href=stylesheet.css>

        <script language="JavaScript">
            function fnUpdateTabs()
            {
                if (parent.window.g_iIEVer>=4) {
                    if (parent.document.readyState=="complete"
                        && parent.frames['frTabs'].document.readyState=="complete")
                        parent.fnSetActiveSheet(0);
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
        <form name="Single" method="post" action="sheet001.jsp">
            <% // 如果数据库中没有表，则报错
                if (tables.size() == 0) {
                    out.println("数据库中无数据表，请检查数据库！");
                } else {
                    out.println("请选择将要操作的表名: <p />");
                }

                for (int i = 0; i < tables.size(); i++) {
                    out.println("<input name=\"SingleChoice\" type=\"radio\" value=\"" + tables.get(i).tableName
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
            String choice = request.getParameter("SingleChoice");
            session.setAttribute("choice", choice);
            if (choice == null) {
                out.print("无 <br>");
            } else {
                out.print(choice + "<p />");
                out.print("<form name=\"SingleResult\" method=\"post\" action=\"result001.jsp\">");
                out.print("<table width=\"400\" border=\"0\">");
                ////////////////////////////////////////////////////////////////
                //输出抬头第一行
                out.print("<tr bgcolor =\"#CCFFFF\"> <td align=\"center\" valign=\"middle\">&nbsp&nbsp&nbsp&nbsp"
                        + " 属性名 &nbsp&nbsp&nbsp&nbsp</td>");
                out.print("<td align=\"center\" valign=\"middle\">&nbsp&nbsp&nbsp&nbsp 操作 &nbsp&nbsp&nbsp&nbsp</td>");
                out.print("<td align=\"center\" valign=\"middle\">&nbsp&nbsp&nbsp&nbsp 值 &nbsp&nbsp&nbsp&nbsp</td>");
                out.print("<td align=\"center\" valign=\"middle\">&nbsp&nbsp&nbsp&nbsp 结果输出 &nbsp&nbsp&nbsp&nbsp</td> </tr>");

                int i;
                for (i = 0; i < tables.size(); i++) { // 获取数据结构中的表
                    if (tables.get(i).tableName.equals(choice)) {
                        break;
                    }
                }

                int count = 0;
                for (int j = 0; j < tables.get(i).field.size(); j++) {
                    out.print("<tr  bgcolor =\"#FFFF99\">");
                    String field_name = tables.get(i).field.get(j).name;
                    out.print("<td align=\"center\" valign=\"middle\">&nbsp&nbsp&nbsp&nbsp"
                            + field_name + "&nbsp&nbsp&nbsp&nbsp</td>");
                    ////////////////////////////////////////////////////////////
                    //输出 SELECT 标签
                    out.print("<td align=\"center\" valign=\"middle\">&nbsp&nbsp&nbsp&nbsp");
                    switch (tables.get(i).field.get(j).Type) {
                        case 1:
                            out.print("<SELECT NAME =\"" + field_name);
                            if (count == 1) {
                                out.print(count);
                            }
                            out.print("Select\">");
                            out.print("<OPTION SELECTED value=\"nochoice\"> 请选择 </OPTION>"
                                    + "<OPTION value=\" > \"> > </OPTION>"
                                    + "<OPTION value=\" < \"> < </OPTION>"
                                    + "<OPTION value=\" = \"> = </OPTION>"
                                    + "<OPTION value=\" >= \"> >= </OPTION>"
                                    + "<OPTION value=\" <= \"> <= </OPTION>"
                                    + "<OPTION value=\" != \"> != </OPTION>"
                                    + "</SELECT>");
                            break;
                        case 2:
                            out.print("<SELECT NAME =\"" + field_name
                                    + "Select\">"
                                    + "<OPTION SELECTED value=\"nochoice\"> 请选择 </OPTION>"
                                    + "<OPTION value=\" = \"> = </OPTION>"
                                    + "<OPTION value=\" LIKE \"> 包含 </OPTION>"
                                    + "</SELECT>");
                            break;
                        case 3:
                            out.print("<SELECT NAME =\"" + field_name
                                    + "Select\">"
                                    + "<OPTION SELECTED value=\"nochoice\"> 请选择 </OPTION>"
                                    + "<OPTION value=\" = \"> = </OPTION>"
                                    + "</SELECT>");
                            break;
                        case 4:
                            out.print("<SELECT NAME =\"" + field_name);
                            if (count == 1) {
                                out.print(count);
                            }
                            out.print("Select\">");
                            out.print("<OPTION SELECTED value=\"nochoice\"> 请选择 </OPTION>"
                                    + "<OPTION value=\" < \"> 在这之前 </OPTION>"
                                    + "<OPTION value=\" = \"> 精确时间 </OPTION>"
                                    + "<OPTION value=\" > \"> 在这之后 </OPTION>"
                                    + "</SELECT>");
                            break;
                    }
                    out.print("&nbsp&nbsp&nbsp&nbsp</td>");
                    ////////////////////////////////////////////////////////////
                    //值
                    out.print("<td align=\"center\" valign=\"middle\">&nbsp&nbsp&nbsp&nbsp"
                            + "<input  type=\"text\" name=\"" + field_name);
                    if (count == 1) {
                        out.print(count);
                    }
                    out.print("Zhi\" size=\"20\"> &nbsp&nbsp&nbsp&nbsp</td>");
                    ////////////////////////////////////////////////////////////
                    //结果输出
                    if (tables.get(i).field.get(j).Type != 1 && tables.get(i).field.get(j).Type != 4) {
                        out.print("<td align=\"center\" valign=\"middle\">&nbsp&nbsp&nbsp&nbsp"
                                + "<input  type=\"checkbox\" name=\""
                                + field_name + "Checkbox\" size=\"20\">" + "&nbsp&nbsp&nbsp&nbsp</td>");
                        out.print("</tr>");
                    }

                    // 如果是数字或者日期类型的就输出两遍
                    if (tables.get(i).field.get(j).Type == 1 || tables.get(i).field.get(j).Type == 4) {
                        if (count == 0) {
                            j--;
                            count++;
                            out.print("<td>单范围填此行</td>");
                            out.print("</tr>");
                        } else {
                            out.print("<td align=\"center\" valign=\"middle\">&nbsp&nbsp&nbsp&nbsp"
                                    + "<input  type=\"checkbox\" name=\""
                                    + field_name + "Checkbox\" size=\"20\">" + "&nbsp&nbsp&nbsp&nbsp</td>");
                            out.print("</tr>");
                            count = 0;
                        }
                    }
                }
                out.print("</table>");
                out.print("<br> <input name=\"submit2\" type=\"submit\" value=\"查询\">");
                out.print("&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<input name=\"reset\" type=\"reset\" value=\"重置\">");
                out.print("<br><br> 提示：日期格式 yyyy-mm-dd [hh:mm:ss] 或 yyyy/mm/dd [hh:mm:nn]");

            }
        %>
    </center>
</body>

</html>
