var mapMarkers = [];
var markers = {};
var myIcon = L.icon({
	iconUrl: "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|e85141&chf=a,s,ee00FFFF",
	iconSize: [21, 34],
})
var myIcon_temp = L.icon({
	iconUrl: "https://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|0B08DF&chf=a,s,ee00FFFF",
	iconSize: [21, 34],
})
var switchAllOnOff = [];

//use for click on map
var point_index = -1; //để chạy trên map
var point_index_temp = -1; //để so sánh khi click sang làng khác
var marker_temp = {};
var point_marker_temp = {};
var lat_temp = 0;
var lon_temp = 0;

var map;    
// var markers = [];
$( document ).ready(function(){
	loadMap()
});

	
function loadMap() {
	fetch("/api/map/getVillageLocation")
		.then((res) => res.json())
		.then((data) => {      
		var coordinate = data.districtCoordinate.split(",")
		map = L.map('map').setView([+coordinate[0], +coordinate[1]], 13); //CL
			L.tileLayer('https://api.maptiler.com/maps/bright/256/{z}/{x}/{y}.png?key=Xx2LVdpWdk1UyVYRKzN0',{
			tileSize: 512,
			zoomOffset: -1,
			minZoom: 1,
			attribution: "\u003ca href=\"https://www.maptiler.com/copyright/\" target=\"_blank\"\u003e\u0026copy; MapTiler\u003c/a\u003e \u003ca href=\"https://www.openstreetmap.org/copyright\" target=\"_blank\"\u003e\u0026copy; OpenStreetMap contributors\u003c/a\u003e",
			crossOrigin: true
		}).addTo(map); 
		loadAllMarker();
		switchChildHandler();
		villageClickHandler();
		switchAllHandler();     
	});
}

function clearVillageInformation(){
	$("#villageName").val("");
	$("#longitude").val("");
	$("#latitude").val("");
	$("#note").val("");
}

function switchChildHandler(){
	//thiết lập cho từng thành phần con
	$(".switch-child").click(function() {
		index = $(this).attr("index")
		let checked = $(this).is(":checked")
		if(checked == true) {
			switchAllOnOff[index] = 1;
			if(!switchAllOnOff.includes(0)) document.getElementById("switch-all").checked = true;
			let coordinate = villages[index].coordinate.split(", ");
			markers[villages[index].villageId] = L.marker([+coordinate[0], +coordinate[1]], {
				icon: myIcon,
			}).addTo(map)
			markers[villages[index].villageId].bindPopup(villages[index].villageName)
					markers[villages[index].villageId].on('mouseover', function(e){
						this.openPopup();
			});
			markers[villages[index].villageId].on('mouseout', function(e){
				this.closePopup();
			});
			//mapMarkers.push(villages[index].villageId)
		}
		else {
			map.removeLayer(markers[mapMarkers[index]])
			//tắt chọn tất cả
			if (!$('#list-village-header').is(':empty')){
				document.getElementById("switch-all").checked = false;	
			}
			//đổi trạng tháng phường trong biến switchAllOnOff
			switchAllOnOff[index] = 0;
		}
	});
}

var index;

function removeAllMarker() {
	for(let i = 0; i < mapMarkers.length; i++)
		if(map.hasLayer(markers[mapMarkers[i]])) {
			map.removeLayer(markers[mapMarkers[i]])
			switchAllOnOff[i] = 0;
		}
}

function loadAllMarker() {
	$("#list-village-header").empty();
	$('#list-village-body').empty();
	mapMarkers = [];
	markers = {};
	switchAllOnOff = [];
	$("#list-village-header").append(`
		<div class="list-village-header" >
			<label style="font-size: 20px; margin: 0; color: #4272d7;">Chọn tất cả</label>
			<label class="switch switch-3d switch-primary mr-3" style="margin: auto;">
				<input id="switch-all" type="checkbox" class="switch-input" checked>
				<span class="switch-label"></span>
				<span class="switch-handle"></span>
			</label>
		</div>
	`)

	for (let i=0; i < villages.length; i++) {
		$("#list-village-body").append(`
			<div class="village-tag" index="${i}">
				<span class="village-field-name">${villages[i].villageName}</span>
				<label class="switch switch-3d switch-primary mr-3" style="margin: auto;">
				  <input id="child-switch-${i}" type="checkbox" class="switch-input switch-child" checked="true" index="${i}">
				  <span class="switch-label"></span>
				  <span class="switch-handle"></span>
				</label>
			</div>
		`);

		//mapMarkers.push(villages[i].villageId)

		//mảng check alll
		switchAllOnOff.push(1);

		let coordinate = villages[i].coordinate.split(", ");
		markers[villages[i].villageId] = L.marker([+coordinate[0], +coordinate[1]], {
			icon: myIcon,
		}).addTo(map)
		
		mapMarkers.push(villages[i].villageId)
		markers[villages[i].villageId]._icon.id = villages[i].villageId + ", " + villages[i].villageName;
		//popup
		markers[villages[i].villageId].bindPopup(villages[i].villageName)

		markers[villages[i].villageId].on('mouseover', function(e){
			this.openPopup();

		});
		markers[villages[i].villageId].on('mouseout', function(e){
			this.closePopup();
		});
	}
	let check_test = $("#switch-all").prop("checked");
	if(check_test === false) $("#switch-all").prop("checked", true);
}

