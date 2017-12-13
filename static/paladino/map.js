var map = L.map('map').setView([42.885165, -78.874559], 10);

L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
	maxZoom: 19,
	attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
}).addTo(map);


// object -> html string
function popupHtml(prop) {
  return '<p><strong>Address: </strong>' + prop.label.replace(', USA', '') + '</p>' + 
    '<p><strong>Owner Name: </strong>' + prop.owner_name + '</p>';
}

// object -> <CircleMarker>
function marker(prop) {
  L.circleMarker([ prop.lat, prop.lng ], {
    color: '#f6eff7',
    weight: 3,
    opacity: 0.7,
    fillColor: '#1c9099',
    fillOpacity: 0.8
  }).addTo(map)
    .bindPopup(popupHtml(prop));
}

props.forEach(marker);


