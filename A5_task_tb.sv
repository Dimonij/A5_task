module A5_task_tb;

localparam WIDTH    = 12;
localparam MAX_DATA = 2 **  WIDTH;

bit                     clk, reset; 
bit                     end_flag1, end_flag2, init_end;

bit [WIDTH-1:0] d_in; 
bit [WIDTH-1:0] d_dut_l;
bit [WIDTH-1:0] d_dut_r;
bit [WIDTH-1:0] test_counter;

bit [WIDTH-1:0] data_i_flow [$];
bit [WIDTH-1:0] d_dut_l_flow [$];
bit [WIDTH-1:0] d_dut_r_flow [$];

int                     flow_cnt;
int                     dut_count;
int                     i;

function [WIDTH-1:0] right_one ( input [WIDTH-1:0] data );

int ii;
bit [WIDTH-1:0] r_flg;

  r_flg     = 0;
  r_flg[0] = data[0];
    for ( ii = 1; ii < WIDTH; ii++ )
      if ( r_flg[ii-1] == 1 )
        r_flg[ii] = 1;
      else
        r_flg[ii] = data[ii];
         
  right_one     = 0;
  right_one[0] = data[0];
    for ( ii = 1; ii < WIDTH; ii++ )
      if ( ( r_flg[ii-1] == 0 )  & ( r_flg[ii] == 1 ) )
        right_one[ii] = 1;
      else
        right_one[ii] = 0;

endfunction

function [WIDTH-1:0] left_one ( input [WIDTH-1:0] data );
int ii;
bit [WIDTH-1:0] l_flg;

  l_flg                 = 0;
  l_flg[WIDTH-1] = data[WIDTH-1];
    for ( ii = WIDTH-2; ii >= 0; ii-- )
      if ( l_flg[ii+1] == 1 )
        l_flg[ii] = 1;
      else
        l_flg[ii] = data[ii];

  left_one                 = 0;
  left_one[WIDTH-1] = data[WIDTH-1];
    for ( ii = WIDTH-2; ii >= 1; ii-- )
      if ( ( l_flg[ii+1] == 0 )  & ( l_flg[ii] == 1 ) )
        left_one[ii] = 1;
      else
        left_one[ii] = 0;

endfunction

// takt generator
initial 
  forever #5 clk = !clk;

// port mapping
A5_task #( WIDTH ) DUT  (
  .clk_i             ( clk ),
  .srst_i            ( reset ),
  .data_i           ( d_in ),
  .data_o_left   ( d_dut_l ),
  .data_o_right ( d_dut_r )
  );

initial
  begin
    end_flag1                      = 0;
    init_end                         = 0;
    #10;
    test_counter                  = 0;
    flow_cnt                        = 0;
    @( posedge clk ) reset = 1'b1;
    @( posedge clk ) reset = 1'b0;	
    #10;
    init_end = 1;
    
// test stimulus generator
  do 
    @( posedge clk ) 
      begin
        d_in = ( $urandom_range ( MAX_DATA,0 ) );
        data_i_flow.push_front ( d_in );
        flow_cnt = flow_cnt + 1;
      end
  while ( flow_cnt <= ( MAX_DATA / 4 ) );

  end_flag1 = 1;
  end

// output accumulator
initial
  begin

    dut_count = 0;
    end_flag2 = 0;
    #50;
    do 
      @( posedge clk ) 
        if ( init_end )
          begin
            d_dut_l_flow.push_front ( d_dut_l );
            d_dut_r_flow.push_front ( d_dut_r);
            dut_count = dut_count + 1;
          end
    while ( dut_count <= ( MAX_DATA / 4 ) );

    end_flag2 = 1;
  end

// result checking	
initial
  begin
    wait ( end_flag1 & end_flag2 );
      for ( i = 0; i <= ( MAX_DATA / 4 ); i++ )
        begin
          $display ( "ITERATION = %d, data input = %b, left_one = %b, right_one = %b ", i, data_i_flow[i], d_dut_l_flow[i], d_dut_r_flow[i] );
          if ( ( d_dut_r_flow [i] != right_one( data_i_flow[i] ) ) & ( d_dut_l_flow [i] != left_one( data_i_flow[i] ) ) )
            begin
              $display( "error at data input = %b, iteration = %d", data_i_flow[i], i );
              $stop;
            end
        end
        $display( "test sucsessful!"  );
        $stop;
  end
	
endmodule