function villageClickHandler(){
	$(".village-tag").click(function(){
		point_index = point_index_temp
		//ban đầu
		index = $(this).attr("index");
		let coordinate = villages[index].coordinate.split(", ");
		$("#ward").val(villages[index].wardId);
		$("#villageName").val(villages[index].villageName);
		$("#longitude").val(coordinate[1]);
		$("#latitude").val(coordinate[0]);
		$("#note").val(villages[index].note);
		// if(villages[index].state[0] === '1') $('#earth').prop('checked', true); else $('#earth').prop('checked', false);
		// if(villages[index].state[1] === '1') $('#air').prop('checked', true); else $('#air').prop('checked', false);
		// if(villages[index].state[2] === '1') $('#water').prop('checked', true); else $('#water').prop('checked', false);
		point_index_temp = index;

		//khi chưa click nào cả
		if(point_index == -1) {
			point_index = point_index_temp
		}
		else {
			//xóa marker tạm nếu có
			if(map.hasLayer(point_marker_temp)) {
				map.removeLayer(point_marker_temp);
				//Hiện lại village cũ
				let old_coordinate = villages[point_index].coordinate.split(", ")
				//Tạo lại marker cho village cũ
				markers[villages[point_index].villageId] = L.marker([+old_coordinate[0], +old_coordinate[1]], {icon: myIcon, }).addTo(map)
				//Thiết lập lại popup cho village cũ
				markers[villages[point_index].villageId].bindPopup(villages[point_index].villageName)

				markers[villages[point_index].villageId].on('mouseover', function(e){
					this.openPopup();

				});
				markers[villages[point_index].villageId].on('mouseout', function(e){
					this.closePopup();
				});
			}

			//Thiết lập point index_mới
			point_index = point_index_temp
		}

		//click vào map thay đổi tạo độ cho làng
		map.on('click', function(e) {
			//remove marker hiện tại của villages khi onclick vào map							
			if(map.hasLayer(markers[mapMarkers[point_index]]) || map.hasLayer(point_marker_temp)){
				map.removeLayer(markers[mapMarkers[point_index]]);
				//Lấy lat lon khi click vào map và hiện ra ở phần update
				lat_temp = e.latlng.lat;
				lon_temp = e.latlng.lng;

				marker_temp = L.marker([lat_temp, lon_temp], {icon: myIcon_temp,})

				//tạo marker tạm trên map
				if(map.hasLayer(point_marker_temp))
					map.removeLayer(point_marker_temp);
				
				point_marker_temp = marker_temp.addTo(map);

				//thay đổi tạo độ theo marker temp
				$("#longitude").val(lon_temp);
				$("#latitude").val(lat_temp);
			}
			else {
				return; //alert("Bạn cần phải hiện làng trên map trước")
			}
		})
	});
}
	
	
$("#btn-update").click(function(){
	//validate
	if(point_index==-1) return alert("Bạn chưa chọn làng nghề");
	
	if($("#villageName").val().trim()=="" || $("#latitude").val().trim()=="" || $("#longitude").val().trim()==""){
		return alert("Vui lòng điền đầy đủ thông tin")
	}
	
	//Gởi cập nhật về cho DB
	data = {}
	data.villageId   = villages[point_index].villageId;
	data.wardId      = Number($("#ward").val());
	data.note        = $("#note").val().trim();		
	data.longitude   = $("#longitude").val().trim();
	data.latitude	= $("#latitude").val().trim();
	data.villageName = $("#villageName").val().trim();
	// let state = "";
	// if($('#earth').is(':checked')){
	// 	state += "1";
	// }
	// else {
	// 	state += "0";
	// }
	// if($('#air').is(':checked')){
	// 	state += "1";
	// }
	// else {
	// 	state += "0";
	// }
	// if($('#water').is(':checked')){
	// 	state += "1";
	// }
	// else {
	// 	state += "0";
	// }
	// data.state = state;
	data = JSON.stringify(data);

	$.ajax({
		type: "POST",
		contentType: "application/json; charset=utf-8",
		url: "/craftvillage/api/village/update",
		data: data,
		success: function(data){
			if(!data){
				alert("Phát hiện lỗi!")
			}
			else{
				//Cập nhật cho mảng
				villages[point_index].wardId = Number($("#ward").val());
				villages[point_index].villageName = $("#villageName").val();
				villages[point_index].coordinate = $("#latitude").val() + ", " + $("#longitude").val();
				villages[point_index].note = $("#note").val();
				//villages[point_index].state = state;

				//đặt thành marker chính khi update thành công
				if(map.hasLayer(point_marker_temp)) {
					map.removeLayer(point_marker_temp)
					markers[villages[point_index].villageId] = L.marker([lat_temp, lon_temp], {icon: myIcon, }).addTo(map)
					markers[villages[point_index].villageId].bindPopup(villages[point_index].villageName)
					markers[villages[point_index].villageId].on('mouseover', function(e){
						this.openPopup();

					});
					markers[villages[point_index].villageId].on('mouseout', function(e){
						this.closePopup();
					});
					}
					alert("Yêu cầu đã được gửi")
			}
		}
	});
});

