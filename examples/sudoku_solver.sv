// Sudoku solver from https://cziesler.github.io/systemverilog/randomization/2023/01/03/sv-sudoku.html

class sudoku #(int M = 3);
  // Number of elements per row/col/block
  localparam N = M*M;

  // Input puzzle
  local int puzzle [N][N];

  // Randomized variable for the solved puzzle
  local rand int row [N][N];
  
  // Constraint to fill in the solved puzzle with non-zero elements of the input
  constraint c_puzzle {
    foreach (puzzle[r,c]) {
      if (puzzle[r][c] != 0) {
        row[r][c] == puzzle[r][c];
      }
    }
  }
  
  // Constraint 1: Value
  constraint c_value {
    foreach (row[r,c]) {
      row[r][c] inside { [1:N] };
    }
  }
      
  // Constraint 2: Row
  constraint c_row {
    foreach (row[r,]) {
      unique { row[r] };
    }
  }
      
  // Constraint 3: Column
  local rand int column [N][N];

  constraint c_row_to_column {
    foreach (row[r,c]) {
      column[c][r] == row[r][c];
    }
  }

  constraint c_column {
    foreach (column[r,]) {
      unique { column[r] };
    }
  }
      
  // Constraint 4: Block
  local rand int block [N][N];

  constraint c_row_to_block {
    foreach (row[r,c]) {
      block[r][c] == row[(r/M)*M+c/M][(r%M)*M+c%M];
    }
  }

  constraint c_block {
    foreach (block[r,]) {
      unique { block[r] };
    }
  }
      
  // Constructor with puzzle passed in
  function new (int puzzle [N][N]);
    this.puzzle = puzzle;
  endfunction : new

  // Print the solved puzzle
  function void print ();
    foreach (row[r,]) begin
      if (r % M == 0) $write("\n");
      foreach (row[,c]) begin
        if (c % M == 0) $write(" ");
        $write("%3d", row[r][c]);
      end
      $write("\n");
    end
  endfunction : print
endclass : sudoku 

program sudoku_solver;
  localparam M = 3, N = M*M;
  int puzzle[N][N];
  
  sudoku #(M) s;
  
  initial begin
    puzzle = '{
      '{ 5,3,0, 0,7,0, 0,0,0 },
      '{ 6,0,0, 1,9,5, 0,0,0 },
      '{ 0,9,8, 0,0,0, 0,6,0 },
      
      '{ 8,0,0, 0,6,0, 0,0,3 },
      '{ 4,0,0, 8,0,3, 0,0,1 },
      '{ 7,0,0, 0,2,0, 0,0,6 },
      
      '{ 0,6,0, 0,0,0, 2,8,0 },
      '{ 0,0,0, 4,1,9, 0,0,5 },
      '{ 0,0,0, 0,8,0, 0,7,9 }
    };
    s = new(puzzle);
    if (s.randomize()) s.print();
    else $display("cannot solve puzzle");
    $finish();
  end
endprogram : sudoku_solver
