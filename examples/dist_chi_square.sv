class chidist;

  int seed = 4821;
  int degree_of_freedom = 5;
  rand int value;

  function int chi_sq_dist();
    return $dist_chi_square( seed, degree_of_freedom);
  endfunction

  constraint c_value { value == chi_sq_dist(); }

endclass

module dist_chi_square;
    
    chidist c1;
    initial begin
        c1 = new();
        for (int i = 0 ; i < 1000 ; i++) begin
            c1.randomize();
            $display("%0d", c1.value);
        end
        $finish();
    end
endmodule
