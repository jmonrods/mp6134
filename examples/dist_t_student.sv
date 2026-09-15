class tdist;

  int seed = 4821;
  int degree_of_freedom = 1;
  rand int value;

  function int t_dist();
    return $dist_t(seed, degree_of_freedom);
  endfunction

  constraint c_value { value == t_dist(); }

endclass

module dist_t_student;
    
    tdist t1;
    initial begin
        t1 = new();
        for (int i = 0 ; i < 1000 ; i++) begin
            t1.randomize();
            $display("%0d", t1.value);
        end
        $finish();
    end
endmodule
