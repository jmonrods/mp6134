class gdist;

  int seed = 4821;
  rand int mean;
  rand int std_deviation;
  rand int value;

  function int gaussian_dist();
    return $dist_normal( seed, mean, std_deviation );
  endfunction

  constraint c_parameters {
    mean == 4000;
    std_deviation == 40;
  }

  constraint c_value { value == gaussian_dist(); }

endclass

module dist_gaussian;
    
    gdist g1;
    initial begin
        g1 = new();
        for (int i = 0 ; i < 1000 ; i++) begin
            g1.randomize();
            $display("%0d", g1.value);
        end
        $finish();
    end
endmodule
