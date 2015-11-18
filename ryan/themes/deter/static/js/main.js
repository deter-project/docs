function navItemClick(addr) {
  var s = addr.substring(1);
  document.getElementById("content").innerHTML =
    '<object style="present" type="text/html" data="'+s+'" ></object>';

  window.location.href = "#"+addr;
}

var reload_origin = true;
function doLoad() {
  console.log("loading");
  var sp = window.location.href.split("#");
  if(sp.length > 1) {
    navItemClick(sp[1]);
  }
  else {
    document.getElementById("content").innerHTML =
      '<img id="content_logo" src="img/DETER_logotype_White.png" />'
  }
}
