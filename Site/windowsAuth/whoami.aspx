<%@Language="C#"%>
<%
    string currentUser = Request.ServerVariables["LOGON_USER"];
    if (currentUser == "")
        currentUser = "anonymous";
    Response.Write("<b>HELLO:</b> " + currentUser);
%>