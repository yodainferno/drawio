let line_points = []; // сохраненный объект с точками
let canvas; // объект canvas DOM
let line_points_input;
let ctx; // объкт состояния canvas

let previous_x = 0,
    previous_y = 0,
    current_x = 0,
    current_y = 0;
let current_step = 0; // текущий шаг рисования (для возврата назад)

let flag = 0; // 0 - не рисуем, 1 - рисуем, 2 -вышли за пределы холста

let line_color = "#000"; // цвет линии по умолчанию
let line_width = 3; // толщина линии по умолчанию

function set_line_points_input_value() {
    line_points_input.value = JSON.stringify(line_points);
}

// инициализация прослушки событий
function init() {
    previous_x = previous_y = current_x = current_y = current_step = flag = 0; 
    
    document.getElementById('change_color').value = line_color;
    document.getElementById('line_height').value = line_width;

    // инициализация переменных
    canvas = document.getElementById('canvas');
    line_points_input = document.getElementById('line_points');

    ctx = canvas.getContext("2d");
    canvas.setAttribute('width', '800px');
    canvas.setAttribute('height', '500px');

    line_points = JSON.parse(line_points_input.value);
    redraw();
    
    // инициализация событий
    canvas.addEventListener("mousemove", function (e) {
        canvas_event('move', e)
    }, false);
    canvas.addEventListener("mousedown", function (e) {
        canvas_event('down', e)
    }, false);
    document.addEventListener("mouseup", function (e) {
        canvas_event('up', e)
    }, false);
    canvas.addEventListener("mouseout", function (e) {
        canvas_event('out', e)
    }, false);


    document.getElementById('clear_button').onclick = function() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        line_points = [];
        set_line_points_input_value();
    };
    // document.getElementById('redraw_button').onclick = function() {
    //     redraw();
    // };

    document.getElementById('cancel_button').onclick = function() {
        let last_step = line_points[line_points.length-1]['step'];
        let current_paint_idx = line_points.length-1;
        while (current_paint_idx > 0 && line_points[current_paint_idx]['step'] == last_step) {
            line_points.pop();
            current_paint_idx--;
        }
        set_line_points_input_value();
        
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        redraw();
    };
    

    // document.getElementById('save_button').onclick = function() {
    //     // redraw();
    // };
    

    // document.getElementById('download_button').onclick = function() {
    //     document.getElementById("download_button").download = "image.png";
    //     document.getElementById("download_button").href = document.getElementById("canvas").toDataURL("image/png").replace(/^data:image\/[^;]/, 'data:application/octet-stream');
    // };


    document.getElementById('change_color').onchange = function(event) {
        line_color = document.getElementById('change_color').value;
    };

    

    
    document.getElementById('line_height').onchange = function(event) {
        let val = document.getElementById('line_height').value;
        if (val >= 1 && val <= 6) {
            line_width = val;
        }
    };
    
    
}

function draw_and_save() {
    let line_object = {
        from: { // откуда
            x: previous_x,
            y: previous_y
        },
        to: { // куда
            x: current_x,
            y: current_y
        },
        color: line_color, // цвет
        width: line_width, // толщина
        step: current_step // номер линии
    };

    draw_part(line_object); // отрисовать
    line_points.push(line_object); // сохранить часть в массив
    set_line_points_input_value();
}

function redraw() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    for (let i = 0; i < line_points.length; i++) {
        let ppp = line_points[i];
        draw_part(ppp);
    }
    set_line_points_input_value();
}

// отрисовать часть линии

function draw_part(object) {
    ctx.beginPath(); // начать

    ctx.moveTo(object['from']['x'], object['from']['y']); // линия от
    ctx.lineTo(object['to']['x'], object['to']['y']); // линия до

    // настройки лининии
    ctx.strokeStyle = object['color'];
    ctx.lineWidth = object['width'];

    ctx.stroke(); // отрисовать линию
    ctx.closePath(); // завершить отрисовку
}

// 
function canvas_event(event_type, e) {
    if (event_type == 'down') {
        previous_x = current_x;
        previous_y = current_y;
        
        current_x = (event.clientX - canvas.offsetLeft);
        current_y = (event.clientY - canvas.offsetTop + window.pageYOffset);
        
        flag = 1;
        current_step++;          
    }
    if (event_type == 'up') {
        flag = 0;
    }
    if (event_type == "out") {
        if (flag == 1) {
            flag = 2;
        } else {
            flag = 0;
        }
    }
    if (event_type == 'move') {
        if (flag == 2) {
            current_step++;          

            current_x = (event.clientX - canvas.offsetLeft);
            current_y = (event.clientY - canvas.offsetTop + window.pageYOffset);

            flag = 1;
        }
        if (flag == 1) {
            previous_x = current_x;
            previous_y = current_y;
            current_x = e.clientX - canvas.offsetLeft;
            current_y = e.clientY - canvas.offsetTop + window.pageYOffset;
            
            draw_and_save();
        }
    }
}