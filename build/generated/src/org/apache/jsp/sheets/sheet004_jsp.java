package org.apache.jsp.sheets;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.util.*;
import java.sql.*;

public final class sheet004_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.Vector _jspx_dependants;

  static {
    _jspx_dependants = new java.util.Vector(1);
    _jspx_dependants.add("/sheets/../GetInfo.jspf");
  }

  private org.glassfish.jsp.api.ResourceInjector _jspx_resourceInjector;

  public Object getDependants() {
    return _jspx_dependants;
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;

    try {
      response.setContentType("text/html;charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;
      _jspx_resourceInjector = (org.glassfish.jsp.api.ResourceInjector) application.getAttribute("com.sun.appserv.jsp.resource.injector");

      out.write('\r');
      out.write('\n');
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
//定义数据
    class fieldInfo
                       {
        String name;
        int fieldType;
        int Type;
        String Operator;
        //Type的定义:
        //数字 :1
        //字符串:2
        //逻辑值:3
        //日期:4
        //Operator的定义:操作符1#操作符2#...
    }
    class tableInfo
                       {
        String tableName;
       List<fieldInfo> field=new LinkedList<fieldInfo>();
               }

      out.write('\n');
//获取数据库中各个信息
            String sqlConn="Admin\n123456";//格式：用户名\n密码
            Connection Conn;
            List<tableInfo> tables=new LinkedList<tableInfo>();//存储所有信息
            try {
            Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
            /**
             * 直接连接access文件。
             */
            String dbur1 = "jdbc:odbc:QueryAccessTest;";//需要设置数据源
            String user = sqlConn.substring(0, sqlConn.indexOf("\n"));
            String psw = sqlConn.substring(sqlConn.indexOf("\n") + 1);
            Properties prop = new Properties();
            prop.put("charSet", "gb2312");
            prop.put("user", user);
            prop.put("password", psw);
            Conn = DriverManager.getConnection(dbur1, prop);
            //out.print("连接数据库成功<br>");
            DatabaseMetaData  dbmd=Conn.getMetaData();  
            ResultSet  rs=dbmd.getTables(null,null,"%",null);  
            while(rs.next()){  
                if(rs.getString(4).equals("TABLE"))
                {
                    String tableName=rs.getString(3);
                     //out.print("table-name:  "+tableName+"<br>");  
                     tableInfo table=new tableInfo();
                     table.tableName=tableName;
                     ResultSet columns=dbmd.getColumns(null, null, tableName, null);
                     while(columns.next())
                                                 {
                              String fieldName=columns.getString(4);
                              int fieldType=columns.getInt(5);
                             // out.print("列名称:"+fieldName+"，列属性"+fieldType+"<br>");
                              fieldInfo field=new fieldInfo();
                              field.name=fieldName;
                              field.fieldType=fieldType;
                              field.Type=0;
                              table.field.add(field);
                                                           }
                     tables.add(table);
                }
            }  
             Conn.close();
        } catch (Exception e) {
            //out.println(e.toString() + "连接数据库失败！");
        }
          

      out.write('\n');
//处理获取的数据
        for(int i=0;i<tables.size();i++){
            for(int j=0;j<tables.get(i).field.size();j++){
                int FT=tables.get(i).field.get(j).fieldType;
                if(FT==-7||FT==-6||FT==2||FT==3||FT==4||FT==5||FT==6||FT==7||FT==8){
                    tables.get(i).field.get(j).Type=1;
                    tables.get(i).field.get(j).Operator="=#>#<#>=#<=#!=#";
                }       
                else if(FT==-16||FT==-15||FT==-9||FT==-1||FT==1||FT==12){
                    tables.get(i).field.get(j).Type=2; 
                    tables.get(i).field.get(j).Operator="=#包含#";
                }                    
                else if(FT==16){
                    tables.get(i).field.get(j).Type=3;
                    tables.get(i).field.get(j).Operator="=#";
                }     
                else if(FT==91||FT==92||FT==93){
                    tables.get(i).field.get(j).Type=4;
                    tables.get(i).field.get(j).Operator="之前#精确#之后#";
                }   
                else
                    tables.get(i).field.remove(j);                                
            }    
        }
              /*for(int i=0;i<tables.size();i++){
                 out.print("表名称:"+tables.get(i).tableName+"<br>");
                 for(int j=0;j<tables.get(i).field.size();j++){
                     out.print("&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp字段名称:"+tables.get(i).field.get(j).name+",字段类型:"+tables.get(i).field.get(j).fieldType
                             +",类型:"+tables.get(i).field.get(j).Type+"<br>");
                 }
             }*/
 

      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\r\n");
      out.write("<!DOCTYPE html>\r\n");
      out.write("<html>\r\n");
      out.write("    <head>\r\n");
      out.write("        <meta http-equiv=\"Content-Type\" content=\"text/html; charset=GB2312\">\r\n");
      out.write("        <title>联结操作</title>\r\n");
      out.write("        <link rel=Stylesheet href=stylesheet.css>\r\n");
      out.write("        <script language=\"JavaScript\">\r\n");
      out.write("            function fnUpdateTabs()\r\n");
      out.write("            {\r\n");
      out.write("                if (parent.window.g_iIEVer>=4) {\r\n");
      out.write("                    if (parent.document.readyState==\"complete\"\r\n");
      out.write("                        && parent.frames['frTabs'].document.readyState==\"complete\")\r\n");
      out.write("                        parent.fnSetActiveSheet(3);\r\n");
      out.write("                    else\r\n");
      out.write("                        window.setTimeout(\"fnUpdateTabs();\",150);\r\n");
      out.write("                }\r\n");
      out.write("            }\r\n");
      out.write("\r\n");
      out.write("            if (window.name!=\"frSheet\")\r\n");
      out.write("                window.location.replace(\"../index.jsp\");\r\n");
      out.write("            else\r\n");
      out.write("                fnUpdateTabs();\r\n");
      out.write("        </script>\r\n");
      out.write("        <script language=\"javascript\" type=\"text/javascript\">\r\n");
      out.write("            function checkbox_max(obj, num) {\r\n");
      out.write("                var s = 0;//计数器\r\n");
      out.write("                var ob = document.getElementsByName(\"JoinChoice\");\r\n");
      out.write("                //统计已选中的复选框个数\r\n");
      out.write("                for (i = 0; i < ob.length; i++) {\r\n");
      out.write("                    if (ob[i].checked == true)\r\n");
      out.write("                        s=s+1;\r\n");
      out.write("                }\r\n");
      out.write("                if (s > num) {\r\n");
      out.write("                    alert(\"最多只能选择两张表！\");\r\n");
      out.write("                    obj.checked = false;\r\n");
      out.write("                }\r\n");
      out.write("            }\r\n");
      out.write("        </script>\r\n");
      out.write("    </head>\r\n");
      out.write("\r\n");
      out.write("    <body link=blue vlink=purple>\r\n");
      out.write("    <center>\r\n");
      out.write("        <form name=\"Join\" method=\"post\" action=\"sheet004.jsp\">\r\n");
      out.write("            ");
 // 如果数据库中没有表，则报错
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
            
      out.write("\r\n");
      out.write("        </form>\r\n");
      out.write("        <hr></hr>\r\n");
      out.write("        ");

            String[] choice = request.getParameterValues("JoinChoice");
            int i = 0;
            session.setAttribute("choice", choice);
            if (choice == null || choice.length == 1) {
                out.print("无 <br>");
            } else {
                out.print("<table width=\"400\" border=\"0\">");
                out.print("<tr bgcolor =\"#66FFFF\"> <td align=\"center\" valign=\"middle\">");
                out.print(choice[0] + "&nbsp&nbsp&nbsp&nbsp </td>");
                out.print("<td align=\"center\" valign=\"middle\">");
                out.print("<SELECT NAME =\"JoinChoiceSelect\">");
                out.print("<OPTION SELECTED value=\"nochoice\"> 请选择联结类型 </OPTION>");
                out.print("<OPTION value=\"INNER JOIN\"> 内联结 </OPTION>");
                out.print("<OPTION value=\"FULL OUTER JOIN\"> 完全外联结 </OPTION>");
                out.print("<OPTION value=\"LEFT OUTER JOIN\"> 左外联结 </OPTION>");
                out.print("<OPTION value=\"RIGHT OUTER JOIN\"> 右外联结 </OPTION>");
                out.print("<OPTION value=\"CROSS JOIN\"> 交叉联结 </OPTION>");
                out.print("</SELECT>&nbsp&nbsp&nbsp&nbsp</td>");
                out.print("<td align=\"center\" valign=\"middle\">");
                out.print(choice[1] + "&nbsp&nbsp&nbsp&nbsp </td> </tr> </table>");

                ////////////////////////////////////////////////////////////////
                //输出抬头第一行
                out.print("<form name=\"JoinResult\" method=\"post\" action=\"result004.jsp\">");
                out.print("<table width=\"400\" border=\"0\">");
                out.print("<tr bgcolor =\"#CCFFFF\"> <td align=\"center\" valign=\"middle\"> 表1 字段名 &nbsp&nbsp&nbsp&nbsp</td>");
                out.print("<td align=\"center\" valign=\"middle\"> 联结条件 &nbsp&nbsp&nbsp&nbsp</td>");
                out.print("<td align=\"center\" valign=\"middle\"> 表2 字段名 &nbsp&nbsp&nbsp&nbsp</td> </tr>");
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

                out.print("<br><br> <input name=\"submit2\" type=\"submit\" value=\"查询\">");
                out.print("&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<input name=\"reset\" type=\"reset\" value=\"重置\">");
            }
        
      out.write("\r\n");
      out.write("    </center>\r\n");
      out.write("</body>\r\n");
      out.write("</html>\r\n");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          out.clearBuffer();
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
