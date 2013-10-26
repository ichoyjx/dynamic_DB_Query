<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="../GetInfo.jspf" %>
<!DOCTYPE html>
<%response.setCharacterEncoding("gb2312");%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=GB2312">
        <title>联结操作</title>
        <link rel=Stylesheet href=stylesheet.css>
        <script language="JavaScript">
            function fnUpdateTabs()
            {
                if (parent.window.g_iIEVer>=4) {
                    if (parent.document.readyState=="complete"
                        && parent.frames['frTabs'].document.readyState=="complete")
                        parent.fnSetActiveSheet(3);
                    else
                        window.setTimeout("fnUpdateTabs();",150);
                }
            }

            if (window.name!="frSheet")
                window.location.replace("../index.jsp");
            else
                fnUpdateTabs();
        </script>
        <script language="javascript" type="text/javascript">
            function checkbox_max(obj, num) {
                var s = 0;//计数器
                var ob = document.getElementsByName("JoinChoice");
                //统计已选中的复选框个数
                for (i = 0; i < ob.length; i++) {
                    if (ob[i].checked == true)
                        s=s+1;
                }
                if (s > num) {
                    alert("最多只能选择两张表！");
                    obj.checked = false;
                }
            }
        </script>
    </head>

    <body link=blue vlink=purple>
    <center>
        <form name="Join" method="post" action="sheet004.jsp">
            <% // 如果数据库中没有表，则报错
                if (tables.size() == 0) {
                    out.println("数据库中无数据表，请检查数据库！");
                } else {
                    out.println("请选择将要操作的表名（两张表）: <p />");
                }

                for (int i = 0; i < tables.size(); i++) {
                    out.println("<input name=\"JoinChoice\" type=\"checkbox\" value=\"" + tables.get(i).tableName
                            + "\" onclick=\"checkbox_max(this,2);\" >" + tables.get(i).tableName);
                    if ((i + 1) % 10 == 0) {
                        out.print("<br>");
                    }
                }
                out.print("<br><br> <input name=\"submit1\" type=\"submit\" value=\"确定\">");
            %>
        </form>
        <hr></hr>
        <%
            String[] choice = request.getParameterValues("JoinChoice");
            int i = 0;
            session.setAttribute("Jchoice", choice);
            if (choice == null || choice.length == 1) {
                out.print("无 <br>");
            } else {
                out.print("<form name=\"JoinResult\" method=\"post\" action=\"result004.jsp\">");
                out.print("<table width=\"400\" border=\"0\">");
                out.print("<tr bgcolor =\"#66FFFF\"> <td align=\"center\" valign=\"middle\">");
                out.print(choice[0] + "&nbsp&nbsp&nbsp&nbsp </td>");
                out.print("<td align=\"center\" valign=\"middle\">&nbsp&nbsp&nbsp&nbsp");
                out.print("<SELECT NAME =\"JoinChoiceSelect\">");
                out.print("<OPTION SELECTED value=\"nochoice\"> 请选择联结类型 </OPTION>");
                out.print("<OPTION value=\" INNER JOIN \"> 内联结 </OPTION>");
                out.print("<OPTION value=\" FULL OUTER JOIN \"> 完全外联结 </OPTION>");
                out.print("<OPTION value=\" LEFT OUTER JOIN \"> 左外联结 </OPTION>");
                out.print("<OPTION value=\" RIGHT OUTER JOIN \"> 右外联结 </OPTION>");
                out.print("<OPTION value=\" CROSS JOIN \"> 交叉联结 </OPTION>");
                out.print("</SELECT>&nbsp&nbsp&nbsp&nbsp</td>");
                out.print("<td align=\"center\" valign=\"middle\">");
                out.print(choice[1] + "&nbsp&nbsp&nbsp&nbsp </td> </tr> </table><br>");

                ////////////////////////////////////////////////////////////////
                //输出抬头第一行               
                out.print("<table width=\"400\" border=\"0\">");
                out.print("<tr bgcolor =\"#CCFFFF\"> <td align=\"center\" valign=\"middle\">&nbsp&nbsp&nbsp&nbsp"
                        + " 表1 字段名 &nbsp&nbsp&nbsp&nbsp</td>");
                out.print("<td align=\"center\" valign=\"middle\"> 联结条件 </td>");
                out.print("<td align=\"center\" valign=\"middle\">&nbsp 表2 (只能选择一个字段) &nbsp</td> </tr>");
                ////////////////////////////////////////////////////////////////
                //找到各个表在数据结构中的位置
                int[] pos = new int[choice.length];
                for (int k = 0; k < choice.length; k++) {
                    for (i = 0; i < tables.size(); i++) { // 获取数据结构中的表
                        if (tables.get(i).tableName.equals(choice[k])) {
                            pos[k] = i;
                        }
                    }
                }//结束后 pos[] 里存放的是当前选择的表在数据库中的位置
                ////////////////////////////////////////////////////////////////
                //输出表的主体内容
                // 1.初始化变量 当前操作的表位置 t; 颜色bg
                int t = 0;
                String bg = "#FFEE99";
                // 2.循环输出第一张表的属性
                for (int p = 0; p < 1; p++) { // 复用的sheet002.jsp的代码，稍作修改
                    int count = 0;
                    t = pos[p]; //第一张表
                    for (int j = 0; j < tables.get(t).field.size(); j++) {
                        out.print("<tr bgcolor=" + bg + ">");
                        String field_name = tables.get(t).field.get(j).name;
                        int field_type = tables.get(t).field.get(j).Type;
                        out.print("<td align=\"center\" valign=\"middle\">&nbsp&nbsp&nbsp&nbsp"
                                + choice[p] + "." + field_name + "&nbsp&nbsp&nbsp&nbsp</td>");

                        out.print("<td align=\"center\" valign=\"middle\"> = </td>");
                        ////////////////////////////////////////////////////////
                        //值（这里要求下拉列表列出出自己外所有表与自己相同属性的字段名)
                        //当前表的位置是 pos[p]
                        out.print("<td align=\"center\" valign=\"middle\">&nbsp&nbsp&nbsp&nbsp"
                                + " <select name=\"" + field_name
                                + "SelectZhi\">");
                        out.print("<option value=\"nochoice\"> 请选择要联结的字段 </option>"); //默认第一个 nochoice

                        for (int s = 0; s < pos.length; s++) { //输出除自己外的其他表的属性
                            int k;
                            for (k = 0; k < tables.get(pos[s]).field.size() && (s != p); k++) {
                                if (field_type == tables.get(pos[s]).field.get(k).Type) {
                                    String sub_field_name = tables.get(pos[s]).field.get(k).name;
                                    out.print("<option value=\"" + choice[s] + "." + sub_field_name + "\">");
                                    out.print(choice[s] + "." + sub_field_name);
                                    out.print("</option>");
                                }
                            }
                        }
                        out.print("</select>&nbsp&nbsp&nbsp&nbsp</td> </tr>");
                    }
                    out.print("</table>");
                }

                out.print("<br> <input name=\"submit2\" type=\"submit\" value=\"查询\">");
                out.print("&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<input name=\"reset\" type=\"reset\" value=\"重置\">");
            }
        %>
    </center>
</body>
</html>
