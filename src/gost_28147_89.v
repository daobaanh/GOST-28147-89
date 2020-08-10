////////////////////////////////////////////////////////////////////////////
//   Mofified, corrected by Dao Ba-Anh (daobaanhvn1991@gmail.com), 2020   //
////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

module gost_28147_89 (clk, rst, mode, load, done, key, pdata, cdata);
  input  clk;    // Input clock signal for synchronous design
  input  rst;    // Syncronous Reset input
  input  mode;   // 0 - encrypt, 1 - decrypt
  input  load;   // load plain text and start cipher cycles
  output done;   // cipher text ready for output read
  //input  kload;  // load cipher key
  input [255:0] key;   // cipher key input
  input  [63:0] pdata; //  plain text input
  output [63:0] cdata; // cipher text output

`include "sbox.vh"

// reg [4:0] i; // cipher cycles counter: 0..31;

// always @(posedge clk)
//   if(rst || load)
//     i <= 5'h0;
//   else //if(~&i)
//     i <= i + 1;

//reg run; //running cipher cycles flag

// wire [2:0] enc_index = (&i[4:3]) ? ~i[2:0] : i[2:0]; //  cipher key index for encrypt
// wire [2:0] dec_index = (|i[4:3]) ? ~i[2:0] : i[2:0]; //  cipher key index for decrypt
// wire [2:0] kindex    = mode ? dec_index : enc_index; //  cipher key index

wire [31:0] K [0:7]; // cipher key storage

assign {K[0],K[1],K[2],K[3],K[4],K[5],K[6],K[7]} = key;

reg   [31:0] b_in;
reg   [31:0] a_in;
reg   [31:0] b [0:32]; // MSB of input data
reg   [31:0] a [0:32]; // LSB of input data
// wire  [31:0] state_addmod32 = a + K[kindex];  // Adding by module 32
// wire  [31:0] state_sbox     = `Sbox(state_addmod32); // S-box replacing
// wire  [31:0] state_shift11  = {state_sbox[20:0],state_sbox[31:21]}; // <<11
wire  [31:0] state_addmod32 [0:31];  // Adding by module 32
wire  [31:0] state_sbox [0:31]; // S-box replacing
wire  [31:0] state_shift11 [0:31]; // <<11

