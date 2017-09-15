---
---
/* Author:
            Matthew Ruten, 2012
   Modifications by Terry Chen on behalf of CSEC, 2017
*/

(function() {
  var CELL_ALIVE = 1, CELL_DEAD = 0;

  window.GameOfLife = (function() {
    // User-set params
    var cell_array,
        display,
        nextGenCells,
        interval = null;    // Will store reference to setInterval method -- this should maybe be part of GameDisplay

    function GameOfLife(params) {
      // Convert init_cells array of 0's and 1's to actual Cell objects
      var length_y,
          length_x,
          y, x;

      var num_cells_y = params["init_cells"].length,
          num_cells_x = params["init_cells"][0].length,
          cell_width  = params["cell_width"]  || 10,
          cell_height = params["cell_height"] || 10,
          init_cells  = params["init_cells"]  || [],
          canvas_id   = params["canvas_id"]   || "life",
          colourful   = params["colourful"] || params["colorful"] || false;

      length_y = init_cells.length;
      display  = new GameDisplay(num_cells_x, num_cells_y, cell_width, cell_height, canvas_id, colourful);

      // each row
      for (y = 0; y < length_y; y++) {
        length_x = init_cells[y].length;
        // each column in rows
        for (x = 0; x < length_x; x++) {
          var state = init_cells[y][x];
          init_cells[y][x] = new Cell(x, y, state);
        }
      }

      cell_array = init_cells;
      display.update(cell_array);

      // Function to calculate the next generation of cells, based
      //  on the rules of the Game of Life
      nextGenCells = function() {
        // Implement the Game of Life rules
        // Simple algorithm:
        //  - For each cell:
        //      - Check all of its neighbours
        //      - Based on the rules, set the next gen cell to alive or dead

        var current_gen = cell_array,
            next_gen = current_gen.map(function (a) { return new Array(a.length) }),      // New array to hold the next gen cells
            length_y = cell_array.length,
            length_x = cell_array[0].length,
            y, x;

        // each row
        for (y = 0; y < length_y; y++) {
          // each column in rows
          for (x = 0; x < length_x; x++) {
            //var state = (init_cells[y][x] == 1) ? CELL_ALIVE : CELL_DEAD;
            var cell = current_gen[y][x];
            // Calculate above/below/left/right row/column values
            var row_above = (y-1 >= 0) ? y-1 : length_y-1; // If current cell is on first row, cell "above" is the last row (stitched)
            var row_below = (y+1 <= length_y-1) ? y+1 : 0; // If current cell is in last row, then cell "below" is the first row
            var column_left = (x-1 >= 0) ? x-1 : length_x - 1; // If current cell is on first row, then left cell is the last row
            var column_right = (x+1 <= length_x-1) ? x+1 : 0; // If current cell is on last row, then right cell is in the first row

            var alive_count = current_gen[row_above][column_left].getState() +
              current_gen[row_above][x].getState() +
              current_gen[row_above][column_right].getState() +
              current_gen[y][column_left].getState() +
              current_gen[y][column_right].getState() +
              current_gen[row_below][column_left].getState() +
              current_gen[row_below][x].getState() +
              current_gen[row_below][column_right].getState();

            // Set new state to current state, but it may change below
            var new_state = cell.getState();

            if (alive_count === 3 ||
                (new_state == CELL_ALIVE && alive_count === 2)) {
              new_state = CELL_ALIVE;
            } else {
              // new state: dead, overpopulation/ underpopulation
              new_state = CELL_DEAD;
            }

            //console.log("Cell at x,y: " + x + "," + y + " has dead_count: " + dead_count + "and alive_count: " + alive_count);

            next_gen[y][x] = new Cell(x, y, new_state);
            //console.log(next_gen[y][x]);
          }
        }
        //console.log(next_gen);
  /*
        next_gen = cell_array;
        next_gen[0][0].setState(CELL_DEAD);
        next_gen[0][1].setState(CELL_ALIVE);
        next_gen[1][0].setState(CELL_ALIVE);
        next_gen[1][1].setState(CELL_DEAD);
  */
        return next_gen;
      };
    };

    // Returns the next generation array of cells
    GameOfLife.prototype.step = function() {
      var next_gen = nextGenCells();
      // Set next gen as current cell array
      cell_array = next_gen;
      //console.log(next_gen);
      display.update(cell_array);
    };

    // Returns the current generation array of cells
    GameOfLife.prototype.getCurrentGenCells = function() {
      return cell_array;
    };

    // Add "The" to function name to reduce confusion
    //  (even though we *could* technically use just setInterval)
    GameOfLife.prototype.setTheInterval = function(the_interval) {
      interval = the_interval;
    };

    GameOfLife.prototype.getInterval = function() {
      return interval;
    }

    return GameOfLife;
  })();

  // This is an object that will take care of all display-related features.
  // Theoretically, you should be able to use any method of display without
  // too much extra code. i.e. if you want to display the game using HTML tables,
  // svg, or whatever other method you feel like. Just create a new <___>Display
  // Object!
  //
  // Modified to use SVG instead of canvas
  var GameDisplay = (function() {
    var drawGridLines,
        updateCells,
        drawCell;

    function GameDisplay(num_cells_x, num_cells_y, cell_width, cell_height, canvas_id, colourful, cell_array) {
      var canvas = document.getElementById(canvas_id),
          ctx = canvas.getContext('2d'),
          width_pixels = num_cells_x * cell_width,
          height_pixels = num_cells_y * cell_height;
      //console.log("width_pixels: " + width_pixels);
      //console.log("height_pixels: " + height_pixels);

      // Encapsulate cell array
      this.cell_array = cell_array;

      // Set fill style
      ctx.fillStyle = APP.currentTheme === 'light' ? '#c0bbbb' : '#4d4444';

      // Re-init factory on theme change
      window.addEventListener("changetheme", function() {
        ctx.fillStyle = APP.currentTheme === 'light' ? '#c0bbbb' : '#4d4444';
        updateCells(true);
      }, false);

      // Fcn definitions

      updateCells = function(flush, cell_array) {
        var length_y, length_x,
            y, x;

        if (cell_array != null && cell_array != undefined) {
          this.cell_array = cell_array;
        }

        length_y = this.cell_array.length;
        length_x = this.cell_array[0].length;

        // each row
        for (y = 0; y < length_y; y++) {
          // each column in rows
          for (x = 0; x < length_x; x++) {
            // Draw Cell on Canvas
            drawCell(this.cell_array[y][x], flush);
          }
        }
      };

      drawCell = function(cell, flush) {
        // find start point (top left)
        var start_x = cell.getXPos() * cell_width,
            start_y = cell.getYPos() * cell_height;

        if (cell.getState() == CELL_ALIVE || (cell.getState() == CELL_ALIVE && flush)) {
          ctx.fillRect(start_x, start_y, cell_width, cell_height);
        } else if (cell.getState() == CELL_DEAD) {
          ctx.clearRect(start_x, start_y, cell_width, cell_height);
        }
      };
    };

    GameDisplay.prototype.update = function(cell_array) {
      updateCells(false, cell_array);
    };

    return GameDisplay;
  })();

  var Cell = (function() {
    //console.log("Creating cell at " + x_pos + "," + y_pos + ", and cell state is: " + state);
    /*var x_pos = 0,        // X Position of Cell in Grid
        y_pos = 0,        // Y position of cell in Grid
        state = CELL_DEAD,   // Cell state: dead or alive.
        asdf;*/
    function Cell(x_pos, y_pos, state) {
      this.x_pos = x_pos;
      this.y_pos = y_pos;
      this.state = state;
    }

    Cell.prototype.getXPos = function() {
      return this.x_pos;
    };

    Cell.prototype.getYPos = function() {
      return this.y_pos;
    };

    Cell.prototype.getState = function() {
      return this.state;
    };

    Cell.prototype.setState = function(new_state) {
      this.state = new_state;
    };

    return Cell;
  })();
})();
