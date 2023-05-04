$(document).ready(function(){
    fetch("/craftvillage/api/notification")
    .then((res) => res.json())
    .then((data) => { 
        if(data.length == 0) {
            $("#noti-dropdown").empty();
            $("#quantity-noti").hide();
        }
        else {
            $("#noti-dropdown").empty();
            data.map(function(item) {
                $("#noti-dropdown").append(`
                    <div class="notifi__item">
                        <div class="content">
                            <p>${item.title}</p>
                            <span class="date">${item.content}</span>
                        </div>
                    </div>
                `);
            });  
        }
    });
});