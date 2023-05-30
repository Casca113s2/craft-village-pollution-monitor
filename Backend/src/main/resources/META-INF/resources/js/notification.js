$(document).ready(function(){ 
    loadNotification();
});
function loadNotification() {
    fetch("/craftvillage/api/notification")
    .then((res) => res.json())
    .then((data) => { 
        if(data.length == 0) {
            $("#noti-dropdown").empty();
            $("#quantity-noti").hide();
        }
        else {
            data = data.sort(function(a,b) { return b.surveyId - a.surveyId})
            //console.log(data);
            $("#quantity-noti").empty();
            $("#quantity-noti").append(data.length)
            $("#noti-dropdown").empty();
            data.map(function(item) {
                $("#noti-dropdown").append(`
                    <div class="notifi__item" id=${item.villageId + "," + item.surveyId}>
                        <div class="content">
                            <p>Cảnh báo ô nhiễm tại ${item.villageName}</p>
                            <span class="date">${item.date}</span>
                        </div>
                    </div>
                `);
            });
            onclickNotification();  
        }
    });
}

function onclickNotification() {
    $('.notifi__item').click(function() {
        idItem = $(this).attr('id').split(',');
        villageId = idItem[0];
        surveyId  = idItem[1];
        
    })
}