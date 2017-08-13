function showNotification(msgType, message){
    var type = "";
    switch(msgType){
        case "success":
            type = "success";
            break;
        case "warning":
            type = "warning";
            break;
        case "danger":
            type = "danger";
            break;
        default:
            type = "info";
    }

    $.notify({
        icon: "notifications",
        message: message

    },{
        type: type,
        timer: 10,
        placement: {
            from: 'bottom',
            align: 'right'
        }
    });
}

////////////////////Confirmation Modal Hide/Show///////////////////

function showConfirmModel(title){
    var confirmModalEle = $("#confirm_modal");
    confirmModalEle.find(".modal-title").html(title);
    confirmModalEle.modal('show');
}

function hideConfirmModel(){
    $("#confirm_modal").modal('hide');
}

function showModel(title){
    var confirmModalEle = $("#myModal");
    confirmModalEle.find(".modal-title").html(title);
    confirmModalEle.modal('show');
}

function hideModel(){
    $("#myModal").modal('hide');
}
