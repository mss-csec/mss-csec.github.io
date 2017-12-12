
/*
Author: Joshua Hogendorn, (c) 2011
Modifications by Terry Chen on behalf of MSS CSEC, 2017
 */

(function() {
  var GameOfLife;

  GameOfLife = (function() {
    GameOfLife.prototype.canvas = null;

    GameOfLife.prototype.gen = 0;

    GameOfLife.prototype.genc = [];

    GameOfLife.prototype.history = 5;

    GameOfLife.prototype.seedweight = 0.2;

    GameOfLife.prototype.grid = {
      x: 50,
      y: 50
    };

    GameOfLife.prototype.cell = {
      w: 10,
      h: 10
    };

    function GameOfLife(canvas, seed, opts) {
      this.canvas = canvas.getContext('2d');
      this.genc = seed;
      this.grid = {
        x: seed.length,
        y: seed[0].length
      };
      if (opts.grid != null) {
        this.grid = opts.grid;
      }
      if (opts.cell != null) {
        this.cell = opts.cell;
      }
      this.canvas.fillStyle = APP.currentTheme === 'light' ? '#eeebeb' : '#2d2d35';
    }

    GameOfLife.prototype._countNeighbours = function(x, y) {
      var xm, xp, ym, yp;
      xp = x + 1 > this.grid.x - 1 ? 0 : x + 1;
      xm = x - 1 < 0 ? this.grid.x - 1 : x - 1;
      yp = y + 1 > this.grid.y - 1 ? 0 : y + 1;
      ym = y - 1 < 0 ? this.grid.y - 1 : y - 1;
      return this.genc[xm][ym] + this.genc[x][ym] + this.genc[xp][ym] + this.genc[xm][y] + this.genc[xp][y] + this.genc[xm][yp] + this.genc[x][yp] + this.genc[xp][yp];
    };

    GameOfLife.prototype._getState = function(x, y) {
      var cell, pop;
      cell = this.genc[x][y];
      pop = this._countNeighbours(x, y);
      if (pop === 3 || (pop === 2 && cell)) {
        return true;
      }
      return false;
    };

    GameOfLife.prototype.runGeneration = function() {
      var x, y;
      this.genc = (function() {
        var i, ref, results;
        results = [];
        for (x = i = 0, ref = this.grid.x; 0 <= ref ? i < ref : i > ref; x = 0 <= ref ? ++i : --i) {
          results.push((function() {
            var j, ref1, results1;
            results1 = [];
            for (y = j = 0, ref1 = this.grid.y; 0 <= ref1 ? j < ref1 : j > ref1; y = 0 <= ref1 ? ++j : --j) {
              results1.push(this._getState(x, y));
            }
            return results1;
          }).call(this));
        }
        return results;
      }).call(this);
      return this.gen++;
    };

    GameOfLife.prototype.render = function() {
      var i, j, ref, ref1, x, y;
      for (x = i = 0, ref = this.grid.x; 0 <= ref ? i < ref : i > ref; x = 0 <= ref ? ++i : --i) {
        for (y = j = 0, ref1 = this.grid.y; 0 <= ref1 ? j < ref1 : j > ref1; y = 0 <= ref1 ? ++j : --j) {
          if (this.genc[x][y]) {
            this.canvas.fillRect(x * this.cell.w, y * this.cell.h, this.cell.w, this.cell.h);
          } else {
            this.canvas.clearRect(x * this.cell.w, y * this.cell.h, this.cell.w, this.cell.h);
          }
        }
      }
      return true;
    };

    GameOfLife.prototype.changeTheme = function() {
      return this.canvas.fillStyle = APP.currentTheme === 'light' ? '#eeebeb' : '#2d2d35';
    };

    GameOfLife.prototype.step = function() {
      this.runGeneration();
      return this.render();
    };

    return GameOfLife;

  })();

  window.GameOfLife = GameOfLife;

}).call(this);