always @(posedge clk)
  if(rst)
    {b_in,a_in} <= {64{1'b0}};
  else if(load)
    {b_in,a_in} <= pdata;

always @(posedge clk)
  if(rst)
    {b[32],a[32]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[0] <= a_in;
    b[0] <= b_in;
  end
  
//round 1
assign state_addmod32[0] = a[0] + K[0];
assign state_sbox[0] = `Sbox(state_addmod32[0]);
assign state_shift11[0] = {state_sbox[0][20:0],state_sbox[0][31:21]};
always @(posedge clk)
  if(rst)
    {b[0],a[0]} <= {64{1'b0}};

  else /*if(~&i)*/ begin
    a[1] <= b[0] ^ state_shift11[0];
    b[1] <= a[0];
  end

//round 2
assign state_addmod32[1] = a[1] + K[1];
assign state_sbox[1] = `Sbox(state_addmod32[1]);
assign state_shift11[1] = {state_sbox[1][20:0],state_sbox[1][31:21]};
always @(posedge clk)
  if(rst)
    {b[1],a[1]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[2] <= b[1] ^ state_shift11[1];
    b[2] <= a[1];
  end

//round 3
assign state_addmod32[2] = a[2] + K[2];
assign state_sbox[2] = `Sbox(state_addmod32[2]);
assign state_shift11[2] = {state_sbox[2][20:0],state_sbox[2][31:21]};
always @(posedge clk)
  if(rst)
    {b[2],a[2]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[3] <= b[2] ^ state_shift11[2];
    b[3] <= a[2];
  end

//round 4
assign state_addmod32[3] = a[3] + K[3];
assign state_sbox[3] = `Sbox(state_addmod32[3]);
assign state_shift11[3] = {state_sbox[3][20:0],state_sbox[3][31:21]};
always @(posedge clk)
  if(rst)
    {b[3],a[3]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[4] <= b[3] ^ state_shift11[3];
    b[4] <= a[3];
  end

//round 5
assign state_addmod32[4] = a[4] + K[4];
assign state_sbox[4] = `Sbox(state_addmod32[4]);
assign state_shift11[4] = {state_sbox[4][20:0],state_sbox[4][31:21]};
always @(posedge clk)
  if(rst)
    {b[4],a[4]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[5] <= b[4] ^ state_shift11[4];
    b[5] <= a[4];
  end

//round 6
assign state_addmod32[5] = a[5] + K[5];
assign state_sbox[5] = `Sbox(state_addmod32[5]);
assign state_shift11[5] = {state_sbox[5][20:0],state_sbox[5][31:21]};
always @(posedge clk)
  if(rst)
    {b[5],a[5]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[6] <= b[5] ^ state_shift11[5];
    b[6] <= a[5];
  end

//round 7
assign state_addmod32[6] = a[6] + K[6];
assign state_sbox[6] = `Sbox(state_addmod32[6]);
assign state_shift11[6] = {state_sbox[6][20:0],state_sbox[6][31:21]};
always @(posedge clk)
  if(rst)
    {b[6],a[6]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[7] <= b[6] ^ state_shift11[6];
    b[7] <= a[6];
  end

//round 8
assign state_addmod32[7] = a[7] + K[7];
assign state_sbox[7] = `Sbox(state_addmod32[7]);
assign state_shift11[7] = {state_sbox[7][20:0],state_sbox[7][31:21]};
always @(posedge clk)
  if(rst)
    {b[7],a[7]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[8] <= b[7] ^ state_shift11[7];
    b[8] <= a[7];
  end

//round 9
assign state_addmod32[8] = a[8] + K[0];
assign state_sbox[8] = `Sbox(state_addmod32[8]);
assign state_shift11[8] = {state_sbox[8][20:0],state_sbox[8][31:21]};
always @(posedge clk)
  if(rst)
    {b[8],a[8]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[9] <= b[8] ^ state_shift11[8];
    b[9] <= a[8];
  end

//round 10
assign state_addmod32[9] = a[9] + K[1];
assign state_sbox[9] = `Sbox(state_addmod32[9]);
assign state_shift11[9] = {state_sbox[9][20:0],state_sbox[9][31:21]};
always @(posedge clk)
  if(rst)
    {b[9],a[9]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[10] <= b[9] ^ state_shift11[9];
    b[10] <= a[9];
  end

//round 11
assign state_addmod32[10] = a[10] + K[2];
assign state_sbox[10] = `Sbox(state_addmod32[10]);
assign state_shift11[10] = {state_sbox[10][20:0],state_sbox[10][31:21]};
always @(posedge clk)
  if(rst)
    {b[10],a[10]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[11] <= b[10] ^ state_shift11[10];
    b[11] <= a[10];
  end

//round 12
assign state_addmod32[11] = a[11] + K[3];
assign state_sbox[11] = `Sbox(state_addmod32[11]);
assign state_shift11[11] = {state_sbox[11][20:0],state_sbox[11][31:21]};
always @(posedge clk)
  if(rst)
    {b[11],a[11]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[12] <= b[11] ^ state_shift11[11];
    b[12] <= a[11];
  end

//round 13
assign state_addmod32[12] = a[12] + K[4];
assign state_sbox[12] = `Sbox(state_addmod32[12]);
assign state_shift11[12] = {state_sbox[12][20:0],state_sbox[12][31:21]};
always @(posedge clk)
  if(rst)
    {b[12],a[12]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[13] <= b[12] ^ state_shift11[12];
    b[13] <= a[12];
  end

//round 14
assign state_addmod32[13] = a[13] + K[5];
assign state_sbox[13] = `Sbox(state_addmod32[13]);
assign state_shift11[13] = {state_sbox[13][20:0],state_sbox[13][31:21]};
always @(posedge clk)
  if(rst)
    {b[13],a[13]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[14] <= b[13] ^ state_shift11[13];
    b[14] <= a[13];
  end

//round 15
assign state_addmod32[14] = a[14] + K[6];
assign state_sbox[14] = `Sbox(state_addmod32[14]);
assign state_shift11[14] = {state_sbox[14][20:0],state_sbox[14][31:21]};
always @(posedge clk)
  if(rst)
    {b[14],a[14]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[15] <= b[14] ^ state_shift11[14];
    b[15] <= a[14];
  end

//round 16
assign state_addmod32[15] = a[15] + K[7];
assign state_sbox[15] = `Sbox(state_addmod32[15]);
assign state_shift11[15] = {state_sbox[15][20:0],state_sbox[15][31:21]};
always @(posedge clk)
  if(rst)
    {b[15],a[15]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[16] <= b[15] ^ state_shift11[15];
    b[16] <= a[15];
  end

//round 17
assign state_addmod32[16] = a[16] + K[0];
assign state_sbox[16] = `Sbox(state_addmod32[16]);
assign state_shift11[16] = {state_sbox[16][20:0],state_sbox[16][31:21]};
always @(posedge clk)
  if(rst)
    {b[16],a[16]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[17] <= b[16] ^ state_shift11[16];
    b[17] <= a[16];
  end

//round 18
assign state_addmod32[17] = a[17] + K[1];
assign state_sbox[17] = `Sbox(state_addmod32[17]);
assign state_shift11[17] = {state_sbox[17][20:0],state_sbox[17][31:21]};
always @(posedge clk)
  if(rst)
    {b[17],a[17]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[18] <= b[17] ^ state_shift11[17];
    b[18] <= a[17];
  end

//round 19
assign state_addmod32[18] = a[18] + K[2];
assign state_sbox[18] = `Sbox(state_addmod32[18]);
assign state_shift11[18] = {state_sbox[18][20:0],state_sbox[18][31:21]};
always @(posedge clk)
  if(rst)
    {b[18],a[18]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[19] <= b[18] ^ state_shift11[18];
    b[19] <= a[18];
  end

//round 20
assign state_addmod32[19] = a[19] + K[3];
assign state_sbox[19] = `Sbox(state_addmod32[19]);
assign state_shift11[19] = {state_sbox[19][20:0],state_sbox[19][31:21]};
always @(posedge clk)
  if(rst)
    {b[19],a[19]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[20] <= b[19] ^ state_shift11[19];
    b[20] <= a[19];
  end

//round 21
assign state_addmod32[20] = a[20] + K[4];
assign state_sbox[20] = `Sbox(state_addmod32[20]);
assign state_shift11[20] = {state_sbox[20][20:0],state_sbox[20][31:21]};
always @(posedge clk)
  if(rst)
    {b[20],a[20]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[21] <= b[20] ^ state_shift11[20];
    b[21] <= a[20];
  end

//round 22
assign state_addmod32[21] = a[21] + K[5];
assign state_sbox[21] = `Sbox(state_addmod32[21]);
assign state_shift11[21] = {state_sbox[21][20:0],state_sbox[21][31:21]};
always @(posedge clk)
  if(rst)
    {b[21],a[21]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[22] <= b[21] ^ state_shift11[21];
    b[22] <= a[21];
  end

//round 23
assign state_addmod32[22] = a[22] + K[6];
assign state_sbox[22] = `Sbox(state_addmod32[22]);
assign state_shift11[22] = {state_sbox[22][20:0],state_sbox[22][31:21]};
always @(posedge clk)
  if(rst)
    {b[22],a[22]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[23] <= b[22] ^ state_shift11[22];
    b[23] <= a[22];
  end

//round 24
assign state_addmod32[23] = a[23] + K[7];
assign state_sbox[23] = `Sbox(state_addmod32[23]);
assign state_shift11[23] = {state_sbox[23][20:0],state_sbox[23][31:21]};
always @(posedge clk)
  if(rst)
    {b[23],a[23]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[24] <= b[23] ^ state_shift11[23];
    b[24] <= a[23];
  end

//round 25
assign state_addmod32[24] = a[24] + K[7];
assign state_sbox[24] = `Sbox(state_addmod32[24]);
assign state_shift11[24] = {state_sbox[24][20:0],state_sbox[24][31:21]};
always @(posedge clk)
  if(rst)
    {b[24],a[24]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[25] <= b[24] ^ state_shift11[24];
    b[25] <= a[24];
  end

//round 26
assign state_addmod32[25] = a[25] + K[6];
assign state_sbox[25] = `Sbox(state_addmod32[25]);
assign state_shift11[25] = {state_sbox[25][20:0],state_sbox[25][31:21]};
always @(posedge clk)
  if(rst)
    {b[25],a[25]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[26] <= b[25] ^ state_shift11[25];
    b[26] <= a[25];
  end

//round 27
assign state_addmod32[26] = a[26] + K[5];
assign state_sbox[26] = `Sbox(state_addmod32[26]);
assign state_shift11[26] = {state_sbox[26][20:0],state_sbox[26][31:21]};
always @(posedge clk)
  if(rst)
    {b[26],a[26]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[27] <= b[26] ^ state_shift11[26];
    b[27] <= a[26];
  end

//round 28
assign state_addmod32[27] = a[27] + K[4];
assign state_sbox[27] = `Sbox(state_addmod32[27]);
assign state_shift11[27] = {state_sbox[27][20:0],state_sbox[27][31:21]};
always @(posedge clk)
  if(rst)
    {b[27],a[27]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[28] <= b[27] ^ state_shift11[27];
    b[28] <= a[27];
  end

//round 29
assign state_addmod32[28] = a[28] + K[3];
assign state_sbox[28] = `Sbox(state_addmod32[28]);
assign state_shift11[28] = {state_sbox[28][20:0],state_sbox[28][31:21]};
always @(posedge clk)
  if(rst)
    {b[28],a[28]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[29] <= b[28] ^ state_shift11[28];
    b[29] <= a[28];
  end

//round 30
assign state_addmod32[29] = a[29] + K[2];
assign state_sbox[29] = `Sbox(state_addmod32[29]);
assign state_shift11[29] = {state_sbox[29][20:0],state_sbox[29][31:21]};
always @(posedge clk)
  if(rst)
    {b[29],a[29]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[30] <= b[29] ^ state_shift11[29];
    b[30] <= a[29];
  end

//round 31
assign state_addmod32[30] = a[30] + K[1];
assign state_sbox[30] = `Sbox(state_addmod32[30]);
assign state_shift11[30] = {state_sbox[30][20:0],state_sbox[30][31:21]};
always @(posedge clk)
  if(rst)
    {b[30],a[30]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[31] <= b[30] ^ state_shift11[30];
    b[31] <= a[30];
  end

//round 32
assign state_addmod32[31] = a[31] + K[0];
assign state_sbox[31] = `Sbox(state_addmod32[31]);
assign state_shift11[31] = {state_sbox[31][20:0],state_sbox[31][31:21]};
always @(posedge clk)
  if(rst)
    {b[31],a[31]} <= {64{1'b0}};
  else /*if(~&i)*/ begin
    a[32] <= b[31] ^ state_shift11[31];
    b[32] <= a[31];
  end

// reg r_done;
// always @(posedge clk)
//   if(rst)
//     r_done <= 1'b0;
//   else
//     r_done <= &i;

// assign done  = r_done;  //ready flag for output data
assign cdata = {a[32],b[32]};

endmodule

