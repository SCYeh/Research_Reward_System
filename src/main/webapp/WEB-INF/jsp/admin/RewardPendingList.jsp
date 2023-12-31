<%@ page import="fr.opensagres.xdocreport.document.json.JSONArray" %>
<%@ page import="fr.opensagres.xdocreport.document.json.JSONObject" %><%--
  Created by IntelliJ IDEA.
  User: z
  Date: 2021/1/20
  Time: 下午 03:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% JSONArray array = (JSONArray) request.getAttribute("json");%>
<html>
<head>
    <title>待審核獎項</title>
    <link rel="stylesheet" type="text/css" href="css/FormStyle.css">
    <script src="js/jquery.min.js"></script>
    <script>
        function commit(project_id,rewardName){
            $.ajax({
                type: 'POST',
                url: 'RewardList',
                dataType: 'json',
                data: JSON.stringify({
                    projectId:project_id,
                    rewardName:rewardName
                }),
                contentType: 'application/json',
                complete:function(XMLHttpRequest,textStatus){
                    var newDoc = document.open("text/html", "replace");
                    newDoc.write(XMLHttpRequest.responseText);
                    newDoc.close();
                }
            });

        };

        $(document).on("click", "button[name='review']",function(){
            var projectId = $(this).parents("tr").find("td").eq(0).text();
            var rewardName = $(this).parents("tr").find("td").eq(1).text();
            commit(projectId,rewardName);
        });
    </script>
</head>
<body>
    <div class="content">
        <table>
            <tr>
                <td class="metadata">申請編號</td>
                <td class="metadata">申請獎項</td>
                <td class="metadata">操作</td>
            </tr>
            <%
                for(Object element: array){
                    JSONObject json = (JSONObject) element;
            %>
            <tr>
                <td><%=json.getInt("project_id")%></td>
                <td><%=json.getString("reward_type")%></td>
                <td>
                    <span><button type="button" name="review">查看</button></span>
                </td>
            </tr>
            <%
                }
            %>
        </table>
    </div>

</body>
</html>
