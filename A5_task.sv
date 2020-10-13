module A5_task

#( parameter WIDTH = 12 )

(
  input logic                          clk_i, srst_i, 
  
  input logic  [WIDTH-1:0]     data_i,
  
  output logic [WIDTH-1:0]    data_o_left,
  output logic [WIDTH-1:0]    data_o_right
);  

logic [WIDTH-1:0] data_temp, r_flags, l_flags;

int i, j, k, m;

//data lock
always_ff @( posedge clk_i )
  if ( srst_i ) 
    data_temp <= 0;
  else  
    data_temp <= data_i;

// right half
always_comb
  begin
    r_flags     = 0;
    r_flags[0] = data_temp[0];
      for ( i = 1; i < WIDTH; i++ )
        begin
          if ( r_flags[i-1] == 1 )
            r_flags[i] = 1;
          else
            r_flags[i] = data_temp[i];
        end
  end

always_comb
  begin
    data_o_right     = 0;
    data_o_right[0] = data_temp[0];
    
    for ( j = 1; j < WIDTH; j++ )
      begin
        if ( ( r_flags[j-1] == 0 )  & ( r_flags[j] == 1 ) )
          data_o_right[j] = 1;
        else
          data_o_right[j] = 0;
      end
  end

//left half
always_comb
  begin
    l_flags                 = 0;
    l_flags[WIDTH-1] = data_temp[WIDTH-1];
      for ( k = WIDTH-2; k >= 0; k-- )
        begin
          if ( l_flags[k+1] == 1 )
            l_flags[k] = 1;
          else
            l_flags[k] = data_temp[k];
        end
  end

always_comb
  begin
    data_o_left                 = 0;
    data_o_left[WIDTH-1] = data_temp[WIDTH-1];
    
    for ( m = WIDTH-2; m >= 1; m--)
      begin
        if ( ( l_flags[m+1] == 0 ) & ( l_flags[m] == 1 ) )
          data_o_left[m] = 1;
        else
          data_o_left[m] = 0;
      end
  end

endmodule
