var current = document.querySelector('#current-image');
var total = document.querySelector('#total-image');
var btn_prev = document.querySelector('#btn-previous-image');
var btn_next = document.querySelector('#btn-next-image');

//set View ban đầu
//var map = L.map('map').setView([9.2940, 105.7216], 13); 
var map;
var markers = {}
    //icon villages
var myIcon = L.icon({
    iconUrl: "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|e85141&chf=a,s,ee00FFFF",
    iconSize: [21, 34],
})

var markerWarning = {};

var markerImagePollution ={};
var id_marker = []; //Save marker id for delete
var villages = [];  
$(document).ready(function(){
    $('#warning').hide() 
    loadMap();
    loadNotification();
});

function loadMap() {
    fetch("/api/map/getVillageLocation")
        .then((res) => res.json())
        .then((data) => {           
            //set view ban đầu
            var coordinate = data.districtCoordinate.split(",")
            map = L.map('map').setView([+coordinate[0], +coordinate[1]], 13); //CL
            L.tileLayer('https://api.maptiler.com/maps/bright/256/{z}/{x}/{y}.png?key=Xx2LVdpWdk1UyVYRKzN0',{
            tileSize: 512,
            zoomOffset: -1,
            minZoom: 1,
            attribution: "\u003ca href=\"https://www.maptiler.com/copyright/\" target=\"_blank\"\u003e\u0026copy; MapTiler\u003c/a\u003e \u003ca href=\"https://www.openstreetmap.org/copyright\" target=\"_blank\"\u003e\u0026copy; OpenStreetMap contributors\u003c/a\u003e",
            crossOrigin: true
            }).addTo(map);

            villages =  data.villages
            //Hiện các marker làng nghề 
            loadAllMarker();
            //Filter by pollution
            filterByPollution();
    });
}

function removeAllMarker() {
    for(let i=0; i<id_marker.length; i++){
        if(map.hasLayer(markers[id_marker[i]])) {
            map.removeLayer(markers[id_marker[i]])
        }
    }
}

function clearInformationVillage(filter = 0) {
    if (map.hasLayer(markerImagePollution)) map.removeLayer(markerImagePollution);

    $('#image-container').empty();
    $('#no-data').append("No data");

    $('#date').empty().append("---");
    $('#pollution').empty().append("---");            
    $('#note').empty().append("---");

    $('#warning').hide()

    btn_prev.onclick = null;
    btn_next.onclick = null;

    $('#household-table').empty();
    
    if(filter != 0) {
        $('#ward-name').empty().append("---");
        $('#village-name').empty().append("---");
        $('#household-number').empty().append("---");
        $('#latitude').empty().append("---")
        $('#longitude').empty().append("---");
        $('#earth').prop('checked', false);
        $('#air').prop('checked', false);
        $('#water').prop('checked', false);

        current.textContent = "--";
        total.textContent= "--";

    }
}

//filter by pollution
function filterByPollution() {         
    $('.pollution-filter').change(function() {
        
        clearInformationVillage(1);
        //Condition for filter
        let pollution = "";
        $('.pollution-filter').each(function() {
            if($(this).prop('checked')) pollution += "1"
            else pollution += "0";
        });
        
        if(pollution === '000') {
            loadAllMarker();
            return;
        }
        //get all village filter
        let villagesFilter = villages.filter(function(village) {
            const stateLookup = {
                '100' : ['100', '110', '101', '111'],
                '010' : ['010', '110', '011', '111'],
                '001' : ['001', '101', '011', '111'],
                '110' : ['110', '111'],
                '101' : ['101', '111'],
                '011' : ['011', '111'],
                '111' : ['111']
            }
            return stateLookup[pollution]?.includes(village.state); 
        });

        if(villagesFilter.length != 0) loadAllMarker(villagesFilter);
        else removeAllMarker();
    })
}

//Load All marker
function loadAllMarker(villagesFilter = []) {
    //reset all marker
    removeAllMarker();
    id_marker = [];
    let villageMarker = []; //village will create marker
    if(villagesFilter.length == 0) {
        villageMarker = villages;              
    }
    else {
        villageMarker = villagesFilter;
    }

    villageMarker.map((item) => {
        // Create and save a reference to each marker
        markers[item.villageId] = L.marker([item.latitude, item.longitude],{
            icon: myIcon,              
        }).addTo(map);
        // Add the ID
        markers[item.villageId]._icon.id = item.villageId + ", " + item.villageName;
        //gắn popup khi mouseover vào
        markers[item.villageId].bindPopup(item.villageName)
        markers[item.villageId].on('mouseover', function(e){
            this.openPopup();

        });
        markers[item.villageId].on('mouseout', function(e){
            this.closePopup();
        });

        //push for delete when filter
        id_marker.push(item.villageId);
    }) 
    //Onclick marker
    onClickMarker();
}

//Onclick Marker 
function onClickMarker() {
    $('.leaflet-marker-icon').click(function(e) {
        // Use the event to find the clicked element
        var el = $(e.srcElement || e.target),
        id_name = el.attr('id').split(', ');
        id = id_name[0]
        village_name = id_name[1]
        //load Onclick
        loadVillageInformation(id, village_name)

        //Ảnh
        loadImage(id)

        //Khai báo
        loadDeclare(id);          
    });         
}

