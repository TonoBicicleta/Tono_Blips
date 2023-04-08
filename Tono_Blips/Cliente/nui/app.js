//
// Ugly code yikes
//
$(function() {
  const url = 'https://Tono_Blips/';
  let started = false;

  function display(bool) {
    if (bool) {
      $("#container").show();
      return;
    }
    $("#container").hide();
  }

  function display2(bool) {
    if (bool) {
      $("#contenedor").show();
      return;
    }
    $("#contenedor").hide();
  }

  function display3(bool) {
    if (bool) {
      $("#contenedorLanco").show();
      return;
    }
    $("#contenedorLanco").hide();
  }

  function filterPhotos(searchText) {
    const photos = document.querySelectorAll('.photo-wrapper');
    photos.forEach(function (photoWrapper) {
      const photoName = photoWrapper.querySelector('.photo-alt').textContent;
      if (photoName.toLowerCase().includes(searchText.toLowerCase())) {
        photoWrapper.style.display = 'block';
      } else {
        photoWrapper.style.display = 'none';
      }
    });
  }

  function filterColors(searchText) {
    const colors = document.querySelectorAll('.color-wrapper');
    colors.forEach(function (colorWrapper) {
      const colorName = colorWrapper.querySelector('.color-name').textContent;
      if (colorName.toLowerCase().includes(searchText.toLowerCase())) {
        colorWrapper.style.display = 'inline-block';
      } else {
        colorWrapper.style.display = 'none';
      }
    });
  }

  display(false);
  display2(false);
  display3(false);
  inputicon = null;
  inputcolor = null;

  window.addEventListener('message', function(event) {
    const item = event.data;
    if (item.type === "ui") {
      if (item.status == true) {
        display(true);
      } else {
        display(false);
      }
    } else if (item.type === "table_data") {
      const tableData = JSON.parse(item.tableData);
      if (Array.isArray(tableData)) {
        $("#table-body").empty();
        for (let i = 0; i < tableData.length; i++) {
          const row = $("<tr>");
          const id = $("<td>").append($("<h1>").text(tableData[i].id));
          const name = $("<td>").append($("<h1>").text('Name: ' + tableData[i].name));
          const deleteBtn = $("<td>").html('<button class="btn-secon">Delete</button>');
          const TeleportBtn = $("<td>").html('<button class="btn-primary">Teleport</button>');

          deleteBtn.click(function(event) {
            if ($(event.target).is('button')) { 
              return $.post(`${url}Borrar`, JSON.stringify({
                id: tableData[i].id,
                nombre: tableData[i].name
              }));
            }
          });

          TeleportBtn.click(function(event) {
            if ($(event.target).is('button')) {
              return $.post(`${url}Tele`, JSON.stringify({
                x: tableData[i].x,
                y: tableData[i].y
              }));
            }
          });

          row.append(id, name, deleteBtn, TeleportBtn); 
          $("#table-body").append(row);
        }
      } else {
        console.log('Invalid table data:', tableData);
      }
      
    }
  });

  $("#trasladar").click(function (event) {
    if ($(event.target).is('button')) {
      display(false);
      display2(true);
    }
  });

  $("#trasladarcolor").click(function (event) {
    if ($(event.target).is('button')) {
      display(false);
      display3(true);
    }
  });

  $("#trasladarmenuprincolor").click(function (event) {
    if ($(event.target).is('button')) {
      display(true);
      display3(false);
    }
  });

  $("#trasladar2").click(function (event) {
    if ($(event.target).is('button')) {
      display(true);
      display2(false);
    }
  });
  
  $("#search-bar").on('input', function() {
    const searchText = $(this).val();
    filterPhotos(searchText);
  });
  
  $("#search-bar-color").on('input', function () {
    const searchText = $(this).val();
    filterColors(searchText);
  });

  window.addEventListener('message', function(event) {
    if (event.data.type === "ui_blips") {
      if (event.status == true) {
        display2(true);
      } else {
        display2(false);
      }
    } else if (event.data.type === 'photo_data') {
      console.log('Received photo data:', event.data.tableData);
      const photosData = JSON.parse(event.data.tableData);
      const photosContainer = document.getElementById('photos-container');
  

      photosContainer.innerHTML = '';
  

      for (const photo of photosData) {

        const photoWrapper = document.createElement('div');
        photoWrapper.className = 'photo-wrapper';

      
        const imgElement = document.createElement('img');
        imgElement.src = 'blips/' + photo.src;
        imgElement.alt = photo.name;
        imgElement.className = 'photo';


        imgElement.addEventListener('click', function() {
          console.log('Selected photo:', photo.id);
          display(true);
          display2(false);
          inputicon = photo.id;
        });


        const photoIdElement = document.createElement('span');
        photoIdElement.className = 'photo-id';
        photoIdElement.textContent = 'ID: ' + photo.id;

    
        const photoAltElement = document.createElement('span');
        photoAltElement.className = 'photo-alt';
        photoAltElement.textContent = photo.name;

   
        photoWrapper.appendChild(imgElement);
        photoWrapper.appendChild(photoIdElement);
        photoWrapper.appendChild(photoAltElement);

   
        photosContainer.appendChild(photoWrapper);
      }

    }
  });

  window.addEventListener('message', function (event) {
    if (event.data.type === "ui_colors") {
      if (event.status == true) {
        display3(true);
      } else {
        display3(false);
      }
    } else if (event.data.type === 'color_data') {
      console.log('Received color data:', event.data.tableData);
      const colorsData = JSON.parse(event.data.tableData);
      const colorsContainer = document.getElementById('colors-container');
  
   
      colorsContainer.innerHTML = '';
  

      for (const color of colorsData) {

        const colorWrapper = document.createElement('div');
        colorWrapper.className = 'color-wrapper';
  

        const colorContent = document.createElement('div');
        colorContent.className = 'color-content';
  

        const circleElement = document.createElement('div');
        circleElement.className = 'circle';
        circleElement.style.backgroundColor = color.color;

  
        circleElement.addEventListener('click', function () {
          console.log('Selected color:', color.id);
          display(true);
          display3(false);
          inputcolor = color.id;
        });
  
        const colorIdElement = document.createElement('span');
        colorIdElement.className = 'color-id';
        colorIdElement.textContent = 'ID: ' + color.id;
  

        const colorNameElement = document.createElement('span');
        colorNameElement.className = 'color-name';
        colorNameElement.textContent = color.name;
  

        colorContent.appendChild(circleElement);
        colorContent.appendChild(colorIdElement);
        colorContent.appendChild(colorNameElement);
  

        colorWrapper.appendChild(colorContent);
  

        colorsContainer.appendChild(colorWrapper);
      }
    }
  });
  


  $("#crear").click(function (event) {
    event.preventDefault(); 
    let inputValue = $("#input").val();
    let inputsize = $("#inputsize").val();
    if (inputValue.length > 10) {
        return $.post(`${url}error`, JSON.stringify({}));
    } else if (inputsize.length > 3) {
      return $.post(`${url}error2`, JSON.stringify({}));
    } else if (!inputsize) {
      return $.post(`${url}error2`, JSON.stringify({}));
    } else if (!inputicon) {
      return $.post(`${url}error3`, JSON.stringify({}));
    } else if (!inputcolor) {
      return $.post(`${url}error4`, JSON.stringify({}));
    } else if (!inputValue) {
      return $.post(`${url}error`, JSON.stringify({}));
    } else if (!inputsize.toString().includes('.')) {
      inputsizedecimal = inputsize + '.0';
    }    

    let size = Number(inputsize);
    if (size === Math.floor(size)) {
      size += 0.0001;
    }

    return $.post(`${url}crear`, JSON.stringify({
        nombre: inputValue,
        size: size,
        sprite: Number(inputicon),
        color: Number(inputcolor)
    }));
});



  document.onkeyup = function(data) {
    if (data.which == 27) {
      return $.post(`${url}exit`, JSON.stringify({}));
    }
  };

  $("#close").click(function(data) {
    return $.post(`${url}exit`, JSON.stringify({}));
  });
});
