$('#btn-change-password').on("click", function(){
    let currentPassword = $('#current-password').val();
    let newPassword = $('#new-password').val();
    let confirmedPassword = $('#confirmed-password').val();
    if(currentPassword.length * newPassword.length * confirmedPassword.length == 0){
        $('#success-message-modal').removeClass("display");
        $('#error-message-modal').text("Empty field!");
        $('#error-message-modal').addClass("display");
        return;
    }
    if(currentPassword === newPassword){
        $('#success-message-modal').removeClass("display");
        $('#error-message-modal').text("Same current password!");
        $('#error-message-modal').addClass("display");
        return;
    }
    if(newPassword !== confirmedPassword){
        $('#success-message-modal').removeClass("display");
        $('#error-message-modal').text("Confirmed password incorrect!");
        $('#error-message-modal').addClass("display");
        return;
    }

    $.ajax({
        url: "/craftvillage/api/user/changepass",
        type: 'POST',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
                oldPass : currentPassword,
                newPass : newPassword,
            }),
        success: function(res) {
            if(res){
            	$("#error-message-modal").removeClass("display");
                $("#success-message-modal").text("Success");
            	$("#success-message-modal").addClass("display");
            }
            else {
                $("#success-message-modal").removeClass("display");
                $("#error-message-modal").text("Wrong password!");
                $("#error-message-modal").addClass("display");
            }
        }
    });
});

$('#modal-change-password').on('click', function(){
    $('#staticModal').modal();
});