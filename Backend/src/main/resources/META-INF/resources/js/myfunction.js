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
})
$('#btn-update-profile').on("click", function(){
    let firstname = $('#firstname').val();
    let lastname = $('#lastname').val();
    let phone = $('#phone').val();
    if(firstname.length * lastname.length == 0){
        $('#success-profile-modal').removeClass("display");
        $('#error-profile-modal').text("Empty field!");
        $('#error-profile-modal').addClass("display");
        return;
    }

    $.ajax({
        url: "/craftvillage/api/user/updateuser",
        type: 'POST',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            firstname : firstname,
            lastname : lastname,
            phone : phone
        }),
        success: function(res) {
            if(res){
                $("#error-profile-modal").removeClass("display");
                $("#success-profile-modal").text("Success");
            	$("#success-profile-modal").addClass("display");
            }
            else {
                $("#success-profile-modal").removeClass("display");
                $("#error-profile-modal").text("Fail to update!");
                $("#error-profile-modal").addClass("display");
            }
        }
    });
})

$('#modal-change-password').on('click', function(){
    $('#staticModal1').modal();
})
$('#modal-profile').on('click', function(){
    $('#staticModal2').modal();
})