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
                        parent.fnSetActiveSheet(1);
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
        <form name="Multi" method="post" action="sheet002.jsp">
            <% // 如果数据库中没有表，则报错
                if (tables.size() == 0) {
                    out.println("数据库中无数据表，请检查数据库！");
                } else {
                    out.println("请选择将要操作的表名（至少两张表）: <p />");
                }

                for (int i = 0; i < tables.size(); i++) {
                    out.println("<input name=\"MultiChoice\" type=\"checkbox\" value=\"" + tables.get(i).tableName
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
            String[] choice = request.getParameterValues("MultiChoice");
            int i = 0;
            session.setAttribute("Mchoice", choice);
            if (choice == null || choice.length == 1) {
                out.print("无 <br>");
            } else {
                for (i = 0; choice != null && i < choice.length; i++) {
                    out.print(choice[i] + "&nbsp&nbsp");
                }
                ////////////////////////////////////////////////////////////////
                //输出抬头第一行
                out.print("<form name=\"MultiResult\" method=\"post\" action=\"result002.jsp\">");
                out.print("<table width=\"400\" border=\"0\">");
                out.print("<tr bgcolor =\"#CCFFFF\"> <td align=\"center\" valign=\"middle\">&nbsp&nbsp&nbsp&nbsp"
                        + " 属性名 &nbsp&nbsp&nbsp&nbsp</td>");
                out.print("<td align=\"center\" valign=\"middle\">&nbsp&nbsp&nbsp&nbsp 操作 &nbsp&nbsp&nbsp&nbsp</td>");
                out.print("<td align=\"center\" valign=\"middle\">&nbsp&nbsp&nbsp&nbsp 值 &nbsp&nbsp&nbsp&nbsp</td>");
                out.print("<td align=\"center\" valign=\"middle\">&nbsp&nbsp&nbsp&nbsp 结果输出 &nbsp&nbsp&nbsp&nbsp</td> </tr>");
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
                // 2.循环输出每张表的属性行，每张表颜色不同
                for (int p = 0; p < choice.length; p++) {
                    int count = 0;
                    t = pos[p]; //第一张表
                    for (int j = 0; j < tables.get(t).field.size(); j++) {
                        out.print("<tr bgcolor=" + bg + ">");
                        String field_name = tables.get(t).field.get(j).name;
                        int field_type = tables.get(t).field.get(j).Type;
                        out.print("<td align=\"center\" valign=\"middle\">&nbsp&nbsp&nbsp&nbsp"
                                + choice[p] + "." + field_name + "&nbsp&nbsp&nbsp&nbsp</td>");
                        ////////////////////////////////////////////////////////
                        //输出 SELECT 标签
                        out.print("<td align=\"center\" valign=\"middle\">&nbsp&nbsp&nbsp&nbsp");
                        switch (field_type) {
                            case 1:
                                out.print("<SELECT NAME =\"" + choice[p] + "." + field_name);
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
                                out.print("<SELECT NAME =\"" + choice[p] + "." + field_name
                                        + "Select\">"
                                        + "<OPTION SELECTED value=\"nochoice\"> 请选择 </OPTION>"
                                        + "<OPTION value=\" = \"> = </OPTION>"
                                        + "<OPTION value=\" LIKE \"> 包含 </OPTION>"
                                        + "</SELECT>");
                                break;
                            case 3:
                                out.print("<SELECT NAME =\"" + choice[p] + "." + field_name
                                        + "Select\">"
                                        + "<OPTION SELECTED value=\"nochoice\"> 请选择 </OPTION>"
                                        + "<OPTION value=\" = \"> = </OPTION>"
                                        + "</SELECT>");
                                break;
                            case 4:
                                out.print("<SELECT NAME =\"" + choice[p] + "." + field_name);
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
                        ////////////////////////////////////////////////////////
                        ////////////////////////////////////////////////////////
                        //值（这里要求既可以输入也可用下拉列表，下拉列表列出出自己外所有表的属性
                        //当前表的位置是 pos[p]
                        out.print("<td align=\"center\" valign=\"middle\">&nbsp<div style=\"position:relative;\">"
                                + "<span style=\"margin-left:120px;width:20px;overflow:hidden;\">"
                                + "<select style=\"width:140px;margin-left:-120px\" name=\"" + field_name
                                + "SelectZhi\" onChange=\"this.parentNode.nextSibling.value=this.value\">");
                        out.print("<option value=\"nochoice\"> </option>"); //默认第一个 nochoice

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


                        //下面代码实现可同时输入
                        out.print("</select> </span>");
                        out.print("<input type=\"text\"  style=\"width:120px;position:absolute;left:0px;\" name=\""
                                + choice[p] + "." + field_name);
                        if (count == 1) {
                            out.print(count);
                        }
                        out.print("Zhi\" size=\"20\"></div> &nbsp&nbsp&nbsp&nbsp</td>");
                        ////////////////////////////////////////////////////////
                        ////////////////////////////////////////////////////////
                        //结果输出
                        if (field_type != 1 && field_type != 4) {
                            out.print("<td align=\"center\" valign=\"middle\">&nbsp&nbsp&nbsp&nbsp"
                                    + "<input  type=\"checkbox\" name=\"" + choice[p] + "."
                                    + field_name + "Checkbox\" size=\"20\">" + "&nbsp&nbsp&nbsp&nbsp</td>");
                            out.print("</tr>");
                        }

                        // 如果是数字或者日期类型的就输出两遍
                        if (field_type == 1 || field_type == 4) {
                            if (count == 0) {
                                j--;
                                count++;
                                out.print("<td> 设定范围</td>");
                                out.print("</tr>");
                            } else {
                                out.print("<td align=\"center\" valign=\"middle\">&nbsp&nbsp&nbsp&nbsp"
                                        + "<input  type=\"checkbox\" name=\"" + choice[p] + "."
                                        + field_name + "Checkbox\" size=\"20\">" + "&nbsp&nbsp&nbsp&nbsp</td>");
                                out.print("</tr>");
                                count = 0;
                            }
                        }
                    }
                    ////////////////////////////////////////////////////////////
                    //变量更新
                    bg = randomColor();
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
