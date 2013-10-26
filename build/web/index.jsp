<%-- 
    Document   : index
    Created on : 2011-10-18, 5:57:12
    Author     : Icho
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%--
    String LogName = (String) session.getAttribute("SuccessName");
    if (LogName.equals("-")) {
        response.sendRedirect("../AppServer1/");
    }
--%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>数据库查询</title>
        <link id="shLink" href="sheets/sheet001.jsp">
        <link id="shLink" href="sheets/sheet002.jsp">
        <link id="shLink" href="sheets/sheet003.jsp">
        <link id="shLink" href="sheets/sheet004.jsp">

        <link id="shLink">

        <script language="JavaScript">
            <!--
            var c_lTabs=4;

            var c_rgszSh=new Array(c_lTabs);
            c_rgszSh[0] = "单表查询";
            c_rgszSh[1] = "多表查询";
            c_rgszSh[2] = "聚合操作";
            c_rgszSh[3] = "联结操作";



            var c_rgszClr=new Array(8);
            c_rgszClr[0]="yellow";
            c_rgszClr[1]="buttonface";
            c_rgszClr[2]="windowframe";
            c_rgszClr[3]="windowtext";
            c_rgszClr[4]="lightblue";
            c_rgszClr[5]="threedhighlight";
            c_rgszClr[6]="threeddarkshadow";
            c_rgszClr[7]="blue";

            var g_iShCur;
            var g_rglTabX=new Array(c_lTabs);

            function fnGetIEVer()
            {
                var ua=window.navigator.userAgent
                var msie=ua.indexOf("MSIE")
                if (msie>0 && window.navigator.platform=="Win32")
                    return parseInt(ua.substring(msie+5,ua.indexOf(".", msie)));
                else
                    return 0;
            }

            function fnBuildFrameset()
            {
                var szHTML="<frameset rows=\"*,37\" border=0 width=0 frameborder=no framespacing=0>"+
                    "<frame src=\""+document.all.item("shLink")[0].href+"\" name=\"frSheet\" noresize>"+
                    "<frameset cols=\"120,*\" border=0 width=0 frameborder=no framespacing=0>"+
  
                    "<frame src=\"\" name=\"frScroll\" marginwidth=0 marginheight=0 scrolling=no>"+
                    "<frame src=\"\" name=\"frTabs\" marginwidth=0 marginheight=0 scrolling=no>"+
  
                    "</frameset></frameset><plaintext>";

                with (document) {
                    open("text/html","replace");
                    write(szHTML);
                    close();
                }

                fnBuildTabStrip();
            }

            function fnBuildTabStrip()
            {

                var szHTML=
                    "<html><head><style>.clScroll {font:8pt Courier New;color:"+c_rgszClr[6]+";cursor:default;line-height:12pt;}"+
                    ".clScroll2 {font:10pt Arial;color:"+c_rgszClr[6]+";cursor:default;line-height:11pt;}</style></head>"+
                    "<body onclick=\"event.returnValue=false;\" ondragstart=\"event.returnValue=false;\" onselectstart=\"event.returnValue=false;\" bgcolor="+c_rgszClr[4]+" topmargin=0 leftmargin=0><table cellpadding=0 cellspacing=0 width=100%>"+
                    "<tr><td colspan=6 height=2 bgcolor="+c_rgszClr[2]+"></td></tr>"+
                    "<tr><td style=\"font:2pt\">&nbsp;<td>"+
  
                    "<td style=\"font:2pt\">&nbsp;<td></tr></table></body></html>";

                with (frames['frScroll'].document) {
                    open("text/html","replace");
                    write(szHTML);
                    close();
                }

                szHTML =
                    "<html><head>"+
                    "<style>A:link,A:visited,A:active {text-decoration:none;"+"color:"+c_rgszClr[3]+";}"+
                    ".clTab {cursor:hand;background:"+c_rgszClr[1]+";font:18pt 宋体;padding-left:4px;padding-right:4px;text-align:center;}"+
                    ".clBorder {background:"+c_rgszClr[2]+";font:2pt;}"+
                    "</style></head><body onload=\"parent.fnInit();\" onselectstart=\"event.returnValue=false;\" ondragstart=\"event.returnValue=false;\" bgcolor="+c_rgszClr[4]+
                    " topmargin=0 leftmargin=0><table id=tbTabs cellpadding=0 cellspacing=0>";

                var iCellCount=(c_lTabs+1)*2;

                var i;
                for (i=0;i<iCellCount;i+=2)
                    szHTML+="<col width=1><col>";

                var iRow;
                for (iRow=0;iRow<6;iRow++) {

                    szHTML+="<tr>";

                    if (iRow==5)
                        szHTML+="<td colspan="+iCellCount+"></td>";
                    else {
                        if (iRow==0) {
                            for(i=0;i<iCellCount;i++)
                                szHTML+="<td height=2 class=\"clBorder\"></td>";
                        } else if (iRow==1) {
                            for(i=0;i<c_lTabs;i++) {
                                szHTML+="<td height=2 nowrap class=\"clBorder\">&nbsp;</td>";
                                szHTML+=
                                    "<td id=tdTab height=2 nowrap class=\"clTab\" onmouseover=\"parent.fnMouseOverTab("+i+");\" onmouseout=\"parent.fnMouseOutTab("+i+");\">"+
                                    "<a href=\""+document.all.item("shLink")[i].href+"\" target=\"frSheet\" id=aTab>&nbsp;"+c_rgszSh[i]+"&nbsp;</a></td>";
                            }
                            szHTML+="<td id=tdTab height=2 nowrap class=\"clBorder\"><a id=aTab>&nbsp;</a></td><td width=100%></td>";
                        } else if (iRow==2) {
                            for (i=0;i<c_lTabs;i++)
                                szHTML+="<td height=2></td><td height=2 class=\"clBorder\"></td>";
                            szHTML+="<td height=2></td><td height=2></td>";
                        } else if (iRow==3) {
                            for (i=0;i<iCellCount;i++)
                                szHTML+="<td height=2></td>";
                        } else if (iRow==4) {
                            for (i=0;i<c_lTabs;i++)
                                szHTML+="<td height=2 width=1></td><td height=2></td>";
                            szHTML+="<td height=2 width=1></td><td></td>";
                        }
                    }
                    szHTML+="</tr>";
                }

                szHTML+="</table></body></html>";
                with (frames['frTabs'].document) {
                    open("text/html","replace");
                    charset=document.charset;
                    write(szHTML);
                    close();
                }
            }

            function fnInit()
            {
                g_rglTabX[0]=0;
                var i;
                for (i=1;i<=c_lTabs;i++)
                    with (frames['frTabs'].document.all.tbTabs.rows[1].cells[fnTabToCol(i-1)])
                g_rglTabX[i]=offsetLeft+offsetWidth-6;
            }

            function fnTabToCol(iTab)
            {
                return 2*iTab+1;
            }

            function fnNextTab(fDir)
            {
                var iNextTab=-1;
                var i;

                with (frames['frTabs'].document.body) {
                    if (fDir==0) {
                        if (scrollLeft>0) {
                            for (i=0;i<c_lTabs&&g_rglTabX[i]<scrollLeft;i++);
                            if (i<c_lTabs)
                                iNextTab=i-1;
                        }
                    } else {
                        if (g_rglTabX[c_lTabs]+6>offsetWidth+scrollLeft) {
                            for (i=0;i<c_lTabs&&g_rglTabX[i]<=scrollLeft;i++);
                            if (i<c_lTabs)
                                iNextTab=i;
                        }
                    }
                }
                return iNextTab;
            }

            function fnScrollTabs(fDir)
            {
                var iNextTab=fnNextTab(fDir);

                if (iNextTab>=0) {
                    frames['frTabs'].scroll(g_rglTabX[iNextTab],0);
                    return true;
                } else
                    return false;
            }

            function fnFastScrollTabs(fDir)
            {
                if (c_lTabs>16)
                    frames['frTabs'].scroll(g_rglTabX[fDir?c_lTabs-1:0],0);
                else
                    if (fnScrollTabs(fDir)>0) window.setTimeout("fnFastScrollTabs("+fDir+");",5);
            }

            function fnSetTabProps(iTab,fActive)
            {
                var iCol=fnTabToCol(iTab);
                var i;

                if (iTab>=0) {
                    with (frames['frTabs'].document.all) {
                        with (tbTabs) {
                            for (i=0;i<=4;i++) {
                                with (rows[i]) {
                                    if (i==0)
                                        cells[iCol].style.background=c_rgszClr[fActive?0:2];
                                    else if (i>0 && i<4) {
                                        if (fActive) {
                                            cells[iCol-1].style.background=c_rgszClr[2];
                                            cells[iCol].style.background=c_rgszClr[0];
                                            cells[iCol+1].style.background=c_rgszClr[2];
                                        } else {
                                            if (i==1) {
                                                cells[iCol-1].style.background=c_rgszClr[2];
                                                cells[iCol].style.background=c_rgszClr[1];
                                                cells[iCol+1].style.background=c_rgszClr[2];
                                            } else {
                                                cells[iCol-1].style.background=c_rgszClr[4];
                                                cells[iCol].style.background=c_rgszClr[(i==2)?2:4];
                                                cells[iCol+1].style.background=c_rgszClr[4];
                                            }
                                        }
                                    } else
                                        cells[iCol].style.background=c_rgszClr[fActive?2:4];
                                }
                            }
                        }
                        with (aTab[iTab].style) {
                            cursor=(fActive?"default":"hand");
                            color=c_rgszClr[3];
                        }
                    }
                }
            }

            function fnMouseOverScroll(iCtl)
            {
                frames['frScroll'].document.all.tdScroll[iCtl].style.color=c_rgszClr[7];
            }

            function fnMouseOutScroll(iCtl)
            {
                frames['frScroll'].document.all.tdScroll[iCtl].style.color=c_rgszClr[6];
            }

            function fnMouseOverTab(iTab)
            {
                if (iTab!=g_iShCur) {
                    var iCol=fnTabToCol(iTab);
                    with (frames['frTabs'].document.all) {
                        tdTab[iTab].style.background=c_rgszClr[5];
                    }
                }
            }

            function fnMouseOutTab(iTab)
            {
                if (iTab>=0) {
                    var elFrom=frames['frTabs'].event.srcElement;
                    var elTo=frames['frTabs'].event.toElement;

                    if ((!elTo) ||
                        (elFrom.tagName==elTo.tagName) ||
                        (elTo.tagName=="A" && elTo.parentElement!=elFrom) ||
                        (elFrom.tagName=="A" && elFrom.parentElement!=elTo)) {

                        if (iTab!=g_iShCur) {
                            with (frames['frTabs'].document.all) {
                                tdTab[iTab].style.background=c_rgszClr[1];
                            }
                        }
                    }
                }
            }

            function fnSetActiveSheet(iSh)
            {
                if (iSh!=g_iShCur) {
                    fnSetTabProps(g_iShCur,false);
                    fnSetTabProps(iSh,true);
                    g_iShCur=iSh;
                }
            }

            window.g_iIEVer=fnGetIEVer();
            if (window.g_iIEVer>=4)
                fnBuildFrameset();
            //-->
        </script>

        <title>数据库查询</title>
    </head>

    <frameset rows="*,39" border=0 width=0 frameborder=no framespacing=0>
        <frame src="sheets/sheet001.jsp" name="frSheet">
            <frame src="sheets/tabstrip.htm" name="frTabs" marginwidth=0 marginheight=0>


                <noframes>
                    <body>
                        <p>此页面使用了框架，而您的浏览器不支持框架。</p>
                    </body>
                </noframes>
                </frameset>
                </html>
