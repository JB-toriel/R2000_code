//-----------------------------------------------------
	// This is design of the decode stage of the pipeline
	// Design Name : IF
	// File Name   : decode.sv
	// Function    :
	// Authors     : de Sainte Marie Nils - Edde Jean-Baptiste
//-----------------------------------------------------

/*
module NOM (LISTE DES PORTS);

DECLARATION DES PORTS
DECLARATION DES PARAMETRES

`include "NOM DE FICHIER";

DECLARATIONS DE VARIABLES
AFFECTATIONS
INSTANCIATIONS DE SOUS-MODULES
BLOCS initial ET always
TACHES ET FONCTIONS

endmodule
*/

/*
	Inputs : internally must always be of type net, externally the inputs can be connected to a variable of type reg or net.
	Outputs : internally can be of type net or reg, externally the outputs must be connected to a variable of type net.
	Inouts : internally or externally must always be type net, can only be connected to a variable net type.
*/

module decode_REG_MAPP ( rs, rt, rd, data_1, data_2);

	// Inputs declaration
	input [4:0] rs, rt, rd;

	// Outputs declaration
	output [31:0] data_1, data_2;

	//Variables DECLARATION
	reg [31:0] registers [0:31];
	integer i;
	
	initial
    begin
      for(i = 0; i < 32; i = i + 1)
        begin
          registers[i]=i;
        end
  	end

	//Code start here
		assign data_1 = registers[rs];
		assign data_2 = registers[rt];

	endmodule // End of decode_REG_MAPP module


module decode_CONTROL_UNIT (inst_in, exception, jump, wb, m, ex);

	// Inputs declaration
	input [31:0] inst_in;

	// Outputs declaration
	output exception, jump;
	output reg [3:0] ex;
	output reg [2:0] m;
	output reg [1:0] wb;

	// Variables declaration
	initial begin
		assign ex = 4'b0000;
		assign m = 4'b000;
		assign wb = 2'b00;
	end

	always @ ( inst_in ) begin
		case (inst_in[31:26])
			0:
			begin
				assign	ex = 4'b1100;
				assign	wb = 2'b10;
			end
			6'b100011:
			begin
				assign	ex = 4'b0001;
				assign	m = 3'b010;
				assign	wb = 2'b11;
			end
			6'b101011:
			begin
				assign	ex = 4'bX001;
				assign	m = 3'b001;
				assign	wb = 2'b0X;
			end
			6'b000100:
			begin
				assign	ex = 4'bX010;
				assign	m = 3'b100;
				assign	wb = 2'b0X;
			end
			default:
		  begin
				assign ex = 4'b0000;
				assign m = 4'b000;
				assign wb = 2'b00;
			end
		endcase
	end
endmodule // decode_CONTROL_UNIT


module ID ( clk, inst_in, write_data_reg, reg_write, exception, jump, rs, rt, rd, imm, data_1, data_2, equal, wb, m, ex/*, ...*/);

	//Inputs declaration
	input clk;
	input [31:0] inst_in, write_data_reg;
	input logic reg_write;


	//Outputs declaration
	output logic exception, jump;
	output [4:0] rs, rt, rd;
	output [31:0] imm, data_1, data_2;
	output logic equal;

	output reg [3:0] ex;
	output reg [2:0] m;
	output reg [1:0] wb;

	//Actual code
	assign rs = inst_in[25:21];
	assign rt = inst_in[20:16];
	assign rd = inst_in[15:11];
	assign imm = {16'h0000, inst_in[15:0]};


	decode_REG_MAPP reg_MAPP ( rs, rt, rd, data_1, data_2);
	decode_CONTROL_UNIT control_UNIT (inst_in, exception, jump, wb, m, ex);

	assign equal = (data_1 == data_2);

endmodule // End of ID module