function switchAllHandler() {
	$("#switch-all").click(function(){
		clearVillageInformation();
		let checked = $(this).is(":checked");
		//set switch
		$.each($(".switch-input"), function(index, value) {
			value.checked = checked;
		});
		//create marker if true
		if(checked == true) {
			//mapMarkers = [];			
			for(let i=0; i < villages.length; i++) {
				if(!map.hasLayer(markers[mapMarkers[i]])) {
					let coordinate = villages[i].coordinate.split(", ");
					if(!map.hasLayer(markers[mapMarkers[i]])) {
						markers[villages[i].villageId] = L.marker([+coordinate[0], +coordinate[1]], {
							icon: myIcon,
						}).addTo(map);
						markers[villages[i].villageId].bindPopup(villages[i].villageName)
						markers[villages[i].villageId].on('mouseover', function(e){
							this.openPopup();

						});
						markers[villages[i].villageId].on('mouseout', function(e){
							this.closePopup();
						});
					}
					switchAllOnOff[i] = 1;	
				}		
				//mapMarkers.push(villages[i].villageId)
			}

		}
		else{
			for(let i=0; i<mapMarkers.length; i++){
				map.removeLayer(markers[mapMarkers[i]])
				switchAllOnOff[i] = 0;
			}	
		}
	});
}

function searchVillages(query) {
	var filteredVillages = [];
	// villages.filter(function(village, index) {
	// 	return village.villageName.toLowerCase().indexOf(query.toLowerCase()) > -1;
	// });

	removeAllMarker();

	//bỏ nút chọn tất cả
	$("#list-village-header").empty();

	for(let i=0; i<villages.length; i++) {
		if(villages[i].villageName.toLowerCase().includes(query.toLowerCase())) {
			filteredVillages[i] = villages[i];
		}
		else {
			filteredVillages[i] = "null";
		}
	}

	// display the filtered villages
	$('#list-village-body').empty();
	filteredVillages.forEach(function(village, index) {
		if(village !== 'null'){
			$('#list-village-body').append(`
				<div class="village-tag" index="${index}">
				<span class="village-field-name">${village.villageName}</span>
				<label class="switch switch-3d switch-primary mr-3" style="margin: auto;">
					<input id="child-switch-${index}" type="checkbox" class="switch-input switch-child" checked="true" index="${index}">
					<span class="switch-label"></span>
					<span class="switch-handle"></span>
				</label>
				</div>
			`);
			// taoj laji marker
			switchAllOnOff[index] = 1;
			let coordinate = villages[index].coordinate.split(", ");
			markers[villages[index].villageId] = L.marker([+coordinate[0], +coordinate[1]], {
				icon: myIcon,
			}).addTo(map)
			markers[villages[index].villageId]._icon.id = villages[index].villageId + ", " + villages[index].villageName;
			markers[villages[index].villageId].bindPopup(villages[index].villageName)
					markers[villages[index].villageId].on('mouseover', function(e){
						this.openPopup();
			});
			markers[villages[index].villageId].on('mouseout', function(e){
				this.closePopup();
			});
		}		
	});
  }
  
  $('#search-input').on('input change', function() {
	var query = $(this).val();
	if(query == ""){
		removeAllMarker();
		loadAllMarker();
		switchChildHandler();
		villageClickHandler();
		switchAllHandler();
		return;
	}
	searchVillages(query);
	switchChildHandler();
	villageClickHandler();
  });
