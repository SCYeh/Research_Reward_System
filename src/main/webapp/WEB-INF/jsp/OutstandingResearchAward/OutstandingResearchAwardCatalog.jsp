
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>傑出研究獎</title>
    <link rel="stylesheet" type="text/css" href="css/FormStyle.css">
    <script src="js/jquery.min.js"></script>
    <style type="text/css">
        body{
            text-align-last: center;
        }
        thead{
            background-color: rgb(255, 255, 240);
        }
        th{
            border-style: solid;
            border-width: thin;
        }
        .left{
            text-align-last: left;
        }
    </style>
</head>
<body>
<div class="content">
    <h2 style="text-align:center;">傑出研究獎</h2>
    <table>
        <thead>
        <tr>
            <td class="metadata">申請表名稱</td>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td class="left"><a class = "filledCheck" href="OutstandingResearchAward" name="OutstandingResearchAward">推薦申請表</a></td>
        </tr>
        <tr>
            <td class="left"><a href="OutstandingResearchAwardReviewInformation" name="OutstandingResearchAwardReviewInformation">審查資料表</a></td>
        </tr>
        <tr>
            <td class="left"><a class = "filledCheck" href="OutstandingResearchAwardTableA" name="OutstandingResearchAwardTableA">近三年內發表之期刊論文統計表</a></td>
        </tr>
        <tr>
            <td class="left"><a class = "filledCheck" href="OutstandingResearchAwardTableB" name="OutstandingResearchAwardTableB">傑出論文績效說明表</a></td>
        </tr>
        <tr>
            <td class="left"><a class = "filledCheck" href="PaperPerformanceDescriptionUpload" name="PaperPerformanceDescriptionUpload">傑出論文績效說明表-檔案上傳</a></td>
        </tr>
        <tr>
            <td class="left"><a href="OtherFileUpload" name="OtherFileUpload">其他附件上傳</a></td>
        </tr>
        </tbody>
    </table>
    <div style="margin: 1rem;" class="edit">
        <button type="button" name="return_last_page" onclick="location.href='RewardList'">回上頁</button>
        <button type="button" name="send_application" onclick="sendApply()">提出申請</button>
    </div>
    <div style="margin: 1rem;" class="review">
        <button type="button" name="return_last_page" onclick="rejectApply()">退件</button>
        <button type="button" name="confirm" onclick="approveApply()">審查完成</button>
    </div>
</div>
</body>
<script>
    $(document).ready(function () {
        $(".review").hide();
        $(".edit").hide();
        if(${readonly}){
            $(".review").show();
        }
        else{
            $(".edit").show();
        }
    })
    async function sendApply(){
        if (!confirm("確定要送出申請?")) {
            return;
        }
        new Promise((resolve, reject) => {
            $.ajax({
                type: 'POST',
                url: 'ProjectFillRate',
                dataType: 'text',
                data: "",
                contentType: 'application/text',
                success: async function (data) {
                    let rateData = JSON.parse(data);
                    resolve(await checkFilled(rateData));
                },
                error: function (data) {
                    console.log(data);
                    reject(false);
                }
            });
        }).then(result=>{
            if(result){
                $.ajax({
                    type: 'POST',
                    url: 'SendApply',
                    dataType: 'text',
                    data: "",
                    contentType: 'application/text',
                    success: function (data) {
                        alert('申請成功');
                        window.location.href = "TraceProgress";
                        window.open('OutstandingResearchAwardPrint', 'TheWindow');
                    },
                    error: function(jqXHR, textStatus, message) {
                        alert(jqXHR.responseText);
                    }
                });
            }
        });
    }

    async function checkFilled(fillRates) {
        if(!fillRates){
            return false;
        }
        console.log(fillRates)
        let fillPage = document.getElementsByClassName("filledCheck");
        let fillRatesKeys = Object.keys(fillRates);
        // ReviewInformation page don't need to be checked fillRate.
        console.log(fillPage.length)
        console.log(fillRatesKeys.length)
        if (fillRatesKeys.length < fillPage.length) {
            let unSavedPageName = "";
            for (let i = 0; i < fillPage.length; i++) {
                let page = fillPage[i];
                if (!fillRates[page.name] ) {
                    unSavedPageName += page.innerHTML + " ";
                }
            }
            alert(unSavedPageName + "頁面尚未儲存");
            return false;
        } else if (fillRatesKeys.length === fillPage.length) {
            let unFinishedPageName = "";
            for (let i = 0; i < fillRatesKeys.length; i++) {
                let fillRatesKey = fillRatesKeys[i];
                const rate = fillRates[fillRatesKey];
                if (rate < 1.0) {
                    unFinishedPageName += fillPage.namedItem(fillRatesKey).innerHTML + " ";
                }
            }
            if (unFinishedPageName.length > 0) {
                alert(unFinishedPageName + "頁面尚未填寫完成");
                return false;
            } else {
                console.log("send");
                return true;
            }
        }
        return false;
    }

    function approveApply(){
        if (confirm("是否確認送出審理?")) {
            $.ajax({
                type: 'POST',
                url: 'ApproveApply',
                dataType: 'text',
                data: "",
                contentType: 'application/text',
                success: function (data) {
                    alert('確認審理成功');
                    window.location.href = "ApprovedRewardList";
                    window.open('OutstandingResearchAwardPrint', 'TheWindow');
                }
            });
        }
    };

    function rejectApply(){
        if (confirm("確定要退件?"))
            window.location.href="ReasonForReturn";
    };
</script>
</html>