function loadVillageInformation(id, village_name) {
    $.getJSON("/api/map/getVillage?villageId="+id, function(data) {
        if (map.hasLayer(markerImagePollution)) map.removeLayer(markerImagePollution);
        var coordinate = data.coordinate.split(", ");
        $("#ward-name").html(data.wardName);
        $("#latitude").html(parseFloat(coordinate[0]).toFixed(5));
        $("#longitude").html(parseFloat(coordinate[1]).toFixed(5));
        
        //Pollution
        if(data.state[0] === '1') $('#earth').prop('checked', true); else $('#earth').prop('checked', false);
        if(data.state[1] === '1') $('#air').prop('checked', true); else $('#air').prop('checked', false);
        if(data.state[2] === '1') $('#water').prop('checked', true); else $('#water').prop('checked', false);

        // $.getJSON("/api/map/getHousehold?villageId="+id, function(data) {
                          
        // });

        $("#village-name").html(village_name);
    });
}

function loadImage(id, surveyId = -1) {
    fetch("/craftvillage/api/survey/listImage?villageId="+id)
         .then((res) => res.json())
         .then((data) => {
            current.textContent= (data.length) ? 1 : 0
            total.textContent=data.length 
            if(data.length != 0) {
                data = data.sort(function(a,b) {return b-a})

                if(surveyId == -1) {
                    getImage(data[0])
                }
                else {
                    index_image = data.findIndex(function(element){
                        return element == surveyId;
                    })
                    current.textContent = index_image+1
                    getImage(data[index_image])
                }

                btn_prev.onclick = function() {
                    getImage(data[Number(current.textContent)-1])
                }
                btn_next.onclick = function() {
                    getImage(data[Number(current.textContent)-1])
                } 
            }
            else {
                clearInformationVillage();
            }
        });
}

function loadDeclare(id) {
    fetch("/api/map/getHousehold?villageId="+id)
         .then((res) => res.json())
         .then((data) => {
            $("#household-number").html(data.length); 
            data = data.sort(function(a,b) { return a.householdId - b.householdId})
            var html="";
            for(var i = 0; i < data.length; i++) {
                html += `
                    <div class="household-record" style="align-items: center; justify-content: space-between;">
                        <div style="display: flex; gap: 30px;">
                            <div class="household-index-field">${i+1}</div>
                            <div class="household-name-field" style="white-space:nowrap;">${data[i].householdName}</div>
                        </div>
                        <div class="household-info-field" style="flex-shrink: 0;"><a id="${data[i].householdId}" href="#" style="color: white;" class="household-info" >Chi tiết >></a> </div>
                    </div>
                `
            }
            let householdRecord = document.getElementById("household-table")
            householdRecord.innerHTML = html

            //Xem khai báo chi tiết của household
            detail = document.querySelectorAll(".household-info");
            for(var i=0; i<detail.length; i++) {
                detail[i].onclick = function(e) {
                    var html = "";
                    var id = $(e.srcElement || e.target).attr('id')
                    getQuestionList(id)
                    $('#staticModal3').modal();
                }
            }
        });
}

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
            var quantity = 0;
            $("#noti-dropdown").empty();
            data.map(function(item) {
                //console.log(item);
                if(item.seen === false) quantity++;
                dateTime = changeFormatDateTime(item.date)
                id_name = item.villageName.replaceAll(' ', '-');
                $("#noti-dropdown").append(`
                    <div class="notifi__item" id=${item.villageId + "," + item.surveyId + "," + id_name + "," + item.seen}>
                        <div class="content">
                            <p ${(item.seen === false ? 'style="font-weight: bold"' : "" )}>Cảnh báo ô nhiễm tại ${item.villageName}</p>
                            <span class="date" ${(item.seen === false ? 'style="color: blue"' : "" )}>${dateTime}</span>
                        </div>
                    </div>
                `);
            });
            $("#quantity-noti").empty();
            if(quantity!= 0) $("#quantity-noti").append(quantity)
            else $("#quantity-noti").hide();
            onclickNotification();  
        }
    });
}

function onclickNotification() {
    $('.notifi__item').click(function() {
        $('.noti__item.js-item-menu').removeClass('show-dropdown');

        if($('#earth-filter').prop('checked') || $('#air-filter').prop('checked') || $('#water-filter').prop('checked')) {
            $('#earth-filter').prop('checked', false);
            $('#air-filter').prop('checked', false);
            $('#water-filter').prop('checked', false);
            loadAllMarker();
        }
        idItem = $(this).attr('id').split(',');
        //console.log(idItem);
        villageId = idItem[0];
        surveyId  = idItem[1];
        villageName = idItem[2].replaceAll('-', ' ');
        checked = idItem[3];

        loadVillageInformation(villageId, villageName)
        loadDeclare(villageId)
        //console.log(typeof(villageId));
        loadImage(villageId, surveyId)
        
        if(checked !== 'true'){
            $.ajax({
                type: "PUT",
                url: "/craftvillage/api/notification?id="+surveyId,
                success: function(result){
                    if(result == true){
                        loadNotification();
                    }
                }
            });
        }
    })
}

function changeFormatDateTime(input) {
    var dateTime = new Date(input);
    var hours = ("0" + dateTime.getHours()).slice(-2);
    var minutes = ("0" + dateTime.getMinutes()).slice(-2);
    var day = ("0" + dateTime.getDate()).slice(-2);
    var month = ("0" + (dateTime.getMonth() + 1)).slice(-2);
    var year = dateTime.getFullYear();

    var newFormat = hours + ":" + minutes + " " + day + "/" + month + "/" + year;

    return newFormat;
}